-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "clojure" },
  callback = function()
    -- Disable blink.cmp for Clojure files
    vim.b.cmp_enabled = false
    -- Disable friendly-snippets for Clojure files
    vim.b.snippets_enabled = false

    local mini_pairs = require("mini.pairs")
    if mini_pairs then
      -- Override ONLY single-quote behavior (allow typing ' but no auto-pair)
      mini_pairs.setup({
        mappings = {
          ["'"] = { action = "open", pair = "'", neigh_pattern = "[^\\].", register = { cr = false } },
        },
      })
    end
  end,
})
