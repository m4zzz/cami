(in-package :cami)

(defvar *connections* (make-hash-table))
(defparameter *con* nil)
(defparameter *buffer* (uiop:read-file-lines "~/guix-install.sh"))
(defparameter *cursor-pos* '(1 1))

(defmacro wrap-tag (tag str)
  `(with-html-string
    (,tag (:raw ,str))))

(defun curse (str)
  "wrap the str with a cursor"
  (with-html-string
    (:span :style "background-color: black; color: white;"
	   (:raw (string str)))))

(defun break-line (line pos)
  "break line into before-cursor, cursor, after-cursor"
  (let ((before-cursor (if (zerop (line-i))
			   ""
			   (subseq line 0 (line-i))))
	(cursor (string (line-char line)))
	(after-cursor (if (= (get-y pos) (length line))
			  ""
			  (subseq line (get-y pos)))))
    (list before-cursor cursor after-cursor)))

(defun esc-str (str)
  "escape the string"
  (if (empty-string-p str)
      ""
      (map-str #'(lambda (x)
		   (if (equal x #\Space)
		       "&nbsp;"
		       (spinneret::escape-string (string x))))
	       str)))

(defun escape-buffer (buf pos)
  "escape the buffer"
  (let ((line (get-line pos))
	(escaped-buffer (mapcar #'esc-str buf)))
    (setf (elt escaped-buffer (buf-row pos))
	  (str+ (esc-str (first (break-line line pos)))
		(curse (esc-str (second (break-line line pos))))
		(esc-str (third (break-line line pos)))))
    escaped-buffer))

(defun reduce-buffer (buf)
  "reduce it so that it can be sent"
  (setf buf (escape-buffer buf *cursor-pos*))
  (setf buf (mapcar #'(lambda (line)	;add line breaks
			(wrap-tag :br line))
		    buf))
  (reduce #'(lambda (x y)		;join all the strings
	      (str+ x y))
	  buf))

(defun handle-new-connection (con)
  (setf *con* con))

(defun recv (connection message)
  (let ((buf (copy-seq *buffer*)))
    (if (modifierp message) (update-cursor (move-cursor message)))
    (websocket-driver:send connection (reduce-buffer buf))))

(defun handle-close-connection (connection)
  (let ((message (format nil "Alpha has left: ~A~%" (random 100))))
    (remhash connection *connections*)
    (setf *buffer* (uiop:read-file-lines "~/guix-install.sh"))
    (setf *cursor-pos* '(1 1))
    (print message)))

(defun cami (env)
  (let ((ws (websocket-driver:make-server env)))
    (websocket-driver:on :open ws
                         (lambda () (handle-new-connection ws)))

    (websocket-driver:on :message ws
                         (lambda (msg) (recv ws msg)))

    (websocket-driver:on :close ws
                         (lambda (&key code reason)
                           (declare (ignore code reason))
                           (handle-close-connection ws)))
    (lambda (responder)
      (declare (ignore responder))
      (websocket-driver:start-connection ws))))

(defvar *back-end* (clack:clackup #'cami :port 12345))
