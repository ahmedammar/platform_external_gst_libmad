# This file is the top android makefile for all sub-modules.

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

mad_TOP := $(LOCAL_PATH)

MAD_BUILT_SOURCES := 		\
	libmad-Android.mk

MAD_BUILT_SOURCES := $(patsubst %, $(abspath $(mad_TOP))/%, $(MAD_BUILT_SOURCES))

ifeq ($(NDK_BUILD),true)
LIB := $(SYSROOT)/usr/lib
else
LIB := $(TARGET_OUT_SHARED_LIBRARIES)
endif

.PHONY: mad-configure mad-configure-real
libmad-configure: $(TARGET_CRTBEGIN_DYNAMIC_O) $(TARGET_CRTEND_O) $(LIB)/libc.so $(LIB)/libz.so
	cd $(mad_TOP) ; \
	touch NEWS AUTHORS ChangeLog ; \
	autoreconf -i && \
	CC="$(CONFIGURE_CC)" \
	CFLAGS="$(CONFIGURE_CFLAGS)" \
	LD=$(TARGET_LD) \
	LDFLAGS="$(CONFIGURE_LDFLAGS)" \
	CPP=$(CONFIGURE_CPP) \
	CPPFLAGS="$(CONFIGURE_CPPFLAGS)" \
	PKG_CONFIG_PATH=$(CONFIGURE_PKG_CONFIG_PATH) \
	PKG_CONFIG_TOP_BUILD_DIR=/ \
	$(abspath $(mad_TOP))/configure --host=arm-linux-androideabi \
	--prefix=/system && \
	for file in $(MAD_BUILT_SOURCES); do \
		rm -f $$file && \
		make -C $$(dirname $$file) $$(basename $$file) ; \
	done

CONFIGURE_TARGETS += libmad-configure

-include $(mad_TOP)/libmad-Android.mk
