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

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

  ;; Lisp code I find on the Internets that may not be packaged
  (add-to-list 'load-path "~/.emacs.d/vendor/")

  ;; My personal lisp programs
  (add-to-list 'load-path "~/.emacs.d/lisp/")

  ;; Keep customizations in a separate file
  (setq custom-file "~/.emacs.d/customizations.el")
  (load custom-file)

  (if (not (package-installed-p 'use-package))
      (progn
        (package-refresh-contents)
        (package-install 'use-package)))

  ;; Load use-package and its dependencies.
  (eval-when-compile
    (require 'use-package))
  (require 'diminish)
  (require 'bind-key)


  ;; ace-jump-mode lets you jump the cursor to any position in a file
  ;; by selecting letters near where you want to go.
  (use-package ace-jump-mode
    :commands ace-jump-mode
    :bind (("C-." . ace-jump-mode)
           ("C-," . ace-jump-line-mode))
    :ensure t)

  (use-package ansible
    :defines ac-dictionary-files
    :init
    (add-hook 'yaml-mode-hook '(lambda () (ansible 1)))
    :ensure t)

  (use-package ansible-doc
    :init
    (add-hook 'yaml-mode-hook #'ansible-doc-mode)
    :ensure t)

  ;; Apache web sever config files
  (use-package apache-mode
    :ensure t)

  (use-package browse-kill-ring
    :init
    (progn
      (browse-kill-ring-default-keybindings))
    :bind ("C-c y" . browse-kill-ring)
    :ensure t)

  (use-package clojure-mode
    :config
    (progn
      (use-package cider
        :ensure t))
    :defer t
    :ensure t)

  (use-package color-theme
    :ensure t)

  (use-package color-theme-solarized
    :init
    (progn
      (load-theme 'solarized t)
      ;; This theme uses the frame-parameter 'background-mode' to
      ;; determine whether to use the light or dark version of the
      ;; theme.
      (set-frame-parameter nil 'background-mode 'dark)
      (when (not (display-graphic-p))
        (set-terminal-parameter nil 'background-mode 'dark))
      ;; Call enable-theme to pick up the change to 'background-mode.
      (enable-theme 'solarized))
    :ensure t)

  ;; company-mode does auto-completion.
  (use-package company
    :init
    (add-hook 'prog-mode-hook 'company-mode)
    :ensure t)

  ;; company-quickhelp adds tooltip functionality to company-mode. These
  ;; tooltips usually show documentation for a given auto complete suggestion.
  (use-package company-quickhelp
    :init
    (company-quickhelp-mode 1)
    :ensure t)

  (use-package dokuwiki-mode
    :ensure t)

  ;; Flycheck checks your program source code on the fly as you edit.
  (use-package flycheck
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :ensure t)

  (use-package jinja2-mode
    :init
    (add-to-list 'auto-mode-alist '("\\.j2\\'" . jinja2-mode))
    :ensure t)

  (use-package magit
    :init
    (setq magit-last-seen-setup-instructions "1.4.0")
    :bind ("C-c g" . magit-status)
    :diminish magit-auto-revert-mode ;; (MRev)
    :ensure t)

  ;; magit-filenotify requires 'filenotify which appears in Emacs 24.4
  (when (and (version<= "24.4" emacs-version)
             (eq system-type 'linux))
    (use-package magit-filenotify
      :init
      (add-hook 'magit-status-mode-hook 'magit-filenotify-mode)
      :ensure t))

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
        (define-key markdown-mode-map (kbd "C-c C-c p") 'markdown-preview-file)))
    :ensure t)

  ;; Mercurial
  (use-package monky
    :bind (("C-c h" . monky-status))
    :ensure t)

  ;; The Nix package manager (http://nixos.org).
  (use-package nix-mode
    :ensure t)

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
      (setq org-log-done 'time))
    :ensure t)

  ;; Outline magic adds some extensions to Emacs vanilla outline-mode.
  ;; It adds visibility cycling and adds structural editing.
  ;; dokuwiki-mode supports outline-magic and makes it nicer to use.
  (use-package outline-magic
    :ensure t)

  ;; paredit is a minor-mode that for performing structured editing of
  ;; S-expressions.  Edit code, not text.
  (use-package paredit
    :init
    (progn
      (add-hook 'clojure-mode-hook 'enable-paredit-mode)
      (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
      (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
      (add-hook 'lisp-mode-hook 'enable-paredit-mode)
      (add-hook 'scheme-mode-hook 'enable-paredit-mode)
      )
    :ensure t)

  (use-package prelude-swap-windows
    :bind ("C-c s" . prelude-swap-windows)
    :load-path "vendor/")

  ;; Projectile makes switching directories and searching for files easier.
  (use-package projectile
    :init
    (projectile-global-mode)
    :ensure t)

  ;; Python
  (use-package python
    :commands python-mode
    :config
    (progn
      ;; Python hackers like their lines to be 72 columns.
      (set-fill-column 72)

      ;; jedi provides auto completion for Python programs. Depends on the
      ;; Python packages "jedi" and "epc" to be installed on the host
      ;; machine.
      (use-package jedi
        :init
        (progn
          (setq jedi:complete-on-dot t)
          (setq jedi:setup-keys t)
          (add-hook 'python-mode-hook 'jedi:setup))
        :ensure t)

      ;; company-jedi wires up jedi to be a backend for the auto completion
      ;; library, company-mode.
      (use-package company-jedi
        :init
        (add-hook 'python-mode-hook
                  (lambda () (add-to-list 'company-backends 'company-jedi)))
        :ensure t)

      ;; Install Python documentation in Emacs Info format.
      (use-package python-info
        :ensure t)

      ;; Work with virtual environments within Emacs
      (use-package virtualenvwrapper
        :commands (venv-activate venv-deactivate venv-mkvirtualenv venv-rmvirtualenv venv-workon)
        :init
        ;; Directory containing my virtualenvs
        (setq venv-location (concat (getenv "HOME") "/.venv/"))
        :config
        (progn
          ;; interactive shell support
          (venv-initialize-interactive-shells)
          ;; eshell support
          (venv-initialize-eshell))
        :ensure t)
      )
    :ensure t)

  ;; Auto-save and backup files are saved as plain text.  Disable them
  ;; for encrypted file types.
  (use-package sensitive-mode
    :mode ("\\.gpg\\'" . sensitive-mode))

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
    (smex-initialize)
    :ensure t)

  ;; Rename buffers and files together.
  (use-package steve-yegge-buffer-utils
    :load-path "vendor/")

  (use-package undo-tree
    :bind ("C-c u" . undo-tree-visualize)
    :config
    (global-undo-tree-mode)
    :diminish undo-tree-mode
    :ensure t)

  ;; writegood-mode can improve my writing style for prose.
  (use-package writegood-mode
    :init
    (progn
      (add-hook 'text-mode-hook 'writegood-mode))
    :ensure t)

  (use-package yaml-mode
    :ensure t)

  (use-package yasnippet
    :init
    (yas-global-mode 1)
    :diminish yas-minor-mode
    :ensure t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Abbreviations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use Emacs default facilities. Don't get fancy until I have to.
(if (file-exists-p abbrev-file-name)
    (progn
      (quietly-read-abbrev-file)
      (setq default-abbrev-mode t)))


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
(add-hook 'text-mode 'turn-on-auto-fill)

;; Show line numbers
(global-linum-mode t)
;; Give line numbers some breathing room
(setq linum-format "%4d ")

;; Show column numbers in the mode line
(column-number-mode)

;; Show matching parens
(show-paren-mode 1)

;; Show trailing whitespace
(setq show-trailing-whitespace t)

;; Don't need the startup message any more
(setq inhibit-startup-message t)

;; Smoother scrolling
;; http://stackoverflow.com/questions/445873/how-can-i-make-emacs-mouse-scrolling-slower-and-smoother
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Backup Files
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; don't litter the fs with backup and autosave files
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save/" t)))
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
  (setq locate-command "/usr/bin/mdfind"))

;; Stop typing full "yes or no" answers to Emacs.
(defalias 'yes-or-no-p 'y-or-n-p)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Machine local config
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "~/.emacs.local.el" 'noerror 'nomessage)

(provide 'init)
;;; init.el ends here
