import { existsSync } from "node:fs"
import { isAbsolute, resolve } from "node:path"

const DEBOUNCE_MS = 300
const SUPPRESS_MS = 1500
const timers = new Map()
const running = new Set()
const rerun = new Set()
const suppressUntil = new Map()

function isPythonFile(filePath) {
  return filePath.endsWith(".py") || filePath.endsWith(".pyi")
}

function getEventPath(event) {
  const candidates = [
    event?.path,
    event?.filePath,
    event?.file?.path,
    event?.properties?.path,
    event?.properties?.filePath,
    event?.data?.path,
    event?.data?.filePath,
  ]

  for (const candidate of candidates) {
    if (typeof candidate === "string" && candidate.length > 0) {
      return candidate
    }
  }

  return null
}

function resolveFilePath(rawPath, worktree, directory) {
  if (!rawPath) {
    return null
  }

  const base = worktree || directory || process.cwd()
  const filePath = isAbsolute(rawPath) ? rawPath : resolve(base, rawPath)

  if (!isPythonFile(filePath) || !existsSync(filePath)) {
    return null
  }

  return filePath
}

async function log(client, level, message, extra = {}) {
  try {
    await client.app.log({
      body: {
        service: "python-ruff-plugin",
        level,
        message,
        extra,
      },
    })
  } catch {}
}

async function formatFile(filePath, $, client) {
  if (running.has(filePath)) {
    rerun.add(filePath)
    return
  }

  running.add(filePath)

  try {
    await $`uv run --no-project ruff check --fix -- ${filePath}`
    await $`uv run --no-project ruff format -- ${filePath}`
    suppressUntil.set(filePath, Date.now() + SUPPRESS_MS)
  } catch (error) {
    await log(client, "warn", "Python post-edit formatting failed", {
      filePath,
      error: error instanceof Error ? error.message : String(error),
    })
  } finally {
    running.delete(filePath)

    if (rerun.delete(filePath)) {
      scheduleFormat(filePath, $, client)
    }
  }
}

function scheduleFormat(filePath, $, client) {
  const existing = timers.get(filePath)
  if (existing) {
    clearTimeout(existing)
  }

  const timer = setTimeout(() => {
    timers.delete(filePath)
    void formatFile(filePath, $, client)
  }, DEBOUNCE_MS)

  timers.set(filePath, timer)
}

export const PythonRuffPlugin = async ({ $, client, directory, worktree }) => {
  return {
    event: async ({ event }) => {
      if (event?.type !== "file.edited") {
        return
      }

      const filePath = resolveFilePath(getEventPath(event), worktree, directory)
      if (!filePath) {
        return
      }

      if (Date.now() < (suppressUntil.get(filePath) || 0)) {
        return
      }

      scheduleFormat(filePath, $, client)
    },
  }
}
