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
   (cons "\\$\\([[:alpha:]_][[:alnum:]_]*\\)" 'font-lock-variable-name-face)
   (cons "function \\(\\sw+\\)" '(1 font-lock-function-name-face))
   (cons fish-builtin-commands-re 'font-lock-builtin-face)
   ))

(defvar fish-mode-syntax-table
  (let ((tab (make-syntax-table text-mode-syntax-table)))
    (modify-syntax-entry ?\# "<" tab)
    (modify-syntax-entry ?\n ">" tab)
    (modify-syntax-entry ?\" "\"\"" tab)
    (modify-syntax-entry ?\' "\"'" tab)
    (modify-syntax-entry ?_ "_" tab)
    (modify-syntax-entry ?$ "_" tab)
    (modify-syntax-entry ?= "." tab)
    (modify-syntax-entry ?& "." tab)
    (modify-syntax-entry ?| "." tab)
    (modify-syntax-entry ?< "." tab)
    (modify-syntax-entry ?> "." tab)
    (modify-syntax-entry ?- "." tab)
    tab)
  "Syntax table used in Fish-mode buffers.")


;;;###autoload
(define-derived-mode fish-mode prog-mode "Fish"
  "Major mode for editing fish shell files."
  :syntax-table fish-mode-syntax-table
  (setq-local font-lock-defaults '(fish-font-lock-keywords-1))
  (setq-local comment-start "# ")
  (setq-local comment-start-skip "#+[\t ]*"))

;;;###autoload (add-to-list 'auto-mode-alist '("\\.fish\\'" . fish-mode))
;;;###autoload (add-to-list 'interpreter-mode-alist '("fish" . fish-mode))

(provide 'fish-mode)

;;; fish-mode.el ends here
