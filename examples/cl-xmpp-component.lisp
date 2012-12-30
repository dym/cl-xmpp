(in-package :xmpp-component)

(setf *random-state* (make-random-state t))

(defvar *connection* NIL)

(defun auth (password)
  (xmpp:auth *connection*
             nil password
             nil))

(defun start-session (resource)
    (xmpp:bind *connection* resource)
    (xmpp:session *connection*)
    (xmpp:get-roster *connection*)
    (xmpp:presence *connection* :priority 5))

(defun main (component password &key
                                  (hostname "localhost")
                                  (port 5400))
  (defparameter *connection*
    (xmpp:connect-component :hostname hostname
                            :port port
                            :server-jid component))
  (auth password))
