;;;; implementation of External Server Component (XEP-0114)
(in-package :cl-xmpp)

(defclass component-connection (connection)
  ()
  (:documentation "XMPP External Component"))

(defun connect-component (&key (hostname *default-hostname*) (port *default-port*)
                               (receive-stanzas t) (begin-xml-stream t) server-jid
                               (class 'component-connection))
  "Open TCP connection to hostname."
  (let ((connection (connect :hostname hostname :port port
                             :receive-stanzas nil :begin-xml-stream begin-xml-stream
                             :jid-domain-part server-jid :class class)))
    (when receive-stanzas
      (receive-stanza connection)) ; <stream ...>
    connection))

(defmethod begin-xml-stream ((connection component-connection)
                             &key (xml-identifier t))
  (with-xml-stream (stream connection)
    (when xml-identifier
      (xml-output stream "<?xml version='1.0' ?>"))
    (xml-output stream (fmt "<stream:stream xmlns='jabber:component:accept' xmlns:stream='http://etherx.jabber.org/streams' to='~A'>" (jid-domain-part connection)))))

(defmethod auth ((connection component-connection)
                 username password resource &key (receive-stanzas t))
  (declare (ignore username resource))
  (with-xml-output (connection)
    (cxml:with-element "handshake"
      (cxml:text
        (ironclad:byte-array-to-hex-string
          (ironclad:digest-sequence
            :sha1 (ironclad:ascii-string-to-byte-array
                    (format nil "~A~A" (stream-id connection) password)))))))
  (if receive-stanzas
    (receive-stanza connection)))

(export '(component-connection connect-component handle-jid))

