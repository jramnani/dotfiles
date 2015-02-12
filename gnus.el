;; Configuration for Gnus. A mail / message reader for Emacs.


 ;; Getting mail and/or news
(setq gnus-select-method '(nntp "news.gnus.org"))


;; Reading messages
;; When a new message comes in for an old conversation, show the previous messages in the conversation.
(setq gnus-fetch-old-headers t)

;; Collapse sequences of quoted lines to the last five only.
;; You can expand and recollapse the hidden portions with "W W c"
;; (setq gnus-treat-hide-citation t
;;       gnus-cited-lines-visible '(0 . 5))

;; Sort messages in reverse chronological order.
;; Settings found at: https://groups.google.com/forum/#!topic/gnu.emacs.help/LYRGpoR4nmY
;; (setq gnus-thread-sort-functions '(gnus-thread-sort-by-number
;;                                    (not gnus-thread-sort-by-most-recent-date))
;;       gnus-subthread-sort-functions '(gnus-thread-sort-by-number
;;                                       gnus-thread-sort-by-date)
;;       gnus-sort-gathered-threads-function 'gnus-thread-sort-by-date)



;; Avoid rich-text messages
(setq mm-discouraged-alternatives '("text/html" "text/richtext"))

;; Summary view formatting
;; Inspired by: https://github.com/correl/dotfiles/blob/master/.emacs.d/emacs.org
(defun jramnani-gnus-summary-line-format-ascii nil
  (interactive)
  (setq gnus-sum-thread-tree-indent " ")
  (setq gnus-sum-thread-tree-root "* ")
  (setq gnus-sum-thread-tree-false-root "x ")
  (setq gnus-sum-thread-tree-single-indent "o ")
  (setq gnus-sum-thread-tree-vertical        "| ")
  (setq gnus-sum-thread-tree-leaf-with-other "|-> ")
  (setq gnus-sum-thread-tree-single-leaf     "+-> ")
  (gnus-message 5 "Using ascii tree layout"))

(defun jramnani-gnus-summary-line-format-unicode nil
  (interactive)
  (setq gnus-sum-thread-tree-indent          "  ")
  (setq gnus-sum-thread-tree-root            "● ")
  (setq gnus-sum-thread-tree-false-root      "◯ ")
  (setq gnus-sum-thread-tree-single-indent   "◎ ")
  (setq gnus-sum-thread-tree-vertical        "│")
  (setq gnus-sum-thread-tree-leaf-with-other "├─► ")
  (setq gnus-sum-thread-tree-single-leaf     "╰─► ")
  (gnus-message 5 "Using unicode tree layout"))

(if (window-system)
    (jramnani-gnus-summary-line-format-unicode)
  (jramnani-gnus-summary-line-format-ascii))

(setq gnus-summary-line-format
      (concat
       "%0{%U%R%z%}"
       "%3{│%}" "%1{%d%}" "%3{│%}" ;; date
       "  "
       "%4{%-20,20f%}"             ;; name
       "  "
       "%3{│%}"
       " "
       "%1{%B%}"
       "%s\n"))
(setq gnus-summary-display-arrow t)

;; Inline images
(add-to-list 'mm-attachment-override-types "image/.*")
(setq mm-inline-large-images t)


;; Keymaps
;; By default Gnus uses "E" to mark a message for deleting ("expiry" in Gnus-speak)
;; "d" means delete in most other worlds
;;(define-key gnus-summary-mode-map (kbd "d") 'gnus-summary-mark-as-expirable)


;; For debugging
;; (setq smtpmail-debug-info t)
