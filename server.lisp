(in-package :cami)

(defun handle-new-connection (con)
  (setf *con* con))

(defun recv (connection msg)
  "msg is usually an event sent as json"
  (let* ((*parse-object-as* :alist)
	 (event (parse msg)))
    (event-handler event)))

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

