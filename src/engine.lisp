(in-package :gear)

(defmacro prepare-engine (core-state path)
  `(progn
     ,@(loop :with items = '(context call-flow scene)
             :for item :in items
             :for var = (alexandria:symbolicate '%temp- item)
             :collect `(let ((,var (make-hash-table :test #'eq)))
                         (declare (special ,var))
                         (flet ((%prepare ()
                                  (load-extensions ',item ,path)
                                  ,var))
                           (maphash
                            (lambda (k v)
                              (setf (gethash k (,(symbolicate item '-table)
                                                ,core-state))
                                    v))
                            (%prepare)))))))

(defmethod start-engine ()
  (let ((user-package-name (package-name *package*)))
    (kit.sdl2:init)
    (sdl2:in-main-thread ()
      (let ((*package* (find-package :gear))
            (core-state (make-instance 'core-state))
            (path (get-path user-package-name "data")))
        (prepare-engine core-state path)
        (load-default-scene core-state)
        (make-display core-state)))
    (kit.sdl2:start)))
