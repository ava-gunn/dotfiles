{:user {:plugins [[lein-pprint "1.1.1"] [cider/cider-nrepl "0.53.2"] [refactor-nrepl "3.10.0"]]
        :aliases {"rebl" ["trampoline" "run" "-m" "rebel-readline.main"]
                  "nrebl" ["trampoline" "run" "-m" "rebel-readline.nrepl.main"]}
        :source-paths ["/Users/clark/.lein/src"]
        :dependencies [[org.clojure/tools.namespace "0.2.7"]
                       [com.bhauman/rebel-readline "0.1.5"]
                       [com.bhauman/rebel-readline-nrepl "0.1.6"] ; Added rebel-readline nREPL integration
                       [nrepl/nrepl "1.0.0"] ; Keep nREPL dependency
                       [cider/cider-nrepl "0.31.0"]]}} ; Keep CIDER nREPL middleware dependency
