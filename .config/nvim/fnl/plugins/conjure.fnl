[;; Conjure — REPL client (nREPL for jank/Clojure, netrepl/stdio for Janet)
 {1 "Olical/conjure"
  :ft ["clojure" "jank" "janet"]
  :build false
  :dependencies ["PaterJason/cmp-conjure"]
  :config (fn []
            (vim.filetype.add {:extension {:jank "clojure"}})
            (set vim.g.conjure#mapping#prefix "<localleader>")
            (set vim.g.conjure#client#clojure#nrepl#connection#auto_repl#enabled false)
            (set vim.g.conjure#log#hud#enabled true)
            (set vim.g.conjure#log#hud#width 0.42)
            (set vim.g.conjure#log#hud#anchor "SE"))}

 ;; nREPL completion source for nvim-cmp
 {1 "PaterJason/cmp-conjure"
  :lazy true
  :config (fn []
            (let [cmp (require "cmp")
                  config (cmp.get_config)]
              (table.insert config.sources {:name "conjure"})
              (cmp.setup config)))}

 ;; Ensure treesitter parsers are installed
 {1 "nvim-treesitter/nvim-treesitter"
  :opts (fn [_ opts]
          (when (= (type opts.ensure_installed) "table")
            (vim.list_extend opts.ensure_installed ["clojure" "janet_simple"])))}

 ;; Paired delimiter support for s-expressions
 {1 "gpanders/nvim-parinfer"
  :ft ["clojure" "jank" "janet"]}

 ;; Janet indentation and syntax support
 {1 "janet-lang/janet.vim"
  :ft ["janet"]}

 ;; Linting for Janet (uses janet -k)
 {1 "mfussenegger/nvim-lint"
  :opts (fn [_ opts]
          (when (not opts.linters_by_ft)
            (set opts.linters_by_ft {}))
          (set opts.linters_by_ft.janet ["janet"]))}]
