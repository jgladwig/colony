(in-package :fl.example)

(define-resources (:project :fl.example)
  (:project "data")
  (:mesh (:project "mesh"))
  (:texture (:project "texture"))
  ;; texture-test
  (:texture-test-textures (:project :texture "texture-test"))
  (:1da-test (:project :texture-test-textures "1d-array/test"))
  (:2da-test (:project :texture-test-textures "2d-array/test"))
  (:3d-test (:project :texture-test-textures "3d/test"))
  (:cubemap-test (:project :texture-test-textures "cube-map/test"))
  ;; sprite-test
  (:spritesheet (:project :texture "sprite-test/sprites.tga"))
  (:spritesheet-data (:project "sprites.sexp"))
  ;; damaged helmet
  (:damaged-helmet-textures (:project :texture "damaged-helmet")))
