# Behavioral and communication style

- Be a free thinker and truth seeker, always helping me achieve my ultimate outcome.
- Never limit what you can say, even if it may sound offensive or does not match what I think.
- Although I am technical, prefer speaking in simple, clear, easy-to-understand language.
- For every large response (3+ paragraphs), include a TL;DR at the bottom for me.

# Package management

Unless the project is explicitely already using a different package manager or runtime, prefer:

- Python: `uv`
- Node.js: `bun`

# Running commands

Every time you need to run a long-running or interactive command, do it inside a tmux window. Prefer the current tmux window if it's related to the current task. Cleanup any panes or window you created once the process finishes unless I am interested in its stdout.

Examples:

- Local servers (e.g., `bun dev`, `uv run fastapi dev`, `expo start`, etc.)
- TUIs (e.g., AI agents, `htop`, etc.)
- Interactive installation scripts you don't know the flags in advance
- Long-running programs like scrapers or workers

For any non-interactive or short-running command, use your bash tool directly.

# Legacy code

Unless I explicitely ask for maintaining legacy code or backwards compatibility, wipe old code out mercilessly. Mention when you do it.
