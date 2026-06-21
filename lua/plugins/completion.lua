-- ============================================================================
-- blink.cmp — the AUTOCOMPLETE popup (suggestions as you type).
-- It pulls suggestions from the LSP (real code intelligence), snippets, buffer
-- words, and file paths. It ships a prebuilt binary, so no Rust toolchain needed.
-- Docs: https://cmp.saghen.dev
-- ============================================================================

return {
  "saghen/blink.cmp",
  -- Pin to the 1.x release line so the prebuilt binary is downloaded for you.
  version = "1.*",
  event = "InsertEnter",
  dependencies = {
    -- Snippet engine + a big library of ready-made snippets.
    {
      "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        -- Load the VSCode-style snippets from friendly-snippets.
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
  -- @module 'blink.cmp'
  -- @type blink.cmp.Config
  opts = {
    snippets = { preset = "luasnip" },
    keymap = {
      -- "default" preset:
      --   <C-y> = accept,  <C-space> = open menu / show docs,
      --   <Tab>/<S-Tab> = move within a snippet,  <C-n>/<C-p> = next/prev item.
      preset = "default",
      -- Add Enter-to-accept on top of the preset (familiar from other editors).
      ["<CR>"] = { "accept", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono", -- icons render correctly with a Nerd Font
    },
    completion = {
      -- Show documentation for the highlighted item automatically.
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      ghost_text = { enabled = true }, -- inline preview of the top suggestion
    },
    -- Where suggestions come from.
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    -- Use the faster Rust fuzzy matcher (the prebuilt binary).
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
