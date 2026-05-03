-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>\\", "<Cmd>ZenMode<CR>", { silent = true })
vim.keymap.set("n", "<leader>;", "A;<esc>", { silent = true })
vim.keymap.set("n", "<leader>qfa", ':cdo execute "norm! @a" | update', { silent = true })
-- vim.keymap.set("i", "<BS>", "<Nop>", { silent = true })
-- vim.keymap.set("i", "<Del>", "<Nop>", { silent = true })
