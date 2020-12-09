(in-package :cami)

(defmacro str+ (&rest strings)
  `(concatenate 'string ,@strings))
