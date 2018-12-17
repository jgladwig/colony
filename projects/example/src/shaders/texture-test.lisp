(in-package :first-light.shader)

(defstruct texture-struct-1d
  (sampler1 :sampler-1d :accessor sampler1)
  (sampler2 :sampler-1d :accessor sampler2))

(defstruct texture-struct-1d-array
  (sampler1 :sampler-1d-array :accessor sampler1)
  (sampler2 :sampler-1d-array :accessor sampler2))

(defstruct texture-struct-2d-array
  (sampler1 :sampler-2d-array :accessor sampler1)
  (sampler2 :sampler-2d-array :accessor sampler2))

(defstruct texture-struct-3d
  (sampler1 :sampler-3d :accessor sampler1)
  (sampler2 :sampler-3d :accessor sampler2))

(defstruct texture-2d/sweep-input
  (sampler1 :sampler-2d :accessor sampler1)
  (sampler2 :sampler-2d :accessor sampler2)
  (channel0 :vec2 :accessor channel0))

(defstruct texture-struct-cube-map
  (sampler1 :sampler-cube :accessor sampler1)
  (sampler2 :sampler-cube :accessor sampler2))

(defstruct texture-struct-cube-map-array
  (sampler1 :sampler-cube-array :accessor sampler1)
  (sampler2 :sampler-cube-array :accessor sampler2))

(defun unlit-texture-1d/frag ((color :vec4)
                              (uv1 :vec2)
                              &uniform
                              (tex texture-struct-1d)
                              (mix-color :vec4))
  (let ((tex-color (texture (sampler1 tex) (.x uv1))))
    (* tex-color mix-color)))

(defun unlit-texture-3d/frag ((color :vec4)
                              (uv1 :vec2)
                              &uniform
                              (tex texture-struct-3d)
                              (mix-color :vec4)
                              (uv-z :float))
  ;; NOTE: an example in which we pass in the zcoord from the material which is
  ;; held true for the entire shader. Just useful for testing an axis aligned
  ;; plane in the 3d texture volume.
  (let ((tex-color (texture (sampler1 tex) (vec3 uv1 uv-z))))
    (* tex-color mix-color)))

(defun unlit-texture-1d-array/frag ((color :vec4)
                                    (uv1 :vec2)
                                    &uniform
                                    (tex texture-struct-1d-array)
                                    (time :float)
                                    (mix-color :vec4)
                                    (num-layers :int))
  ;; NOTE: Not a general purpose 1d-array shader, but just an example!
  (let* ((uv-dist (sqrt (+ (expt (* (sin time) (.s uv1)) 2)
                           (expt (* (cos time) (.t uv1)) 2))))
         (layer-uv (vec2 (.x uv1)
                         ;; The layer we pick is the result of how far we are
                         ;; to the 1,1 corner of the texture.
                         (clamp (floor (mix 0 num-layers uv-dist))
                                0 (1- num-layers))))
         (tex-color (texture (sampler1 tex) layer-uv)))
    (* tex-color mix-color)))

(defun unlit-texture-2d-array/frag ((color :vec4)
                                    (uv1 :vec2)
                                    &uniform
                                    (time :float)
                                    (tex texture-struct-2d-array)
                                    (mix-color :vec4)
                                    (uv-z :float)
                                    (num-layers :int))
  ;; NOTE: Not a general purpose 1d-array shader, but just an example!
  ;; We take ths incoming uv-z and use it to index the layers.
  (let* ((uv-dist (sqrt (+ (expt (* (sin time) (.s uv1)) 2)
                           (expt (* (cos time) (.t uv1)) 2))))
         ;; The layer we pick is the result of how far we are
         ;; to the 1,1 corner of the texture.
         (z-layer (clamp (floor (mix 0 num-layers uv-dist)) 0 (1- num-layers)))
         (tex-color (texture (sampler1 tex) (vec3 uv1 z-layer))))
    (* tex-color mix-color)))

