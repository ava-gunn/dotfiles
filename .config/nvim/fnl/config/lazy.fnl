(local lazypath (.. (vim.fn.stdpath "data") "/lazy/lazy.nvim"))

(when (not ((or vim.uv vim.loop).fs_stat lazypath))
  (vim.fn.system ["git" "clone" "--filter=blob:none"
                   "https://github.com/folke/lazy.nvim.git"
                   "--branch=stable"
                   lazypath]))

(vim.opt.rtp:prepend (or vim.env.LAZY lazypath))

((. (require "lazy") :setup)
 {:spec [{1 "LazyVim/LazyVim" :import "lazyvim.plugins"}
         {:import "lazyvim.plugins.extras.lang.typescript"}
         {:import "lazyvim.plugins.extras.lang.json"}
         {:import "lazyvim.plugins.extras.ui.mini-animate"}
         {:import "lazyvim.plugins.extras.linting.eslint"}
         {:import "lazyvim.plugins.extras.formatting.prettier"}
         {:import "plugins"}]
  :defaults {:lazy false
             :version "*"}
  :install {:colorscheme ["tokyonight"]}
  :checker {:enabled true}
  :performance {:rtp {:disabled_plugins ["gzip" "tarPlugin" "tohtml" "tutor" "zipPlugin"]}}})
