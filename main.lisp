(ql:quickload :usocket)
(ql:quickload :babel)

(defun read-until-new-line (stream)
  (loop for b = (read-byte stream nil nil)
	while (and b (not (equal b 10)))
	collect b))

(defun to-string-as-shiftjis (bytes-list)
  (let ((bytes (make-array (length bytes-list)
			   :element-type '(unsigned-byte 8)
			   :initial-contents bytes-list)))
    (babel:octets-to-string bytes :encoding :cp932)))

(defun access ()
  (let* ((socket (usocket:socket-connect "koukoku.shadan.open.ad.jp" 23 :element-type '(unsigned-byte 8)))
	 (stream (usocket:socket-stream socket)))
    (unwind-protect
	 (progn
	   (loop for line = (read-until-new-line stream)
		 while (not (= 0 (length line)))
		 do (format t "~A~%" (to-string-as-shiftjis line))))
      (usocket:socket-close socket))))
