#!/bin/sh

#
# This script can be used to regenerate the bindings.lisp file using
# SWIG. 
#

swig -cffi -module bindings -noswig-lisp -o bindings.lisp scripts/bindings.i 
swig -cffi -module bindings-ssl -noswig-lisp -o bindings-ssl.lisp scripts/ssl.i 

# nice going, swig. once again, i'm left to clean up your mess
sed -i 's|( 127)|(- 127)|' bindings.lisp
sed -i 's|(cl:- "2.0.20" "stable")|"2.0.20-stable"|' bindings.lisp

# ------------------------------------------------------------------------------
# make our exports
# ------------------------------------------------------------------------------
echo -ne "(in-package :libevent2)\n\n" > exports.lisp
cat bindings.lisp | \
    grep -e '^(\(cffi\|cl\):' | \
    grep -v 'defcstruct' | \
    sed 's|^(cffi:defcfun.*" \(#.(lispify[^)]\+)\).*|\1|' | \
    sed 's|^(cffi:defcenum.*\(#.(lispify[^)]\+)\).*|\1|' | \
    sed 's|^(cl:defconstant.*\(#.(lispify[^)]\+)\).*|\1|' | \
    sed 's|^\(.*\)$|(export '"'"'\1)|' \
    >> exports.lisp

echo -ne "(in-package :libevent2-ssl)\n\n" > exports-ssl.lisp
cat bindings-ssl.lisp | \
    grep -e '^(\(cffi\|cl\):' | \
    grep -v 'defcstruct' | \
    sed 's|^(cffi:defcfun.*" \(#.(le::lispify[^)]\+)\).*|\1|' | \
    sed 's|^(cffi:defcenum.*\(#.(le::lispify[^)]\+)\).*|\1|' | \
    sed 's|^(cl:defconstant.*\(#.(le::lispify[^)]\+)\).*|\1|' | \
    sed 's|^\(.*\)$|(export '"'"'\1)|' | \
	sed 's|(le::lispify\([^)]\+\))|(le::lispify\1 :libevent2-ssl)|' \
	>> exports-ssl.lisp

# ------------------------------------------------------------------------------
# make our accessors
# ------------------------------------------------------------------------------
cat <<-EOFMAC > accessors.lisp
(in-package :libevent2.accessors)

(defmacro make-accessors (c-struct)
  \`(progn
     ,@(loop for slot-name in (foreign-slot-names (intern (string c-struct) :libevent2))
             for accessor-name = (intern (concatenate 'string (symbol-name c-struct)
                                                      "-"
                                                      (symbol-name slot-name)))
             append (list \`(defmacro ,accessor-name (ptr)
                             (list 'foreign-slot-value ptr '',(intern (string c-struct) :libevent2) '',slot-name))
                          \`(export ',accessor-name :libevent2.accessors)))))

EOFMAC

cat bindings.lisp | \
    grep defcstruct | \
    sed 's|.*#\.(lispify|(make-accessors #.(libevent2::lispify|g' | sed 's|$|)|' \
    >> accessors.lisp

