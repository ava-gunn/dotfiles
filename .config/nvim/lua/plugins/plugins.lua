return {
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
  { "ThePrimeagen/vim-be-good" },
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
}
