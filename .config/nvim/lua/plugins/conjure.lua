return {
  -- Conjure — REPL client (nREPL for jank/Clojure, netrepl/stdio for Janet)
  {
    "Olical/conjure",
    ft = { "clojure", "jank", "janet" },
    build = false,
    dependencies = { "PaterJason/cmp-conjure" },
    config = function()
      vim.filetype.add({ extension = { jank = "clojure" } })
      vim.g["conjure#mapping#prefix"] = "<localleader>"
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
      vim.g["conjure#log#hud#enabled"] = true
      vim.g["conjure#log#hud#width"] = 0.42
      vim.g["conjure#log#hud#anchor"] = "SE"
    end,
  },

  -- nREPL completion source for nvim-cmp
  {
    "PaterJason/cmp-conjure",
    lazy = true,
    config = function()
      local cmp = require("cmp")
      local config = cmp.get_config()
      table.insert(config.sources, { name = "conjure" })
      cmp.setup(config)
    end,
  },

  -- Ensure treesitter parsers are installed
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "clojure", "janet_simple" })
      end
    end,
  },

  -- Paired delimiter support for s-expressions
  {
    "gpanders/nvim-parinfer",
    ft = { "clojure", "jank", "janet" },
  },

  -- Janet indentation and syntax support
  {
    "janet-lang/janet.vim",
    ft = { "janet" },
  },

  -- Linting for Janet (uses janet -k)
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.janet = { "janet" }
    end,
  },
}
