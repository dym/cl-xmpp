;;;; $Id: package.lisp,v 1.12 2005/11/18 21:43:52 eenge Exp $
;;;; $Source: /project/cl-xmpp/cvsroot/cl-xmpp/package.lisp,v $

;;;; See the LICENSE file for licensing information.

(in-package :cl-user)

(eval-when (:execute :load-toplevel :compile-toplevel)
  (defpackage :cl-xmpp
      (:use :cl
	    #+allegro :socket
	    #+openmcl :ccl)
      (:nicknames :xmpp)
    (:export
     ;; connection-related
     :connect :disconnect :stream- :hostname :port :connectedp
     :receive-stanza-loop :begin-xml-stream :end-xml-stream :with-iq
     :with-iq-query :connection :username :mechanisms :features
     :feature-p :feature-required-p :mechanism-p :receive-stanza
     :server-stream
     :stanza-waiting-p
     ;; only available if you've loaded cl-xmpp-tls
     :connect-tls :connect-tls2
     ;; xmpp commands
     :discover
     :registration-requirements :register
     :auth-requirements :auth
     :presence :message :bind :session
     ;; subscriptions
     :request-subscription :approve-subscription
     :deny/cancel-subscription :unsubscribe
     ;; roster
     :get-roster :roster-add :roster-remove
     ;; privacy-lists
     :get-privacy-lists :get-privacy-list
     ;; dom-ish interface
     :xml-element :name :elements :attributes :node :data
     :xml-attribute :value :get-element :get-attribute
     ;; event interface
     :event
     :presence
     :roster
     :xmpp-protocol-error
     :xmpp-protocol-error-auth
     :xmpp-protocol-error-wait
     :xmpp-protocol-error-cancel
     :xmpp-protocol-error-modify
     :disco-info :features
     :identity-
     :disco :identities
     :disco-items :items
     :item :jid
     :message :to :from :body
     ;; user-hooks for handling events
     :handle
     ;; variables
     :*default-port :*default-hostname* :*errors* :*debug-stream*)))