;; Testing input parameter sweeping.
(defun noise-2d/sweep-input/frag ((color :vec4)
                                  (uv1 :vec2)
                                  &uniform
                                  (tex texture-2d/sweep-input)
                                  (mix-color :vec4))
  (let* ((new-uv (/ (+ (* uv1 1) (* (channel0 tex) 5)) 2.0))
         (noise-uv (perlin new-uv))
         (tex-color (texture (sampler1 tex) (/ (+ uv1 noise-uv) 2.0))))
    (* tex-color mix-color)))

(defun unlit-texture-cube-map/vert ((pos :vec3)
                                    (normal :vec3)
                                    (tangent :vec4)
                                    (color :vec4)
                                    (uv1 :vec2)
                                    (uv2 :vec2)
                                    (joints :vec4)
                                    (weights :vec4)
                                    &uniform
                                    (model :mat4)
                                    (view :mat4)
                                    (proj :mat4))
  ;; TODO is to only apply rotation, not translation.
  (values (* proj view model (vec4 pos 1))
          color
          pos))

(defun unlit-texture-cube-map/frag ((color :vec4)
                                    (tex-cube-map-coord :vec3) ;; pos from the vert shader
                                    &uniform
                                    (tex texture-struct-cube-map)
                                    (mix-color :vec4))
  (let* ((tex-color (texture (sampler1 tex) tex-cube-map-coord)))
    (* tex-color mix-color)))

(defun unlit-texture-cube-map-array/frag ((color :vec4)
                                          (tex-cube-map-coord :vec3) ;; pos from the vert shader
                                          &uniform
                                          (tex texture-struct-cube-map-array)
                                          (cube-layer :float)
                                          (num-layers :float)
                                          (mix-color :vec4))
  ;; TODO: Fix this to grab out of different layers like 2d-array.
  (let* ((cube-map-array-tex-coord (vec4 tex-cube-map-coord 0))
         (tex-color (texture (sampler1 tex) cube-map-array-tex-coord)))
    (* tex-color mix-color)))

(define-shader unlit-texture-1d ()
  (:vertex (unlit/vert :vec3 :vec3 :vec4 :vec4 :vec2 :vec2 :vec4 :vec4))
  (:fragment (unlit-texture-1d/frag :vec4 :vec2)))

(define-shader unlit-texture-3d ()
  (:vertex (unlit/vert :vec3 :vec3 :vec4 :vec4 :vec2 :vec2 :vec4 :vec4))
  (:fragment (unlit-texture-3d/frag :vec4 :vec2)))

(define-shader unlit-texture-1d-array ()
  (:vertex (unlit/vert :vec3 :vec3 :vec4 :vec4 :vec2 :vec2 :vec4 :vec4))
  (:fragment (unlit-texture-1d-array/frag :vec4 :vec2)))

(define-shader noise-2d/sweep-input ()
  (:vertex (unlit/vert :vec3 :vec3 :vec4 :vec4 :vec2 :vec2 :vec4 :vec4))
  (:fragment (noise-2d/sweep-input/frag :vec4 :vec2)))

(define-shader unlit-texture-2d-array ()
  (:vertex (unlit/vert :vec3 :vec3 :vec4 :vec4 :vec2 :vec2 :vec4 :vec4))
  (:fragment (unlit-texture-2d-array/frag :vec4 :vec2)))

(define-shader unlit-texture-cube-map ()
  (:vertex (unlit-texture-cube-map/vert :vec3 :vec3 :vec4 :vec4 :vec2 :vec2 :vec4 :vec4))
  (:fragment (unlit-texture-cube-map/frag :vec4 :vec3)))

(define-shader unlit-texture-cube-map-array ()
  (:vertex (unlit-texture-cube-map/vert :vec3 :vec3 :vec4 :vec4 :vec2 :vec2 :vec4 :vec4))
  (:fragment (unlit-texture-cube-map-array/frag :vec4 :vec3)))
