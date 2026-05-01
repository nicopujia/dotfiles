# Neovim Cheatsheet

Leader is Space. Use this as a quick reference for the mappings configured in this repo.

## Core

`<leader>?`: Show buffer local keymaps.
`<leader>hc`: Open this cheatsheet.

## Search / Telescope

`<leader>sf`: Search files, including dotfiles, while respecting ignores.
`<leader>sg`: Search text across the project, including hidden files and folders except `.git` and `node_modules`.
`<leader>sb`: Search open buffers.
`<leader>sr`: Search recent files.
`<leader>sc`: Search available commands.
`<leader>sk`: Search keymaps.
`<leader>ss`: Search document symbols.
`<leader>sS`: Search workspace symbols.
`<leader>sd`: Search diagnostics.

## LSP

`gd`: Go to definition.
`K`: Show hover documentation.
`gr`: Go to references.
`<leader>rn`: Rename symbol.
`<leader>ca`: Run code action.
`<leader>f`: Format the current buffer.
`[d`: Jump to the previous diagnostic.
`]d`: Jump to the next diagnostic.

## Diagnostics / Trouble

`<leader>xx`: Toggle all diagnostics in Trouble.
`<leader>xX`: Toggle diagnostics for the current buffer in Trouble.
`<leader>cs`: Toggle document symbols in Trouble without stealing focus.
`<leader>cl`: Toggle LSP references and definitions in a right side Trouble view.
`<leader>xq`: Toggle the quickfix list in Trouble.
`<leader>xl`: Toggle the location list in Trouble.

## Explorer / Neo-tree

`<leader>ee`: Toggle the left filesystem explorer and reveal the current file.
`<leader>ef`: Focus the left filesystem explorer.
`<leader>eg`: Open the left git status explorer.

## Obsidian

Obsidian workspaces come from `OBSIDIAN_VAULT`.

`<leader>on`: Create a new note.
`<leader>oo`: Open the current note in Obsidian.
`<leader>os`: Search notes.
`<leader>oq`: Quick switch between notes.
`<leader>ot`: Open today's note.
`<leader>ow`: Switch workspace.

## Completion

Completion uses `blink.cmp` with LSP, path, and buffer sources. The menu is enabled, automatic documentation popups are off, and ghost text is off.

## Help

`<leader>?`: Show buffer local keymaps.
`<leader>hc`: Open this cheatsheet.
