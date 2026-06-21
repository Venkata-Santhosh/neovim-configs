-- ============================================================================
-- neo-tree — a file explorer sidebar (like the file tree in VS Code).
-- Toggle it with  <leader>e  (Space then e).
-- ============================================================================

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",        -- common Lua helper library (many plugins need it)
    "nvim-tree/nvim-web-devicons",  -- file-type icons (needs a Nerd Font, see README)
    "MunifTanjim/nui.nvim",         -- UI component library neo-tree is built on
  },
  -- `keys` = lazy-load this plugin only when one of these keys is pressed.
  keys = {
    { "<leader>fe", "<cmd>Neotree toggle<CR>", desc = "File Explorer (toggle)" },
    { "<leader>fo", "<cmd>Neotree focus<CR>",  desc = "File explorer (focus)" },
  },
  opts = {
    close_if_last_window = true, -- close Neovim if neo-tree is the last window
    filesystem = {
      follow_current_file = { enabled = true }, -- highlight the file you're editing
      use_libuv_file_watcher = true,            -- auto-refresh on external changes
      filtered_items = {
        visible = true,        -- still SHOW hidden/ignored files...
        hide_dotfiles = false, -- ...including dotfiles (.env, .gitignore)
        hide_gitignored = false,
      },
    },
    window = {
      width = 32,
      mappings = {
        ["<space>"] = "none", -- free up Space so it stays our leader key
      },
    },
  },
}
