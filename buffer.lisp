(in-package :cami)

;;; what a buffer should do:
;;; save its contents to a file
;;; 

;;; for now, by default, buffer class holds only text contents.
(defclass buffer ()
  ((contents				; the screen shows what's here
    :initform ""
    :accessor contents)
   (cursor
    :initform (make-instance 'cursor)
    :accessor cursor)
   (file				; this is where the buffer loads from and saves to.
    :initform nil
    :accessor file)))
