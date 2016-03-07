;;; jramnani-date -- Summary
;;
;;; Commentary:
;; Helper functions for dealing with dates and times.
;;
;; Credit to Xah Lee's Formatting Date and Time functions.
;; http://ergoemacs.org/emacs/elisp_datetime.html
;;
;;
;;; Code:


(defun insert-date ()
  "Insert the current date as YYYY-MM-DD."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))


(defun insert-date-time ()
  "Insert current date-time string in full ISO 8601 format.
Example: 2010-11-29T23:23:35-08:00"
  (interactive)
  (insert
   (concat
    (format-time-string "%Y-%m-%dT%T")
    (jramnani-format-timzone-string (format-time-string "%z")))))


(defun jramnani-format-timzone-string (tzstring)
  "Given a TZSTRING like '-0600', insert a colon to separate hours and minutes.
i.e. '-0600' -> '-06:00'"
  (concat
   (substring tzstring 0 3) ":" (substring tzstring 3 5)))


(provide 'jramnani-date)


;;; jramnani-date.el ends here
