(in-package :cami)

(defun render (connection buf)
  "render the buffer"
  (websocket-driver:send connection
			 (with-output-to-string (*standard-output*)
			   (encode-alist (list
					  '("command" . "render")
					  (cons "args" (reduce-buffer buf)))))))


(defun reload ()
  "reload the browser"
  (websocket-driver:send *con*
			 (with-output-to-string (*standard-output*)
			   (encode-alist (list
					  '("command" . "reload")
					  '("args" . ""))))))

