return {
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "microsoft/vscode-js-debug",
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
      },
    },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      local dap_js = require("dap-vscode-js")
      local dap = require("dap")

      dap_js.setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome" },
      })

      -- Shared configurations for all JS/TS filetypes
      local js_config = {
        -- Attach to running Next.js dev server (node)
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Next.js server",
          port = 9229,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        -- Launch Next.js dev server with debug
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Next.js dev",
          runtimeExecutable = "npx",
          runtimeArgs = { "next", "dev", "--inspect" },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          console = "integratedTerminal",
        },
        -- Debug client-side React in Chrome
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome (localhost:3000)",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}/src",
          sourceMaps = true,
        },
        -- Debug Jest tests
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest tests",
          runtimeExecutable = "npx",
          runtimeArgs = { "jest", "--runInBand", "${file}" },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          console = "integratedTerminal",
        },
      }

      for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
        dap.configurations[ft] = js_config
      end
    end,
  },

  -- Custom keybindings: Del, PageUp, PageDown for stepping
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<Del>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<PageDown>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<PageUp>", function() require("dap").step_out() end, desc = "Step Out" },
    },
  },
}
