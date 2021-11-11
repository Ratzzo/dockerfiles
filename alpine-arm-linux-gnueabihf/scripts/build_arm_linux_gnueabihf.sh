#!/bin/sh

GCC_VER=10.2.0
BINUTILS_VER=2.36.1
LINUX_VER=v5.11
GLIBC_VER=release/2.33/master
GMP_VER=6.2.1
NTHREADS=24

_target=arm-linux-gnueabihf

BINUTILS_ARCHIVE=binutils-${BINUTILS_VER}.tar.gz
BINUTILS_FOLDER=${BINUTILS_ARCHIVE%.*.*}
BINUTILS_BASEURL=https://ftp.gnu.org/gnu/binutils/

GLIBC_FOLDER=glibc
GLIBC_BASEURL="git://sourceware.org/git/glibc.git"

HEADERS_FOLDER=linux
HEADERS_BASEURL="https://github.com/torvalds/linux.git"

GCC_ARCHIVE=gcc-${GCC_VER}.tar.xz
GCC_FOLDER=${GCC_ARCHIVE%.*.*}
GCC_BASEURL=https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/


BASEDIR=$PWD

if [ $1 == "download" ]
then
	echo download
elif [ $1 == "build" ]
then
	echo build
fi

## TODO: optimize this garbage with an array of parameters ##

## BINUTILS ##

CURRENT_ARCHIVE=$BINUTILS_ARCHIVE
CURRENT_FOLDER=$BINUTILS_FOLDER
CURRENT_BASEURL=$BINUTILS_BASEURL
OUTPUT_FOLDER=$CURRENT_FOLDER-${_target}

if [ $1 == "download" ]
then
	if [ ! -f $CURRENT_ARCHIVE ]
	then
		wget $CURRENT_BASEURL$CURRENT_ARCHIVE
	fi
elif [ $1 == "build" ]
then
	if [ ! -d $CURRENT_FOLDER ]
	then
		tar xvf $CURRENT_ARCHIVE
		cd $CURRENT_FOLDER
		sed -i 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in
		sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" libiberty/configure
		cd ..
	fi 

	if [ ! -d $OUTPUT_FOLDER ]
	then
		mkdir -p $OUTPUT_FOLDER
		cd $OUTPUT_FOLDER
		"$BASEDIR"/$CURRENT_FOLDER/configure --prefix=/usr \
			--target=${_target} \
			--infodir=/usr/share/info/${_target} \
			--enable-lto --enable-plugins \
			--enable-deterministic-archives \
			--disable-nls \
			--disable-werror
		make -j$NTHREADS
		make install
		cd ..
	else
		cd $OUTPUT_FOLDER
		make install
		cd ..
	fi
fi


## END BINUTILS ##

## HEADERS ##

CURRENT_FOLDER=$HEADERS_FOLDER
CURRENT_BASEURL=$HEADERS_BASEURL
OUTPUT_FOLDER=$CURRENT_FOLDER-${_target}-headers

if [ $1 == "download" ]
then
	if [ ! -d $CURRENT_FOLDER ]
	then
		git clone --depth=1 --branch=$LINUX_VER $CURRENT_BASEURL $CURRENT_FOLDER
	fi
elif [ $1 == "build" ]
then

	if [ ! -d $OUTPUT_FOLDER ]
	then
		mkdir -p $OUTPUT_FOLDER
		cd $OUTPUT_FOLDER
		make -C ../${CURRENT_FOLDER} ARCH=arm INSTALL_HDR_PATH=/usr/${_target} headers_install
		cd ..
	else
		cd $OUTPUT_FOLDER
		make install
		cd ..
	fi
fi



## END HEADERS ##

## GCC CORE ##
CURRENT_ARCHIVE=$GCC_ARCHIVE
CURRENT_FOLDER=$GCC_FOLDER
CURRENT_BASEURL=$GCC_BASEURL
OUTPUT_FOLDER=$CURRENT_FOLDER-${_target}-base

if [ $1 == "download" ]
then
	if [ ! -f $CURRENT_ARCHIVE ]
	then
		wget $CURRENT_BASEURL$CURRENT_ARCHIVE
	fi
elif [ $1 == "build" ]
then
	if [ ! -d $CURRENT_FOLDER ] 
	then
		tar xvf $CURRENT_ARCHIVE
		cd $CURRENT_FOLDER
		./contrib/download_prerequisites
		cd ..
	fi


	if [ ! -d $OUTPUT_FOLDER ]
	then
		mkdir -p $OUTPUT_FOLDER
		cd $OUTPUT_FOLDER
		$BASEDIR/$CURRENT_FOLDER/configure --prefix=/usr \
			--target=${_target} \
			--enable-languages=c,lto \
			--enable-static \
			--with-system-zlib \
			--enable-lto --disable-dw2-exceptions \
			--disable-nls --enable-version-specific-runtime-libs \
			--with-arch=armv7-a --with-fpu=neon --enable-checking=release
		make -j$NTHREADS all-gcc
		make -j$NTHREADS install-gcc
		cd ..
	else
		cd $OUTPUT_FOLDER
		make -j$NTHREADS install-gcc
		cd ..
	fi
	
