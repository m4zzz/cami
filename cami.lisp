(in-package :cami)

(defvar *connections* (make-hash-table))
(defparameter *con* nil)
(defparameter *buffer* nil)

(defun handle-new-connection (con)
  (setf *con* con))

(defun curse-last-char (str)
  (str+ (subseq str 0 (1- (length str)))
	(str+ "<span style=\"background-color: black; color: white;\">"
	      (string (elt str (1- (length str))))
	      "</span>")))


(defun recv (connection message)
  (format t "*buffer*: ~A~%msg: ~A~%" *buffer* message)
  (setf *buffer* (str+ *buffer* message))
  (websocket-driver:send connection (curse-last-char *buffer*)))

(defun handle-close-connection (connection)
  (let ((message (format nil "Alpha has left: ~A~%" (random 100))))
    (remhash connection *connections*)
    (setf *buffer* "")
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
