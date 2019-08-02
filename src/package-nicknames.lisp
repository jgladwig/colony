(in-package #:cl-user)

(defpackage #:virality.nicknames
  (:use #:cl)
  (:import-from
   #+sbcl #:sb-ext
   #+ccl #:ccl
   #+(or ecl abcl clasp) #:ext
   #:add-package-local-nickname)
  (:export #:define-nicknames))

(in-package #:virality.nicknames)

(defmacro define-nicknames (&body body)
  `(progn
     ,@(mapcan
        (lambda (x)
          (destructuring-bind (source . mappings) x
            (mapcar
             (lambda (x)
               `(add-package-local-nickname ,@x ,source))
             mappings)))
        body)))

(define-nicknames
  (:first-light
   (:a :alexandria)
   (:u :golden-utils)
   (:log :verbose)
   (:v2 :origin.vec2)
   (:v3 :origin.vec3)
   (:comp :first-light.components))

  (:first-light.components
   (:a :alexandria)
   (:u :golden-utils)
   (:log :verbose)
   (:~ :origin.swizzle)
   (:v2 :origin.vec2)
   (:v3 :origin.vec3)
   (:v4 :origin.vec4)
   (:m4 :origin.mat4)
   (:q :origin.quat)
   (:v :first-light)
   (:gpu :virality.gpu)
   (:contrib.mat :virality.contrib.materials))

  (:virality.gpu
   (:a :alexandria)
   (:u :golden-utils)
   (:log :verbose)
   (:v :first-light))

  (:virality.prefabs
   (:a :alexandria)
   (:u :golden-utils)
   (:log :verbose)
   (:v :first-light)
   (:comp :first-light.components))

  (:virality.contrib.textures
   (:v4 :origin.vec4)
   (:v :first-light))

  (:virality.contrib.materials
   (:v2 :origin.vec2)
   (:v3 :origin.vec3)
   (:v4 :origin.vec4)
   (:m4 :origin.mat4)
   (:v :first-light)
   (:contrib.tex :virality.contrib.textures))

  (:virality.contrib.actions
   (:a :alexandria)
   (:u :golden-utils)
   (:log :verbose)
   (:v4 :origin.vec3)
   (:q :origin.quat)
   (:v :first-light)
   (:comp :first-light.components))

  (:first-light.shader.swizzle
   (:a :alexandria)
   (:u :golden-utils))

  ;; remove later
  (:%first-light
   (:gpu :virality.gpu)
   (:contrib.tex :virality.contrib.textures)
   (:contrib.mat :virality.contrib.materials))
  )
