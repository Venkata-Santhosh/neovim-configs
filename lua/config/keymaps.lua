-- ============================================================================
-- keymaps.lua  —  GLOBAL shortcuts that don't belong to a specific plugin.
-- (Plugin-specific shortcuts live next to their plugin in lua/plugins/.)
--
-- The helper: vim.keymap.set(mode, keys, action, opts)
--   mode: "n"=normal, "i"=insert, "v"=visual, "x"=visual, "t"=terminal
--   Run `:help vim.keymap.set` for details.
-- ============================================================================

local map = vim.keymap.set

-- Clear search highlighting by pressing <Esc> in normal mode.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- ---- Saving & quitting -----------------------------------------------------
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })

-- ---- Move between split windows with Ctrl + h/j/k/l -------------------------
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- ---- Resize splits with arrow keys -----------------------------------------
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- ---- Buffer navigation (open files are "buffers") --------------------------
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete (close) buffer" })

-- ---- Move selected lines up/down in visual mode ----------------------------
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep the cursor in place when joining lines with J.
map("n", "J", "mzJ`z", { desc = "Join line (keep cursor)" })

-- Keep the selection after indenting with < or > in visual mode.
map("v", "<", "<gv", { desc = "Indent left, keep selection" })
map("v", ">", ">gv", { desc = "Indent right, keep selection" })

-- Center the screen when jumping half-pages or to search results.
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- ---- Diagnostics (errors/warnings from the LSP) ----------------------------
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- ---- Terminal: press <Esc><Esc> to leave terminal-insert mode --------------
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
