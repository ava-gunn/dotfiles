return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
  {
    "alexghergh/nvim-tmux-navigation",
    keys = {
      { "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", mode = { "n", "t" } },
      { "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", mode = { "n", "t" } },
      { "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", mode = { "n", "t" } },
      { "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", mode = { "n", "t" } },
    },
    config = function()
      require("nvim-tmux-navigation").setup({
        disable_when_zoomed = true,
      })
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      on_open = function(_)
        vim.opt.laststatus = 0
        vim.fn.jobstart({ "sh", "-c", "tmux set status off" }, { detach = true })
        vim.fn.jobstart({ "sh", "-c", "tmux list-panes -F '#F' | grep -q Z || tmux resize-pane -Z" }, { detach = true })
      end,
      on_close = function(_)
        vim.opt.laststatus = 3
        vim.fn.jobstart({ "sh", "-c", "tmux set status on" }, { detach = true })
        vim.fn.jobstart({ "sh", "-c", "tmux list-panes -F '#F' | grep -q Z && tmux resize-pane -Z" }, { detach = true })
      end,
    },
  },
  { "folke/twilight.nvim", cmd = { "Twilight", "TwilightEnable", "TwilightDisable" } },
  {
    "RutaTang/compter.nvim",
    event = "VeryLazy",
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
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
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
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
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
  {
    "gruvw/strudel.nvim",
    build = "npm ci",
    cmd = { "StrudelLaunch", "StrudelQuit", "StrudelToggle", "StrudelUpdate", "StrudelExecute", "StrudelStop" },
    config = function()
      require("strudel").setup()
    end,
  },
}
