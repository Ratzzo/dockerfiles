#!/bin/sh
LUAJITROOT=$LUAJIT_BUILD_ROOT/$LUAJIT

cd  $LUAJITROOT
#compile inside 32bit chroot
echo -e "	\n
cd /opt/luajit/ \n
make HOST_CC=\"gcc\" CROSS=\"\" TARGET_SYS=Windows -j4 clean\n
make -C src CROSS=\"\" TARGET_SYS=Windows -j4 host/minilua host/buildvm \n
" | chroot $ALPINE32_ROOT
#cp -r /opt/alpine32/opt/luajit/src .

#override ld to use i386 interpreter 
mv src/host/buildvm src/host/buildvm_bin
mv src/host/minilua src/host/minilua_bin

echo -e "#!/bin/sh\n
	/opt/alpine32/lib/ld-musl-i386.so.1 $LUAJITROOT/src/host/buildvm_bin \"\$@\"
" > src/host/buildvm
chmod +x src/host/buildvm

echo -e "#!/bin/sh\n
	/opt/alpine32/lib/ld-musl-i386.so.1 $LUAJITROOT/src/host/minilua_bin \"\$@\"
" > src/host/minilua
chmod +x src/host/minilua

#fool make into thinking buildvm script is the actual file
make -C src CROSS=i686-w64-mingw32- TARGET_SYS=Windows -t host/buildvm
make CROSS=i686-w64-mingw32- TARGET_SYS=Windows BUILDMODE="static"  -j4
mv src/luajit.exe src/luajit
make CROSS=i686-w64-mingw32- TARGET_SYS=Windows BUILDMODE="static" PREFIX=$PREFIX install 

