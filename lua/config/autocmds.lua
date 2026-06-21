-- ============================================================================
-- autocmds.lua  —  "automatic commands" that run on certain events.
-- Pattern: vim.api.nvim_create_autocmd(EVENT, { ... })
-- Run `:help autocmd-events` to see every event you can hook into.
-- ============================================================================

-- Briefly highlight text you just yanked (copied). Nice visual feedback.
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Remove trailing whitespace automatically when you save any file.
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Trim trailing whitespace on save",
  group = vim.api.nvim_create_augroup("trim-whitespace", { clear = true }),
  callback = function()
    local save = vim.fn.winsaveview()    -- remember cursor position
    vim.cmd([[keeppatterns %s/\s\+$//e]]) -- delete trailing spaces, silently
    vim.fn.winrestview(save)             -- restore cursor position
  end,
})

-- When you reopen a file, jump back to where you last were.
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore last cursor position",
  group = vim.api.nvim_create_augroup("last-position", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
