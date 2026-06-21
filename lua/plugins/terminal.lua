-- ============================================================================
-- toggleterm — a nice integrated terminal you can pop open/closed with a key.
-- (Neovim also has a built-in `:terminal`, but toggleterm makes it reusable and
--  floating/split with one keystroke.)
--
-- Open/close:  Ctrl + \   (also <leader>tf float, <leader>th below, <leader>tv right)
-- Leave terminal "insert" mode back to normal mode:  <Esc><Esc>
-- ============================================================================

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { [[<C-\>]], desc = "Toggle terminal" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal (float)" },
    { "<leader>th", "<cmd>ToggleTerm direction=horizontal size=12<CR>", desc = "Terminal (below)" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<CR>", desc = "Terminal (right)" },
  },
  opts = {
    open_mapping = [[<C-\>]], -- the main toggle key
    direction = "float",       -- default style: a floating window
    float_opts = { border = "curved" },
    size = function(term)
      if term.direction == "horizontal" then return 12 end
      if term.direction == "vertical" then return vim.o.columns * 0.4 end
    end,
  },
}
