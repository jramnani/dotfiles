;; https://www.gnu.org/software/emacs/manual/html_node/auth/Help-for-developers.html#Help-for-developers

(defun jramnani-find-password (HOST PORT USERNAME)
  "Find a password in Emacs auth-source.
HOST PORT and USERNAME are all strings to use for the query.
Return a list of strings as (USERNAME PASSWORD).
Return nil if the entry is not found."
  (let ((found (nth 0 (auth-source-search :host HOST
                                          :port PORT
                                          :user USERNAME
                                          :require '(:user :secret)
                                          :max 1))))
    (if found
        (list (plist-get found :user)
              (let ((secret (plist-get found :secret)))
                (if (functionp secret)
                    (funcall secret)
                  secret)))
      nil)))

(provide 'jramnani-auth)

;;; jramnani-auth.el ends here
