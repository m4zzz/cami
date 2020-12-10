(in-package :cami)

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

(defun rep (str pos with)
  "replace the element at pos in str"
  (cond ((= pos 0) (str+ with (subseq str 1)))
	((= pos (len- str)) (str+ (subseq str 0 (len- str)) with))
	(t (str+ (subseq str 0 pos) with (subseq str (1+ pos))))))





