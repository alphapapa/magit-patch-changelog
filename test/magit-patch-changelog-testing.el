(require 'ert)
(require 'espuds)
(require 'magit-patch-changelog)
(require 'anaphora)

(defun magit-patch-changelog-test-wait-for (predicate &optional predargs ms interval continue)
  "Wait until PREDICATE function returns non-`nil'.
  PREDARGS is argument list for the PREDICATE function.
  MS is milliseconds to wait.  INTERVAL is polling interval in milliseconds."
  (let* ((int (aif interval it (aif ms (max 300 (/ ms 10)) 300)))
         (count (max 1 (if ms (truncate (/ ms int)) 25))))
    (unless (or (cl-loop repeat count
                         when (apply predicate predargs)
                         return t
                         do (sleep-for 0 int))
                continue)
      (error "Timeout: %s" predicate))))

;; if yes-or-no-p isn't specially overridden, make it always "yes"
(let ((original-yes-or-no-p (symbol-function 'yes-or-no-p)))
  (add-function :around (symbol-function 'message-cancel-news)
                (lambda (f &rest args)
                  (if (not (eq (symbol-function 'yes-or-no-p) original-yes-or-no-p))
                      (apply f args)
                    (cl-letf (((symbol-function 'yes-or-no-p) (lambda (&rest args) t)))
                      (apply f args))))))

(magit-patch-changelog-setup)

;;; _
(provide 'magit-patch-changelog-testing)
;;; magit-patch-changelog-testing.el ends here
