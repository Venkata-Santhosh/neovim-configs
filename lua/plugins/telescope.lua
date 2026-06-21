-- ============================================================================
-- telescope — the FUZZY FINDER. This is the tool you'll use most.
-- Find files, search text across the whole project, jump to symbols, etc.
-- Powered by ripgrep (`rg`) and fd, which you install on the system (see README).
-- ============================================================================

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    -- A C extension that makes filtering much faster. `make` compiles it.
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- Make Neovim's own selection prompts use Telescope's nice UI.
    "nvim-telescope/telescope-ui-select.nvim",
  },
  -- Shortcuts (mnemonic: f = "find").
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>",   desc = "Find text (grep) in project" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>",     desc = "Find open buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "Find help docs" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>",    desc = "Find recent files" },
    { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Find word under cursor" },
    -- Search symbols (classes/methods) by NAME across your project AND dependency
    -- JARs. Picking a result from a library opens jdtls' on-the-fly decompiled
    -- source — this is the IntelliJ "Search Everywhere / Ctrl+N" equivalent.
    { "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Find symbol in project + libraries" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Find diagnostics (errors)" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>",     desc = "Find keymaps" },
    { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Find files (quick)" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        -- Press <C-/> in the picker (insert mode) to see all its shortcuts.
        --
        -- Disable treesitter highlighting INSIDE the preview window.
        -- Telescope 0.1.x's previewer calls the OLD nvim-treesitter `master`-branch
        -- API (`nvim-treesitter.parsers.ft_to_lang`, `nvim-treesitter.configs`),
        -- which no longer exists on the `main` branch we use (see plugins/treesitter.lua).
        -- That mismatch throws `attempt to call field 'ft_to_lang' (a nil value)`.
        -- Turning it off makes the previewer fall back to Vim's regex/`syntax`
        -- highlighting, which still looks fine for short preview snippets.
        preview = {
          treesitter = false,
        },
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
      },
    })
    -- Load the optional extensions (pcall = "try, ignore error if missing").
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
  end,
}
