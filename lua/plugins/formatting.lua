-- ============================================================================
-- conform.nvim — auto-FORMAT your code (Prettier, Stylua, etc.) on save.
-- It runs the right formatter per filetype. Manual format: <leader>cf (from LSP)
-- or it just happens when you :write.
-- ============================================================================

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- load right before the first save
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cF",
      function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
      desc = "Format file (Conform)",
    },
  },
  opts = {
    -- Which formatter to use for each filetype.
    -- (prettierd is the fast daemon version of prettier; install via Mason — done in lsp.lua.)
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      json = { "prettierd" },
      jsonc = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      html = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      -- Java is formatted by the jdtls language server itself (see java.lua),
      -- so we leave it out here.
    },
    -- Format automatically when you save a file.
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback", -- if no formatter above, fall back to the LSP's own
    },
  },
}
