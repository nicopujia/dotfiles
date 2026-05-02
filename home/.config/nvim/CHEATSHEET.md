# Neovim Cheatsheet

Leader is Space. This guide only lists mappings, options, and plugin behavior configured in this repo's Neovim config.

## Core

`<leader>?`: Show buffer local keymaps with which key.
`<leader>hc`: Open this cheatsheet.

Configured defaults: absolute and relative line numbers, 4 space tabs, spaces instead of tabs, OS clipboard sharing, true color, sorted diagnostics with signs and underlines.

## Buffer Tabs

`gt`: Move to the next buffer tab.
`gT`: Move to the previous buffer tab.
`:q`: Close the current buffer tab without quitting Neovim.
`:q!`: Force close the current buffer tab without quitting Neovim.
`:qa`: Close all buffer tabs without quitting Neovim.
`:qa!`: Force close all buffer tabs without quitting Neovim.
`:exit`: Quit Neovim.

Buffer tabs use `bufferline.nvim`, show LSP diagnostics, and reserve a left offset when Neo-tree is open.

## Git

Git hunks show in the sign column next to line numbers: `+` added, `~` changed, `_` deleted.
`<leader>gd`: Open `git diff HEAD` in a read-only diff buffer.
`<leader>gD`: Open `git diff HEAD -- current-file` in a read-only diff buffer.
`:GitDiff`: Open `git diff HEAD` in a read-only diff buffer.
`:GitDiff path/to/file`: Open `git diff HEAD -- path/to/file` in a read-only diff buffer.

## Telescope

`<leader>sf`: Search files, including dotfiles, while respecting ignores.
`<leader>sg`: Search text across the project, including hidden files and folders except `.git` and `node_modules`.
`<leader>sb`: Search open buffers.
`<leader>sr`: Search recent files in a dropdown.
`<leader>sc`: Search commands in a dropdown.
`<leader>sk`: Search keymaps in a dropdown.
`<leader>ss`: Search document symbols.
`<leader>sS`: Search workspace symbols.
`<leader>sd`: Search diagnostics.

Telescope uses the `fzf` extension and ignores `.git` and `node_modules`.

## LSP Mappings

These mappings are set when an LSP attaches to the current buffer.

`gd`: Go to definition.
`K`: Show hover documentation.
`gr`: Go to references.
`<leader>rn`: Rename symbol.
`<leader>ca`: Run code action.
`<leader>f`: Format the current buffer.
`[d`: Jump to the previous diagnostic.
`]d`: Jump to the next diagnostic.

Python enables Ruff and ty. Python files auto format on save with Ruff.

## Trouble

`<leader>xx`: Toggle all diagnostics in Trouble.
`<leader>xX`: Toggle diagnostics for the current buffer in Trouble.
`<leader>cs`: Toggle document symbols in Trouble without stealing focus.
`<leader>cl`: Toggle LSP references and definitions in a right side Trouble view.
`<leader>xq`: Toggle the quickfix list in Trouble.
`<leader>xl`: Toggle the location list in Trouble.

## Neo-tree

`<leader>ee`: Toggle sidebar visibility, preserving the last Files/Git source. Opens Files by default.
`<leader>ef`: Open or focus the left files explorer; if it is already focused, return focus to the editor.
`<leader>eg`: Open or focus the left git status explorer; if it is already focused, return focus to the editor.

Neo-tree shows dotfiles, opens on the left, and uses a bottom statusline source selector with `Files` and `Git`.

## Shell Commands

`:!`: Run shell commands through interactive `zsh`, so aliases from `shell-config.sh` work, including `g` for `git`.

## Obsidian

Obsidian workspaces come from `OBSIDIAN_VAULT`.

`<leader>on`: Create a new note.
`<leader>oo`: Open the current note in Obsidian.
`<leader>os`: Search notes.
`<leader>oq`: Quick switch between notes.
`<leader>ot`: Open today's note.
`<leader>ow`: Switch workspace.

## Completion

Completion uses `blink.cmp` with LSP, path, and buffer sources. The completion menu is enabled. Automatic documentation popups and ghost text are off.

## Themes

`NVIM_THEME=light`: Use `dayfox` with white background overrides.
`NVIM_THEME=dark`: Use `monokai-nightasty` with its native black background.

Without `NVIM_THEME`, Neovim follows the macOS appearance: `dayfox` for light mode, `monokai-nightasty` for dark mode.
