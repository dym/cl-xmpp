(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :cl-xmpp))

(defpackage #:cl-xmpp-examples-system
  (:use :cl
        :asdf))

(in-package #:cl-xmpp-examples-system)

(defsystem cl-xmpp-examples
  :name "cl-xmpp-examples"
  :author "Dmitriy Budashny"
  :licence "MIT"
  :description "Common Lisp XMPP client examples"
  :depends-on (:cl-xmpp
               :cl-xmpp-sasl
               :cxml)
  :components ((:file "packages")
               (:file "cl-xmpp-client")))
