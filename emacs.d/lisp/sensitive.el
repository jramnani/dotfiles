;;; sensitive-mode.el ---

;; See: http://anirudhsasikumar.net/blog/2005.01.21.html

(define-minor-mode sensitive-mode
  "Disables backup creation and auto saving.
Enable for sensitive file types like GPG encrypted files
or password lists.  You want to disable auto saving for
these files because backups are stored in clear text.

With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode."
  ;; The initial value for 'sensitive-mode'.
  nil
  ;; The mode line indicator
  " Sensitive"
  ;; The minor mode bindings.
  nil
  (if (symbol-value sensitive-mode)
      (progn
	;; disable backups
	(set (make-local-variable 'backup-inhibited) t)
	;; disable auto-save
	(if auto-save-default
	    (auto-save-mode -1)))
    ;resort to default value of backup-inhibited
    (kill-local-variable 'backup-inhibited)
    ;resort to default auto save setting
    (if auto-save-default
	(auto-save-mode 1))))

(provide 'sensitive-mode)

;;; sensitive-mode.el ends here
