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
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t))

(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(require 'use-package)

(use-package browse-kill-ring
  :init
  (progn
    (browse-kill-ring-default-keybindings))
  :bind ("C-c y" . browse-kill-ring)
  :ensure t)

(use-package color-theme
  :init
  (color-theme-initialize)
  :ensure t)

(use-package color-theme-solarized
  :init
  (load-theme 'solarized-dark t)
  :ensure t)

(use-package fish-mode
  :mode "\\.fish\\'"
  :ensure t)

(use-package magit
  :bind (("C-x C-g" . magit-status)
         ("C-c C-g" . magit-status))
  :ensure t)

(use-package magit-filenotify
  :ensure t)

(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :ensure t)

(use-package yasnippet
  :idle
  (yas-global-mode 1)
  :ensure t)


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

;; Show line numbers
(linum-mode)
;; Give line numbers some breathing room
(setq linum-format "%4d ")

;; Show column numbers in the mode line
(column-number-mode)

;; Show matching parens
(show-paren-mode 1)

;; Show trailing whitespace
(setq show-trailing-whitespace t)

;; When am I not on an 80 column terminal?
(setq fill-column 80)

;; Don't need the startup message any more
(setq inhibit-startup-message t)


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

;; Dismiss the buffer that has the current focus
(global-set-key (kbd "C-c d") (lambda ()
                                "Dismiss buffer"
                                (interactive)
                                (other-window 1)
                                (delete-other-windows)))

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
;; Whitespace
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; I prefer spaces to tabs
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;; Clean up trailing whitespace on file save
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Evil
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Evil mode must be enabled after all other initialization is complete.
;(require 'evil)
;(evil-mode 1)