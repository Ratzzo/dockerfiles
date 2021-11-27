HOST_ARCH=$(shell cat /etc/apk/arch)
SHARED_DIR=/opt/shared
SCRIPTS_DIR=/opt/scripts
CACHE_DIR=$(SHARED_DIR)/cache
BUILD_DIR=$(SHARED_DIR)/build
NTHREADS:=20
TARGET_BOARD:=orange_pi_zero_lts
TARGET_BOARD_BASE_CONFIG=$(SCRIPTS_DIR)/targets/$(TARGET_BOARD)

KERNEL_FILE=linux-5.4.19.tar.xz                
KERNEL_URL=https://cdn.kernel.org/pub/linux/kernel/v5.x/$(KERNEL_FILE)
KERNEL_FILE_OUTPUT=$(CACHE_DIR)/$(KERNEL_FILE)
KERNEL_DIR=$(BUILD_DIR)/linux-5.4.19
KERNEL_INSTALL_DIR=$(KERNEL_DIR)-install
KERNEL_OUTPUT=$(KERNEL_DIR)/arch/arm/boot/zImage
KERNEL_CONFIG_TARGET=$(KERNEL_DIR)/.config
KERNEL_ARCH=arm
KERNEL_CROSS_COMPILE=arm-linux-gnueabihf-
KERNEL_HOSTCFLAGS=-fcommon
KERNEL_NAME_FILE=$(KERNEL_INSTALL_DIR)/.kernel_name
KERNEL_NAME=$(shell cat $(KERNEL_NAME_FILE))


#this will become .config file
KERNEL_CONFIG:=$(TARGET_BOARD_BASE_CONFIG)/kernel/kernelconfig-linux-5.4.19-rt11
KERNEL_INSTALL_SCRIPT:=$(TARGET_BOARD_BASE_CONFIG)/kernel/kernel_install
UBOOT_CONFIG:=$(TARGET_BOARD_BASE_CONFIG)/uboot/ubootconfig-v2019.04

#this section is for the main alpine image
ALPINE_IMAGE_INITRAMFS_FILE=initramfs-$(KERNEL_NAME)
ALPINE_IMAGE_INITRAMFS_SOURCES_DIR=$(TARGET_BOARD_BASE_CONFIG)/initramfs
ALPINE_IMAGE_INITRAMFS_REPACK_FILE_OUTPUT=$(BUILD_DIR)/$(ALPINE_IMAGE_INITRAMFS_FILE)
ALPINE_IMAGE_SIZE=2G
ALPINE_IMAGE_FILE=alpine_image.img
ALPINE_IMAGE_PARTS_DIR=$(BUILD_DIR)/$(ALPINE_IMAGE_FILE).parts
ALPINE_IMAGE_FILE_OUTPUT=$(BUILD_DIR)/$(ALPINE_IMAGE_FILE)
ALPINE_IMAGE_LODEVICE=$(shell cat $(ALPINE_IMAGE_PARTS_DIR)/lodevice)
ALPINE_IMAGE_MOUNT_POINT=$(BUILD_DIR)/$(ALPINE_IMAGE_FILE).mount

KERNEL_RT_PATCH_FILE=patch-5.4.19-rt11.patch.xz
KERNEL_RT_PATCH_URL=https://cdn.kernel.org/pub/linux/kernel/projects/rt/5.4/older/$(KERNEL_RT_PATCH_FILE)
KERNEL_RT_PATCH_FILE_OUTPUT=$(CACHE_DIR)/$(KERNEL_RT_PATCH_FILE)

UBOOT_FILE=u-boot-v2019.04.tar.gz
UBOOT_URL=https://source.denx.de/u-boot/u-boot/-/archive/v2019.04/$(UBOOT_FILE)
UBOOT_FILE_OUTPUT=$(CACHE_DIR)/$(UBOOT_FILE)
UBOOT_DIR=$(BUILD_DIR)/u-boot-v2019.04
UBOOT_BINARY_OUTPUT=$(UBOOT_DIR)/u-boot-sunxi-with-spl.bin
UBOOT_CROSS_COMPILE=arm-none-eabi-
UBOOT_ARCH=arm
UBOOT_HOSTCFLAGS=-fcommon
UBOOT_CONFIG_TARGET=$(UBOOT_DIR)/.config


#minirootfs is used as a chroot to build the alpine image
#this provides an armv7 environment for bootstrapping the actual rootfs.ext4 image
#that is going to be mounted by the init script as the root directory
ALPINE_MINIROOTFS_NAME=alpine-minirootfs-3.14.3-armv7
ALPINE_MINIROOTFS_FILE=$(ALPINE_MINIROOTFS_NAME).tar.gz
ALPINE_MINIROOTFS_URL=https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/armv7/$(ALPINE_MINIROOTFS_FILE)
ALPINE_MINIROOTFS_FILE_OUTPUT=$(CACHE_DIR)/$(ALPINE_MINIROOTFS_FILE)
ALPINE_MINIROOTFS_DIR=$(BUILD_DIR)/$(ALPINE_MINIROOTFS_NAME)
ALPINE_MINIROOTFS_PACKAGES=e2fsprogs make perl


