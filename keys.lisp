(in-package :cami)

(defparameter *modifier-keys* '("Tab" "Control" "Alt" "Shift"
				"Meta" "ArrowUp" "ArrowDown"
				"ArrowLeft" "ArrowRight" "Backspace"
				"Enter" "CapsLock"))

(defun modifierp (key)
  (member key *modifier-keys* :test #'string=))

