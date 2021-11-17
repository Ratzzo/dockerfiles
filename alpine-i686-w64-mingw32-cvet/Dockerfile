FROM ratzzo/alpine-i686-w64-mingw32
#docker build . --squash -t ratzzo/alpine-i686-w64-mingw32-cvet
ENV PREFIX=/opt/mingw32/

##apr
ENV APR=apr-1.7.0
ENV APR_FILE=${APR}.tar.gz
ENV APR_URL=http://apache.cs.utah.edu//apr/


RUN cd opt/ && wget ${APR_URL}${APR_FILE} && tar xvf ${APR_FILE} && rm ${APR_FILE}
RUN cd opt/${APR} && RM="rm -f" ./configure --host=i686-w64-mingw32 --enable-pool-debug=yes apr_cv_mutex_robust_shared=no --prefix=${PREFIX}
ADD patches/ /opt/patches/
RUN cd /opt/${APR}/include/arch/win32 && patch -i /opt/patches/apr_arch_misc.patch && patch -i /opt/patches/apr_private.patch
RUN cd opt/${APR} && make; gcc tools/gen_test_char.c -o tools/gen_test_char; ./tools/gen_test_char > include/private/apr_escape_test_char.h; make -j4; make install


##zlib
ENV ZLIB=zlib-1.2.11
ENV ZLIB_FILE=${ZLIB}.tar.gz
ENV ZLIB_URL=https://www.zlib.net/

RUN cd opt/ && wget ${ZLIB_URL}${ZLIB_FILE} && tar xvf ${ZLIB_FILE} && rm ${ZLIB_FILE}
RUN cd /opt/${ZLIB}/ && make PREFIX=i686-w64-mingw32- -fwin32/Makefile.gcc -j4 && make PREFIX=i686-w64-mingw32- DESTDIR=${PREFIX} LIBRARY_PATH=lib BINARY_PATH=bin INCLUDE_PATH=include -fwin32/Makefile.gcc install && make PREFIX=i686-w64-mingw32- DESTDIR=${PREFIX} LIBRARY_PATH=lib BINARY_PATH=bin INCLUDE_PATH=include SHARED_MODE=1 -fwin32/Makefile.gcc install
#RUN cd /opt/${ZLIB}/ && ./configure --static --prefix=${PREFIX} && make CC=i686-w64-mingw32-gcc -j4 && make CC=i686-w64-mingw32-gcc install


###libpng
ENV LIBPNG=libpng-1.6.37
ENV LIBPNG_FILE=${LIBPNG}.tar.xz 
ENV LIBPNG_URL=https://download.sourceforge.net/libpng/

RUN cd opt/ && wget ${LIBPNG_URL}${LIBPNG_FILE} && tar xvf ${LIBPNG_FILE} && rm ${LIBPNG_FILE}
RUN cd /opt/${LIBPNG}/ && CPPFLAGS="-L${PREFIX}lib -I${PREFIX}include" ./configure --host=i686-w64-mingw32 --prefix=${PREFIX} && make CFLAGS=-L${PREFIX}lib -j4 && make install

##libjpeg
ENV LIBJPEG=jpeg-6b
ENV LIBJPEG_FILE=jpegsrc.v6b.tar.gz
ENV LIBJPEG_URL=https://download.sourceforge.net/libjpeg/

RUN cd opt/ && wget ${LIBJPEG_URL}${LIBJPEG_FILE} && tar xvf ${LIBJPEG_FILE} && rm ${LIBJPEG_FILE}

##patch configure
RUN cd /opt/${LIBJPEG} && \
	patch -i /opt/patches/jpeg-6b_configure.patch &&	\ 
	EXEEXT=.exe AR=i686-w64-mingw32-ar CC=i686-w64-mingw32-gcc RANLIB=i686-w64-mingw32-ranlib CFLAGS="-Wno-implicit" ./configure --host=i686-w64-mingw32 --prefix=${PREFIX} && \
	make -j4 AR="i686-w64-mingw32-ar rc" && make install-headers && make install-lib


##fltk
ENV FLTK=fltk_windows
ENV FLTK_URL=https://Ratzzo@bitbucket.org/Ratzzo/fltk.git

RUN cd /opt/ && git clone --depth=1 ${FLTK_URL} ${FLTK}
RUN cd /opt/${FLTK} && autoconf; automake --add-missing; CFLAGS="-I/opt/mingw32/include -L/opt/mingw32/lib" CPPFLAGS=$CFLAGS ./configure --host=i686-w64-mingw32 --prefix=/opt/mingw32 && make -C src -j4 && make -C src install && make -C FL -j4 && make -C FL install


