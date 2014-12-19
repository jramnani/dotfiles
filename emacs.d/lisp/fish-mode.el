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

(defcustom fish-indent-debug nil
  "Setting to true value will cause the indentation enging to print
debug messages to the *Messages* buffer."
  :group 'fish
  :type 'boolean
  :safe 'booleanp)


(defconst fish-indent-begin-keywords
  '("function")
  "Keywords that begin an indentation block scope.")

(defconst fish-indent-begin-re
  (regexp-opt fish-indent-begin-keywords 'symbols)
  "Regexp that matches beginning of indentation blocks")

(defconst fish-indent-end-re
  "\\_<end\\_>"
  "Regexp that matches the end of indentation block")

(require 'smie)

;; Grammar
(defconst fish-smie-grammar
  (smie-prec2->grammar
   (smie-bnf->prec2
    '((exp)  ; A constant, or a $var, or a sequence of them
      (cmd ("if" cmd "end")
           ("if" cmd "else" cmd "end")
           ("if" cmd "else if" cmd "else" cmd "end")
           ("for" exp "in" cmd "end")
           ("function" cmd "end")
           (cmd "|" cmd)
           (cmd "&&" cmd)
           (cmd "||" cmd)
           (cmd ";" cmd)
           (cmd "&" cmd)))
    '((assoc "case") (assoc ";" "&") (assoc "&&" "||") (assoc "|")))))


;; Tokenizers
(defun fish-smie-forward-token ()
  (forward-comment (point-max))
  (cond
   ((looking-at fish-builtin-commands-re)
    (goto-char (match-end 0))
    (match-string-no-properties 0))
   (t (buffer-substring-no-properties
       (point)
       (progn
         (skip-syntax-forward "w_.")
         (point))))))

(defun fish-smie-backward-token ()
  (forward-comment (- (point)))
  (cond
   ((looking-back fish-builtin-commands-re (- (point) 2) t)
    (goto-char (match-beginning 0))
    (match-string-no-properties 0))
   (t (buffer-substring-no-properties
        (point)
        (progn
          (skip-syntax-backward "w_.")
          (point))))))

;; Indentation rules
(defcustom fish-smie-indent-basic 4
   "Indentation level for Fish shell's SMIE configuration"
   :group 'fish
   :type 'integer
   :safe 'integerp)

(defun fish-smie-rules (kind token)
  (if fish-indent-debug
      (message "fish-smie-rules -> Kind: '%s', Token: '%s'" kind token))
  (pcase (cons kind token)
    (`(:elem . basic)
     (if (smie-rule-hanging-p)
         0
       fish-smie-indent-basic))
    (`(,_ . ,(or ",")) (smie-rule-separator kind))
    (`(:after . "end") 0)
    (`(:list-intro . ,(or `"function")) nil)
    (`(:before . "if")
     (and (not (smie-rule-bolp))
          (smie-rule-prev-p "else")
          (smie-rule-parent)))))


;; Autoloads

;;;###autoload
(define-derived-mode fish-mode prog-mode "Fish"
  "Major mode for editing fish shell files."
  :syntax-table fish-mode-syntax-table
  (setq-local font-lock-defaults '(fish-font-lock-keywords-1))
  (setq-local comment-start "# ")
  (setq-local comment-start-skip "#+[\t ]*")
  ;; Wire up SMIE for indentation
  (smie-setup fish-smie-grammar #'fish-smie-rules
              :forward-token #'fish-smie-forward-token
              :backward-token #'fish-smie-backward-token))


;;;###autoload
(add-to-list 'auto-mode-alist (cons (purecopy "\\.fish\\'")  'fish-mode))

;;;###autoload
(add-to-list 'interpreter-mode-alist (cons (purecopy "fish")  'fish-mode))

(provide 'fish-mode)

;;; fish-mode.el ends here
