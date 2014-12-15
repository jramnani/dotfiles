(require 'ert)
(require 'fish-mode)

;; For testing indentation
(use-package cursor-test
  :ensure t)

;; Borrowed from Emacs' internal tests for python-mode
(defmacro fish-tests-with-temp-buffer (contents &rest body)
  "Create a `fish-mode' enabled temp buffer with CONTENTS.
BODY is code to be executed within the temp buffer.  Point is
always located at the beginning of buffer."
  (declare (indent 1) (debug t))
  `(with-temp-buffer
     (fish-mode)
     (insert ,contents)
     (goto-char (point-min))
     ,@body))

(ert-deftest fish-tests-provides-feature ()
  "Major modes should register themselves in the list of features"
  (fish-tests-with-temp-buffer
   ""
    (should (equal (featurep 'fish-mode) t))))

(ert-deftest fish-tests-syntax-highlighting ()
  "Fish shell should provide syntax highlighting"
  ;; These are pretty simple tests right now.
  (fish-tests-with-temp-buffer
      "echo 'hello world'"
    ;; Fontify the buffer.  There will be no text properties if you don't do this.
    (font-lock-fontify-buffer)

    ;; Move point to the 'e' character of "echo"
    (goto-char (point-min))

    ;; The command "echo" is a Fish builtin function
    (should (equal (get-text-property (point) 'face)
                   'font-lock-builtin-face))))


(ert-deftest fish-tests-should-indent-function-body ()
  "First use of cursor-test to test indentation and cursor position"
  (cursor-test/equal
   :description "test 1"
   :expect (cursor-test/setup
            :init "
function foo
    |
end
")
   :actual (cursor-test/setup
            :init "
function foo|
end
"
            :exercise (lambda ()
                        (fish-mode)
                        (newline-and-indent))))
  )
