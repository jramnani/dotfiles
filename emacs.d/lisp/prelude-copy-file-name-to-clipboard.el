;;; prelude-copy-file-name-to-clipboard -- Summary

;;; Commentary:
; Credit: https://stackoverflow.com/questions/2416655/file-path-to-clipboard-in-emacs

;;; Code:
(defun prelude-copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

;;; prelude-copy-file-name-to-clipboard ends here
