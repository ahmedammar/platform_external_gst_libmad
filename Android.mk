# This file is the top android makefile for all sub-modules.

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

mad_TOP := $(LOCAL_PATH)

MAD_BUILT_SOURCES := 		\
	libmad-Android.mk

MAD_BUILT_SOURCES := $(patsubst %, $(mad_TOP)/%, $(MAD_BUILT_SOURCES))

.PHONY: mad-configure mad-configure-real
mad-configure-real:
	cd $(mad_TOP) ; \
	touch NEWS AUTHORS ChangeLog ; \
	autoreconf -i && \
	CC="$(CONFIGURE_CC)" \
	CFLAGS="$(CONFIGURE_CFLAGS)" \
	LD=$(TARGET_LD) \
	LDFLAGS="$(CONFIGURE_LDFLAGS)" \
	CPP=$(CONFIGURE_CPP) \
	CPPFLAGS="$(CONFIGURE_CPPFLAGS)" \
	PKG_CONFIG_LIBDIR=$(CONFIGURE_PKG_CONFIG_LIBDIR) \
	PKG_CONFIG_TOP_BUILD_DIR=/ \
	$(mad_TOP)/configure --host=arm-linux-androideabi \
	--prefix=/system ; \
	for file in $(MAD_BUILT_SOURCES); do \
		make -C $$(dirname $$file) $$(basename $$file) ; \
	done

mad-configure: mad-configure-real

CONFIGURE_TARGETS += mad-configure

-include $(mad_TOP)/libmad-Android.mk