#roofs will be mounted by the init script on boot as /
ALPINE_ROOTFS_DEFAULT_USER=alpine
ALPINE_ROOTFS_DEFAULT_PASSWORD=alpine
ALPINE_ROOTFS_DEFAULT_ROOT_PASSWORD=alpine
ALPINE_ROOTFS_DEFAULT_HOSTNAME=alpine
ALPINE_ROOTFS_VERSION=v3.14
ALPINE_ROOTFS_FILE=rootfs.ext4
ALPINE_ROOTFS_SIZE=512M
ALPINE_ROOTFS_FILE_OUTPUT=$(BUILD_DIR)/$(ALPINE_ROOTFS_FILE)
ALPINE_ROOTFS_PARTS_DIR=$(BUILD_DIR)/rootfs.ext4.parts
ALPINE_ROOTFS_PACKAGES=\
alpine-base \
chrony \
containerd \
docker \
nano \
screen \
certbot \
openssh \
lsblk \
rsyslog \
rsyslog-omlibdbi \
sqlite \
nginx \
openssl \
openrc \
dhcpcd \
dhcpcd-openrc 

ALPINE_ROOTFS_RC_ADD=\
devfs sysinit           \
dmesg sysinit           \
mdev sysinit            \
docker boot            \
dhcpcd boot            \
hwclock boot            \
modules boot            \
sysctl boot             \
hostname boot           \
bootmisc boot           \
syslog boot             \
mount-ro shutdown       \
killprocs shutdown      \
savecache shutdown      

#extra packages
ALPINE_ROOTFS_USER_PACKAGES:=
ALPINE_ROOTFS_BOOTSTRAP_URL=https://dl-cdn.alpinelinux.org/alpine/$(ALPINE_ROOTFS_VERSION)
ALPINE_ROOTFS_BOOTSTRAP_REPOS=main community


QEMU_BINFMT_TARGET=/proc/sys/fs/binfmt_misc/qemu-arm
QEMU_ARM_STATIC_LOCATION=/usr/bin/qemu-arm-static
QEMU_ARM_STATIC_CHROOT_TARGET=$(ALPINE_MINIROOTFS_DIR)/usr/bin/qemu-arm-static

ALPINE_UBOOT_FILE=alpine-uboot-3.14.3-armv7.tar.gz
ALPINE_UBOOT_URL=https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/armv7/$(ALPINE_UBOOT_FILE)
ALPINE_UBOOT_FILE_OUTPUT=$(CACHE_DIR)/$(ALPINE_UBOOT_FILE)
ALPINE_UBOOT_DIR=$(BUILD_DIR)/alpine-uboot-3.14.3-armv7
ALPINE_UBOOT_INITRAMFS_FILE=$(ALPINE_UBOOT_DIR)/boot/initramfs-lts
ALPINE_UBOOT_INITRAMFS_DIR=$(ALPINE_UBOOT_DIR)-initramfs

ALPINE_APKOVL_FILE=alpine.apkovl.tar.gz
ALPINE_APKOVL_FILE_OUTPUT=$(BUILD_DIR)/$(ALPINE_APKOVL_FILE)

.PHONY: locate kernel_archive kernel_clean kernel_install_clean kernel_rt_patch_archive alpine_minirootfs_archive binfmt_register binfmt_unregister chroot chroot_clean chroot_unpack chroot_bind chroot_unbind qemu_arm_static_nodep qemu_arm_static_nodep_clean 

#locate the current architecture
locate:
	@cat /etc/apk/arch

all:
	

## DOWNLOAD TARGETS ##

#kernel
kernel_archive: $(KERNEL_FILE_OUTPUT)

$(KERNEL_FILE_OUTPUT):
	. common_params; cached_download $@ $(KERNEL_URL)

kernel_rt_patch_archive: $(KERNEL_RT_PATCH_FILE_OUTPUT)

$(KERNEL_RT_PATCH_FILE_OUTPUT): $(KERNEL_FILE_OUTPUT)
	. common_params; cached_download $@ $(KERNEL_RT_PATCH_URL)

#uboot
uboot_archive: $(UBOOT_FILE_OUTPUT)

$(UBOOT_FILE_OUTPUT):
	. common_params; cached_download $@ $(UBOOT_URL)

#alpine minirootfs
alpine_minirootfs_archive: $(ALPINE_MINIROOTFS_FILE_OUTPUT)

$(ALPINE_MINIROOTFS_FILE_OUTPUT):
	. common_params; cached_download $@ $(ALPINE_MINIROOTFS_URL)

