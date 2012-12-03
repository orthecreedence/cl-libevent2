(asdf:defsystem cl-libevent2-ssl
  :author "Andrew Danger Lyon <orthecreedence@gmail.com>"
  :license "MIT"
  :version "0.1.0"
  :description "Extends cl-libevent2 to wrap its SSL implementation."
  :depends-on (#:cffi #:cl-libevent2)
  :components ((:file "libevent2-ssl")
               (:file "bindings-ssl" :depends-on ("libevent2-ssl"))
               (:file "exports-ssl" :depends-on ("bindings-ssl"))))
