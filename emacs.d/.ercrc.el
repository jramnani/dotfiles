;; Emacs IRC client configuration

(add-to-list 'erc-modules 'stamp)

;; If the module list is modified, you must call erc-update-modules for it to
;; take effect.
(erc-update-modules)

;; Set my nickname
(setq erc-nick "jramnani")

;; Hide messages that break up conversations.
(setq erc-hide-list '("JOIN" "NICK" "PART" "QUIT"))

(use-package jramnani-auth
  :load-path "lisp/")

;; Identify my nickname with the IRC server.
(defun register-nickname-after-connect (SERVER NICK)
  (let ((credentials (jramnani-find-password SERVER
                                             (erc-compute-port)
                                             NICK)))
    (if credentials
        (erc-message "PRIVMSG" (concat "NickServ identify " (nth 1 (credentials)))))))

(add-hook 'erc-after-connect 'register-nickname-after-connect)


;; Notify me when my nick is mentioned.

;; Don't notify me about these types of messages.
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))

;; Thanks, https://github.com/danielsz/.emacs.d/blob/master/org-init.org#erc
(defvar notify-command (executable-find "terminal-notifier") "The path to terminal-notifier")

(defun jramnani-notify (title message)
  "Shows a message through the Notification center system using
 `notify-command` as the program."
  (cl-flet ((encfn (s) (encode-coding-string s (keyboard-coding-system))) )
    (let* ((process (start-process "notify" nil
                                   notify-command
                                   "-title" (encfn title)
                                   "-message" (encfn message))))))
  t)

(defun jramnani-erc-hook (match-type nick message)
  "Shows a notification, when user's nick was mentioned. If the buffer is currently not visible, makes it sticky."
  (unless (posix-string-match "^\\** *Users on #" message)
    (jramnani-notify
     (concat "ERC: name mentioned on: " (buffer-name (current-buffer)))
     message
     )))

(when (bound-and-true-p notify-command)
  (add-hook 'erc-text-matched-hook 'jramnani-erc-hook))
