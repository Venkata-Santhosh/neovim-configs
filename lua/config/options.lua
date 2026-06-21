-- ============================================================================
-- options.lua  —  core editor behaviour.
-- `vim.opt.X = Y` is how you set a setting. `vim.o`, `vim.wo`, `vim.bo` exist
-- too, but `vim.opt` is the friendliest. Run `:help 'optionname'` to learn any.
-- ============================================================================

local opt = vim.opt

-- ---- Line numbers ----------------------------------------------------------
opt.number = true          -- show the absolute line number on the current line
opt.relativenumber = true  -- show OTHER lines relative to it (great for 5j, 3k)

-- ---- Indentation -----------------------------------------------------------
opt.tabstop = 2            -- a <Tab> looks like 2 spaces wide
opt.shiftwidth = 2         -- one indent level = 2 spaces
opt.expandtab = true       -- pressing <Tab> inserts spaces, not a tab char
opt.smartindent = true     -- auto-indent new lines sensibly
opt.breakindent = true     -- wrapped lines keep their indentation

-- ---- Search ----------------------------------------------------------------
opt.ignorecase = true      -- searching is case-insensitive...
opt.smartcase = true       -- ...UNLESS you type an uppercase letter
opt.hlsearch = true        -- highlight all matches (clear with <Esc>, see keymaps)
opt.incsearch = true       -- jump to matches as you type

-- ---- UI / appearance -------------------------------------------------------
opt.termguicolors = true   -- enable 24-bit colours (needed by colorschemes)
opt.signcolumn = "yes"     -- always show the left gutter (git/diagnostics) — no jitter
opt.cursorline = true      -- highlight the line the cursor is on
opt.scrolloff = 10         -- keep 10 lines visible above/below the cursor
opt.wrap = false           -- do not soft-wrap long lines (toggle later if you like)
opt.colorcolumn = "100"    -- a vertical guide at column 100
opt.cmdheight = 1          -- height of the command line at the bottom

-- ---- Splits (window layout) ------------------------------------------------
opt.splitright = true      -- vertical splits open to the RIGHT
opt.splitbelow = true      -- horizontal splits open BELOW

-- ---- Editing quality of life ----------------------------------------------
opt.mouse = "a"            -- enable the mouse in all modes (resize splits, scroll)
opt.clipboard = "unnamedplus" -- use the SYSTEM clipboard for yank/paste (needs xclip/wl-clipboard on Linux)
opt.undofile = true        -- persist undo history to disk between sessions
opt.updatetime = 250       -- faster response (e.g. hover diagnostics) in ms
opt.timeoutlen = 400       -- how long to wait for a mapped key sequence (ms)
opt.confirm = true         -- ask to save instead of failing when you :q a dirty buffer

-- ---- Whitespace visibility -------------------------------------------------
opt.list = true            -- show invisible characters...
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- ...like this

-- Show a live preview of :substitute as you type it.
opt.inccommand = "split"
