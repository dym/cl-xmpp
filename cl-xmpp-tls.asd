;;;; -*- mode: lisp -*-
;;;; $Id: cl-xmpp-tls.asd,v 1.4 2005/11/14 14:26:47 eenge Exp $
;;;; $Source: /project/cl-xmpp/cvsroot/cl-xmpp/cl-xmpp-tls.asd,v $

;;;; See the LICENSE file for licensing information.

(in-package #:cl-user)

(defpackage #:cl-xmpp-tls-system
    (:use #:cl #:asdf))

(in-package #:cl-xmpp-tls-system)

(defsystem cl-xmpp-tls
    :name "cl-xmpp-tls"
    :author "Erik Enge"
    :licence "MIT"
    :description "Common Lisp XMPP client implementation with TLS+SASL support"
    :depends-on (:cl-xmpp-sasl :cl+ssl)
    :components ((:file "cl-xmpp-tls")))

