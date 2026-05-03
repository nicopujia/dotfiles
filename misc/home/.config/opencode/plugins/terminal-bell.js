const BELL_EVENTS = new Set(["session.idle", "session.error", "permission.asked"])

export const TerminalBellPlugin = async () => {
  return {
    event: async ({ event }) => {
      if (!BELL_EVENTS.has(event?.type)) {
        return
      }

      await Bun.write(Bun.stdout, "\x07")
    },
  }
}
