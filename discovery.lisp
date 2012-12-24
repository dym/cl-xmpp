;;;; Implementation of Service Discovery (XEP-0030)
(in-package :xmpp)

(defclass discovery-request-info (iq-get) ())

(defclass discovery-request-items (iq-get) ())

(defmethod discover ((connection connection) &key (type :info) id from to node)
  "Make discovery request. (for client and server features)"
  (let ((xmlns (case type
                 (:info "http://jabber.org/protocol/disco#info")
                 (:items "http://jabber.org/protocol/disco#items")
                 (otherwise
                   (error "Unknown type ~a (Please choose between :info and :items)" type)))))
    (with-iq-query-sv (connection :id (or id (string (gensym "info"))) :xmlns xmlns
                                  :to to :from from :node node))))

(defmethod answer-discovery-info ((connection connection) &key
                                  from to id node category type name features)
  (with-iq-query-sv (connection :id id :xmlns "http://jabber.org/protocol/disco#info"
                                :from from :to to :type "result" :node node)
    (cxml:with-element "identity"
      (when category (cxml:attribute "category" category))
      (when type (cxml:attribute "type" type))
      (when name (cxml:attribute "name" name)))
    (loop for feature in features
          collect (cxml:with-element "feature"
                    (cxml:attribute "var" feature)))))

(defmethod answer-discovery-items ((connection connection) &key from to id node items)
  (with-iq-query-sv (connection :id id :xmlns "http://jabber.org/protocol/disco#items"
                                :from from :to to :type "result" :node node)
    (loop for item in items
          collect (cxml:with-element "item" (cxml:attribute "jid" item)))))

(defmethod xml-element-to-iq ((connection connection) (object xml-element) (type (eql :result))
                              (xmlns (eql :|http://jabber.org/protocol/disco#info|)))
  (declare (ignore connection xmlns))
  (make-disco-info (get-element object :query)))

(defmethod xml-element-to-iq ((connection connection) (object xml-element) (type (eql :result))
                              (xmlns (eql :|http://jabber.org/protocol/disco#items|)))
  (declare (ignore connection xmlns))
  (make-disco-items (get-element object :query)))

(defmethod xml-element-to-iq ((connection connection) (object xml-element) (type (eql :get))
                              (xmlns (eql :|http://jabber.org/protocol/disco#info|)))
  (declare (ignore connection))
  (make-iq 'discovery-request-info object type xmlns))

(defmethod xml-element-to-iq ((connection connection) (object xml-element) (type (eql :get))
                              (xmlns (eql :|http://jabber.org/protocol/disco#items|)))
  (declare (ignore connection))
  (make-iq 'discovery-request-items object type xmlns))

(export '(discovery-request-info answer-discovery-info
          discovery-request-items answer-discovery-items))

