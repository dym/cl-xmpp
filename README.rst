.. -*- restructuredtext -*-

=======
CL-XMPP
=======

This is a Common Lisp implementation of the XMPP RFCs.  Please
see http://common-lisp.net/project/cl-xmpp for more information.

Example:
========

Connect as a jabber client
--------------------------

::

  (require :cl-xmpp)

  (defvar *connection* (xmpp:connect :hostname "jabber.org"))
  ;; or xmpp:connect-tls if you loaded cl-xmpp-tls
  ;; note that for XMPP servers which do not have the same hostname
  ;; as the domain-part of the user's JID you will have to pass that
  ;; in.  eg for Google Talk:
  ;;  (defvar *connection* (xmpp:connect-tls :hostname "talk.google.com"
  ;;                                         :jid-domain-part "gmail.com"))

  (xmpp:auth *connection* "username" "password" "resource")
  ;; or pass :mechanism :sasl-plain, :digest-md5 or sasl-digest-md5
  ;; if you loaded cl-xmpp-sasl or cl-xmpp-tls.

  ;; send someone a message
  (xmpp:message *connection* "username@hostname" "what's going on?")

  ;; then sit back and watch the messages roll in:
  (xmpp:receive-stanza-loop *connection*)
  <MESSAGE from=username@hostname to=me@myserver>
  [....]
  ;; or use xmpp:receive-stanza if you're just wanting one stanza
  ;; (note it will still block until you have received a complete
  ;; stanza)

  ;; That's it.  Interrupt the loop to issue other commands, eg:
  (xmpp:get-roster *connection*)
  ;; or any of the other ones you may find by looking through cl-xmpp.lisp
  ;; and package.lisp to see which ones are exported.

  ;; If you wish to handle the incoming messages or other objects simply
  ;; specify an xmpp:handle method for the objects you are interested in
  ;; or (defmethod xmpp:handle (connection object) ...)  to get them
  ;; all.  Or alternatively specify :dom-repr t to receive-stanza-loop
  ;; to get DOM-ish objects.

  ;; For example, if you wanted to create an annoying reply bot:

  (defmethod xmpp:handle ((connection xmpp:connection) (message xmpp:message))
    (xmpp:message connection (xmpp:from message) 
        (format nil "reply to: ~a" (xmpp:message object))))

===========
CL-XMPP-EXT
===========

I made this library for implementing XMPP server component for myself.

This extension supports:

* IQ stanza handling
* Service Discovery (XEP-0030)
* External Server Component (XEP-0114)
* and more feature if I need....

USAGE
=====

Connect Server as External Component
------------------------------------

First, configure server for accepting External Component.
For example in ejabberd ::

  {listen, [{5550, ejabberd_service,
                   [{ip, {127, 0, 0, 1}}, {access, all},
                    {host, "myext.mydomain.tld",
		     [{password, "somepassword"}]}]}]} 

Restart your ejabberd, start Common Lisp environment,
and load cl-xmpp-ext via ASDF.

::

  (let ((conn (xmpp:connect-component :hostname "localhost" :port 5550
                                      :server-jid "myext.mydomain.tld")))
    (xmpp:auth conn nil "somepassword" nil) ; handshake
    ...)

To handle messages, defmethod xmpp:handle like as cl-xmpp.
Several event classes are added:

* xmpp:iq, xmpp:iq-get, xmpp:iq-set, xmpp:iq-result, xmpp:iq-errpr
* xmpp:discovery-request-items, xmpp:discovery-request-info

