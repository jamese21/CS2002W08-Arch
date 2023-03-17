// Student ID: <please insert your student id here for marker's convenience>
// 
// Please comment assembly code 
// For Part 3 you are NOT required to comment function "badrandom"
// For Part 3 you ARE required to comment function "badrandom_recurse"
//
// Comments start with // 
// You are not required to comment assembler directives 
// For full details of requirements please see practical spec.


	.text
	.file	"badrandom.c"
	.globl	badrandom
	.p2align	2
	.type	badrandom,@function
badrandom:
	.cfi_startproc
	stp	x29, x30, [sp, #-32]!
	stp	x20, x19, [sp, #16]
	mov	x29, sp
	.cfi_def_cfa w29, 32
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w30, -24
	.cfi_offset w29, -32
	adrp	x8, mult
	adrp	x9, add
	mov	x19, x5
	adrp	x20, array_length
	adrp	x10, array
	cmp	w0, #1
	str	w1, [x8, :lo12:mult]
	adrp	x8, div
	str	w2, [x9, :lo12:add]
	adrp	x9, min
	str	wzr, [x20, :lo12:array_length]
	str	w3, [x8, :lo12:div]
	str	w4, [x9, :lo12:min]
	str	x6, [x10, :lo12:array]
	b.lt	.LBB0_2
	bl	badrandom_recurse
	b	.LBB0_3
.LBB0_2:
	mov	w0, wzr
.LBB0_3:
	ldr	w8, [x20, :lo12:array_length]
	and	w0, w0, #0x1
	str	w8, [x19]
	ldp	x20, x19, [sp, #16]
	ldp	x29, x30, [sp], #32
	ret
.Lfunc_end0:
	.size	badrandom, .Lfunc_end0-badrandom
	.cfi_endproc

	.p2align	2
	.type	badrandom_recurse,@function
badrandom_recurse:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x8, array_length
	ldrsw	x9, [x8, :lo12:array_length]
	cmp	w9, #199
	b.le	.LBB1_2
	mov	w0, wzr
	b	.LBB1_5
.LBB1_2:
	adrp	x10, array
	adrp	x11, min
	ldr	x10, [x10, :lo12:array]
	str	w0, [x10, x9, lsl #2]
	add	w9, w9, #1
	ldr	w10, [x11, :lo12:min]
	str	w9, [x8, :lo12:array_length]
	cmp	w10, w0
	b.le	.LBB1_4
	mov	w0, #1
	b	.LBB1_5
.LBB1_4:
	sdiv	w8, w0, w10
	adrp	x9, add
	adrp	x11, mult
	ldr	w9, [x9, :lo12:add]
	msub	w8, w8, w10, w0
	ldr	w10, [x11, :lo12:mult]
	adrp	x11, div
	cmp	w8, #0
	cneg	w8, w9, ne
	madd	w8, w10, w0, w8
	ldr	w9, [x11, :lo12:div]
	sdiv	w10, w8, w9
	msub	w0, w10, w9, w8
	bl	badrandom_recurse
.LBB1_5:
	and	w0, w0, #0x1
	ldp	x29, x30, [sp], #16
	ret
.Lfunc_end1:
	.size	badrandom_recurse, .Lfunc_end1-badrandom_recurse
	.cfi_endproc

	.type	array_length,@object
	.local	array_length
	.comm	array_length,4,4
	.type	mult,@object
	.local	mult
	.comm	mult,4,4
	.type	add,@object
	.local	add
	.comm	add,4,4
	.type	div,@object
	.local	div
	.comm	div,4,4
	.type	min,@object
	.local	min
	.comm	min,4,4
	.type	array,@object
	.local	array
	.comm	array,8,8
	.ident	"clang version 14.0.6 (Red Hat 14.0.6-4.el9_1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
