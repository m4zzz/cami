(in-package :cami)

(declaim (optimize (speed 0) (space 0) (debug 3)))

(defmacro aif (cond &body body)
  `(let ((it ,cond))
     (if it ,@body)))

(defmacro awhen (cond &body body)
  `(let ((it ,cond))
     (when it ,@body)))

(defun empty-string-p (str)
  (if (string= str "") t nil))

(defun len- (seq)
  (1- (length seq)))

(defun last1 (seq)
  (elt seq (len- seq)))

(defun str+ (&rest strings)
  (reduce #'(lambda (x y)
	      (concatenate 'string (string x) (string y)))
	  strings))

(defun lookup (alist hash &key (test #'string=))
  "lookup alist when strings are keys"
  (alexandria:assoc-value alist hash :test test))

(defun do-nothing ()
  (print "do-nothing"))

(defun red-str (lst)
  "lst is a list of strings"
  (reduce #'str+ lst))

(defmacro map-str (fn str)
  "map over a string and return a string"
  `(red-str (map 'list ,fn ,str)))

(defun rep (str pos with)
  "replace the element at pos in str"
  (cond ((= pos 0) (str+ with (subseq str 1)))
	((= pos (len- str)) (str+ (subseq str 0 (len- str)) with))
	(t (str+ (subseq str 0 pos) with (subseq str (1+ pos))))))





