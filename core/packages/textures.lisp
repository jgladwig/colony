(in-package :defpackage+-user-1)

(defpackage+ #:first-light.textures
  (:nicknames #:fl.textures)
  (:use #:cl #:%first-light)
  ;; profiles
  (:export #:clamp-all-edges
           #:default-profile
           ;; TODO: exploratory framebuffer support
           #:framebuffer)
  ;; textures
  (:export #:debug-texture
           #:missing-texture
           ;; TODO: Exploratory framebuffer support
           #:framebuffer-color
           #:framebuffer-depth
           #:framebuffer-depth/stencil
           #:framebuffer-stencil))