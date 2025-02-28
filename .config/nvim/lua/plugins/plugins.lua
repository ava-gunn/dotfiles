return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup({
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
        },
      })
    end,
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        on_open = function(_)
          vim.opt.laststatus = 0
          vim.fn.system([[tmux set status off]])
          vim.fn.system([[tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z]])
        end,
        on_close = function(_)
          vim.opt.laststatus = 3
          vim.fn.system([[tmux set status on]])
          vim.fn.system([[tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z]])
        end,
      })
    end,
  },
  { "folke/twilight.nvim" },
  {
    "jim-fx/sudoku.nvim",
    cmd = "Sudoku",
    config = function()
      require("sudoku").setup({
        -- configuration ...
      })
    end,
  },
  {
    "RutaTang/compter.nvim",
    config = function()
      require("compter").setup({
        templates = {
          {
            pattern = [[-\?\d\+]],
            priority = 0,
            increase = function(content)
              content = tonumber(content)
              return content + 1, true
            end,
            decrease = function(content)
              content = tonumber(content)
              return content - 1, true
            end,
          },
          {
            pattern = [[\<\(true\|false\|TRUE\|FALSE\|True\|False\)\>]],
            priority = 100,
            increase = function(content)
              local switch = {
                ["true"] = "false",
                ["false"] = "true",
                ["True"] = "False",
                ["False"] = "True",
                ["TRUE"] = "FALSE",
                ["FALSE"] = "TRUE",
              }
              return switch[content], true
            end,
            decrease = function(content)
              local switch = {
                ["true"] = "false",
                ["false"] = "true",
                ["True"] = "False",
                ["False"] = "True",
                ["TRUE"] = "FALSE",
                ["FALSE"] = "TRUE",
              }
              return switch[content], true
            end,
          },
        },
      })
    end,
  },
  {
    "tris203/precognition.nvim",
    config = {
      startVisible = true,
    },
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "razak17/tailwind-fold.nvim",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "jsx", "tsx", "html", "svelte", "astro", "vue", "typescriptreact", "php", "blade" },
  },
}
