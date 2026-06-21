-- ============================================================================
-- Colorscheme — tender (https://github.com/jacoborus/tender.vim)
-- A warm dark theme. It's a classic Vim colorscheme (works great in Neovim with
-- termguicolors, which we enable in options.lua).
--
-- NOTE: tender is DARK, so we do NOT use a transparent background here — it paints
-- its own dark background. We also force a LIGHT cursor so the block cursor stays
-- visible on the dark background.
-- ============================================================================

return {
  "jacoborus/tender.vim",
  lazy = false,    -- a theme should always be loaded
  priority = 1000, -- load before other plugins
  config = function()
    vim.o.background = "dark"

    -- Keep the block cursor visible on the dark background, re-applied whenever
    -- the colorscheme (re)loads.
    local function fix_cursor()
      vim.api.nvim_set_hl(0, "Cursor", { fg = "#282828", bg = "#EEEEEE" })
      vim.api.nvim_set_hl(0, "lCursor", { fg = "#282828", bg = "#EEEEEE" })
    end
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("fix-cursor-visibility", { clear = true }),
      callback = fix_cursor,
    })

    vim.cmd.colorscheme("tender")
    fix_cursor()
  end,
}
