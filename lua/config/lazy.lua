-- ============================================================================
-- lazy.lua  —  installs and configures lazy.nvim, our PLUGIN MANAGER.
-- lazy.nvim downloads plugins from GitHub, keeps them updated, and only loads
-- them when needed (that's the "lazy" part = fast startup).
-- Docs: https://lazy.folke.io
-- ============================================================================

-- 1) Auto-install lazy.nvim itself the first time you launch Neovim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    return
  end
end

-- 2) Add lazy.nvim to Neovim's runtime path so we can `require` it.
vim.opt.rtp:prepend(lazypath)

-- 3) Configure lazy and tell it where our plugins live.
--    `{ import = "plugins" }` loads EVERY file under lua/plugins/ automatically,
--    so to add a plugin later you just drop a new file in that folder.
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = {
    -- Colorscheme to use while plugins are still installing on first launch.
    colorscheme = { "tender", "habamax" },
  },
  checker = {
    enabled = true, -- periodically check for plugin updates...
    notify = false, -- ...but don't nag you with notifications
  },
  change_detection = {
    notify = false, -- don't notify when you edit your own config files
  },
})
