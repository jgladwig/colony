(in-package #:virality.extensions.actions)

(defmethod action:on-update (action (type (eql 'rotate)))
  (let* ((renderer (action:renderer (action:manager action)))
         (attrs (action:attrs action))
         (angle (or (u:href attrs :angle) o:2pi))
         (step (u:map-domain 0 1 0 angle (action:step action))))
    (ecase (or (u:href attrs :axis) :z)
      (:x (v:rotate renderer (q:orient :local :x step) :replace t))
      (:y (v:rotate renderer (q:orient :local :y step) :replace t))
      (:z (v:rotate renderer (q:orient :local :z step) :replace t)))))

(defmethod action:on-finish (action (type (eql 'rotate)))
  (when (action:repeat-p action)
    (action:replace action 'rotate/reverse)))

(defmethod action:on-update (action (type (eql 'rotate/reverse)))
  (let* ((renderer (action:renderer (action:manager action)))
         (attrs (action:attrs action))
         (angle (or (u:href attrs :angle) o:2pi))
         (step (- angle (u:map-domain 0 1 0 angle (action:step action)))))
    (ecase (or (u:href attrs :axis) :z)
      (:x (v:rotate renderer (q:orient :local :x step) :replace t))
      (:y (v:rotate renderer (q:orient :local :y step) :replace t))
      (:z (v:rotate renderer (q:orient :local :z step) :replace t)))))

(defmethod action:on-finish (action (type (eql 'rotate/reverse)))
  (when (action:repeat-p action)
    (action:replace action 'rotate)))