#alpine uboot archive (under generic arm on the downloads)
alpine_uboot_archive: $(ALPINE_UBOOT_FILE_OUTPUT)

$(ALPINE_UBOOT_FILE_OUTPUT):
	. common_params; cached_download $@ $(ALPINE_UBOOT_URL)

## END DOWNLOAD TARGETS ##
	

## KERNEL COMPILATION ##

.PHONY: kernel_info

kernel_zImage: $(KERNEL_OUTPUT)

#installs the kernel into a temporary directory
#files are later copied to their respective locations
#inside of the main image
kernel_install: $(KERNEL_INSTALL_DIR)

kernel_install_clean:
	rm -rf $(KERNEL_INSTALL_DIR)

#untar and apply patch
$(KERNEL_DIR): $(KERNEL_FILE_OUTPUT) $(KERNEL_RT_PATCH_FILE_OUTPUT)
	cd $(BUILD_DIR); tar xvf $(KERNEL_FILE_OUTPUT); cd $(KERNEL_DIR); unxz -c $(KERNEL_RT_PATCH_FILE_OUTPUT) | patch -p1

KERNEL_INSTALL_CONFIG=$(KERNEL_INSTALL_DIR)/kernel_config

$(KERNEL_INSTALL_DIR): $(KERNEL_OUTPUT)
	mkdir -p $@
	cd $(KERNEL_DIR); make ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) INSTALL_MOD_PATH=$(KERNEL_INSTALL_DIR) INSTALL_HDR_PATH=$(KERNEL_INSTALL_DIR) INSTALL_PATH=$(KERNEL_INSTALL_DIR) modules_install headers_install dtbs_install
	cp $(KERNEL_CONFIG_TARGET) $(KERNEL_INSTALL_CONFIG)
	cp $(KERNEL_OUTPUT) $(KERNEL_INSTALL_DIR)
	echo $(shell strings $(dir $(KERNEL_OUTPUT))/Image 2> /dev/null |  grep 'Linux version' | cut -d " " -f 3) > $(KERNEL_NAME_FILE)

#copy kernelconfig to .config
$(KERNEL_CONFIG_TARGET): | $(KERNEL_DIR)
	cp $(KERNEL_CONFIG) $(KERNEL_CONFIG_TARGET)

#compile the kernel
$(KERNEL_OUTPUT): $(KERNEL_CONFIG_TARGET)
	cd $(KERNEL_DIR); make -j$(NTHREADS) HOSTCFLAGS=$(KERNEL_HOSTCFLAGS) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE)

kernel_info: $(KERNEL_OUTPUT)
	@strings $(dir $(KERNEL_OUTPUT))/Image |  grep 'Linux version'

kernel_name: $(KERNEL_OUTPUT)
	@echo $(KERNEL_NAME)

kernel_menuconfig:
	cd $(KERNEL_DIR); make -j$(NTHREADS) KCONFIG_CONFIG=$(KERNEL_CONFIG) HOSTCFLAGS=$(KERNEL_HOSTCFLAGS) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) menuconfig


kernel_clean:
	cd $(KERNEL_DIR); make -j$(NTHREADS) HOSTCFLAGS=$(KERNEL_HOSTCFLAGS) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) mrproper
	make kernel_install_clean

## END KERNEL COMPILATION ##

## UBOOT COMPILATION ##

.PHONY: uboot_clean uboot uboot_config_diff

$(UBOOT_DIR): $(UBOOT_FILE_OUTPUT)
	cd $(BUILD_DIR); tar xvf $(UBOOT_FILE_OUTPUT)

$(UBOOT_BINARY_OUTPUT): $(TARGET_BOARD_BASE_CONFIG)/uboot | $(UBOOT_DIR)
	make uboot_clean
	cp $(UBOOT_CONFIG) $(UBOOT_CONFIG_TARGET)
	cd $(UBOOT_DIR); make -j$(NTHREADS) HOSTCFLAGS=$(UBOOT_HOSTCFLAGS) ARCH=$(UBOOT_ARCH) CROSS_COMPILE=$(UBOOT_CROSS_COMPILE)
	touch $@

uboot: $(UBOOT_BINARY_OUTPUT)

uboot_clean:
	cd $(UBOOT_DIR); make -j$(NTHREADS) HOSTCFLAGS=$(UBOOT_HOSTCFLAGS) ARCH=$(UBOOT_ARCH) CROSS_COMPILE=$(UBOOT_CROSS_COMPILE) mrproper

uboot_menuconfig:
	cd $(UBOOT_DIR); make -j$(NTHREADS) KCONFIG_CONFIG=$(UBOOT_CONFIG) HOSTCFLAGS=$(UBOOT_HOSTCFLAGS) ARCH=$(UBOOT_ARCH) CROSS_COMPILE=$(UBOOT_CROSS_COMPILE) menuconfig

