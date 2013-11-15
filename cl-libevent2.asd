(asdf:defsystem cl-libevent2
  :author "Andrew Danger Lyon <orthecreedence@gmail.com>"
  :license "MIT"
  :version "0.1.5"
  :description "Low-level libevent2 bindings for Common Lisp."
  :depends-on (#:cffi #:cffi-libffi)
  :components ((:file "libevent2")
               (:file "wrapper" :depends-on ("libevent2"))
               (:file "bindings" :depends-on ("wrapper"))
               (:file "exports" :depends-on ("bindings"))
               (:file "accessors" :depends-on ("exports"))))

