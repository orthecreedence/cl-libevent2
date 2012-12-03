%module bindings

%feature("intern_function", "le::lispify");

%insert("lisphead") %{
(in-package :libevent2-ssl)
%}

/* enable SSL */
#define _EVENT_HAVE_OPENSSL 1

typedef unsigned short ev_uint16_t;

%include "/usr/local/include/event2/bufferevent_ssl.h"
