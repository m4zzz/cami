(in-package :cami)

(defun next-char ()
  (update-cursor (list
		  (get-row)
		  (1+ (get-col)))))

(defun prev-char ()
  (update-cursor (list
		  (get-row)
		  (1- (get-col)))))

(defun next-line ()
  (update-cursor (list
		  (1+ (get-row))
		  (get-col))))

(defun prev-line ()
  (update-cursor (list
		  (1- (get-row))
		  (get-col))))




