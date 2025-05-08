-- ~/.config/nvim/lua/plugins/clojure.lua

return {
  -- Conjure for interactive development
  {
    "Olical/conjure",
    -- Load mappings only for relevant filetypes on entering the buffer
    event = "BufReadPre",
    ft = { "clojure", "fennel", "scheme", "racket", "hy", "janet" },
    init = function()
      -- Set options directly using vim.g variables (standard Conjure way)
      vim.g.conjure_log_split = "vertical"
      vim.g.conjure_log_split_size = 60
      vim.g.conjure_eval_result_prefix = "=> "
      vim.g.conjure_extract_custom_extractors = {
        clojure = "(ns $file-path)", -- Example custom extractor
      }
      -- Set keymaps using standard vim.keymap.set
      -- Note: We use BufReadPre/ft trick above, so map in config or use autocmd
      -- Alternatively, map directly here if you prefer VeryLazy event.
    end,
    config = function()
      -- You might put keymaps here if using event = "VeryLazy" instead of init
      -- Example keymap (use your preferred leader)
      -- These often need to be buffer-local for Conjure
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "clojure", "fennel", "scheme", "racket", "hy", "janet" },
        group = vim.api.nvim_create_augroup("ConjureKeymaps", { clear = true }),
        callback = function(args)
          local map = vim.keymap.set
          local opts = { buffer = args.buf, noremap = true, silent = true }
          map("n", "<localleader>el", "<cmd>ConjureEvalCurrentForm<cr>", opts)
          map("n", "<localleader>eb", "<cmd>ConjureEvalRootForm<cr>", opts)
          map("n", "<localleader>ef", "<cmd>ConjureEvalFile<cr>", opts)
          map("n", "<localleader>ew", "<cmd>ConjureEvalCurrentWord<cr>", opts)
          map("v", "<localleader>e", "<cmd>ConjureEvalVisual<cr>", opts)
          map("n", "<localleader>lr", "<cmd>ConjureLogRefresh<cr>", opts)
          map("n", "<localleader>lt", "<cmd>ConjureLogToggle<cr>", opts)
          -- Add more maps based on Conjure docs / AstroCommunity reference
        end,
      })
    end,
  },

  -- Parinfer (optional, for structural editing)
  {
    "eraserhd/parinfer-rust",
    -- You might need to build it if your package manager doesn't handle it
    build = "cargo build --release",
    ft = { "clojure", "scheme", "lisp", "racket" }, -- Trigger on relevant filetypes
    -- No specific config usually needed unless you want to change modes via commands
  },

  -- Ensure Clojure Treesitter parser is installed
  -- This should ideally be merged with your main treesitter config
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure opts.ensure_installed is a table
      if type(opts.ensure_installed) ~= "table" then
        opts.ensure_installed = {}
      end
      -- Add clojure if not already present
      if not vim.tbl_contains(opts.ensure_installed, "clojure") then
        table.insert(opts.ensure_installed, "clojure")
      end
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        clojure = { "clj-kondo" },
        -- ... other linters
      }
    end,
  },

  -- Optional: LSP configuration for clojure-lsp (if not handled elsewhere)
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       -- Ensure clojure_lsp is setup here, potentially using mason.nvim
  --       clojure_lsp = {},
  --     },
  --   },
  -- },
  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     if type(opts.ensure_installed) ~= "table" then opts.ensure_installed = {} end
  --     if not vim.tbl_contains(opts.ensure_installed, "clojure-lsp") then
  --       table.insert(opts.ensure_installed, "clojure-lsp")
  --     end
  --   end
  -- }
}
