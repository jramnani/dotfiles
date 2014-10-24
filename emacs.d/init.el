(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
			 ("org" . "http://orgmode.org/elpa/")
			 ("gnu" . "http://elpa.gnu.org/packages/")))

(require 'package)
(package-initialize)

;;;;;;;;;;;;;
;;
;; APPEARANCE
;;
;;;;;;;;;;;;;

;; Hide the menu bar when running in a terminal
(when (not (display-graphic-p))
  (menu-bar-mode -1))

;; Set color scheme
(load-theme 'solarized-dark t)

;; Show line numbers
(linum-mode t)
;; Give line numbers some breathing room
(setq linum-format "%4d ")


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
