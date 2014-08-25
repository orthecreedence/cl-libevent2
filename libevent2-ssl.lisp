(defpackage #:libevent2-ssl
  (:use :cl :cffi)
  (:nicknames :le-ssl))

(in-package :libevent2-ssl)

(eval-when (:load-toplevel)
  (define-foreign-library libevent2-ssl
    (:darwin (:or "libevent_openssl.dylib"
                  ; brew's install of libevent on Mac OX X
                  "/usr/local/lib/libevent_openssl.dylib"
                  ; macports
                  "/opt/local/lib/libevent_openssl.dylib"))
    (:unix (:or "/usr/local/lib/event2/libevent_openssl.so"
                "libevent_openssl.so"
                "libevent_openssl-2.0.so.5"
                "/usr/lib/libevent_openssl.so"
                "/usr/local/lib/libevent_openssl.so"))
    (:windows (:or "libevent_openssl.dll"
                   "libevent_openssl-2-0-5.dll"))
    (t (:default "libevent_openssl")))
  (unless (foreign-library-loaded-p 'libevent2-ssl)
    (use-foreign-library libevent2-ssl)))

