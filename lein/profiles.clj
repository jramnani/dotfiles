{:user {:dependencies [[org.clojure/tools.trace "0.7.9"]
                       [pjstadig/humane-test-output "0.6.0"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]
        :plugins [[cider/cider-nrepl "0.22.4"]
                  [com.jakemccrary/lein-test-refresh "0.24.1"]
                  [lein-pprint "1.1.2"]
                  [lein-cloverage "1.0.6"]]}}
