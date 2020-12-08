(in-package :cami)

(defvar *connections* (make-hash-table))
(defparameter *con* nil)
(defparameter *buffer* nil)

(defun handle-new-connection (con)
  (setf *con* con))

(defun send-back (connection message)
  (print message)
  (websocket-driver:send connection message))

(defun handle-close-connection (connection)
  (let ((message (format nil "Alpha has left: ~A~%" (random 100))))
    (remhash connection *connections*)
    (print message)))

(defun cami (env)
  (let ((ws (websocket-driver:make-server env)))
    (websocket-driver:on :open ws
                         (lambda () (handle-new-connection ws)))

    (websocket-driver:on :message ws
                         (lambda (msg) (send-back ws msg)))

    (websocket-driver:on :close ws
                         (lambda (&key code reason)
                           (declare (ignore code reason))
                           (handle-close-connection ws)))
    (lambda (responder)
      (declare (ignore responder))
      (websocket-driver:start-connection ws))))

(defvar *back-end* (clack:clackup #'cami :port 12345))
