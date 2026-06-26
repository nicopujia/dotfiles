# Communication
- **Tone:** simple, easy to understand, concise.
- **Format:** include a **TL;DR** at the bottom of any response longer than 2 paragraphs.

# Package Management
Default to `uv` (Python) and `bun` (Node.js) unless the project explicitly uses a different manager.

# Running Commands
- **Long-running/Interactive:** Run servers, TUIs, scrapers, and more inside a `tmux` window (prefer current window if related). Clean up created panes/windows upon completion. Verify a process isn't already running before executing it.
- **Short/Non-interactive:** Use the standard bash tool directly.

# Documentation Lookup
Prefer `ctx7` over training data and web search to verify third-party library documentation. Usage:

```bash
# Step 1: Resolve library ID
ctx7 library <name> "<query>"

# Step 2: Query documentation
ctx7 docs <libraryId> "<query>"
```