uboot_config_diff:
	diff $(UBOOT_CONFIG) $(UBOOT_CONFIG_TARGET)
	

## END UBOOT COMPILATION ##

## BINFMT UTIL ##
binfmt_register: $(QEMU_BINFMT_TARGET)

binfmt_unregister:
	@./qemu_binfmt unregister
	@echo $@

$(QEMU_BINFMT_TARGET):
	@./qemu_binfmt register
	@echo $@
## END BINFMT UTIL ##

## ALPINE MINIROOTFS CHROOT ##

chroot_clean: chroot_unbind binfmt_unregister
	rm -rf $(ALPINE_MINIROOTFS_DIR)

chroot_unpack: $(ALPINE_MINIROOTFS_DIR)

#unpacks minirootfs archive
$(ALPINE_MINIROOTFS_DIR): $(ALPINE_MINIROOTFS_FILE_OUTPUT)
	mkdir -p $@
	cd $(ALPINE_MINIROOTFS_DIR); tar xvf $(ALPINE_MINIROOTFS_FILE_OUTPUT)
	make qemu_arm_static_nodep binfmt_register
	@mkdir -p $(ALPINE_MINIROOTFS_DIR)$(CACHE_DIR)/$(ALPINE_MINIROOTFS_NAME) $(CACHE_DIR)/$(ALPINE_MINIROOTFS_NAME)
	@mkdir -p $(ALPINE_MINIROOTFS_DIR)$(SCRIPTS_DIR)
	@mount -o bind $(SHARED_DIR) $(ALPINE_MINIROOTFS_DIR)$(SHARED_DIR) #bind cache directory
	apk add --root $(ALPINE_MINIROOTFS_DIR) --cache-dir $(CACHE_DIR)/$(ALPINE_MINIROOTFS_NAME) $(ALPINE_MINIROOTFS_PACKAGES) || true
	make qemu_arm_static_nodep_clean
	@umount $(ALPINE_MINIROOTFS_DIR)$(SHARED_DIR)
	

$(QEMU_ARM_STATIC_CHROOT_TARGET): $(QEMU_BINFMT_TARGET) | $(ALPINE_MINIROOTFS_DIR)
	@mount -t proc proc $(ALPINE_MINIROOTFS_DIR)/proc/
	@mount -t sysfs sys $(ALPINE_MINIROOTFS_DIR)/sys/
	@mount -o bind /dev/ $(ALPINE_MINIROOTFS_DIR)/dev/
	@mount -o bind /dev/pts/ $(ALPINE_MINIROOTFS_DIR)/dev/pts/
	@mount -o bind /run $(ALPINE_MINIROOTFS_DIR)/run/
	@mount -o bind $(SHARED_DIR) $(ALPINE_MINIROOTFS_DIR)$(SHARED_DIR)
	@mount -o bind $(SCRIPTS_DIR) $(ALPINE_MINIROOTFS_DIR)$(SCRIPTS_DIR)
	@make qemu_arm_static_nodep
	@cp /etc/resolv.conf $(ALPINE_MINIROOTFS_DIR)/etc/resolv.conf
	@mkdir -p $(ALPINE_MINIROOTFS_DIR)

qemu_arm_static_nodep:
	if [ ! -f $(QEMU_ARM_STATIC_CHROOT_TARGET) ]; then cp $(QEMU_ARM_STATIC_LOCATION) $(QEMU_ARM_STATIC_CHROOT_TARGET); fi;

qemu_arm_static_nodep_clean:
	@rm $(QEMU_ARM_STATIC_CHROOT_TARGET) || true

#prepares minirootfs for chrooting
chroot_bind: $(QEMU_ARM_STATIC_CHROOT_TARGET)

#unbinds all the stuff in minirootfs
chroot_unbind: 
	@umount $(ALPINE_MINIROOTFS_DIR)/proc/		2> /dev/null || true
	@umount $(ALPINE_MINIROOTFS_DIR)/sys/		2> /dev/null || true
	@umount $(ALPINE_MINIROOTFS_DIR)/dev/pts/	2> /dev/null || true
	@umount $(ALPINE_MINIROOTFS_DIR)/dev/		2> /dev/null || true
	@umount $(ALPINE_MINIROOTFS_DIR)/run/		2> /dev/null || true
	@umount $(ALPINE_MINIROOTFS_DIR)$(SHARED_DIR)	2> /dev/null || true
	@umount $(ALPINE_MINIROOTFS_DIR)$(SCRIPTS_DIR)	2> /dev/null || true
	@rm $(QEMU_ARM_STATIC_CHROOT_TARGET)		2> /dev/null || true
	@rm $(ALPINE_MINIROOTFS_DIR)/etc/resolv.conf	2> /dev/null || true
	@echo	$@


