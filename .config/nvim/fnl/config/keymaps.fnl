(local opts {:silent true})

(vim.keymap.set "n" "<C-h>" "<Cmd>NvimTmuxNavigateLeft<CR>" opts)
(vim.keymap.set "n" "<C-j>" "<Cmd>NvimTmuxNavigateDown<CR>" opts)
(vim.keymap.set "n" "<C-k>" "<Cmd>NvimTmuxNavigateUp<CR>" opts)
(vim.keymap.set "n" "<C-l>" "<Cmd>NvimTmuxNavigateRight<CR>" opts)
