;;;;;;;;;;;;;
;;
;; PACKAGING
;;
;;;;;;;;;;;;;

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

(use-package color-theme
  :init
  (color-theme-initialize)
  :ensure t)

(use-package color-theme-solarized
  :init
  (load-theme 'solarized-dark t)
  :ensure t)


;;;;;;;;;;;;;
;;
;; APPEARANCE
;;
;;;;;;;;;;;;;

;; Hide the menu bar when running in a terminal
(when (not (display-graphic-p))
  (menu-bar-mode -1))

;; Show line numbers
(linum-mode)
;; Give line numbers some breathing room
(setq linum-format "%4d ")

;; Show matching parens
(show-paren-mode 1)

;;;;;;;;;;;;;;;
;;
;; BACKUP FILES
;;
;;;;;;;;;;;;;;;

(setq
 ; don't clobber symlinks
 backup-by-copying t
 ; don't litter the fs with backup files
 backup-directory-alist '(("." . "~/tmp/emacs"))
 delete-old-versions t
 kept-new-versions 6
 kept-new-versions 2
 ; use versioned backups
 version-control t
 )


;;;;;;;;;;;;;;;;;
;;
;; Keybord mappings
;;
;;;;;;;;;;;;;;;;;

;; Remap M-x to something more comfortable
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\C-x\C-m" 'execute-extended-command)

;; Remap C-w to work like the shell
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key "\C-x\C-k" 'kill-region)

;; F3 starts recording a macro, F4 stops recording, now F5 will replay the macro
(global-set-key [f5] 'call-last-kbd-macro)

;; org-mode key bindings need to be specified when using iTerm2
(when (string= "iTerm.app" (getenv "TERMINAL_PROGRAM"))
  (define-key input-decode-map "\e[1;9A" [M-up])
  (define-key input-decode-map "\e[1;9B" [M-down])
  (define-key input-decode-map "\e[1;9C" [M-right])
  (define-key input-decode-map "\e[1;9D" [M-left])

  (define-key input-decode-map "\e[1;10A" [M-S-up])
  (define-key input-decode-map "\e[1;10B" [M-S-down])
  (define-key input-decode-map "\e[1;10C" [M-S-right])
  (define-key input-decode-map "\e[1;10D" [M-S-left])
)


;;;;;;;;;;;;;
;;
;; WHITESPACE
;;
;;;;;;;;;;;;;

;; I prefer spaces to tabs
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;;;;;;;
;;
;; Evil
;;
;;;;;;;

;; Evil mode must be enabled after all other initialization is complete.
;(require 'evil)
;(evil-mode 1)