chroot: $(QEMU_ARM_STATIC_CHROOT_TARGET) $(KERNEL_INSTALL_DIR)
	@chroot $(ALPINE_MINIROOTFS_DIR) sh -c "cat /opt/scripts/minirootfs_chroot_motd; cd /opt/scripts/; sh; make alpine_rootfs_umount" || true
	@make chroot_unbind binfmt_unregister

chroot_make: $(QEMU_ARM_STATIC_CHROOT_TARGET) $(KERNEL_INSTALL_DIR)
	if [ ! $(MAKE_ARGS) ]; then exit 1; fi;
	@chroot $(ALPINE_MINIROOTFS_DIR) sh -c "cat /opt/scripts/minirootfs_chroot_motd; cd /opt/scripts/; make $(MAKE_ARGS); make alpine_rootfs_umount" || true
	@make chroot_unbind binfmt_unregister	

## END ALPINE MINIROOTFS CHROOT ##

## ROOTFS (this happens inside the armv7 chroot) ##

ALPINE_ROOTFS_CHROOT_MOUNT=/mnt/$(ALPINE_ROOTFS_FILE)
ALPINE_ROOTFS_CACHE_DIR=$(CACHE_DIR)/$(ALPINE_ROOTFS_FILE).$(ALPINE_ROOTFS_VERSION)

ifeq ($(HOST_ARCH),armv7)

.PHONY: alpine_rootfs_mount alpine_rootfs_umount alpine_rootfs_clean alpine_rootfs_bootstrap

$(ALPINE_ROOTFS_PARTS_DIR):
	mkdir -p $@

$(ALPINE_ROOTFS_PARTS_DIR)/allocate: | $(ALPINE_ROOTFS_PARTS_DIR)
	fallocate -l $(ALPINE_ROOTFS_SIZE) $(ALPINE_ROOTFS_FILE_OUTPUT)
	touch $@ 

$(ALPINE_ROOTFS_PARTS_DIR)/mount: $(ALPINE_ROOTFS_PARTS_DIR)/allocate Makefile
	make alpine_rootfs_umount
	yes | mkfs.ext4 $(ALPINE_ROOTFS_FILE_OUTPUT)
	mkdir -p $(ALPINE_ROOTFS_CHROOT_MOUNT)
	mount $(ALPINE_ROOTFS_FILE_OUTPUT) $(ALPINE_ROOTFS_CHROOT_MOUNT)
	touch $@

$(ALPINE_ROOTFS_PARTS_DIR)/bootstrap: $(ALPINE_ROOTFS_PARTS_DIR)/mount
	@sh -c "if [ ! -d $(KERNEL_INSTALL_DIR) ]; then \
	echo make kernel_install outside the chroot is required for this step.; \
	exit 100; \
	fi"
	@make $(ALPINE_ROOTFS_PARTS_DIR)/mount
	@mkdir -p $(ALPINE_ROOTFS_CHROOT_MOUNT)$(CACHE_DIR) $(ALPINE_ROOTFS_CHROOT_MOUNT)$(SCRIPTS_DIR) 
	@mount -o bind $(CACHE_DIR) $(ALPINE_ROOTFS_CHROOT_MOUNT)$(CACHE_DIR)
	@mount -o bind $(SCRIPTS_DIR) $(ALPINE_ROOTFS_CHROOT_MOUNT)$(SCRIPTS_DIR)
	@mkdir -p $(ALPINE_ROOTFS_CHROOT_MOUNT)$(ALPINE_ROOTFS_CACHE_DIR)
	@mkdir -p $(ALPINE_ROOTFS_CHROOT_MOUNT)/etc && \
	cp /etc/resolv.conf $(ALPINE_ROOTFS_CHROOT_MOUNT)/etc/resolv.conf
	@mkdir -p $(dir $(ALPINE_ROOTFS_CHROOT_MOUNT)$(QEMU_ARM_STATIC_LOCATION)) && cp $(QEMU_ARM_STATIC_LOCATION) $(ALPINE_ROOTFS_CHROOT_MOUNT)$(QEMU_ARM_STATIC_LOCATION)
	sh -c "apk --arch armv7 -X $(ALPINE_ROOTFS_BOOTSTRAP_URL)/main -X $(ALPINE_ROOTFS_BOOTSTRAP_URL)/community -U --allow-untrusted --root $(ALPINE_ROOTFS_CHROOT_MOUNT) --cache-dir $(ALPINE_ROOTFS_CACHE_DIR) --initdb add $(ALPINE_ROOTFS_PACKAGES) $(ALPINE_ROOTFS_USER_PACKAGES) && touch $@"
	@chroot $(ALPINE_ROOTFS_CHROOT_MOUNT) sh -c "cd /opt/scripts/; . makefile_helpers; rc_add_multi $(ALPINE_ROOTFS_RC_ADD)" || true
	@chroot $(ALPINE_ROOTFS_CHROOT_MOUNT) sh -c "cd /opt/scripts/; \
	. makefile_helpers; \
	ALPINE_ROOTFS_DEFAULT_HOSTNAME=$(ALPINE_ROOTFS_DEFAULT_HOSTNAME) \
	ALPINE_ROOTFS_DEFAULT_USER=$(ALPINE_ROOTFS_DEFAULT_USER) \
	ALPINE_ROOTFS_DEFAULT_PASSWORD=$(ALPINE_ROOTFS_DEFAULT_PASSWORD) \
	ALPINE_ROOTFS_DEFAULT_ROOT_PASSWORD=$(ALPINE_ROOTFS_DEFAULT_ROOT_PASSWORD) \
	set_default_config" || true
	. makefile_helpers; \
	ALPINE_ROOTFS_CHROOT_MOUNT=$(ALPINE_ROOTFS_CHROOT_MOUNT) \
	ALPINE_ROOTFS_BOOTSTRAP_URL=$(ALPINE_ROOTFS_BOOTSTRAP_URL) \
	bootstrap_repos $(ALPINE_ROOTFS_BOOTSTRAP_REPOS) || true
	@cp -r $(KERNEL_INSTALL_DIR)/lib $(ALPINE_ROOTFS_CHROOT_MOUNT) || true #ideally this should be on the main image, not the rootfs.ext4
	@cp -r $(KERNEL_INSTALL_DIR)/include $(ALPINE_ROOTFS_CHROOT_MOUNT)/usr || true #ideally this should be on the main image, not the rootfs.ext4
	@umount $(ALPINE_ROOTFS_CHROOT_MOUNT)$(CACHE_DIR)
	@umount $(ALPINE_ROOTFS_CHROOT_MOUNT)$(SCRIPTS_DIR)
	@rm $(ALPINE_ROOTFS_CHROOT_MOUNT)$(QEMU_ARM_STATIC_LOCATION)
	@rm -rf $(ALPINE_ROOTFS_CHROOT_MOUNT)$(SHARED_DIR) $(ALPINE_ROOTFS_CHROOT_MOUNT)$(SCRIPTS_DIR)

