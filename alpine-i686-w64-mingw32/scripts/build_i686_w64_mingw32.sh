#!/bin/sh

GCC_VER=9.2.0
BINUTILS_VER=2.33.1
HEADERS_VER=7.0.0

_target=i686-w64-mingw32

BINUTILS_ARCHIVE=binutils-${BINUTILS_VER}.tar.gz
BINUTILS_FOLDER=${BINUTILS_ARCHIVE%.*.*}
BINUTILS_BASEURL=https://ftp.gnu.org/gnu/binutils/

HEADERS_ARCHIVE=mingw-w64-v${HEADERS_VER}.tar.bz2
HEADERS_FOLDER=${HEADERS_ARCHIVE%.*.*}
HEADERS_BASEURL=https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/

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
			--enable-targets=i686-w64-mingw32 --disable-nls \
			--disable-werror
		make -j4
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

CURRENT_ARCHIVE=$HEADERS_ARCHIVE
CURRENT_FOLDER=$HEADERS_FOLDER
CURRENT_BASEURL=$HEADERS_BASEURL
OUTPUT_FOLDER=$CURRENT_FOLDER-${_target}-headers

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
	fi


	if [ ! -d $OUTPUT_FOLDER ]
	then
		mkdir -p $OUTPUT_FOLDER
		cd $OUTPUT_FOLDER
		$BASEDIR/$CURRENT_FOLDER/mingw-w64-headers/configure --prefix=/usr/${_target} --enable-sdk=all --host=${_target}
		make -j4
		make install
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
			--enable-targets=i686-w64-mingw32 --enable-checking=release
		make -j$THREADS all-gcc
		make -j4 install-gcc
		cd ..
	else
		cd $OUTPUT_FOLDER
		make -j install-gcc
		cd ..
	fi
	
fi


## END GCC CORE ##

## MINGW CRT ##

CURRENT_ARCHIVE=$HEADERS_ARCHIVE
CURRENT_FOLDER=$HEADERS_FOLDER
CURRENT_BASEURL=$HEADERS_BASEURL
OUTPUT_FOLDER=$CURRENT_FOLDER-${_target}-crt

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
	fi


	if [ ! -d $OUTPUT_FOLDER ]
	then
		mkdir -p $OUTPUT_FOLDER
		cd $OUTPUT_FOLDER
		$BASEDIR/$CURRENT_FOLDER/configure --prefix=/usr/${_target} \
			--host=${_target} --enable-wildcard \
			--enable-lib32
		make -j$THREADS
		make -j4 install
		cd ..
	else
		cd $OUTPUT_FOLDER
		make -j4 install
		cd ..
	fi
fi

## END MINGW CRT ##

## MINGW PTHREADS ##

CURRENT_ARCHIVE=$HEADERS_ARCHIVE
CURRENT_FOLDER=$HEADERS_FOLDER
CURRENT_BASEURL=$HEADERS_BASEURL
OUTPUT_FOLDER=$CURRENT_FOLDER-${_target}-winpthreads

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
	fi


	if [ ! -d $OUTPUT_FOLDER ]
	then
		mkdir -p $OUTPUT_FOLDER
		cd $OUTPUT_FOLDER
		$BASEDIR/$CURRENT_FOLDER/mingw-w64-libraries/winpthreads/configure --prefix=/usr/${_target} \
		--host=${_target} --enable-static --enable-shared
		
		make -j$THREADS
		make -j4 install
		cd ..
	else
		cd $OUTPUT_FOLDER
		make -j4 install
		cd ..
	fi
fi

#CURRENT_FOLDER=$HEADERS_FOLDER
#CURRENT_BASEURL=$HEADERS_BASEURL
#OUTPUT_FOLDER=$CURRENT_FOLDER-${_target}-winpthreads32
#
#if [ ! -f $CURRENT_ARCHIVE ]
#then
#	wget $CURRENT_BASEURL$CURRENT_ARCHIVE
#fi
#
#
#if [ ! -d $CURRENT_FOLDER ] 
#then
#	tar xvf $CURRENT_ARCHIVE
#fi
#
#
#if [ ! -d $OUTPUT_FOLDER ]
#then
#	mkdir -p $OUTPUT_FOLDER
#	cd $OUTPUT_FOLDER
#	CFLAGS=-m32 RCFLAGS=-Fi686-w64-mingw32 $BASEDIR/$CURRENT_FOLDER/mingw-w64-libraries/winpthreads/configure --prefix=/usr/${_target} --libdir=/usr/${_target}/lib32 \
#        --host=${_target} --enable-static --enable-shared 
#	
##	make -j4
##	make -j4 install
#	cd ..
#fi

## END MINGW PTHREADS ##


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
				--enable-checking=release --disable-multilib

		make -j$THREADS
		make install
		cd ..
	else
		cd $OUTPUT_FOLDER
		make -j4 install
		cd ..
	fi
fi

## END GCC ##


#make -j4