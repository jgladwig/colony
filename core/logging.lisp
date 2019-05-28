(in-package #:%first-light)

(defun enable-logging (core)
  (let ((context (context core)))
    (unless (v:thread v:*global-controller*)
      (v:start v:*global-controller*))
    (when (option context :log-repl-enabled)
      (setf (v:repl-level) (option context :log-level)
            (v:repl-categories) (option context :log-repl-categories)))
    (au:when-let ((log-debug (find-resource context :log-debug)))
      (ensure-directories-exist log-debug)
      (v:define-pipe ()
        (v:level-filter :level :debug)
        (v:file-faucet :file log-debug)))
    (au:when-let ((log-error (find-resource context :log-error)))
      (ensure-directories-exist log-error)
      (v:define-pipe ()
        (v:level-filter :level :error)
        (v:file-faucet :file log-error)))))