alpine_rootfs_clean:	
	make alpine_rootfs_umount
	rm -f $(ALPINE_ROOTFS_PARTS_DIR)/*
	rm -f $(ALPINE_ROOTFS_FILE_OUTPUT)

alpine_rootfs_bootstrap: $(ALPINE_ROOTFS_PARTS_DIR)/bootstrap

alpine_rootfs_mount: $(ALPINE_ROOTFS_PARTS_DIR)/mount

alpine_rootfs_umount:
	@umount $(ALPINE_ROOTFS_CHROOT_MOUNT)$(SCRIPTS_DIR) 	2> /dev/null || true
	@umount $(ALPINE_ROOTFS_CHROOT_MOUNT)$(CACHE_DIR) 	2> /dev/null || true
	@umount $(ALPINE_ROOTFS_CHROOT_MOUNT) 			2> /dev/null || true
	@umount $(ALPINE_ROOTFS_FILE_OUTPUT) 			2> /dev/null || true
	@rm $(ALPINE_ROOTFS_PARTS_DIR)/mount 			2> /dev/null || true

$(ALPINE_ROOTFS_FILE_OUTPUT): $(ALPINE_ROOTFS_PARTS_DIR)/bootstrap

else ifeq ($(HOST_ARCH),x86_64)

.PHONY: alpine_rootfs_clean alpine_rootfs_bootstrap

alpine_rootfs_clean:
	make chroot_make MAKE_ARGS=$@

$(ALPINE_ROOTFS_PARTS_DIR)/bootstrap: Makefile
	make chroot_make MAKE_ARGS=$@

alpine_rootfs_bootstrap: $(ALPINE_ROOTFS_PARTS_DIR)/bootstrap

endif
## END ROOTFS ##
## INITRAMFS ##
#this used the alpine uboot archive "alpine-uboot-x.xx.x-armv7.tar.gz" as the source for the initramfs

.PHONY: alpine_uboot_unpack alpine_uboot_initramfs_unpack alpine_uboot_clean alpine_uboot_initramfs_clean alpine_uboot_initramfs_list alpine_uboot_initramfs_repack alpine_uboot_initramfs_repack_clean

$(ALPINE_UBOOT_DIR):
	mkdir -p $@
	cd $@; tar xvf $(ALPINE_UBOOT_FILE_OUTPUT)

$(ALPINE_UBOOT_INITRAMFS_DIR): $(ALPINE_IMAGE_INITRAMFS_SOURCES_DIR) $(KERNEL_OUTPUT) | $(ALPINE_UBOOT_DIR)
	@rm -rf $(ALPINE_UBOOT_INITRAMFS_DIR)
	@mkdir -p $@
	@cd $(ALPINE_UBOOT_INITRAMFS_DIR); \
	gzip -d < $(ALPINE_UBOOT_INITRAMFS_FILE) | cpio -idm
	@cd $(ALPINE_IMAGE_INITRAMFS_SOURCES_DIR); \
	SRC=$(ALPINE_IMAGE_INITRAMFS_SOURCES_DIR) \
	DEST=$(ALPINE_UBOOT_INITRAMFS_DIR) \
	KERNEL_INSTALL_DIR=$(KERNEL_INSTALL_DIR) \
	KERNEL_NAME=$(KERNEL_NAME) \
	./initramfs_install

$(ALPINE_IMAGE_INITRAMFS_REPACK_FILE_OUTPUT): $(ALPINE_UBOOT_INITRAMFS_DIR)
	@make alpine_uboot_initramfs_repack_clean
	@cd $(ALPINE_UBOOT_INITRAMFS_DIR); find . | cpio -H newc -o -R root:root | gzip -9 > $(ALPINE_IMAGE_INITRAMFS_REPACK_FILE_OUTPUT)

alpine_uboot_initramfs_list:
	find $(ALPINE_UBOOT_INITRAMFS_DIR)

alpine_uboot_unpack: $(ALPINE_UBOOT_DIR)

alpine_uboot_initramfs_unpack: $(ALPINE_UBOOT_INITRAMFS_DIR)

alpine_uboot_initramfs_repack: $(ALPINE_IMAGE_INITRAMFS_REPACK_FILE_OUTPUT)

alpine_uboot_initramfs_repack_clean:
	rm -f $(ALPINE_IMAGE_INITRAMFS_REPACK_FILE_OUTPUT)

alpine_uboot_clean:
	rm -r $(ALPINE_UBOOT_DIR)
	make alpine_uboot_initramfs_clean
	
alpine_uboot_initramfs_clean:
	rm -r $(ALPINE_UBOOT_INITRAMFS_DIR)


## END INITRAMFS ##

## MAIN IMAGE ##

.PHONY: image image_lodevice image_lodevice_clean image_mount image_mount_clean image_uboot_install image_uboot_clean image_boot



image: $(ALPINE_IMAGE_PARTS_DIR)/uboot

image_lodevice: $(ALPINE_IMAGE_PARTS_DIR)/lodevice

#clean lodevice (also unmounts)
image_lodevice_clean:
	@make image_mount_clean
	@. makefile_helpers; if [ -f $(ALPINE_IMAGE_PARTS_DIR)/lodevice ]; then docker_losetup_cleanup_override $$(cat $(ALPINE_IMAGE_PARTS_DIR)/lodevice) && rm $(ALPINE_IMAGE_PARTS_DIR)/lodevice && echo Detached.; else echo Already detached.; fi || true

image_mount: $(ALPINE_IMAGE_PARTS_DIR)/mount

#unmount
image_mount_clean:
	@if [ -d $(ALPINE_IMAGE_MOUNT_POINT) ]; then \
		umount $(ALPINE_IMAGE_MOUNT_POINT); \
	fi || true
	rm -rf $(ALPINE_IMAGE_MOUNT_POINT)
	rm -f $(ALPINE_IMAGE_PARTS_DIR)/mount

image_clean:
	make image_lodevice_clean
	rm -rf $(ALPINE_IMAGE_PARTS_DIR)
	rm -f $(ALPINE_IMAGE_FILE_OUTPUT)

image_uboot_install: $(ALPINE_IMAGE_PARTS_DIR)/uboot

#zero fill uboot address and size
#not invoked on image clean, and only here for testing
image_uboot_clean:


image_kernel_install: $(ALPINE_IMAGE_PARTS_DIR)/image_kernel_install

image_kernel_install_clean:
	rm $(ALPINE_IMAGE_PARTS_DIR)/image_kernel_install

$(ALPINE_IMAGE_PARTS_DIR):
	mkdir -p $@

#this dependency maskes sure the image is mounted
$(ALPINE_IMAGE_MOUNT_POINT): $(ALPINE_IMAGE_PARTS_DIR)/image_base
	make $(ALPINE_IMAGE_PARTS_DIR)/lodevice
	mkdir -p $@
	mount $$(cat $(ALPINE_IMAGE_PARTS_DIR)/lodevice)p1 $(ALPINE_IMAGE_MOUNT_POINT)

$(ALPINE_IMAGE_PARTS_DIR)/mount: | 
	@#only depend on existence
	if [ ! -d $(ALPINE_IMAGE_MOUNT_POINT) ]; then \
		make $(ALPINE_IMAGE_MOUNT_POINT) && touch $@; \
	fi

$(ALPINE_IMAGE_PARTS_DIR)/lodevice: 
	@. makefile_helpers; \
	device=$$(docker_losetup_setup_override $(ALPINE_IMAGE_FILE_OUTPUT)) 2> /dev/null; \
	if [ "$$device" ]; then \
		echo $$device; \
		echo $$device > $(ALPINE_IMAGE_PARTS_DIR)/lodevice; \
	else \
		echo Unable to setup loop device.; \
		exit 1; \
	fi

$(ALPINE_IMAGE_PARTS_DIR)/image_base: $(ALPINE_ROOTFS_PARTS_DIR)/bootstrap | $(ALPINE_IMAGE_PARTS_DIR)
	@make image_lodevice_clean
	@echo "Allocating $(ALPINE_IMAGE_FILE_OUTPUT)..."
	@fallocate $(ALPINE_IMAGE_FILE_OUTPUT) -l $(ALPINE_IMAGE_SIZE)
	@dd if=/dev/zero of=$(ALPINE_IMAGE_FILE_OUTPUT) bs=1M count=8 conv=notrunc
	@echo "Partitioning $(ALPINE_IMAGE_FILE_OUTPUT)..."
	@echo -en "o\n n\n \n \n \n \n p \n w" | fdisk $(ALPINE_IMAGE_FILE_OUTPUT) > /dev/null
	@make $(ALPINE_IMAGE_PARTS_DIR)/lodevice > /dev/null
	@echo "Formatting $(ALPINE_IMAGE_FILE_OUTPUT)..."
	@yes | mkfs.ext4 $$(cat $(ALPINE_IMAGE_PARTS_DIR)/lodevice)p1 > /dev/null
	@touch $(ALPINE_IMAGE_PARTS_DIR)/image_base
	
$(ALPINE_IMAGE_PARTS_DIR)/image_kernel_install: $(ALPINE_IMAGE_INITRAMFS_REPACK_FILE_OUTPUT) $(KERNEL_INSTALL_DIR) $(TARGET_BOARD_BASE_CONFIG)/kernel $(TARGET_BOARD_BASE_CONFIG)/extlinux $(ALPINE_IMAGE_PARTS_DIR)/image_base $(ALPINE_APKOVL_FILE_OUTPUT)
	#mount if not mounted
	make $(ALPINE_IMAGE_PARTS_DIR)/mount
	KERNEL_INSTALL_DIR=$(KERNEL_INSTALL_DIR) \
	ALPINE_IMAGE_MOUNT_POINT=$(ALPINE_IMAGE_MOUNT_POINT) \
	ALPINE_IMAGE_INITRAMFS_REPACK_FILE_OUTPUT=$(ALPINE_IMAGE_INITRAMFS_REPACK_FILE_OUTPUT) \
	KERNEL_NAME=$(KERNEL_NAME) \
	TARGET_BOARD_BASE_CONFIG=$(TARGET_BOARD_BASE_CONFIG) \
	ALPINE_ROOTFS_FILE_OUTPUT=$(ALPINE_ROOTFS_FILE_OUTPUT) \
	ALPINE_APKOVL_FILE_OUTPUT=$(ALPINE_APKOVL_FILE_OUTPUT) \
	ALPINE_ROOTFS_CACHE_DIR=$(ALPINE_ROOTFS_CACHE_DIR) \
	$(KERNEL_INSTALL_SCRIPT)
	touch $@

#aka image_uboot_install
$(ALPINE_IMAGE_PARTS_DIR)/uboot: $(ALPINE_IMAGE_PARTS_DIR)/image_kernel_install $(UBOOT_BINARY_OUTPUT)
	make image_lodevice_clean
	if [ -f $(ALPINE_IMAGE_FILE_OUTPUT) ]; then \
		echo dd if=$(UBOOT_BINARY_OUTPUT) of=$(ALPINE_IMAGE_FILE_OUTPUT) bs=1024 seek=8 conv=notrunc; \
		dd if=$(UBOOT_BINARY_OUTPUT) of=$(ALPINE_IMAGE_FILE_OUTPUT) bs=1024 seek=8 conv=notrunc; \
	fi
	touch $@

image_boot: $(ALPINE_IMAGE_PARTS_DIR)/uboot
	ALPINE_IMAGE_FILE_OUTPUT=$(ALPINE_IMAGE_FILE_OUTPUT) \
	$(TARGET_BOARD_BASE_CONFIG)/qemu_boot

## END MAIN IMAGE ##


## APKOVL ##
#apkovl contains whatever the user selects. However is primarily used
#for config

APKOVL_DIR=$(TARGET_BOARD_BASE_CONFIG)/apkovl

$(ALPINE_APKOVL_FILE_OUTPUT): $(APKOVL_DIR)
	cd $(APKOVL_DIR); tar cvfz $(ALPINE_APKOVL_FILE_OUTPUT) *

apkovl: $(ALPINE_APKOVL_FILE_OUTPUT)

apkovl_clean:
	rm -f $(ALPINE_APKOVL_FILE_OUTPUT)


## END APKOVL ##

.PHONY: what_is

what_is:
	@echo $($(VAR))
