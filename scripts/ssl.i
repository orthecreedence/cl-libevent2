%module bindings

%feature("intern_function", "le::lispify");

%insert("lisphead") %{
(in-package :libevent2-ssl)
%}

%ignore "_EVENT_LT_OBJDIR";
%ignore "_EVENT_VERSION";
%ignore "_EVENT_PACKAGE";
%ignore "_EVENT_PACKAGE_BUGREPORT";
%ignore "_EVENT_PACKAGE_NAME";
%ignore "_EVENT_PACKAGE_STRING";
%ignore "_EVENT_PACKAGE_TARNAME";
%ignore "_EVENT_PACKAGE_URL";
%ignore "_EVENT_PACKAGE_VERSION";
%ignore "LIBEVENT_VERSION";

/* enable SSL */
#define _EVENT_HAVE_OPENSSL 1

typedef unsigned long size_t;

%include "/usr/local/include/event2/event-config.h"
%include "/usr/local/include/event2/util.h"

typedef unsigned short ev_uint16_t;

%include "/usr/local/include/event2/bufferevent_ssl.h"
