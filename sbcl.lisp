(in-package :zip)

(defun octets-to-string (octets ef)
  (declare (ignore ef))			;fixme
  (let* ((m (length octets))
	 (n (cond 
	      ((zerop m) 0)
	      ((zerop (elt octets (1- m))) (1- m))
	      (t m)))
	 (result (make-string n)))
    (map-into result #'code-char octets)
    result))

(defun string-to-octets (string ef)
  (declare (ignore ef))			;fixme
  (let ((result (make-array (1+ (length string))
			    :element-type '(unsigned-byte 8)
			    :initial-element 0)))
    (map-into result #'char-code string)
    result))

(defclass buffer-output-stream (sb-gray:fundamental-binary-output-stream)
    ((buf :initarg :buf :accessor buf)
     (pos :initform 0 :accessor pos)))

(defmethod sb-gray:stream-write-sequence
    ((stream buffer-output-stream) seq &optional (start 0) end)
  (replace (buf stream)
	   :start1 (pos stream)
	   :start2 start
	   :end2 end))

(defun make-buffer-output-stream (outbuf)
  (make-instance 'buffer-output-stream :buf outbuf))

(defclass truncating-stream (sb-gray:fundamental-binary-input-stream)
    ((input-handle :initarg :input-handle :accessor input-handle)
     (size :initarg :size :accessor size)
     (pos :initform 0 :accessor pos)))

(defmethod sb-gray:stream-read-byte ((s truncating-stream))
  (if (< (pos s) (size s))
      (prog1
	  (read-byte (input-handle s))
	(incf (pos s)))
      nil))

(defmethod sb-gray:stream-read-sequence
    ((s truncating-stream) seq &optional (start 0) (end (length seq)))
  (let ((n (- end start))
	(max (- (size s) (pos s))))
    (read-sequence (input-handle s)
		   seq
		   :start start
		   :end (+ start (min n max)))))
