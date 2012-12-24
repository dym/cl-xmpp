(in-package :xmpp)

(defclass iq (event)
  ((from :accessor from :initarg :from)
   (to :accessor to :initarg :to)
   (id :accessor id :initarg :id)
   (type :accessor type- :initarg :type)
   (xmlns :accessor xmlns :initarg :xmlns))
  (:documentation ""))

(defclass iq-get (iq) ())
(defclass iq-set (iq) ())
(defclass iq-result (iq) ())
(defclass iq-error (iq) ())

(defmethod print-object ((object iq) stream)
  (print-unreadable-object (object stream :type t :identity t)
    (format stream "from:~A to:~A id:~A type:~A xmlns:~A"
            (from object) (to object) (id object) (type- object) (xmlns object))))

(defun make-iq (class object type xmlns)
  (make-instance class
                 :xml-element object
                 :from (value (get-attribute object :from))
                 :to (value (get-attribute object :to))
                 :id (value (get-attribute object :id))
                 :type type
                 :xmlns xmlns))

(defmethod xml-element-to-iq ((connection connection) (object xml-element) (type (eql :get)) xmlns)
  (declare (ignore connection))
  (make-iq 'iq-get object type xmlns))

(defmethod xml-element-to-iq ((connection connection) (object xml-element) (type (eql :set)) xmlns)
  (declare (ignore connection))
  (make-iq 'iq-set object type xmlns))

(defmethod xml-element-to-iq ((connection connection) (object xml-element) (type (eql :result)) xmlns)
  (declare (ignore connection))
  (make-iq 'iq-result object type xmlns))

(defmethod xml-element-to-iq ((connection connection) (object xml-element) (type (eql :error)) xmlns)
  (declare (ignore connection))
  (make-iq 'iq-error object type xmlns))

(defmethod xml-element-to-event ((connection connection)
                                 (object xml-element) (name (eql :iq)))
  (xml-element-to-iq
    connection object
    (ensure-keyword (value (get-attribute object :type)))
    (let ((query (get-element object :query)))
      (if query (intern (value (get-attribute query :xmlns)) "KEYWORD")))))

(export '(iq iq-get iq-set iq-result iq-error xmlns id))

