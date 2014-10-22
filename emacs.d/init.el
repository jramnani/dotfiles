(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
			 ("org" . "http://orgmode.org/elpa/")
			 ("gnu" . "http://elpa.gnu.org/packages/")))

(require 'package)
(package-initialize)

; Manage backup files
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


; Evil mode must be enabled after all other initialization is complete.
;(require 'evil)
;(evil-mode 1)
