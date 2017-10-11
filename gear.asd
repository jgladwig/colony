(asdf:defsystem #:gear
  :description "An experimental game engine."
  :author ("Michael Fiano <michael.fiano@gmail.com>")
  :maintainer "Michael Fiano <michael.fiano@gmail.com>"
  :license "MIT"
  :homepage "https://github.com/mfiano/gear"
  :bug-tracker "https://github.com/mfiano/gear/issues"
  :source-control (:git "git@github.com:mfiano/gear.git")
  :version "0.1.0"
  :encoding :utf-8
  :long-description #.(uiop:read-file-string
                        (uiop/pathname:subpathname *load-pathname* "README.md"))
  :depends-on (#:alexandria
               #:gamebox-math)
  :pathname "src"
  :serial t
  :components
  ((:file "package")
   (:file "transform-state")
   (:file "transform")
   (:file "gear")))
   (:file "components")
