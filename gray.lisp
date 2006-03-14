(in-package :zip)

(defclass buffer-output-stream (fundamental-binary-output-stream)
    ((buf :initarg :buf :accessor buf)
     (pos :initform 0 :accessor pos)))

(defmethod stream-write-sequence
    #+sbcl ((stream buffer-output-stream) seq &optional (start 0) (end (length seq)))
    #+lispworks ((stream buffer-output-stream) seq start end)
    #-(or sbcl lispworks) ...
  (replace (buf stream) seq
	   :start1 (pos stream)
	   :start2 start
	   :end2 end)
  (incf (pos stream) (- end start))
  seq)

(defun make-buffer-output-stream (outbuf)
  (make-instance 'buffer-output-stream :buf outbuf))

(defclass truncating-stream (fundamental-binary-input-stream)
    ((input-handle :initarg :input-handle :accessor input-handle)
     (size :initarg :size :accessor size)
     (pos :initform 0 :accessor pos)))

(defmethod stream-read-byte ((s truncating-stream))
  (if (< (pos s) (size s))
      (prog1
	  (read-byte (input-handle s))
	(incf (pos s)))
      nil))

(defmethod stream-read-sequence
    #+sbcl ((s truncating-stream) seq &optional (start 0) (end (length seq)))
    #+lispworks ((s truncating-stream) seq start end)
    #-(or sbcl lispworks) ...
  (let* ((n (- end start))
	 (max (- (size s) (pos s)))
	 (result
	  (read-sequence (input-handle s)
			 seq
			 :start start
			 :end (+ start (min n max)))))
    (incf (pos s) (- result start))
    result))
