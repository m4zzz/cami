(in-package :cami)

;;; what a cursor should do.
;;; keep track of its position on the screen.
;;; and by extension within the buffer.
;;; keep track of its style.

(defclass cursor ()
  ((line
    :initform 1
    :accessor line)
   (col
    :initform 1
    :accessor col)))
