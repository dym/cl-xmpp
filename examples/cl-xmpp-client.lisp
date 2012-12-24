(in-package :xmpp-client)

(setf *random-state* (make-random-state t))

(defvar *connection* NIL)

(defun auth (username password)
  (let* ((random-part (random 10000))
         (resource (concatenate 'string
                                "cl-xmpp-client-"
                                (write-to-string random-part))))
    (xmpp:auth *connection*
               username password
               resource
               :mechanism :sasl-digest-md5)
    resource))

(defun start-session (resource)
    (xmpp:bind *connection* resource)
    (xmpp:session *connection*)
    (xmpp:get-roster *connection*)
    (xmpp:presence *connection* :priority 5))

(defun main (username password &key (hostname "localhost"))
  (defparameter *connection* (xmpp:connect :hostname hostname))
  (let ((resource (auth username password)))
    (start-session resource)))
