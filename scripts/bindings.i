%module bindings

%feature("intern_function", "lispify");

%insert("lisphead") %{
(in-package :libevent2)
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

#define AF_UNSPEC   0
#define AF_UNIX 1
#define AF_INET 2
#define AF_INET6 23
#define SOCK_STREAM 1
#define IPPROTO_TCP 6

typedef unsigned long size_t;

struct timeval {
  long tv_sec;
  long tv_usec;
};

struct sockaddr_in {
    short   sin_family;
    unsigned short sin_port;

    /* NOTE: should be unsigned long, but CFFI adds +4 to the offset if this
       is a long, which really shouldn't happen. unsigned int seems to work on
       all platforms, so until otherwise noted, this is how it's going to stay */
    unsigned int sin_addr;
    /*struct  in_addr sin_addr;*/
    /*char    sin_zero[8];*/
    char sin_zero_0;
    char sin_zero_1;
    char sin_zero_2;
    char sin_zero_3;
    char sin_zero_4;
    char sin_zero_5;
    char sin_zero_6;
    char sin_zero_7;
};

struct sockaddr_in6 {
    unsigned short sin6_family;
    unsigned short sin6_port;
    unsigned int sin6_flowinfo;
    /* struct sin6_addr */
    /* unsigned char s6_addr[16] */
    unsigned char sin6_addr_0;
    unsigned char sin6_addr_1;
    unsigned char sin6_addr_2;
    unsigned char sin6_addr_3;
    unsigned char sin6_addr_4;
    unsigned char sin6_addr_5;
    unsigned char sin6_addr_6;
    unsigned char sin6_addr_7;
    unsigned char sin6_addr_8;
    unsigned char sin6_addr_9;
    unsigned char sin6_addr_10;
    unsigned char sin6_addr_11;
    unsigned char sin6_addr_12;
    unsigned char sin6_addr_13;
    unsigned char sin6_addr_14;
    unsigned char sin6_addr_15;
    unsigned int sin6_scope_id;
};

/* for linux */
struct addrinfo {
    int     ai_flags;
    int     ai_family;
    int     ai_socktype;
    int     ai_protocol;
    size_t  ai_addrlen;
    struct sockaddr  *ai_addr;
    char   *ai_canonname;
    struct evutil_addrinfo  *ai_next;
};

/* for windows */
struct evutil_addrinfo {
    int     ai_flags;     /* AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST */
    int     ai_family;    /* PF_xxx */
    int     ai_socktype;  /* SOCK_xxx */
    int     ai_protocol;  /* 0 or IPPROTO_xxx for IPv4 and IPv6 */
    size_t  ai_addrlen;   /* length of ai_addr */
    char   *ai_canonname; /* canonical name for nodename */
    struct sockaddr  *ai_addr; /* binary address */
    struct evutil_addrinfo  *ai_next; /* next structure in linked list */
};

struct evkeyval {
    struct evkeyval *next;
    struct evkeyval **prev;

    char* key;
    char* value;
};

struct evkeyvalq {
    struct evkeyval *thq_first;
    struct evkeyval **thq_last;
};

%include "/usr/local/include/event2/event-config.h"
%include "/usr/local/include/event2/util.h"

typedef unsigned short ev_uint16_t;

%include "/usr/local/include/event2/event.h"
%include "/usr/local/include/event2/dns.h"
%include "/usr/local/include/event2/bufferevent.h"
%include "/usr/local/include/event2/bufferevent_struct.h"
%include "/usr/local/include/event2/buffer.h"
%include "/usr/local/include/event2/listener.h"
%include "/usr/local/include/event2/http.h"

enum evhttp_connection_state {
    EVCON_DISCONNECTED,    /**< not currently connected not trying either*/
    EVCON_CONNECTING,    /**< tries to currently connect */
    EVCON_IDLE,        /**< connection is established */
    EVCON_READING_FIRSTLINE,/**< reading Request-Line (incoming conn) or
                 **< Status-Line (outgoing conn) */
    EVCON_READING_HEADERS,    /**< reading request/response headers */
    EVCON_READING_BODY,    /**< reading request/response body */
    EVCON_READING_TRAILER,    /**< reading request/response chunked trailer */
    EVCON_WRITING        /**< writing request/response headers/body */
};

struct evhttp_connection {
    /* struct next (server only) */
    struct evhttp_connection *tqe_next;
    struct evhttp_connection **tqe_prev;

    evutil_socket_t fd;
    struct bufferevent *bufev;
    struct event retry_ev;
    char *bind_address;
    u_short bind_port;
    char *address;
    u_short port;
    size_t max_headers_size;
    ev_uint64_t max_body_size;
    int flags;
    int timeout;
    int retry_cnt;
    int retry_max;
    enum evhttp_connection_state state;
    struct evhttp *http_server;

    /* struct requests */
    struct evhttp_request *tqh_first;
    struct evhttp_request **tqh_last;

    /* everything after this point can be safely ignored, but included to be safe... */

    void (*cb)(struct evhttp_connection *, void *);
    void *cb_arg;
    void (*closecb)(struct evhttp_connection *, void *);
    void *closecb_arg;
    struct deferred_cb read_more_deferred_cb;
    struct event_base *base;
    struct evdns_base *dns_base;
};

struct evhttp_request {
    /* struct next */
    struct evhttp_request *tqe_next;
    struct evhttp_request **tqe_prev;

    struct evhttp_connection *evcon;
    int flags;
    struct evkeyvalq *input_headers;
    struct evkeyvalq *output_headers;
    char *remote_host;
    ev_uint16_t remote_port;
    char *host_cache;
    enum evhttp_request_kind kind;
    enum evhttp_cmd_type type;
    size_t headers_size;
    size_t body_size;
    char *uri;
    struct evhttp_uri *uri_elems;
    char major;
    char minor;

    /* everything after this point can be safely ignored, but included to be safe... */

    int response_code;
    char *response_code_line;
    struct evbuffer *input_buffer;
    ev_int64_t ntoread;
    unsigned chunked:1,
        userdone:1;
    struct evbuffer *output_buffer;
    void (*cb)(struct evhttp_request *, void *);
    void *cb_arg;
    void (*chunk_cb)(struct evhttp_request *, void *);
};

