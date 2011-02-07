;;; features for servers.
(in-package :xmpp)

(defmethod message ((connection connection) to body &key id (type :chat) from)
  (with-xml-output (connection)
    (cxml:with-element "message"
      (cxml:attribute "to" to)
      (when from (cxml:attribute "from" from))
      (when id (cxml:attribute "id" id))
      (when type (cxml:attribute "type" (string-downcase (string type))))
      (cxml:with-element "body" (cxml:text body)))))

(defmacro with-iq-sv ((connection &key id from to (type "get")) &body body)
  `(with-xml-output (,connection)
     (cxml:with-element "iq"
       (when ,id (cxml:attribute "id" ,id))
       (when ,from (cxml:attribute "from" ,from))
       (when ,to (cxml:attribute "to" ,to))
       (cxml:attribute "type" ,type)
       ,@body)))

(defmacro with-iq-query-sv ((connection &key xmlns id from to node (type "get")) &body body)
  `(with-iq-sv (,connection :id ,id :type ,type :from ,from :to ,to)
     (cxml:with-element "query"
       (cxml:attribute "xmlns" ,xmlns)
       (when ,node (cxml:attribute "node" ,node))
       ,@body)))

