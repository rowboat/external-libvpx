;
;  Copyright (c) 2010 The WebM project authors. All Rights Reserved.
;
;  Use of this source code is governed by a BSD-style license
;  that can be found in the LICENSE file in the root of the source
;  tree. An additional intellectual property rights grant can be found
;  in the file PATENTS.  All contributing project authors may
;  be found in the AUTHORS file in the root of the source tree.
;


%include "vpx_ports/x86_abi_support.asm"

;int vp8_block_error_xmm(short *coeff_ptr,  short *dcoef_ptr)
global sym(vp8_block_error_xmm)
sym(vp8_block_error_xmm):
    push        rbp
    mov         rbp, rsp
    SHADOW_ARGS_TO_STACK 2
    push rsi
    push rdi
    ; end prologue

        mov         rsi,        arg(0) ;coeff_ptr

        mov         rdi,        arg(1) ;dcoef_ptr
        movdqa      xmm3,       [rsi]

        movdqa      xmm4,       [rdi]
        movdqa      xmm5,       [rsi+16]

        movdqa      xmm6,       [rdi+16]
        psubw       xmm3,       xmm4

        psubw       xmm5,       xmm6
        pmaddwd     xmm3,       xmm3
        pmaddwd     xmm5,       xmm5

        paddd       xmm3,       xmm5

        pxor        xmm7,       xmm7
        movdqa      xmm0,       xmm3

        punpckldq   xmm0,       xmm7
        punpckhdq   xmm3,       xmm7

        paddd       xmm0,       xmm3
        movdqa      xmm3,       xmm0

        psrldq      xmm0,       8
        paddd       xmm0,       xmm3

        movd        rax,        xmm0

    pop rdi
    pop rsi
    ; begin epilog
    UNSHADOW_ARGS
    pop         rbp
    ret

;int vp8_block_error_mmx(short *coeff_ptr,  short *dcoef_ptr)
global sym(vp8_block_error_mmx)
sym(vp8_block_error_mmx):
    push        rbp
    mov         rbp, rsp
    SHADOW_ARGS_TO_STACK 2
    push rsi
    push rdi
    ; end prolog


        mov         rsi,        arg(0) ;coeff_ptr
        pxor        mm7,        mm7

        mov         rdi,        arg(1) ;dcoef_ptr
        movq        mm3,        [rsi]

        movq        mm4,        [rdi]
        movq        mm5,        [rsi+8]

        movq        mm6,        [rdi+8]
        pxor        mm1,        mm1 ; from movd mm1, dc ; dc =0

        movq        mm2,        mm7
        psubw       mm5,        mm6

        por         mm1,        mm2
        pmaddwd     mm5,        mm5

        pcmpeqw     mm1,        mm7
        psubw       mm3,        mm4

        pand        mm1,        mm3
        pmaddwd     mm1,        mm1

        paddd       mm1,        mm5
        movq        mm3,        [rsi+16]

        movq        mm4,        [rdi+16]
        movq        mm5,        [rsi+24]

        movq        mm6,        [rdi+24]
        psubw       mm5,        mm6

        pmaddwd     mm5,        mm5
        psubw       mm3,        mm4

        pmaddwd     mm3,        mm3
        paddd       mm3,        mm5

        paddd       mm1,        mm3
        movq        mm0,        mm1

        psrlq       mm1,        32
        paddd       mm0,        mm1

        movd        rax,        mm0

    pop rdi
    pop rsi
    ; begin epilog
    UNSHADOW_ARGS
    pop         rbp
    ret


;int vp8_mbblock_error_mmx_impl(short *coeff_ptr, short *dcoef_ptr, int dc);
global sym(vp8_mbblock_error_mmx_impl)
sym(vp8_mbblock_error_mmx_impl):
    push        rbp
    mov         rbp, rsp
    SHADOW_ARGS_TO_STACK 3
    push rsi
    push rdi
    ; end prolog


        mov         rsi,        arg(0) ;coeff_ptr
        pxor        mm7,        mm7

        mov         rdi,        arg(1) ;dcoef_ptr
        pxor        mm2,        mm2

        movd        mm1,        dword ptr arg(2) ;dc
        por         mm1,        mm2

        pcmpeqw     mm1,        mm7
        mov         rcx,        16

mberror_loop_mmx:
        movq        mm3,       [rsi]
        movq        mm4,       [rdi]

        movq        mm5,       [rsi+8]
        movq        mm6,       [rdi+8]


        psubw       mm5,        mm6
        pmaddwd     mm5,        mm5

        psubw       mm3,        mm4
        pand        mm3,        mm1

        pmaddwd     mm3,        mm3
        paddd       mm2,        mm5

        paddd       mm2,        mm3
        movq        mm3,       [rsi+16]

        movq        mm4,       [rdi+16]
        movq        mm5,       [rsi+24]

        movq        mm6,       [rdi+24]
        psubw       mm5,        mm6

        pmaddwd     mm5,        mm5
        psubw       mm3,        mm4

        pmaddwd     mm3,        mm3
        paddd       mm2,        mm5

        paddd       mm2,        mm3
        add         rsi,        32

        add         rdi,        32
        sub         rcx,        1

        jnz         mberror_loop_mmx

        movq        mm0,        mm2
        psrlq       mm2,        32

        paddd       mm0,        mm2
        movd        rax,        mm0

    pop rdi
    pop rsi
    ; begin epilog
    UNSHADOW_ARGS
    pop         rbp
    ret


