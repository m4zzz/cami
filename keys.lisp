(in-package :cami)

;;; Key Representation
;;; '('(Ctrl?Alt?Meta?Shift?KeySeq?) . '([a-z]+))
;;; First list can be empty for keys like ArrowDown or Delete or characters.
;;; First list is called the leader-list
;;; Second list is called the stroke-list
;;; A key can serve as leader for another key.
;;; ^%@!t -> this means ctrl-meta-alt-t
;;; You're not supposed to write keys by hand.

(defparameter *modifier-keys* '("Control" "Alt" "Shift" "Meta"))

(defun modifierp (key)
  (member key *modifier-keys* :test #'string=))

(defparameter *keymap*
  (list
   '("ArrowRight" . #'next-char)
   '("ArrowLeft" . #'prev-char)
   '("ArrowDown" . #'next-line)
   '("ArrowUp" . #'prev-line)
   '("^r" . #'reload)))

(defun key-event-p (event)
  "is this a keyboard event?"
  (let ((event-name (alexandria:assoc-value event "event" :test #'string=)))
    (if (string= event-name "keydown") t)))

(defun event-handler (event)
  "pass the event down to a handler"
  (cond ((key-event-p event) (handle-key-event event))))

(defun make-key-string (key-event)
  (let ((alt-char "@")
	(ctrl-char "^")
	(meta-char "%")
	(shift-char "!")
	(key (lookup key-event "key"))
	(key-str ""))
    (if (lookup key-event "alt") (setf key-str (str+ key-str alt-char)))
    (if (lookup key-event "ctrl") (setf key-str (str+ key-str ctrl-char)))
    (if (lookup key-event "meta") (setf key-str (str+ key-str meta-char)))
    (if (lookup key-event "shift") (setf key-str (str+ key-str shift-char)))
    (unless (modifierp key) (setf key-str (str+ key-str key)))
    key-str))

(defun handle-key-event (event)
  (print (make-key-string event))
  (awhen (lookup *keymap* (make-key-string event))
    (apply (cadr it) nil)))

