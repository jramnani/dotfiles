;; Emacs IRC client configuration

(add-to-list 'erc-modules 'stamp)

;; If the module list is modified, you must call erc-update-modules for it to
;; take effect.
(erc-update-modules)

;; Set my nickname
(setq erc-nick "jramnani")

;; Hide messages that break up conversations.
(setq erc-hide-list '("JOIN" "PART" "QUIT"))

;; Identify my nickname with the IRC server
(load "jramnani-find-password.el")

(defun register-nickname-after-connect (SERVER NICK)
  (let ((credentials (jramnani-find-password SERVER
                                             (erc-compute-port)
                                             NICK)))
    (if credentials
        (erc-message "PRIVMSG" (concat "NickServ identify " (nth 1 (credentials)))))))

(add-hook 'erc-after-connect 'register-nickname-after-connect)
