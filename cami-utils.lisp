(in-package :cami)

(defun str+ (&rest strings)
  (reduce #'(lambda (x y)
	      (concatenate 'string (string x) (string y)))
	  strings))

(defun rep (str pos with)
  "replace the element at pos in str"
  (cond ((= pos 0) (str+ with (subseq str 1)))
	((= pos (1- (length str))) (str+ (subseq str 0 (1- (length str))) with))
	(t (str+ (subseq str 0 pos) with (subseq str (1+ pos))))))