##openssl
ENV OPENSSL=openssl-1.1.1d
ENV OPENSSL_FILE=${OPENSSL}.tar.gz
ENV OPENSSL_URL=https://www.openssl.org/source/

RUN cd opt/ && wget ${OPENSSL_URL}${OPENSSL_FILE} && tar xvf ${OPENSSL_FILE} && rm ${OPENSSL_FILE}
RUN cd /opt/${OPENSSL}/ && CROSS_COMPILE=i686-w64-mingw32- ./Configure mingw --prefix=${PREFIX} && make -j4 
RUN cd /opt/${OPENSSL}/ && make install_sw; true




###curl
ENV LIBCURL=curl-7.67.0
ENV LIBCURL_FILE=${LIBCURL}.tar.gz
ENV LIBCURL_URL=https://curl.haxx.se/download/

RUN cd opt/ && wget ${LIBCURL_URL}${LIBCURL_FILE} && tar xvf ${LIBCURL_FILE} && rm ${LIBCURL_FILE}
RUN cd /opt/${LIBCURL}/ && CFLAGS="-I/opt/mingw32/include -L/opt/mingw32/lib" ./configure --host=i686-w64-mingw32 --without-libpsl --without-libidn2 --prefix=${PREFIX} && make -C lib -j4 && make -C include -j4 && make -C lib install && make -C include install
#rm lib/libcurl.la; make -C lib -j4


###leptonica
ENV LIBLEPT=leptonica-1.78.0
ENV LIBLEPT_FILE=${LIBLEPT}.tar.gz
ENV LIBLEPT_URL=http://leptonica.org/source/

RUN cd opt/ && wget ${LIBLEPT_URL}${LIBLEPT_FILE} && tar xvf ${LIBLEPT_FILE} && rm ${LIBLEPT_FILE}
RUN cd /opt/${LIBLEPT}/ && CFLAGS="-I/opt/mingw32/include -L/opt/mingw32/lib" ./configure --host=i686-w64-mingw32 --prefix=${PREFIX} --enable-static --disable-shared && make -C src -j4 && make -C src install


##rapidjson
ENV RAPIDJSON=rapidjson
ENV RAPIDJSON_URL=https://github.com/Tencent/rapidjson.git

RUN cd /opt/ && git clone --depth=1 ${RAPIDJSON_URL} ${RAPIDJSON}
RUN cd /opt/${RAPIDJSON} && cp -r include ${PREFIX}

##luajit
# For some reason luajit depends on host and guest architecture pointer size to be equal in order to build
# in this case we are cross compiling from 64 bit alpine to 32bit mingw without a multilib gcc (no -m32)
# So, we bootstrap a 32bit alpine and then compile from there luajit's minilua and buildvm, then continue the compilation
# in the 64bit host (see luajit.sh)
ENV LUAJIT=luajit
ENV LUAJIT_SCRIPT=luajit.sh
ENV LUAJIT_REPO=https://github.com/LuaJIT/LuaJIT.git
ENV LUAJIT_BRANCH=v2.0
ENV ALPINE32_ROOT=/opt/alpine32
ENV LUAJIT_BUILD_ROOT=${ALPINE32_ROOT}/opt

#bootstrap 32bit alpine root
RUN mkdir ${ALPINE32_ROOT} && apk --arch x86 -X https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/ -U --allow-untrusted --root ${ALPINE32_ROOT} --initdb add alpine-base gcc make musl-dev
RUN cd ${LUAJIT_BUILD_ROOT} && git clone --depth=1 --branch=${LUAJIT_BRANCH} ${LUAJIT_REPO} ${LUAJIT}
ADD ${LUAJIT_SCRIPT} ${LUAJIT_BUILD_ROOT}/${LUAJIT}/
run cd ${LUAJIT_BUILD_ROOT}/${LUAJIT}; chmod +x luajit.sh; ./luajit.sh

##sqlite
ENV SQLITE=sqlite
ENV SQLITE_FILE=sqlite-autoconf-3360000.tar.gz
ENV SQLITE_URL=https://sqlite.org/2021/

RUN cd opt/ && wget ${SQLITE_URL}${SQLITE_FILE} && tar xvf ${SQLITE_FILE} && rm ${SQLITE_FILE}
RUN cd opt/sqlite-autoconf-3360000 && ./configure --host=i686-w64-mingw32 --prefix=${PREFIX} && make -j4 && make install

RUN apk add --no-cache zip

##cleanup
#RUN rm -r ${ALPINE32_ROOT} && cd /opt/ && rm -r ${APR} ${ZLIB} ${LIBPNG} ${LIBJPEG} ${FLTK} ${OPENSSL} ${LIBCURL} ${LIBLEPT} ${RAPIDJSON}
