;;; json-format.el -- Pretty format JSON text

;;; Commentary:
;;
;; Credit for this snippet goes to: http://irreal.org/blog/?p=354

;;; Code:

(defun json-format ()
  "Format JSON between the mark and the point."
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "python -m json.tool" (buffer-name) t)))

(provide 'json-format)

;;; json-format.el ends here
