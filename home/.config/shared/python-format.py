#!/usr/bin/env -S uv run --script

import os
import subprocess
import sys


def run_step(args: list[str], data: bytes, timeout: float) -> bytes:
    try:
        completed = subprocess.run(
            args,
            input=data,
            capture_output=True,
            check=False,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired:
        print(
            f"python-format.sh: timed out after {timeout:g}s: {' '.join(args)}",
            file=sys.stderr,
        )
        raise SystemExit(124)

    if completed.returncode != 0:
        if completed.stderr:
            sys.stderr.buffer.write(completed.stderr)
        raise SystemExit(completed.returncode)

    return completed.stdout


def main() -> int:
    if len(sys.argv) < 2 or not sys.argv[1]:
        print("python-format.sh: missing file path", file=sys.stderr)
        return 1

    file_path = sys.argv[1]
    timeout = float(os.environ.get("PYTHON_FORMAT_TIMEOUT", "30"))
    source = sys.stdin.buffer.read()

    checked = run_step(
        ["ruff", "check", "--exit-zero", "--fix", "--stdin-filename", file_path, "-"],
        source,
        timeout,
    )
    formatted = run_step(
        ["ruff", "format", "--stdin-filename", file_path, "-"],
        checked,
        timeout,
    )
    sys.stdout.buffer.write(formatted)
    return 0


raise SystemExit(main())
