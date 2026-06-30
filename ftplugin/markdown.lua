-- ============================================================================
-- ftplugin/markdown.lua — settings applied automatically to every .md buffer.
-- (Neovim auto-sources ftplugin/<filetype>.lua from the runtimepath.)
--
-- Goal: make typing/pasting code inside ``` fenced blocks behave predictably,
-- instead of the treesitter markdown indenter (which can't see into code fences).
-- ============================================================================

local bo = vim.bo

-- 2-space indents, spaces not tabs (matches the rest of your config).
bo.expandtab = true
bo.shiftwidth = 2
bo.tabstop = 2
bo.softtabstop = 2

-- Use plain autoindent: a new line keeps the PREVIOUS line's indentation.
-- Inside a code block this means your code stays aligned, and you press <Tab>
-- to go one level deeper / <Shift-Tab> (or <BS>) to come back. No "staircase".
bo.indentexpr = ""      -- turn off the treesitter indenter for markdown
bo.autoindent = true
bo.smartindent = false  -- smartindent's C-style heuristics misfire in prose/fences

-- Reminder: to paste multi-line code WITHOUT cascading indentation, leave insert
-- mode (<Esc>) and paste in NORMAL mode with `p` — it preserves indentation exactly.
