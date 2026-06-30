-- ============================================================================
-- lsp.lua — LANGUAGE SERVERS = the "intelligence" behind the IDE.
--
-- What is LSP? The "Language Server Protocol". For each language there's a
-- background program (a "language server") that understands your code and gives
-- Neovim features like: go-to-definition, hover docs, rename, find-references,
-- autocomplete data, and live error/warning diagnostics.
--
-- We use:
--   * mason.nvim          -> a package manager that DOWNLOADS those servers for you
--   * mason-lspconfig     -> bridges mason names <-> Neovim's lsp config
--   * mason-tool-installer-> also auto-installs formatters/linters
--   * nvim-lspconfig      -> ships ready-made configs for ~300 servers
--
-- This file targets Neovim 0.11+ and its modern `vim.lsp.config` / `vim.lsp.enable`.
-- ============================================================================

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "saghen/blink.cmp", -- so we can pull in its completion capabilities
  },
  config = function()
    -- ----------------------------------------------------------------------
    -- 1) When a language server attaches to a buffer, set up handy keymaps.
    --    These only exist in files where a server is running.
    -- ----------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
      callback = function(event)
        local function map(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", vim.lsp.buf.definition, "Go to Definition")
        -- Click-to-navigate. Jump to where a symbol is defined; press <C-o> to go back.
        --   * DOUBLE-CLICK  : works in a terminal (iTerm2) — plain clicks reach Neovim.
        --   * Ctrl+click    : only works in GUI Neovim (Neovide) or graphics terminals;
        --                     in iTerm2 the OS turns Ctrl+click into a right-click menu,
        --                     so Neovim never receives it.
        vim.keymap.set("n", "<2-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>",
          { buffer = event.buf, desc = "LSP: Go to Definition (double-click)" })
        vim.keymap.set("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>",
          { buffer = event.buf, desc = "LSP: Go to Definition (Ctrl+click, GUI only)" })
        map("gr", vim.lsp.buf.references, "Go to References")
        map("gi", vim.lsp.buf.implementation, "Go to Implementation")
        map("gD", vim.lsp.buf.declaration, "Go to Declaration")
        map("K", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action (quick fix)")
        map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
        map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
      end,
    })

    -- ----------------------------------------------------------------------
    -- 2) Nicer-looking diagnostic icons + inline virtual text.
    -- ----------------------------------------------------------------------
    vim.diagnostic.config({
      virtual_text = true,    -- show the message inline at end of line
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN]  = "▲",
          [vim.diagnostic.severity.HINT]  = "⚑",
          [vim.diagnostic.severity.INFO]  = "»",
        },
      },
    })

    -- ----------------------------------------------------------------------
    -- 3) Tell every server about blink.cmp's completion capabilities.
    --    `'*'` is a special key meaning "default config for ALL servers".
    -- ----------------------------------------------------------------------
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    vim.lsp.config("*", { capabilities = capabilities })

    -- ----------------------------------------------------------------------
    -- 4) Per-server settings (override the defaults from nvim-lspconfig).
    --    Most servers need NO extra config — an empty {} is fine.
    -- ----------------------------------------------------------------------
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          completion = { callSnippet = "Replace" },
          -- Stop "undefined global `vim`" warnings in our config files.
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })

    -- gopls: the official Go language server. Settings enable extra static
    -- analysis (staticcheck), auto-import of unimported packages, and inlay
    -- hints — matching the "batteries included" feel of the VS Code Go plugin.
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          gofumpt = true,            -- stricter gofmt formatting
          completeUnimported = true, -- suggest + auto-import packages you haven't imported yet
          usePlaceholders = true,    -- fill function arguments as snippet placeholders
          staticcheck = true,        -- extra lint diagnostics (staticcheck.io)
          analyses = {
            unusedparams = true,
            unusedwrite = true,
            nilness = true,
            useany = true,
          },
          hints = {                  -- inlay hints (the greyed-in type/param names)
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    })

    -- emmet_ls: expand HTML/CSS abbreviations (also useful in JSX/TSX).
    vim.lsp.config("emmet_ls", {
      filetypes = {
        "html", "css", "scss", "javascriptreact", "typescriptreact", "javascript", "typescript",
      },
    })

    -- ----------------------------------------------------------------------
    -- 5) Make sure the servers/tools we want are INSTALLED, then ENABLE them.
    --    NOTE: jdtls (Java) is intentionally NOT enabled here — the
    --    nvim-jdtls plugin starts it specially (see lua/plugins/java.lua and
    --    ftplugin/java.lua). We only ask mason to download it.
    -- ----------------------------------------------------------------------

    -- LSP servers to enable for everyday editing.
    local servers = {
      "lua_ls",      -- Lua (for editing this very config)
      "ts_ls",       -- TypeScript / JavaScript / React (.ts .tsx .js .jsx)
      "eslint",      -- ESLint diagnostics + "fix all" code action
      "html",        -- HTML
      "cssls",       -- CSS / SCSS
      "tailwindcss", -- Tailwind CSS class IntelliSense
      "jsonls",      -- JSON (with schema validation)
      "emmet_ls",    -- Emmet abbreviations
      "bashls",      -- Bash / shell scripts
      "yamlls",      -- YAML
      "gopls",       -- Go
    }

    -- mason-lspconfig: ensure the above are downloaded, and AUTO-ENABLE each one
    -- as soon as it's installed. This avoids the "server not installed / missing
    -- from PATH" error you get if you enable a server before Mason fetches it.
    -- We exclude jdtls because nvim-jdtls starts Java itself (see ftplugin/java.lua).
    require("mason-lspconfig").setup({
      ensure_installed = vim.list_extend(vim.deepcopy(servers), { "jdtls" }),
      automatic_enable = { exclude = { "jdtls" } },
    })

    -- mason-tool-installer: download formatters & linters (used by conform/eslint).
    require("mason-tool-installer").setup({
      ensure_installed = {
        "prettierd", -- fast formatter for JS/TS/React/CSS/HTML/JSON/Markdown/YAML
        "stylua",    -- Lua formatter
        "goimports", -- Go: format + auto add/remove imports
        "gofumpt",   -- Go: stricter gofmt
      },
    })
  end,
}
