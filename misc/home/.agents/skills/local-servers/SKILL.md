---
name: local-servers
description: Use this skill when the user asks to run local development servers (for example, `bun dev`, `pnpm dev`, `uv run`, etc). Start them in the current tmux window, not detached.
---

Whenever the user asks you to run local servers, the first thing you must do is check if you are currently in a tmux session. Use the `interactive_bash` tool with this exact tmux command:

```tmux
display-message -p '#S'
```

If that command fails, skip this skill.

Otherwise, if you ARE in a tmux session, run each local server in a new tmux pane, INSIDE the current tmux window you currently are at. Use the `interactive_bash` tool with these exact tmux commands for each server:

```tmux
split-window -v -c "#{pane_current_path}" -P -F "#{pane_id}"
send-keys -t "<pane_id>" "<server command>" Enter
```

Replace `<pane_id>` with the pane id returned by `split-window`, and replace `<server command>` with the actual command the user asked you to run, such as `bun dev`, `pnpm dev`, or `uv run <command>`.

Example for `bun dev`:

```tmux
split-window -v -c "#{pane_current_path}" -P -F "#{pane_id}"
send-keys -t "%3" "bun dev" Enter
```

Managing servers:

To view local server panes in the current tmux window, use the `interactive_bash` tool with this exact tmux command:

```tmux
list-panes -F '#{pane_id} #{pane_current_command} #{pane_current_path}'
```

To view recent output from a server pane, use the `interactive_bash` tool with this exact tmux command:

```tmux
capture-pane -p -t "<pane_id>" -S -200
```

To stop a server, send Ctrl-C to its pane with the `interactive_bash` tool and this exact tmux command:

```tmux
send-keys -t "<pane_id>" C-c
```

To restart a server in the same pane, first stop it, then send the server command again with the `interactive_bash` tool and this exact tmux command:

```tmux
send-keys -t "<pane_id>" "<server command>" Enter
```

Replace `<pane_id>` with the pane id from `list-panes`, and replace `<server command>` with the original server command.

Rules:

- Do NOT create new windows or sessions, ONLY panes.
- Do NOT use detached/non-interactive sessions for these tasks.
- Do NOT use `new-session`, `new-window`, `split-window -d`, shell backgrounding (`&`), or `nohup`.
- Do NOT run long-running local servers with the `bash` tool.
- Build long-running server commands so they stay visible and interactive in-place.
