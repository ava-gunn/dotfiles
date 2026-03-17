[{1 "neovim/nvim-lspconfig"
  :opts {:inlay_hints {:enabled false}}}

 {1 "alexghergh/nvim-tmux-navigation"
  :config (fn []
            ((. (require "nvim-tmux-navigation") :setup)
             {:disable_when_zoomed true
              :keybindings {:left "<C-h>"
                            :down "<C-j>"
                            :up "<C-k>"
                            :right "<C-l>"}}))}

 {1 "folke/twilight.nvim"}

 {1 "RutaTang/compter.nvim"
  :config (fn []
            ((. (require "compter") :setup)
             {:templates [{:pattern "-\\?\\d\\+"
                           :priority 0
                           :increase (fn [content]
                                       (values (+ (tonumber content) 1) true))
                           :decrease (fn [content]
                                       (values (- (tonumber content) 1) true))}
                          {:pattern "\\<\\(true\\|false\\|TRUE\\|FALSE\\|True\\|False\\)\\>"
                           :priority 100
                           :increase (fn [content]
                                       (let [switch {:true "false" :false "true"
                                                     :True "False" :False "True"
                                                     :TRUE "FALSE" :FALSE "TRUE"}]
                                         (values (. switch content) true)))
                           :decrease (fn [content]
                                       (let [switch {:true "false" :false "true"
                                                     :True "False" :False "True"
                                                     :TRUE "FALSE" :FALSE "TRUE"}]
                                         (values (. switch content) true)))}]}))}

 {1 "folke/snacks.nvim"
  :keys [{1 "<leader>." 2 (fn [] (Snacks.scratch)) :desc "Toggle Scratch Buffer"}
         {1 "<leader>S" 2 (fn [] (Snacks.scratch.select)) :desc "Select Scratch Buffer"}]}

 {1 "gruvw/strudel.nvim"
  :build "npm ci"
  :config (fn [] ((. (require "strudel") :setup)))}]