;int vp8_mbblock_error_xmm_impl(short *coeff_ptr, short *dcoef_ptr, int dc);
global sym(vp8_mbblock_error_xmm_impl)
sym(vp8_mbblock_error_xmm_impl):
    push        rbp
    mov         rbp, rsp
    SHADOW_ARGS_TO_STACK 3
    push rsi
    push rdi
    ; end prolog


        mov         rsi,        arg(0) ;coeff_ptr
        pxor        xmm7,       xmm7

        mov         rdi,        arg(1) ;dcoef_ptr
        pxor        xmm2,       xmm2

        movd        xmm1,       dword ptr arg(2) ;dc
        por         xmm1,       xmm2

        pcmpeqw     xmm1,       xmm7
        mov         rcx,        16

mberror_loop:
        movdqa      xmm3,       [rsi]
        movdqa      xmm4,       [rdi]

        movdqa      xmm5,       [rsi+16]
        movdqa      xmm6,       [rdi+16]


        psubw       xmm5,       xmm6
        pmaddwd     xmm5,       xmm5

        psubw       xmm3,       xmm4
        pand        xmm3,       xmm1

        pmaddwd     xmm3,       xmm3
        add         rsi,        32

        add         rdi,        32

        sub         rcx,        1
        paddd       xmm2,       xmm5

        paddd       xmm2,       xmm3
        jnz         mberror_loop

        movdqa      xmm0,       xmm2
        punpckldq   xmm0,       xmm7

        punpckhdq   xmm2,       xmm7
        paddd       xmm0,       xmm2

        movdqa      xmm1,       xmm0
        psrldq      xmm0,       8

        paddd       xmm0,       xmm1
        movd        rax,        xmm0

    pop rdi
    pop rsi
    ; begin epilog
    UNSHADOW_ARGS
    pop         rbp
    ret


;int vp8_mbuverror_mmx_impl(short *s_ptr, short *d_ptr);
global sym(vp8_mbuverror_mmx_impl)
sym(vp8_mbuverror_mmx_impl):
    push        rbp
    mov         rbp, rsp
    SHADOW_ARGS_TO_STACK 2
    push rsi
    push rdi
    ; end prolog


        mov             rsi,        arg(0) ;s_ptr
        mov             rdi,        arg(1) ;d_ptr

        mov             rcx,        16
        pxor            mm7,        mm7

mbuverror_loop_mmx:

        movq            mm1,        [rsi]
        movq            mm2,        [rdi]

        psubw           mm1,        mm2
        pmaddwd         mm1,        mm1


        movq            mm3,        [rsi+8]
        movq            mm4,        [rdi+8]

        psubw           mm3,        mm4
        pmaddwd         mm3,        mm3


        paddd           mm7,        mm1
        paddd           mm7,        mm3


        add             rsi,        16
        add             rdi,        16

        dec             rcx
        jnz             mbuverror_loop_mmx

        movq            mm0,        mm7
        psrlq           mm7,        32

        paddd           mm0,        mm7
        movd            rax,        mm0

    pop rdi
    pop rsi
    ; begin epilog
    UNSHADOW_ARGS
    pop         rbp
    ret


;int vp8_mbuverror_xmm_impl(short *s_ptr, short *d_ptr);
global sym(vp8_mbuverror_xmm_impl)
sym(vp8_mbuverror_xmm_impl):
    push        rbp
    mov         rbp, rsp
    SHADOW_ARGS_TO_STACK 2
    push rsi
    push rdi
    ; end prolog


        mov             rsi,        arg(0) ;s_ptr
        mov             rdi,        arg(1) ;d_ptr

        mov             rcx,        16
        pxor            xmm7,       xmm7

mbuverror_loop:

        movdqa          xmm1,       [rsi]
        movdqa          xmm2,       [rdi]

        psubw           xmm1,       xmm2
        pmaddwd         xmm1,       xmm1

        paddd           xmm7,       xmm1

        add             rsi,        16
        add             rdi,        16

        dec             rcx
        jnz             mbuverror_loop

        pxor        xmm0,           xmm0
        movdqa      xmm1,           xmm7

        movdqa      xmm2,           xmm1
        punpckldq   xmm1,           xmm0

        punpckhdq   xmm2,           xmm0
        paddd       xmm1,           xmm2

        movdqa      xmm2,           xmm1

        psrldq      xmm1,           8
        paddd       xmm1,           xmm2

        movd            rax,            xmm1

    pop rdi
    pop rsi
    ; begin epilog
    UNSHADOW_ARGS
    pop         rbp
    ret
