;;;; Utilities
(in-package :xmpp)

(defun xmlelt->s (xmlelt)
  (case (xmpp:name xmlelt)
    (:#text (xmpp:data xmlelt))
    (otherwise
      `(,(xmpp:name xmlelt)
         ,(loop for attr in (xmpp:attributes xmlelt)
                collect `(,(xmpp:name attr) ,(xmpp:value attr)))
         ,(loop for child in (xmpp:elements xmlelt)
                collect (xmlelt->s child))))))

