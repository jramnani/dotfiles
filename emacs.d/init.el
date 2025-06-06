;;; init.el --- Initialization file for Emacs.
;;;
;;; Commentary:
;;;
;;; Author: Jeff Ramnani
;;;
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Packaging
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Fix Emacs bug: #28603. Should be fixed upstream in version 26.
;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=28603#5
(setq gnutls-trustfiles '("/etc/ssl/cert.pem"))

(defun in-user-emacs-directory
    (relative-directory)
  "Concat RELATIVE-DIRECTORY to user-emacs-directory.
RELATIVE-DIRECTORY should end in a slash."
  (concat user-emacs-directory relative-directory))

(defun init-packages ()
  "Initialize Emacs package management."

  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

  ;; Lisp code I find on the Internets that may not be packaged
  (add-to-list 'load-path (in-user-emacs-directory "vendor/"))

  ;; My personal lisp programs
  (add-to-list 'load-path (in-user-emacs-directory "lisp/"))

  ;; Keep customizations in a separate file
  (setq custom-file (in-user-emacs-directory "customizations.el"))
  (load custom-file 'noerror))

(defun install-packages ()
  "Install and configure third-party packages."

  (if (not (package-installed-p 'use-package))
      (progn
        (package-refresh-contents)
        (package-install 'diminish)
        (package-install 'use-package)))

  ;; Load use-package and its dependencies.
  (eval-when-compile
    (require 'use-package))

  ;; Diminish needs to be loaded before any packages that depend on it.
  ;; (use-package diminish)

  (require 'bind-key)

  ;; Assume packages should be installed
  (setq use-package-always-ensure t)

  ;; ace-jump-mode lets you jump the cursor to any position in a file
  ;; by selecting letters near where you want to go.
  (use-package ace-jump-mode
    :commands ace-jump-mode
    :bind (("C-." . ace-jump-mode)
           ("C-," . ace-jump-line-mode)))

  (use-package ace-window
    :bind ("M-o" . 'ace-window))

  (use-package ansible
    :defines ac-dictionary-files
    :init
    (add-hook 'yaml-mode-hook '(lambda () (ansible 1))))

  (use-package ansible-doc
    :init
    (add-hook 'yaml-mode-hook #'ansible-doc-mode))

  ;; Apache web sever config files
  (use-package apache-mode)

  (use-package browse-kill-ring
    :init
    (progn
      (browse-kill-ring-default-keybindings))
    :bind ("C-c y" . browse-kill-ring))

  (use-package clojure-mode)

  ;; Cider is an interactive development environment for Clojure.
  (use-package cider)

  ;; company-mode does auto-completion.
  (use-package company
    :init
    (add-hook 'prog-mode-hook 'company-mode))

  ;; company-quickhelp adds tooltip functionality to company-mode. These
  ;; tooltips usually show documentation for a given auto complete suggestion.
  (use-package company-quickhelp
    :init
    (company-quickhelp-mode 1))

  (use-package dracula-theme)

  (use-package dokuwiki-mode)

  (use-package dtrace-script-mode
    :mode "\\.d\\'")

  ;; Elixir
  (use-package elixir-mode
    :init
    (add-hook 'elixir-format-hook (lambda ()
                                    (if (projectile-project-p)
                                        (setq elixir-format-arguments
                                              (list "--dot-formatter"
                                                    (concat (locate-dominating-file buffer-file-name ".formatter.exs") ".formatter.exs")))
                                      (setq elixir-format-arguments nil))))
    (add-hook 'elixir-mode-hook
              (lambda () (add-hook 'before-save-hook 'elixir-format nil t))))

  (use-package fish-mode)

  (use-package ruby-end
    :diminish ruby-end-mode)

  (use-package elixir-yasnippets)

  (use-package flycheck-credo
    :init
    (eval-after-load 'flycheck
      '(flycheck-credo-setup))
    :hook (elixir-mode . flycheck-mode))

  (use-package flycheck-dialyxir
    :init
    (eval-after-load 'flycheck
      '(flycheck-dialyxir-setup))
    :hook (elixir-mode . flycheck-mode))

  (use-package alchemist
    :init
    (setq alchemist-goto-elixir-source-dir "~/code/elixir/elixir")
    (add-to-list 'elixir-mode-hook
                 (defun auto-activate-ruby-end-mode-for-elixir-mode ()
                   (set (make-variable-buffer-local 'ruby-end-expand-keywords-before-re)
                        "\\(?:^\\|\\s-+\\)\\(?:do\\)")
                   (set (make-variable-buffer-local 'ruby-end-check-statement-modifiers) nil)
                   (ruby-end-mode +1)))
    :config
    (add-to-list 'alchemist-iex-mode-hook
                 (lambda () (company-mode-on)))
    :hook (elixir-mode . alchemist-mode))


  ;; eldoc provides help on elisp function arguments in the minibuffer.
  (use-package eldoc
    :init
    (progn
      (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
      (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)))

  ;; ERT is the Emacs Lisp Regression Testing tool. Basically, the unit testing
  ;; framework for Elisp.
  (use-package ert-results-mode
    :ensure nil
    :commands ert-results-mode
    :config
    ;; ERT opens a new window to show me the results.  Then, when I try
    ;; to quit the results window, it buries the buffer instead of
    ;; deleting the window.  Delete the new window, please.
    (bind-key (kbd "q") 'delete-window ert-results-mode-map))

  ;; Configure Emacs 'exec-path' variable to be the same as my SHELL's PATH.
  ;; Specifically for OS X GUI editor windows because GUI apps get a different
  ;; default environment.
  (use-package exec-path-from-shell
    :init
    (when (memq window-system '(mac ns))
      (exec-path-from-shell-initialize)))

  ;; Provides a visual indicator of where the 'fill-column' is set.
  ;; 'fill-column' is used for wrapping lines.
  (use-package fill-column-indicator
    :init
    (add-hook 'prog-mode-hook 'fci-mode)
    ;; fci-mode is messing with auto complete and quickhelp.
    :disabled t)

  ;; Flycheck checks your program source code on the fly as you edit.
  (use-package flycheck
    :init
    (add-hook 'after-init-hook #'global-flycheck-mode))

  ;; GitLab CI
  (use-package gitlab-ci-mode)

  (use-package gitlab-ci-mode-flycheck
    :after flycheck gitlab-ci-mode
    :init
    (gitlab-ci-mode-flycheck-enable))

  ;; Get link to open buffer in GitHub/GitLab.
  ;; Optionally open it in the browser.
  (use-package git-link
    :config
    (setq git-link-open-in-browser nil))

  ;; Golang
  (use-package go-mode)

  ;; Groovy
  (use-package groovy-mode
    :init
    (add-to-list 'auto-mode-alist '("Jenkinsfile\\'" . groovy-mode)))

  (use-package jinja2-mode
    :init
    (add-to-list 'auto-mode-alist '("\\.j2\\'" . jinja2-mode)))

  ;; Date and time utility functions.
  (use-package jramnani-date
    :load-path "lisp/")

  ;; Pretty print JSON in a buffer
  (use-package json-format
    :load-path "lisp/")

  ;; Lice inserts open source license text as comments in the buffer.
  ;; Useful for inserting file headers.
  (use-package lice
    :commands lice
    :init
    (setq lice:default-license "mit"))

  (use-package lisp-mode
    :ensure nil
    :commands emacs-lisp-mode
    :config
    (progn
      ;; Set up a keybinding to run tests.  When run interactively ERT doesn't
      ;; visit your test file to pick up changes, instead you must eval the
      ;; buffer, because ERT just runs whatever's in memory.
      (defun jramnani-run-ert-tests ()
        "Run Emacs Lisp tests interactively using ERT"
        (interactive)
        (eval-buffer)
        (ert t))
      (bind-key (kbd "C-c t") 'jramnani-run-ert-tests emacs-lisp-mode-map)))

  ;; Git client for Emacs
  (use-package magit
    :bind ("C-c g" . magit-status)
    :hook (git-commit-mode . (lambda () (set-fill-column 72)))
    :config
    (setq git-commit-summary-max-length 50))

  (use-package markdown-mode
    :config
    (progn
      (when (eq system-type 'darwin)
        (defun markdown-preview-file ()
          "Use Marked.app to preview the current file"
          (interactive)
          (shell-command
           (format "open -a 'Marked 2.app' %s"
                   (shell-quote-argument (buffer-file-name))))
          )
        (define-key markdown-mode-map (kbd "C-c C-c p") 'markdown-preview-file))))

  ;; Mercurial
  (use-package monky
    :bind (("C-c h" . monky-status)))

  ;; Directory browser like NERDTree for Vim
  (defun neotree-project-dir ()
    "Open NeoTree at the projectile root."
    (interactive)
    (let ((project-dir (projectile-project-root))
          (file-name (buffer-file-name)))
      (neotree-toggle)
      (if project-dir
          (if (neo-global--window-exists-p)
              (progn
                (neotree-dir project-dir)
                (neotree-find file-name))))))

  (use-package neotree
    :bind (("C-c d" . neotree-project-dir))
    :config
    (setq neo-create-file-auto-open t
          neo-smart-open t
          neo-show-hidden-files t
          neo-auto-indent-point t)
    (setq neo-theme (if (display-graphic-p) 'nerd 'arrow)))

  ;; The Nix package manager (http://nixos.org).
  (use-package nix-mode)

  ;; org-mode
  (use-package org
    :bind
    ("C-c a" . org-agenda)
    :init
    (progn
      ;; Org Agenda view requires that you tell it which files to process
      (setq org-agenda-files (quote ("~/Dropbox/Documents/OrgMode/todo.org")))
      ;; Keywords to describe the state of a task
      (setq org-todo-keywords
            '((sequence "TODO(t)" "IN-PROGRESS" "WAITING" "DONE")))
      ;; Change the font colors used for todo items.
      ;; IN-PROGRESS = Solarized violet
      ;; TODO = Solarized orange
      (setq org-todo-keyword-faces '(("IN-PROGRESS" . (:foreground "#6c71c4" :weight "bold"))
                                     ("TODO" . (:foreground "#cb4b16" :weight "bold"))))
      ;; Attach a timestamp to completed tasks
      (setq org-log-done 'time)))

  ;; Outline magic adds some extensions to Emacs vanilla outline-mode.
  ;; It adds visibility cycling and adds structural editing.
  ;; dokuwiki-mode supports outline-magic and makes it nicer to use.
  (use-package outline-magic)

  ;; paredit is a minor-mode for performing structured editing of
  ;; S-expressions.  Edit code, not text.
  (use-package paredit
    :init
    (progn
      (add-hook 'clojure-mode-hook 'enable-paredit-mode)
      (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
      (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
      (add-hook 'lisp-mode-hook 'enable-paredit-mode)
      (add-hook 'scheme-mode-hook 'enable-paredit-mode)))

  (use-package prelude-copy-file-name-to-clipboard
    :load-path "vendor/")

  (use-package prelude-smarter-move-beginning-of-line
    :init
    (global-set-key [remap move-beginning-of-line]
                    'prelude-smarter-move-beginning-of-line)
    :load-path "vendor/")

  (use-package prelude-swap-windows
    :bind ("C-c s" . prelude-swap-windows)
    :load-path "vendor/")

  ;; Projectile makes switching directories and searching for files easier.
  ;; Set projectile-project-search-path to my local project directories in my
  ;; local machine config.
  (use-package projectile
    :init
    (projectile-mode +1)
    :bind (("C-c p" . projectile-command-map)))

  ;; Python
  (use-package python
    :commands python-mode
    :init
    (progn
      ;; Configure modes for Pipenv files
      (add-to-list 'auto-mode-alist '("Pipfile\\'" . conf-mode))
      (add-to-list 'auto-mode-alist '("Pipfile\\.lock\\'" . javascript-mode)))
    :config
    (progn
      ;; Python hackers like their lines to be 72 columns.
      (set-fill-column 72)))

  ;; jedi provides auto completion for Python programs. Depends on the
  ;; Python packages "jedi" and "epc" to be installed on the host
  ;; machine.
  ;; To install on a new machine run the following commands:
  ;; M-x jedi:install-server
  (use-package jedi-core
    :init
    ;; Tell Jedi to use python3
    (setq py-python-command "/usr/bin/env python3")
    ;; This variable needs to be set for the jedi:environment-virtualenv config to work.
    (setq jedi:environment-root "jedi")
    ;; Use Python 3 for Jedi
    ;; Add --always-copy to virtualenv invocation. Homebrew keeps breaking
    ;; symlinks when upgrading Python, even for patch releases.
    (setq jedi:environment-virtualenv
          '("virtualenv" "--quiet" "--python" "python3" "--always-copy"))
    (add-hook 'python-mode-hook 'jedi:setup))

  ;; company-jedi wires up jedi to be a backend for the auto completion
  ;; library, company-mode.
  (use-package company-jedi
    :init
    (add-hook 'python-mode-hook
              (lambda () (add-to-list 'company-backends 'company-jedi))))

  ;; A major mode for editing Pip requirements files.
  (use-package pip-requirements)

  ;; Install Python documentation in Emacs Info format.
  (use-package python-info)

  ;; Work with Python virtual environments within Emacs
  (use-package virtualenvwrapper
    :commands (venv-activate venv-deactivate venv-mkvirtualenv venv-rmvirtualenv venv-workon)
    :init
    ;; Directory containing my virtualenvs
    (setq venv-location (concat (getenv "HOME") "/.virtualenvs"))
    :config
    (progn
      ;; interactive shell support
      (venv-initialize-interactive-shells)
      ;; eshell support
      (venv-initialize-eshell)))

  (use-package rainbow-delimiters
    :hook ((clojure-mode . rainbow-delimiters-mode)
           (emacs-lisp-mode . rainbow-delimiters-mode)
           (lisp-mode . rainbow-delimiters-mode)))

  ;; re-builder lets you build regular expressions interactively.
  (use-package re-builder
    :config
    (progn
      ;; Setting reb-re-syntax to 'string let's you write regexes with
      ;; fewer backslash escapes.
      (setq reb-re-syntax 'string)))

  ;; Auto-save and backup files are saved as plain text.  Disable them
  ;; for encrypted file types.
  (use-package sensitive-mode
    :mode ("\\.gpg\\'" . sensitive-mode)
    :load-path "lisp/")

  (use-package shell-script-mode
    :ensure nil
    ;; For editing my Bash profile within my dotfiles repo.
    :mode ("bash\\(rc\\|_profile\\|machinerc\\)\\'" . shell-script-mode))

  ;; Smex provides history and searching on top of M-x.
  (use-package smex
    :bind (("M-x" . smex)
           ("M-X" . smex-major-mode-commands)
           ("C-x m" . smex)
           ("C-c m" . smex))
    :init
    (progn
      (setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory)))
    :config
    (smex-initialize))

  ;; Solarized color theme
  (use-package solarized-theme
    :init
    (load-theme 'solarized-dark t))

  ;; Edit SSH Config files.
  (use-package ssh-config-mode
    :mode ((".ssh/config\\'"       . ssh-config-mode)
           ("sshd?_config\\'"      . ssh-config-mode)
           ("known_hosts\\'"       . ssh-known-hosts-mode)
           ("authorized_keys2?\\'" . ssh-authorized-keys-mode)))

  ;; Rename buffers and files together.
  (use-package steve-yegge-buffer-utils
    :load-path "vendor/")

  (use-package undo-tree
    :bind (("C-c u" . undo-tree-visualize)
           ("s-z" . undo-tree-undo)
           ("s-Z" . undo-tree-redo))
    :init
    (progn
      (defalias 'redo 'undo-tree-redo)
      (setq undo-tree-history-directory-alist `(("." . ,(in-user-emacs-directory "tmp/undo")))
            undo-tree-auto-save-history t
            undo-tree-visualizer-timestamps t
            undo-tree-visualizer-diff t))
    :diminish undo-tree-mode)

  ;; The unfill package provides the inverse functions of Emacs' fill-paragraph
  ;; and fill-region commands.
  (use-package unfill)

  ;; Web mode - Emacs standard HTML mode doesn't understand templates, or CSS, or JS.
  (use-package web-mode
    :mode (;; Use web-mode for plain HTML
           "\\.html?\\'"
           ;; PHP
           "\\.phtml\\'"
           ;; Microsoft ASP and Java JSP templates
           "\\.[agj]sp\\'"
           "\\.as[cp]x\\'"
           ;; Ruby templates
           "\\.erb\\'"
           ;; Mustache templates
           "\\.mustache\\'"
           ;; Django templates
           "\\.djhtml\\'"
           ;; Jinja templates
           "\\.j2\\'"
           "\\.jinja2\\'")
    :init
    ;; fci-mode causes weird issues with web-mode. e.g. indentation.
    (add-hook 'web-mode-hook 'turn-off-fci-mode))

  ;; winner mode remembers window configurations
  ;; It's like undo/redo for window configurations
  (use-package winner
    :ensure nil
    :init
    (progn
      (when (fboundp 'winner-mode)
	    (winner-mode 1))))

  ;; writegood-mode can improve my writing style for prose.
  (use-package writegood-mode
    :init
    (progn
      (add-hook 'text-mode-hook 'writegood-mode)))

  ;; OS X property list files.
  (use-package xml-mode
    :ensure nil
    :mode "\\.plist\'")


  (use-package yaml-mode)

  (use-package yasnippet
    :config
    (yas-global-mode 1)
    :defer 2
    :diminish yas-minor-mode)

  (use-package yasnippet-snippets)
)


(when (>= emacs-major-version 24)
  (progn
    (init-packages)
    (install-packages)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Abbreviations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use Emacs default facilities. Don't get fancy until I have to.
(if (file-exists-p abbrev-file-name)
    (progn
      (quietly-read-abbrev-file)
      (setq-default abbrev-mode t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Appearance
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Hide the menu bar when running in a terminal
(when (not (display-graphic-p))
  (menu-bar-mode -1))

;; Choose a font. In order of preference.
(when (display-graphic-p)
  (cond
   ((find-font (font-spec :name "Inconsolata"))
    (set-frame-font "Inconsolata-16"))
   ((find-font (font-spec :name "Monaco"))
    (set-frame-font "Monaco-14"))))

;; auto-fill-mode automatically wraps text. It uses the variable
;; "fill-column" to determine when to wrap.
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Show line numbers
(global-display-line-numbers-mode 1)
;; Show column numbers in the mode line
(column-number-mode)

;; Show matching parens
(show-paren-mode 1)

;; Show trailing whitespace
(setq show-trailing-whitespace t)

;; Smoother scrolling
;; http://stackoverflow.com/questions/445873/how-can-i-make-emacs-mouse-scrolling-slower-and-smoother
(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)

(setq scroll-margin 10
      scroll-step 1
      next-line-add-newlines nil
      scroll-conservatively 10000
      scroll-preserve-screen-position t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Backup Files
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; don't litter the fs with backup and autosave files
(setq backup-directory-alist `(("." . ,(in-user-emacs-directory "backups/"))))
(setq auto-save-file-name-transforms `((".*" ,(in-user-emacs-directory "auto-save/") t)))
;; Use versioned backups
(setq version-control t)
;; keep this many recent backup versions of a file
(setq kept-new-versions 6)
;; Don't clobber symlinks
(setq backup-by-copying t)
;; Delete excess backup files silently (don't ask me)
(setq delete-old-versions t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Buffers
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ibuffer lets you operate on buffers in the same manner as dired, and color codes
;; different file types.
(defalias 'list-buffers 'ibuffer)

;; ido swaps out switch-to-buffer with a nicer autocomplete system
(ido-mode 1)
;; Enable flex matching, which I hope works like fuzzy matching
(setq ido-enable-flex-matching t)
;; Case insensitive searching for ido
(setq ido-case-fold t)
;; Don't ask me to confirm when creating new buffers
(setq ido-create-new-buffer 'always)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Emacs Server
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Run emacs as a daemon, but only for GUI sessions
(when (display-graphic-p)
  (server-start))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Environment
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; exec-path is used by Emacs to find programs it needs for features like
;; EasyPG, spell checking, and file compression.
(setq exec-path (append '("/usr/local/bin" "/usr/local/sbin") exec-path))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Keybord mappings
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; M-f should go to the beginning of the next word. Like Vim's `w'` command
;; Emacs default behavior of moving you to the *end* of a word has always been
;; awkward for me.
(global-set-key (kbd "M-f") 'forward-to-word)
(global-set-key (kbd "M-F") 'forward-word)

;; Remap M-x to something more comfortable
(global-set-key (kbd "C-c C-m") 'execute-extended-command)
(global-set-key (kbd "C-x C-m") 'execute-extended-command)

;; Remap C-w to work like the shell
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-c C-k") 'kill-region)
(global-set-key (kbd "C-x C-k") 'kill-region)

;; F3 starts recording a macro, F4 stops recording, now F5 will replay the macro
(global-set-key (kbd "<f5>") 'call-last-kbd-macro)

;; Toggle line wrapping.
(global-set-key (kbd "C-c q") 'auto-fill-mode)

;; Toggle showing line numbers
(global-set-key (kbd "C-c l") 'linum-mode)

;; Toggle showing whitespace
(global-set-key (kbd "C-c w") 'whitespace-mode)
;; Same, but carry over from my Vim days.
(global-set-key (kbd "<f2>") 'whitespace-mode)

;; When I split a window, move the focus to the new window
(global-set-key (kbd "C-x 2") (lambda ()
                                (interactive)
                                (split-window-vertically)
                                (other-window 1)))

(global-set-key (kbd "C-x 3") (lambda ()
                                (interactive)
                                (split-window-horizontally)
                                (other-window 1)))

;; Use regexp searching by default
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; Join line (mapped to act like vim's "J" which is more intuitive to me)
(global-set-key (kbd "C-c j") (lambda ()
                                (interactive)
                                (join-line 1)))

;; org-mode key bindings need to be specified when using iTerm2
(when (string= "iTerm.app" (getenv "TERM_PROGRAM"))
  (define-key input-decode-map "\e[1;9A" [M-up])
  (define-key input-decode-map "\e[1;9B" [M-down])
  (define-key input-decode-map "\e[1;9C" [M-right])
  (define-key input-decode-map "\e[1;9D" [M-left])

  (define-key input-decode-map "\e[1;10A" [M-S-up])
  (define-key input-decode-map "\e[1;10B" [M-S-down])
  (define-key input-decode-map "\e[1;10C" [M-S-right])
  (define-key input-decode-map "\e[1;10D" [M-S-left])
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Shell
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TODO: Emacs doesn't like Fish in shell-mode, or it doesn't like something
;; in my fish config.
(setenv "ESHELL" "/bin/bash")
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Spell Check
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set my default dictionary.
(setq ispell-dictionary "english")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Whitespace
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; I prefer spaces to tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Clean up trailing whitespace on file save
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Miscellaneous
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (eq system-type 'darwin)
  ;; Use Spotlight to locate files.  Thanks, EmacWiki.
  ;; http://www.emacswiki.org/emacs/MacOSTweaks#toc7
  (setq locate-command "/usr/bin/mdfind")

  ;; Prefer to open new files in an existing Frame, rather than creating a new
  ;; Frame each time.
  ;; https://superuser.com/questions/277755/emacs-opens-files-in-a-new-frame-when-opened-with-open-a
  (setq ns-pop-up-frames nil))

;; Stop typing full "yes or no" answers to Emacs.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Startup message and scratch buffer
(setq
 ;; don't need the startup message anymore
 inhibit-startup-message t
 ;; empty scratch buffer
 initial-scratch-message nil
 ;; scratch buffer default
 initial-major-mode 'text-mode
 ;; Select help window so it's easy to quit it with 'q'
 help-window-select t
 )

;; Delete selected text when typing. This also overwrites highlighted text
;; during copy/paste. This makes copy/paste a lot easier for me.
(delete-selection-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Machine local config
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "~/.emacs.local.el" 'noerror 'nomessage)

(provide 'init)
;;; init.el ends here
