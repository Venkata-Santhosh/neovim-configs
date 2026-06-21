-- ============================================================================
-- nvim-treesitter — modern syntax highlighting + smart indentation.
-- Treesitter PARSES your code into a syntax tree for accurate highlighting.
--
-- IMPORTANT: we use the **main** branch. The older `master` branch is frozen and
-- explicitly does NOT support Neovim 0.12+ (it caused a `range (nil value)` crash).
-- The `main` branch has a different API: it does NOT auto-enable highlighting via
-- a `highlight = { enable = true }` option — instead we start it per buffer with
-- `vim.treesitter.start()` in a FileType autocmd (done below).
-- ============================================================================

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",      -- REQUIRED for Neovim 0.11+/0.12 (master is frozen at 0.11)
  lazy = false,
  build = ":TSUpdate",  -- compile/update parsers after install/update
  config = function()
    require("nvim-treesitter").setup()

    -- Parsers to install. Add any language you work with here.
    local parsers = {
      "lua", "vim", "vimdoc", "query",          -- needed by Neovim itself
      "javascript", "typescript", "tsx",         -- React stack (javascript covers .jsx)
      "html", "css", "scss", "json", "jsonc",
      "java",                                     -- Java
      "bash", "markdown", "markdown_inline",      -- markdown_inline = code inside .md
      "yaml", "toml", "dockerfile", "gitignore", "regex",
    }
    require("nvim-treesitter").install(parsers)

    -- The main branch doesn't auto-start highlighting — we do it per buffer.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user-treesitter-start", { clear = true }),
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        -- Map filetype -> treesitter language (e.g. "typescriptreact" -> "tsx").
        local lang = vim.treesitter.language.get_lang(ft) or ft
        -- Only start if a parser for this language is actually installed.
        if not pcall(vim.treesitter.language.add, lang) then
          return
        end
        pcall(vim.treesitter.start, buf, lang)
        -- Treesitter-based indentation (experimental on the main branch).
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
