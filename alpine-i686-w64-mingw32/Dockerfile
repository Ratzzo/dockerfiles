FROM ratzzo/alpine-gcc

RUN apk add --no-cache automake gettext bison flex gperf intltool libtool lzip openssl xz p7zip gdk-pixbuf && mkdir -p /opt/shared
ADD scripts/ /opt/shared/
RUN cd /opt/shared && ./build_i686_w64_mingw32.sh download
RUN cd /opt/shared && ./build_i686_w64_mingw32.sh build
RUN rm -r /opt/shared/; strip /usr/lib/gcc/i686-w64-mingw32/9.2.0/cc1 /usr/lib/gcc/i686-w64-mingw32/9.2.0/cc1plus

#patch stupid mingw headers
RUN cd /usr/i686-w64-mingw32/include/ && echo -en "--- objidl.h\n+++ objidl.h\n@@ -6,6 +6,7 @@\n\n #include <rpc.h>\n #include <rpcndr.h>\n+#include <wtypes.h>\n\n #ifndef COM_NO_WINDOWS_H\n #include <windows.h>\n" | patch;
RUN cd /usr/i686-w64-mingw32/include/ && echo -en "--- wtypes.h\n+++ wtypes.h\n@@ -10,7 +10,7 @@\n \n #ifndef COM_NO_WINDOWS_H\n #include <windows.h>\n-#include <ole2.h>\n+//#include <ole2.h>\n #endif\n \n #ifndef __wtypes_h__\n" | patch;
RUN cd /usr/i686-w64-mingw32/include/ && echo -en "--- wtypesbase.h\n+++ wtypesbase.h\n@@ -10,7 +10,7 @@\n \n #ifndef COM_NO_WINDOWS_H\n #include <windows.h>\n-#include <ole2.h>\n+//#include <ole2.h>\n #endif\n \n #ifndef __wtypesbase_h__\n" | patch;


