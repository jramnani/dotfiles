;; Emacs IRC client configuration

(add-to-list 'erc-modules 'stamp)

;; If the module list is modified, you must call erc-update-modules for it to
;; take effect.
(erc-update-modules)

;; Hide messages that break up conversations.
(setq erc-hide-list '("JOIN" "PART" "QUIT"))