fi


## END GCC CORE ##

## GLIBC ##

CURRENT_FOLDER=$GLIBC_FOLDER
CURRENT_BASEURL=$GLIBC_BASEURL
OUTPUT_FOLDER=$CURRENT_FOLDER-${_target}

if [ $1 == "download" ]
then
	if [ ! -d $CURRENT_FOLDER ]
	then
		git clone --depth=1 --branch=$GLIBC_VER $CURRENT_BASEURL $CURRENT_FOLDER
	fi
elif [ $1 == "build" ]
then

	if [ ! -d $OUTPUT_FOLDER ]
	then
		mkdir -p $OUTPUT_FOLDER
		cd $OUTPUT_FOLDER
		$BASEDIR/$CURRENT_FOLDER/configure --prefix=/usr/${_target} --build=$MACHTYPE --host=${_target} --target=${_target} --with-headers=/usr/${_target}/include --disable-multilib libc_cv_forced_unwind=yes
		make install-bootstrap-headers=yes install-headers
		make -j$NTHREADS csu/subdir_lib
		install csu/crt1.o csu/crti.o csu/crtn.o /usr/${_target}/lib
		${_target}-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o /usr/${_target}/lib/libc.so
		touch /usr/${_target}/include/gnu/stubs.h
		cd ..
	else
		cd $OUTPUT_FOLDER
		#make install
		cd ..
	fi
fi

## END GLIBC ##

## GCC LIB ##
CURRENT_ARCHIVE=$GCC_ARCHIVE
CURRENT_FOLDER=$GCC_FOLDER
CURRENT_BASEURL=$GCC_BASEURL
OUTPUT_FOLDER=$CURRENT_FOLDER-${_target}-base

if [ $1 == "download" ]
then
	if [ ! -f $CURRENT_ARCHIVE ]
	then
		wget $CURRENT_BASEURL$CURRENT_ARCHIVE
	fi
elif [ $1 == "build" ]
then
	if [ ! -d $CURRENT_FOLDER ] 
	then
		tar xvf $CURRENT_ARCHIVE
		cd $CURRENT_FOLDER
		./contrib/download_prerequisites
		cd ..
	fi


	#if [ ! -d $OUTPUT_FOLDER ]
	#then
	mkdir -p $OUTPUT_FOLDER
	cd $OUTPUT_FOLDER
	make -j$NTHREADS all-target-libgcc
	make -j$NTHREADS install-target-libgcc
	cd ..
	#else
	#	cd $OUTPUT_FOLDER
	#	#make -j4 install-gcc
	#	cd ..
	#fi
	
fi


## END GCC LIB ##

## FINISH GLIBC ##

CURRENT_FOLDER=$GLIBC_FOLDER
CURRENT_BASEURL=$GLIBC_BASEURL
OUTPUT_FOLDER=$CURRENT_FOLDER-${_target}

if [ $1 == "download" ]
then
	if [ ! -d $CURRENT_FOLDER ]
	then
		git clone --depth=1 --branch=$GLIBC_VER $CURRENT_BASEURL $CURRENT_FOLDER
	fi
elif [ $1 == "build" ]
then

		mkdir -p $OUTPUT_FOLDER
		cd $OUTPUT_FOLDER
		make -j$NTHREADS
		make install
		cd ..
fi

## END FINISH GLIBC ##


## GCC ##
CURRENT_ARCHIVE=$GCC_ARCHIVE
CURRENT_FOLDER=$GCC_FOLDER
CURRENT_BASEURL=$GCC_BASEURL
OUTPUT_FOLDER=$CURRENT_FOLDER-${_target}

if [ $1 == "download" ]
then
	if [ ! -f $CURRENT_ARCHIVE ]
	then
		wget $CURRENT_BASEURL$CURRENT_ARCHIVE
	fi
elif [ $1 == "build" ]
then
	if [ ! -d $CURRENT_FOLDER ] 
	then
		tar xvf $CURRENT_ARCHIVE
		cd $CURRENT_FOLDER
		./contrib/download_prerequisites
		cd ..
	fi


	if [ ! -d $OUTPUT_FOLDER ]
	then
		mkdir -p $OUTPUT_FOLDER
		cd $OUTPUT_FOLDER
		$BASEDIR/$CURRENT_FOLDER/configure	--prefix=/usr --libexecdir=/usr/lib \
				--target=${_target} \
				--enable-languages=c,c++ \
				--enable-shared --enable-static \
				--enable-threads=posix --enable-fully-dynamic-string \
				--enable-libstdcxx-time=yes --enable-libstdcxx-filesystem-ts=yes \
				--with-system-zlib --enable-cloog-backend=isl \
				--enable-lto --disable-dw2-exceptions --enable-libgomp \
				--enable-checking=release --disable-multilib \
				--with-arch=armv7-a --with-fpu=neon --disable-libsanitizer

		make -j$NTHREADS
		make install
		cd ..
	else
		cd $OUTPUT_FOLDER
		make -j$NTHREADS install
		cd ..
	fi
fi

## END GCC ##
#
#
##make -j4
