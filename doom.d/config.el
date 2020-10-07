;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jeff Ramnani"
      user-mail-address "jeff@jefframnani.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; In visual mode, Doom maps TAB to yas-insert-snippet, which is dumb.
;; One of my favorite features of Emacs is indent-region which many times just
;; does the right thing.
;; I don't think I ever want to replace a region of text with a snippet.
(map! :v [tab] #'indent-region)


;; Increase the default font size. You whippersnappers.
(set-face-attribute 'default nil :height 160)


(defun my-neotree-project-dir-toggle ()
  "Open NeoTree using the project root, using projectile, find-file-in-project,
or the current buffer directory."
  (interactive)
  (let* ((filepath (buffer-file-name))
         (project-dir
          (with-demoted-errors
              (cond
               ((featurep 'projectile)
                (projectile-project-root))
               ((featurep 'find-file-in-project)
                (ffip-project-root))
               (t ;; Fall back to version control root.
                (if filepath
                    (vc-call-backend
                     (vc-responsible-backend filepath) 'root filepath)
                  nil)))))
         (neo-smart-open t))

    (if (and (fboundp 'neo-global--window-exists-p)
             (neo-global--window-exists-p))
        (neotree-hide)
      (neotree-show)
      (when project-dir
        (neotree-dir project-dir))
      (when filepath
        (neotree-find filepath)))))

(map! :leader "d" #'my-neotree-project-dir-toggle)

;; (use-package! undo-tree
;;   :bind (("C-c u" . undo-tree-visualize)
;;          ("s-z" . undo-tree-undo)
;;          ("s-Z" . undo-tree-redo))
;;   :init
;;   (progn
;;     (global-undo-tree-mode)
;;     (defalias 'redo 'undo-tree-redo)
;;     (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/tmp/undo"))
;;           undo-tree-auto-save-history t
;;           undo-tree-visualizer-timestamps t
;;           undo-tree-visualizer-diff t))
;;   :diminish undo-tree-mode)

;; (map! :leader "u" #'undo-tree-visualize)

(use-package! ace-window
  :bind ("M-o" . 'ace-window))

(use-package! browse-kill-ring
  :init
  (progn
    (browse-kill-ring-default-keybindings))
  :bind ("C-c y" . browse-kill-ring))

;; I don't know why Doom changes this value to 2. It absolutely ruins
;; performance when editing files. And how much typing am I actually saving
;; when completing on really short tokens?
(use-package! company
  :init
  (setq company-minimum-prefix-length 3))

(use-package! projectile
  :config
  (setq projectile-project-search-path '("~/code" "~/work")))
