-- ============================================================================
-- markdown.lua — Markdown editing + Mermaid DIAGRAM rendering.
--
-- Two complementary tools:
--   1) markdown-preview.nvim : opens a live browser tab that renders your
--      markdown AND mermaid (```mermaid``` code blocks become real diagrams).
--      This is your reliable, terminal-agnostic way to "see" mermaid diagrams.
--   2) render-markdown.nvim  : prettifies markdown right inside Neovim
--      (headings, tables, checkboxes, code blocks) so editing feels nice.
-- ============================================================================

return {
  -- --- Live browser preview with Mermaid support ----------------------------
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    -- Downloads the preview server binary. We call the bundled install script
    -- directly (synchronous + reliable) instead of the async installer, which can
    -- get cut off and leave an empty app/bin/ folder. Works on Linux & macOS.
    -- If preview ever fails to open, re-run it: :call mkdp#util#install()
    build = "cd app && bash install.sh",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Preview (browser, mermaid)", ft = "markdown" },
    },
    config = function()
      -- Don't auto-close the browser tab when you switch away from the file.
      vim.g.mkdp_auto_close = 0
      -- mermaid is rendered by the preview's bundled JS — nothing else to install.
    end,
  },

  -- --- In-editor markdown prettifier ---------------------------------------
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      -- Render even while your cursor is on the line (set 'i' to hide while editing).
      render_modes = { "n", "c", "t" },
      code = { sign = false, width = "block" },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle in-editor Markdown render", ft = "markdown" },
    },
  },
}
