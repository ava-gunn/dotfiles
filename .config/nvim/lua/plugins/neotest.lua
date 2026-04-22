return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
    },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          jestCommand = "npx jest",
          jestConfigFile = function(file)
            -- In the nintendo.com monorepo, find the nearest jest.config.js
            local root = file:match("(.-/apps/[^/]+/)")
              or file:match("(.-/packages/[^/]+/)")
            if root then
              return root .. "jest.config.js"
            end
            return vim.fn.getcwd() .. "/jest.config.js"
          end,
          cwd = function(file)
            -- Run jest from the app/package root in the monorepo
            return file:match("(.-/apps/[^/]+/)")
              or file:match("(.-/packages/[^/]+/)")
              or vim.fn.getcwd()
          end,
        },
      },
    },
  },
}
