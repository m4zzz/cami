(in-package :cl-user)

(asdf:defsystem :cami
  :version "0.1"
  :description "a high leverage text editor"
  :author "m4zzz"
  :depends-on (:hunchentoot
               :clack
               :websocket-driver
               :alexandria
               :spinneret)
  :serial t
  :components ((:file "package")
               (:file "cami-utils")
	       (:file "keys")
	       (:file "cursor")
               (:file "cami")))
