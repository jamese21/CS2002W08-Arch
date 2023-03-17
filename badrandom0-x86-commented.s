:# Student ID: 210006835
# 
# Please comment assembly code 
# For Part 1 you are NOT required to comment function "badrandom"
# For Part 1 you ARE required to comment function "badrandom_recurse"
#
# Comment character is # 
# You are not required to comment assembler directives 
# For full details of requirements please see practical spec.

	.text
	.file	"badrandom.c"
	.globl	badrandom
	.p2align	4, 0x90
	.type	badrandom,@function
badrandom:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$48, %rsp
	movq	16(%rbp), %rax
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	%edx, -12(%rbp)
	movl	%ecx, -16(%rbp)
	movl	%r8d, -20(%rbp)
	movq	%r9, -32(%rbp)
	movl	$0, array_length
	movl	-8(%rbp), %eax
	movl	%eax, mult
	movl	-12(%rbp), %eax
	movl	%eax, add
	movl	-16(%rbp), %eax
	movl	%eax, div
	movl	-20(%rbp), %eax
	movl	%eax, min
	movq	16(%rbp), %rax
	movq	%rax, array
	movb	$0, -33(%rbp)
	cmpl	$1, -4(%rbp)
	jl	.LBB0_2
	movl	-4(%rbp), %edi
	callq	badrandom_recurse
	andb	$1, %al
	movb	%al, -33(%rbp)
.LBB0_2:
	movl	array_length, %ecx
	movq	-32(%rbp), %rax
	movl	%ecx, (%rax)
	movb	-33(%rbp), %al
	andb	$1, %al
	movzbl	%al, %eax
	addq	$48, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	badrandom, .Lfunc_end0-badrandom
	.cfi_endproc

	.p2align	4, 0x90
	.type	badrandom_recurse,@function
badrandom_recurse:
	.cfi_startproc 					
	pushq	%rbp 					# pushes previous base pointer (%rbp) to top of stack
	.cfi_def_cfa_offset 16			
	.cfi_offset %rbp, -16			
	movq	%rsp, %rbp				# copies current stack pointer (%rsp) to base pointer (%rbp) 
	.cfi_def_cfa_register %rbp		
	subq	$16, %rsp				# reserves 16 bytes of the stack for local variables of badrandom_recurse, so now stack frame is 16 bytes, 
									# %rbp points to base of stack frame and %rsp points to top of stack
	movl	%edi, -8(%rbp)			# -8(%rbp) = current
	cmpl	$200, array_length		# compares MAXIMUMARRAYSIZE and array_length
									# does MAXIMUMARRAYSIZE-array_length and sets flags
	jl	.LBB1_2						# jumps to .LBB1_2 if array_length<MAXIMUMARRAYSIZE (if OF!=SF)
	movb	$0, -1(%rbp)			# -1(%rbp) = 0 (return value is set to false)
	jmp	.LBB1_7						# go to cleanup and return

.LBB1_2:							# if (current < min) {
        							# 	return true; } 
	movl	-8(%rbp), %edx			# %edx = current
	movq	array, %rax				# %rax = pointer to first index of array
	movslq	array_length, %rcx		# %rcx = array_length
	movl	%edx, (%rax,%rcx,4)		# copies value in %edx to address %rax+4*%rcx
									# aka array[array_length] = current (the x4 is because the array indexes are 4 bytes each)
	movl	array_length, %eax		# %eax = array_length
	addl	$1, %eax				# %eax += 1
	movl	%eax, array_length		# array_length = %eax
									# (roundabout way of doing array_length += 1)
	movl	-8(%rbp), %eax			# %eax = current
	cmpl	min, %eax				# compares min and current
									# aka if (current < min)
	jge	.LBB1_4						# jumps to .LBB1_4 if current>=min (if SF==OF)
	movb	$1, -1(%rbp)			# -1(%rbp) = 1 (sets return value to true)
	jmp	.LBB1_7						# jumps to .LBB1_7

.LBB1_4:							# if (current%min == 0) {
        							# 	return badrandom_recurse((current*mult+add)%div); }
	movl	-8(%rbp), %eax			# %eax = current
	cltd							# extends %eax into %edx by extending the sign bit into all bits of edx
	idivl	min						# %edx = edx:eax%min aka current%min (result of edx:eax/min is stored in %eax but not used here)
	cmpl	$0, %edx				# compares 0 to %edx (if (current%min == 0))
	jne	.LBB1_6						# jumps to .LBB1_6 if (0 != current%min)
	movl	-8(%rbp), %eax			# %eax = current
									# below is (current*mult+add)%div
	imull	mult, %eax				# edx:eax = mult*current
	addl	add, %eax				# eax += add
	cltd							# extends %eax into %edx by extending the sign bit into all bits of edx
	idivl	div						# %edx = (current*mult+add)%div
	movl	%edx, %edi				# %edi = %edx
	callq	badrandom_recurse		# recursive call
	andb	$1, %al					# does al && 1 (basically nothing, just doing return value & 1)
	movb	%al, -1(%rbp)			# -1(%rbp) = %al (setting return value)
	jmp	.LBB1_7
.LBB1_6:							# else {
        							# 	return badrandom_recurse((current*mult-add)%div);
    								# }
	movl	-8(%rbp), %eax			# %eax = current
									# below is (current*mult-add)%div
	imull	mult, %eax				# edx:eax = mult*current
	subl	add, %eax				# eax -= add
	cltd							# extends %eax into %edx by extending the sign bit into all bits of edx
	idivl	div						# %edx = (current*mult+add)%div
	movl	%edx, %edi				# %edi = %edx
	callq	badrandom_recurse		# recursive call
	andb	$1, %al					# %al = 1
	movb	%al, -1(%rbp)			# sets return value to true

.LBB1_7:							# cleans up (put return value in return register, restore pointers to original state)
	movb	-1(%rbp), %al			# %al = return value
	andb	$1, %al					# al &= 1 (does nothing)
	movzbl	%al, %eax				# %eax = %al (also fills the remaining bytes in %eax with zeroes)
	addq	$16, %rsp				# %rsp += 16 (restores stack pointer)
	popq	%rbp					# restores rbp back to original state 
	.cfi_def_cfa %rsp, 8
	retq							# moves instruction pointer back to where it was before function call
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
	.addrsig_sym badrandom_recurse
	.addrsig_sym array_length
	.addrsig_sym mult
	.addrsig_sym add
	.addrsig_sym div
	.addrsig_sym min
	.addrsig_sym array
