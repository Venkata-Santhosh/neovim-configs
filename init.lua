-- ============================================================================
-- init.lua  —  the FIRST file Neovim reads on startup.
-- We keep it tiny on purpose: it just loads our other config files in order.
-- Everything else lives under  lua/config/  and  lua/plugins/.
-- ============================================================================

-- 1) Set the <leader> key BEFORE loading any plugins.
--    "leader" is a prefix key you press before custom shortcuts.
--    We use the Spacebar. Example: <leader>ff  means  Space then f then f.
--    This MUST come first, or plugin shortcuts bind to the wrong key.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2) Core editor settings (line numbers, tabs, search behaviour, etc.)
require("config.options")

-- 3) Bootstrap the plugin manager (lazy.nvim) and load everything
--    found in  lua/plugins/*.lua
require("config.lazy")

-- 4) Our own global keymaps + automatic behaviours.
--    Loaded last so they can rely on plugins being available.
require("config.keymaps")
require("config.autocmds")
