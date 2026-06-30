-- ============================================================================
-- vim-table-mode — effortless Markdown tables.
-- Turn it on, type a row of `| cells |`, and columns auto-align as you go.
-- Toggle with  <leader>tm  (Space t m).
-- ============================================================================

return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown" },
  keys = {
    { "<leader>tm", "<cmd>TableModeToggle<CR>", desc = "Table Mode (toggle)", ft = "markdown" },
    { "<leader>tt", "<cmd>TableModeRealign<CR>", desc = "Table: realign columns", ft = "markdown" },
  },
  init = function()
    -- Use `|` as the corner char so output is standard GitHub-flavored markdown
    -- ( |---|---| ) instead of vim-table-mode's default ( +---+---+ ).
    vim.g.table_mode_corner = "|"
  end,
}
