(in-package :zip)

;;;; FIXME

(defun default-external-format ()
  :dummy)

(defun octets-to-string (octets ef)
  (declare (ignore ef))
  (let* ((m (length octets))
	 (n (cond 
	      ((zerop m) 0)
	      ((zerop (elt octets (1- m))) (1- m))
	      (t m)))
	 (result (make-string n)))
    (map-into result #'code-char octets)
    result))

(defun string-to-octets (string ef)
  (declare (ignore ef))
  (let ((result (make-array (1+ (length string))
			    :element-type '(unsigned-byte 8)
			    :initial-element 0)))
    (map-into result #'char-code string)
    result))
