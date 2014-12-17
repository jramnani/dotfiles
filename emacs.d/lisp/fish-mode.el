(defvar fish-builtin-commands
  '("alias" "and"
    "begin" "bg" "bind" "block" "break" "breakpoint" "builtin"
    "case" "cd" "command" "commandline" "complete" "contains" "continue" "count"
    "dirh" "dirs"
    "echo" "else" "emit" "end" "eval" "exec" "exit"
    "fg" "fish" "fish_config" "fish_indent" "fish_pager" "fish_prompt" "fish_right_prompt"
    "fish_update_completions" "fishd" "for" "funced" "funcsave" "function" "functions"
    "help" "history"
    "if" "isatty"
    "jobs"
    "math" "mimedb"
    "nextd" "not"
    "open" "or"
    "popd" "prevd" "psub" "pushd" "pwd"
    "random" "read" "return"
    "set" "set_color" "source" "status" "switch"
    "test" "trap" "type"
    "ulimit" "umask" "vared" "while"))

(defvar fish-builtin-commands-re
  (regexp-opt fish-builtin-commands 'words))

(defvar fish-font-lock-keywords-1
  (list
   ;; $VARIABLE
   (cons "\\$\\([[:alpha:]_][[:alnum:]_]*\\)" 'font-lock-variable-name-face)
   ;; set VARIABLE
   (cons "set \\([[:alpha:]_][[:alnum:]_]*\\)" '(1 font-lock-variable-name-face))
   ;; set -lx VARIABLE
   (cons "set \\(-[[:word:]]*\\)* \\([[:alpha:]_][[:alnum:]_]*\\)" '(2 font-lock-variable-name-face))
   (cons "function \\(\\sw+\\)" '(1 font-lock-function-name-face))
   (cons fish-builtin-commands-re 'font-lock-builtin-face)
   ))

(defvar fish-mode-syntax-table
  (let ((tab (make-syntax-table text-mode-syntax-table)))
    (modify-syntax-entry ?\# "<" tab)
    (modify-syntax-entry ?\n ">" tab)
    (modify-syntax-entry ?\" "\"\"" tab)
    (modify-syntax-entry ?\' "\"'" tab)
    (modify-syntax-entry ?_ "w" tab)
    (modify-syntax-entry ?. "w" tab)
    (modify-syntax-entry ?/ "w" tab)
    (modify-syntax-entry ?$ "_" tab)
    (modify-syntax-entry ?= "." tab)
    (modify-syntax-entry ?& "." tab)
    (modify-syntax-entry ?| "." tab)
    (modify-syntax-entry ?< "." tab)
    (modify-syntax-entry ?> "." tab)
    (modify-syntax-entry ?- "." tab)
    tab)
  "Syntax table used in Fish-mode buffers.")


;; Indentation

(defcustom fish-indent-offset 4
  "Default indentation offset for Fish."
  :group 'fish
  :type 'integer
  :safe 'integerp)


(defconst fish-indent-begin-keywords
  '("function")
  "Keywords that begin an indentation block scope.")

(defconst fish-indent-begin-re
  (regexp-opt fish-indent-begin-keywords 'symbols)
  "Regexp that matches beginning of indentation blocks")

(defconst fish-indent-end-re
  "\\_<end\\_>"
  "Regexp that matches the end of indentation block")

(defvar fish-indent-level 0
  "Buffer local state holding the current indentation level")
(make-variable-buffer-local 'fish-indent-level)


(defun fish-calculate-indent ()
  (message "Calculating indent. Line: %s, Point %s, Line: %s" (line-number-at-pos (point)) (point) (thing-at-point 'line))
  (message "Thing at point is: %s" (thing-at-point 'word))
  (message "Parse syntax at point is: %s": (syntax-ppss))
  (save-excursion
    (forward-line 0)
    (cond
     ;; Are we at the beginning of the buffer?  If so, don't indent.
     ((eq (point) (point-min))
      (message "Beginning of buffer. fish-indent-level = 0")
      (setq-local fish-indent-level 0))
     ;; Do we see a block beginning keyword on a previous line?
     ;; If so, increase the indent level.
     ((looking-at fish-indent-begin-re)
      (setq-local fish-indent-level (+ fish-indent-level fish-indent-offset))
      (message "Found fish-indent-begin keyword. fish-indent-level = %s" fish-indent-level))
     ;; Do we see a block ending keyword?  If so, decrease the indent level.
     ((looking-at fish-indent-end-re)
      (setq-local fish-indent-level (if (> fish-indent-level 0)
                                        (- fish-indent-level fish-indent-offset)))
      (message "Found fish-indent-end keyword. fish-indent-level = %s" fish-indent-level))

     (t
      ;; Default condition is to return the current indent level.
      (message "Default condition. fish-indent-level = %s" fish-indent-level)
      fish-indent-level)))
  )

(defun fish-indent-line ()
  (indent-line-to (fish-indent-level))
  )


;; Autoloads

;;;###autoload
(define-derived-mode fish-mode prog-mode "Fish"
  "Major mode for editing fish shell files."
  :syntax-table fish-mode-syntax-table
  (setq-local font-lock-defaults '(fish-font-lock-keywords-1))
  (setq-local comment-start "# ")
  (setq-local comment-start-skip "#+[\t ]*")
  (setq-local indent-line-function 'fish-indent-line))

;;;###autoload (add-to-list 'auto-mode-alist '("\\.fish\\'" . fish-mode))
;;;###autoload (add-to-list 'interpreter-mode-alist '("fish" . fish-mode))

(provide 'fish-mode)

;;; fish-mode.el ends here
