(in-package :fl.core)

(au:define-constant +mouse-button-names+
    #(nil :mouse-left :mouse-middle :mouse-right :mouse-x1 :mouse-x2)
  :test #'equalp)

(defstruct mouse-motion-state x y dx dy)

;;; Events

(defun on-mouse-button-up (core-state button)
  (input-transition-out core-state `(:mouse ,button)))

(defun on-mouse-button-down (core-state button)
  (input-transition-in core-state `(:mouse ,button)))

(defun on-mouse-scroll (core-state x y)
  (let ((states (au:href (states (input-data core-state)))))
    (unless (zerop x)
      (setf (au:href states '(:mouse :scroll-horizontal)) x))
    (unless (zerop y)
      (setf (au:href states '(:mouse :scroll-vertical)) y))))

(defun on-mouse-move (core-state x y dx dy)
  (symbol-macrolet ((state (au:href (states (input-data core-state)) '(:mouse :motion))))
    (setf (mouse-motion-state-x state) x
          (mouse-motion-state-y state) y
          (mouse-motion-state-dx state) dx
          (mouse-motion-state-dy state) dy)))

;;; User protocol

(defun mouse-button-enter-p (context button)
  (input-enter-p context :mouse button))

(defun mouse-button-enabled-p (context button)
  (input-enabled-p context :mouse button))

(defun mouse-button-exit-p (context button)
  (input-exit-p context :mouse button))

(defun get-mouse-position (context)
  (let ((state (au:href (states (input-data (core-state context))) '(:mouse :motion))))
    (with-slots (x y dx dy) state
      (values x y dx dy))))

(defun get-mouse-scroll (context axis)
  (let ((states (states (input-data (core-state context)))))
    (case axis
      (:horizontal (au:href states '(:mouse :scroll-horizontal)))
      (:vertical (au:href states '(:mouse :scroll-vertical))))))