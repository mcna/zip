(in-package :zip)

(defun default-external-format ()
  stream::*default-external-format*)

(defun octets-to-string (octets ef)
  (external-format:decode-external-string octets ef))

(defun string-to-octets (string ef)
  (external-format:encode-lisp-string string ef))
