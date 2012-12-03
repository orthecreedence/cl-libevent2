(defpackage #:libevent2
  (:use :cl :cffi)
  (:nicknames :le))

(defpackage #:libevent2.accessors
  (:use :cl :cffi :libevent2)
  (:nicknames :le-a))

(in-package :libevent2)

(eval-when (:load-toplevel)
  (define-foreign-library libevent2-core
    (:darwin (:or "libevent_core.dylib"))
    (:unix (:or "libevent_core.so"
                "libevent_core-2.0.so.5"
                "/usr/lib/libevent_core.so"
                "/usr/local/lib/libevent_core.so"
                ; brew's install of libevent on Mac OX X
                "/usr/local/lib/libevent_core.dylib"))
    (:windows (:or "libevent_core.dll"
                   "libevent_core-2-0-5.dll"))
    (t (:default "libevent_core")))
  (unless (foreign-library-loaded-p 'libevent2-core)
    (use-foreign-library libevent2-core))

  (define-foreign-library libevent2-extra
    (:darwin (:or "libevent_extra.dylib"))
    (:unix (:or "libevent_extra.so"
                "libevent_extra-2.0.so.5"
                "/usr/lib/libevent_extra.so"
                "/usr/local/lib/libevent_extra.so"
                ; brew's install of libevent on Mac OX X
                "/usr/local/lib/libevent_extra.dylib"))
    (:windows (:or "libevent_extra.dll"
                   "libevent_extra-2-0-5.dll"))
    (t (:default "libevent_extra")))
  (unless (foreign-library-loaded-p 'libevent2-extra)
    (use-foreign-library libevent2-extra)))

