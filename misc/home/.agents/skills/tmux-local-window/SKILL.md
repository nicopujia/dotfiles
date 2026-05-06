---
name: tmux-local-window
description: Use when asked to run local dev servers; start them in the current tmux pane/window, not a new tmux session.
---

# Same-Pane Local Server Runs

Use this skill when the user asks to run local development servers (for example, `npm run dev`, `pnpm dev`, `bun run dev`, `uv run`, `yarn dev`, `go run`, `cargo run`, `python -m` server commands, or `django runserver`).

Behavior:

1. Keep the command in the **current tmux pane** the user is already in.
2. Do not create new tmux sessions/windows/panes unless explicitly requested.
3. Build long-running server commands so they stay visible and interactive in-place.

Execution rule:

Use this exact pattern whenever you need to execute a local server command:

```bash
if [ -n "${TMUX_PANE:-}" ] && command -v tmux >/dev/null 2>&1; then
  tmux send-keys -t "$TMUX_PANE" "cd $(pwd) && <server_command>" C-m
else
  <server_command>
fi
```

If this is a multi-command startup, use one command string:

```bash
tmux send-keys -t "$TMUX_PANE" "cd /path/to/project && cmd1 && cmd2" C-m
```

Do not use detached/non-interactive sessions for these tasks.
