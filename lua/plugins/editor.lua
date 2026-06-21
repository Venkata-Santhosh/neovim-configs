-- ============================================================================
-- editor.lua — a BUNDLE of smaller quality-of-life plugins.
-- A plugin file can return a LIST of plugin specs (note the {{...},{...}}).
-- ============================================================================

return {
  -- --- Statusline: the info bar at the bottom (mode, git branch, file, etc.) --
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy", -- load after startup finishes (keeps startup fast)
    opts = {
      options = {
        theme = "auto", -- automatically match whatever colorscheme is active (Monokai)
        globalstatus = true, -- one statusline for all windows, not one each
        section_separators = "",
        component_separators = "|",
      },
    },
  },

  -- --- which-key: pops up a menu showing what each shortcut does -------------
  -- After you press <leader> and pause, a cheatsheet appears. Perfect for learning.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        -- Label the leader-key groups so the popup reads nicely.
        { "<leader>f", group = "Find / File" },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code (LSP)" },
        { "<leader>g", group = "Git" },
        { "<leader>m", group = "Markdown / Mermaid" },
        { "<leader>t", group = "Terminal" },
      },
    },
  },

  -- --- flash.nvim: jump anywhere on screen in a few keystrokes ---------------
  -- Press `s` then type 2 chars near where you want to go; labels appear — press
  -- the label letter to teleport the cursor there. Fastest way to navigate.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter select" },
    },
  },

  -- --- gitsigns: shows added/changed/removed lines in the gutter ------------
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", gs.next_hunk, "Next git hunk")
        map("n", "[h", gs.prev_hunk, "Previous git hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview git hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset git hunk")
        map("n", "<leader>gb", gs.blame_line, "Blame current line")
      end,
    },
  },

  -- --- autopairs: auto-close brackets, quotes, etc. -------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true, -- shorthand for: config = function() require(...).setup() end
  },

  -- --- indent guides: faint vertical lines showing indentation levels -------
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- --- a smarter Esc/comment/surround grab-bag (we use comments) -------------
  -- Note: Neovim has built-in commenting: `gcc` toggles a line, `gc` in visual
  -- mode toggles a selection. mini.comment makes it filetype-aware for JSX too.
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {},
  },
}
