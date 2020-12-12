(in-package :cami)

;;; row is the line number
;;; row and column both start from 1
;;; pos is '(line-number column-number)

(defun valid-pos-p (pos)
  "these are the values pos should never take"
  (unless (null pos)
    (let ((row (car pos))
	  (col (cadr pos)))
      (if (and (> row 0) (> col 0)) t nil))))

(defun get-row ()
  "get the current line number"
  (get-x *cursor-pos*))

(defun get-col ()
  "get the current col number"
  (get-y *cursor-pos*))

(defun get-x (pos)
  (if (valid-pos-p pos)
      (car pos)))

(defun get-y (pos)
  (if (valid-pos-p pos)
      (cadr pos)))

(defun buf-row (pos)
  (if (valid-pos-p pos)
    (1- (get-x pos))))

(defun buf-col (pos)
  (if (valid-pos-p pos)
      (1- (get-y pos))))

(defmacro buf-i ()
  `(buf-row pos))

(defmacro line-i ()
  `(buf-col pos))

(defmacro buf-line (buf)
  `(elt ,buf (buf-i)))

(defmacro line-char (line)
  `(elt ,line (line-i)))

(defun buf-length ()
  "the number of lines"
  (length *buffer*))

(defun line-length (pos)
  (if (valid-pos-p pos)
      (length (get-line pos))))

(defun get-line (pos)
  "get the line string from *buffer*"
  (if (valid-pos-p pos)
      (buf-line *buffer*)))

(defun get-char (pos)
  "get the char at pos in line"
  (if (valid-pos-p pos)
      (line-char (get-line pos))))

(defun out-of-bounds-p (pos)
  "check if pos is where it shouldn't be"
  (if (valid-pos-p pos)
      (if (and (> (buf-length) (buf-i))
	       (> (line-length pos) (line-i)))
	  nil t)))

(defun update-cursor (pos)
  "pos is '(row col)"
  (if (valid-pos-p pos)
      (unless (out-of-bounds-p pos)
	(setf *cursor-pos* pos)
	(render *con* *buffer*))))

(defun move-cursor (key)
  "update the cursor accordingly"
  (let ((row (get-row))
	(col (get-col)))
    (cond ((string= key "ArrowLeft")  (list row (1- col)))
	  ((string= key "ArrowRight") (list row (1+ col)))
	  ((string= key "ArrowUp")    (list (1- row) col))
	  ((string= key "ArrowDown")  (list (1+ row) col)))))
