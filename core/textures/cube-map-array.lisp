(in-package :%first-light)

(defmethod load-texture-data ((texture-type (eql :texture-cube-map-array)) texture context)
  (let* ((use-mipmaps-p (get-computed-applied-attribute texture :use-mipmaps))
         (immutable-p (get-computed-applied-attribute texture :immutable))
         (texture-max-level
           (get-computed-applied-attribute texture :texture-max-level))
         (texture-base-level
           (get-computed-applied-attribute texture :texture-base-level))
         (max-mipmaps (- texture-max-level texture-base-level))
         (data (get-computed-applied-attribute texture :data)))

    ;; load all of the images we may require.
    (let* ((images (read-mipmap-images context data use-mipmaps-p
                                       :cube-map-array))
           (first-cube (aref images 0))
           (first-image (aref (second (aref first-cube 0)) 0))
           ;; TODO: This is not safe, need to check all of them.
           (num-mipmaps (length (second (aref first-cube 0)))))

      (v:trace :fl.core.texture "Loading :texture-cube-map-array images = ~a"
               images)

      ;; Check to ensure they all fit into texture memory.
      ;;
      ;; TODO: Refactor out of each method into validate-mipmap-images and
      ;; generalize.
      (loop :for (placement mipmaps) :across first-cube
            :for image = (aref mipmaps 0)
            :do (when (> (max (height image) (width image))
                         (gl:get-integer :max-texture-size))
                  ;; TODO: print out the location of the failing image.
                  (error "An Image for texture ~A is to big to be loaded onto this card. Max resolution is ~A in either dimension."
                         (name texture)
                         (gl:get-integer :max-texture-size))))


      ;; Figure out the ideal mipmap count from the base resolution.
      (multiple-value-bind (expected-mipmaps expected-resolutions)
          ;; TODO: This might need work with cube-maps.
          (compute-mipmap-levels (width first-image)
                                 (height first-image))
        (declare (ignore expected-resolutions))


        ;; TODO: Fix this up for cube-maps
        #++(validate-mipmap-images images texture
                                   expected-mipmaps expected-resolutions)

        (potentially-degrade-texture-min-filter texture)

        ;; Allocate immutable storage if required.
        (when immutable-p
          (let ((num-mipmaps-to-generate
                  (if use-mipmaps-p (min expected-mipmaps max-mipmaps) 1)))
            (%gl:tex-storage-2d texture-type num-mipmaps-to-generate
                                (internal-format first-image)
                                (width first-image)
                                (height first-image))))

        ;; Insert all cubes plus mipmaps into the GPU.
        (loop
          :for cube :across images
          :do
             (loop
               :for idx :below (if use-mipmaps-p num-mipmaps 1)
               :for level = (+ texture-base-level idx)
               ;; Now load all six faces, each face at the same mipmap level.
               :do
                  (loop
                    :for (face-signifier mipmaps) :across cube
                    :do
                       (with-slots (%width %height %internal-format
                                    %pixel-format %pixel-type %data)
                           (aref mipmaps idx)
                         (if immutable-p
                             (gl:tex-sub-image-2d face-signifier level 0 0
                                                  %width %height
                                                  %pixel-format
                                                  %pixel-type %data)
                             (gl:tex-image-2d face-signifier level
                                              %internal-format
                                              %width %height 0
                                              %pixel-format %pixel-type
                                              %data))))))

        (free-mipmap-images images :cube-map-array)
        (potentially-autogenerate-mipmaps texture-type texture)))))
