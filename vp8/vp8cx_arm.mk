##
##  Copyright (c) 2010 The WebM project authors. All Rights Reserved.
##
##  Use of this source code is governed by a BSD-style license
##  that can be found in the LICENSE file in the root of the source
##  tree. An additional intellectual property rights grant can be found
##  in the file PATENTS.  All contributing project authors may
##  be found in the AUTHORS file in the root of the source tree.
##


#VP8_CX_SRCS list is modified according to different platforms.

#File list for arm
# encoder
VP8_CX_SRCS-$(HAVE_ARMV6)  += encoder/arm/csystemdependent.c

VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/encodemb_arm.c
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/quantize_arm.c
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/picklpf_arm.c
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/boolhuff_arm.c
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/mcomp_arm.c

VP8_CX_SRCS_REMOVE-$(HAVE_ARMV6)  += encoder/generic/csystemdependent.c
VP8_CX_SRCS_REMOVE-$(HAVE_ARMV7)  += encoder/boolhuff.c
VP8_CX_SRCS_REMOVE-$(HAVE_ARMV7)  += encoder/mcomp.c

#File list for armv6
# encoder
VP8_CX_SRCS-$(HAVE_ARMV6)  += encoder/arm/armv6/walsh_v6$(ASM)

#File list for neon
# encoder
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/fastfdct4x4_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/fastfdct8x4_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/fastquantizeb_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/sad8_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/sad16_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/shortfdct_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/subtract_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/variance_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/vp8_mse16x16_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/vp8_subpixelvariance8x8_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/vp8_subpixelvariance16x16_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/vp8_subpixelvariance16x16s_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/vp8_memcpy_neon$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/vp8_packtokens_armv7$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/vp8_packtokens_mbrow_armv7$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/vp8_packtokens_partitions_armv7$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/boolhuff_armv7$(ASM)
VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/neon/vp8_shortwalsh4x4_neon$(ASM)

VP8_CX_SRCS-$(HAVE_ARMV7)  += encoder/arm/vpx_vp8_enc_asm_offsets.c

#
# Rule to extract assembly constants from C sources
#
ifeq ($(ARCH_ARM),yes)
vpx_vp8_enc_asm_offsets.asm: obj_int_extract
vpx_vp8_enc_asm_offsets.asm: $(VP8_PREFIX)encoder/arm/vpx_vp8_enc_asm_offsets.c.o
	./obj_int_extract rvds $< $(ADS2GAS) > $@
OBJS-yes += $(VP8_PREFIX)encoder/arm/vpx_vp7_enc_asm_offsets.c.o
CLEAN-OBJS += vpx_vp8_enc_asm_offsets.asm
$(filter %$(ASM).o,$(OBJS-yes)): vpx_vp8_enc_asm_offsets.asm
endif
