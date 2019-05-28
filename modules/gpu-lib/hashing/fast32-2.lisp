(in-package #:first-light.gpu.hash)

;;;; Hashing functions
;;;; FAST32_2
;;;; Brian Sharpe
;;;; https://github.com/BrianSharpe/GPU-Noise-Lib/blob/master/gpu_noise_lib.glsl

(define-function fast32-2 ((grid-cell :vec2))
  (let ((p (vec4 grid-cell (1+ grid-cell))))
    (setf p (+ (* (- p (* (floor (* p (/ 69.0))) 69.0))
                  (.xyxy (vec2 2.009842 1.372549)))
               (.xyxy (vec2 403.83917 377.2427))))
    (multf p p)
    (fract (* (.xzxz p) (.yyww p) (/ 32745.708984)))))

(define-function fast32-2 ((grid-cell :vec3))
  (decf grid-cell (* (floor (* grid-cell (/ 69.0))) 69.0))
  (let* ((offset (vec3 55.882355 63.167774 52.941177))
         (scale (vec3 0.235142 0.205890 0.216449))
         (grid-cell-inc1 (* (step grid-cell (vec3 67.5)) (1+ grid-cell)))
         (grid-cell (+ (* grid-cell scale) offset))
         (grid-cell (* grid-cell grid-cell))
         (grid-cell-inc1 (+ (* grid-cell-inc1 scale) offset))
         (grid-cell-inc1 (* grid-cell-inc1 grid-cell-inc1))
         (x (* (vec4 (.x grid-cell)
                     (.x grid-cell-inc1)
                     (.x grid-cell)
                     (.x grid-cell-inc1))
               (vec4 (.yy grid-cell) (.yy grid-cell-inc1)))))
    (values (fract (* x (.z grid-cell) (/ 69412.07)))
            (fract (* x (.z grid-cell-inc1) (/ 69412.07))))))

(define-function fast32-2 ((grid-cell :vec4))
  (decf grid-cell (* (floor (* grid-cell (/ 69.0))) 69.0))
  (let* ((offset (vec4 16.84123 18.774548 16.873274 13.664607))
         (scale (vec4 0.102007 0.114473 0.139651 0.08455))
         (grid-cell-inc1 (* (step grid-cell (vec4 67.5)) (1+ grid-cell)))
         (grid-cell (+ (* grid-cell scale) offset))
         (grid-cell (* grid-cell grid-cell))
         (grid-cell-inc1 (+ (* grid-cell-inc1 scale) offset))
         (grid-cell-inc1 (* grid-cell-inc1 grid-cell-inc1))
         (x (* (vec4 (.x grid-cell)
                     (.x grid-cell-inc1)
                     (.x grid-cell)
                     (.x grid-cell-inc1))
               (vec4 (.yy grid-cell) (.yy grid-cell-inc1))))
         (z (* (vec4 (.z grid-cell)
                     (.z grid-cell-inc1)
                     (.z grid-cell)
                     (.z grid-cell-inc1))
               (vec4 (.ww grid-cell) (.ww grid-cell-inc1))
               (/ 47165.637))))
    (values (fract (* x (.x z)))
            (fract (* x (.y z)))
            (fract (* x (.z z)))
            (fract (* x (.w z))))))

(define-function fast32-2/4-per-corner ((grid-cell :vec4))
  (decf grid-cell (* (floor (* grid-cell (/ 69.0))) 69.0))
  (let* ((offset (vec4 16.84123 18.774548 16.873274 13.664607))
         (scale (vec4 0.102007 0.114473 0.139651 0.08455))
         (grid-cell-inc1 (* (step grid-cell (vec4 67.5)) (1+ grid-cell)))
         (grid-cell (+ (* grid-cell scale) offset))
         (grid-cell (* grid-cell grid-cell))
         (grid-cell-inc1 (+ (* grid-cell-inc1 scale) offset))
         (grid-cell-inc1 (* grid-cell-inc1 grid-cell-inc1))
         (x (* (vec4 (.x grid-cell)
                     (.x grid-cell-inc1)
                     (.x grid-cell)
                     (.x grid-cell-inc1))
               (vec4 (.yy grid-cell) (.yy grid-cell-inc1))))
         (z (* (vec4 (.z grid-cell)
                     (.z grid-cell-inc1)
                     (.z grid-cell)
                     (.z grid-cell-inc1))
               (vec4 (.ww grid-cell) (.ww grid-cell-inc1))))
         (hash (* x (.x z)))
         (z0w0-0 (fract (* hash (/ 56974.746))))
         (z0w0-1 (fract (* hash (/ 47165.637))))
         (z0w0-2 (fract (* hash (/ 55049.668))))
         (z0w0-3 (fract (* hash (/ 49901.273))))
         (hash (* x (.y z)))
         (z1w0-0 (fract (* hash (/ 56974.746))))
         (z1w0-1 (fract (* hash (/ 47165.637))))
         (z1w0-2 (fract (* hash (/ 55049.668))))
         (z1w0-3 (fract (* hash (/ 49901.273))))
         (hash (* x (.z z)))
         (z0w1-0 (fract (* hash (/ 56974.746))))
         (z0w1-1 (fract (* hash (/ 47165.637))))
         (z0w1-2 (fract (* hash (/ 55049.668))))
         (z0w1-3 (fract (* hash (/ 49901.273))))
         (hash (* x (.w z)))
         (z1w1-0 (fract (* hash (/ 56974.746))))
         (z1w1-1 (fract (* hash (/ 47165.637))))
         (z1w1-2 (fract (* hash (/ 55049.668))))
         (z1w1-3 (fract (* hash (/ 49901.273)))))
    (values z0w0-0 z0w0-1 z0w0-2 z0w0-3
            z1w0-0 z1w0-1 z1w0-2 z1w0-3
            z0w1-0 z0w1-1 z0w1-2 z0w1-3
            z1w1-0 z1w1-1 z1w1-2 z1w1-3)))
