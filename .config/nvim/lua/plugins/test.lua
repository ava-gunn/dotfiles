return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "haydenmeade/neotest-jest",
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "yarn test",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        })
      )
      table.insert(opts.adapters, require("neotest-playwright"))
    end,
  },
}
