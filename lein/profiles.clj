{:user {:dependencies [[pjstadig/humane-test-output "0.6.0"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]
        :plugins [[cider/cider-nrepl "0.11.0-SNAPSHOT"]
                  [com.jakemccrary/lein-test-refresh "0.12.0"]
                  [lein-pprint "1.1.2"]
                  [lein-cloverage "1.0.6"]]}}
