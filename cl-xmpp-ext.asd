(defsystem :cl-xmpp-ext 
  :name "cl-xmpp-ext"
  :author "Tetsuya Takatsuru"
  :license "MIT"
  :description "Extensions for cl-xmpp"
  :depends-on (:cl-xmpp)
  :components (;; XMPP Basic Layer
               (:file "util")
               (:file "serverside")
               (:file "iq" :depends-on ("util"))
               (:file "discovery" :depends-on ("iq" "serverside"))
               (:file "components" :depends-on ("serverside"))
               ))

