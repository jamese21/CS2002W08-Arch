# Student ID: <please insert your student id here for marker's convenience>
# 
# Please comment assembly code 
# For Part 2 you ARE required to comment function "badrandom"
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
	pushq	%rbp 					# pushes previous base pointer (%rbp) to top of stack
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp				# copies current stack pointer (%rsp) to base pointer (%rbp)
									# stack frame is currently 0 bytes, so %rsp and %rbp point to the same address
	.cfi_def_cfa_register %rbp
	pushq	%r15					# pushes value in %r15 to top of stack
	pushq	%r14					# pushes value in %r14 to top of stack
	pushq	%rbx					# pushes value in %rbx to top of stack
									# these can be restored later by popping them
	.cfi_offset %rbx, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	testl	%edi, %edi				# if(start >= 1)
									# (%edi is start) 
									# testl sets ZF=1 if start=0 and sets SF=1 if start<0
	jle	.LBB0_1						# jump to .LBB0_1 if start is 0 or negative (ZF = 1 or SF!=OF)
									# (return false)
	movl	%edx, %r10d				# %r10d = add
	movq	16(%rbp), %r14			# %r14 = array
									# only rdi-r9 (6 registers) are available for the 7 arguments in badrandom, 
									# so the 7th argument (in_array) is stored on the stack as per the calling convention.
									# this is accessed manually using %rbp as a reference point
	movl	%edx, %r15d				# %r15d = add
	negl	%r15d					# %r15d = -add
									# saving +add and -add to be used in the if/else recursive call block later
	xorl	%ebx, %ebx				# %ebx = 0
	.p2align	4, 0x90
.LBB0_3:							# ITERATION
	movl	%edi, (%r14,%rbx,4)		# array[array_length] = current
									# %edi is current
									# %r14 is a pointer to array
									# %rbx is array_length
									# *4 is because each index is 4 bytes
	cmpl	%r8d, %edi				# if (current < min) 
									# min-current,set flags
									# setl and jl both check if SF!=OF. 
	setl	%r11b					# set r11b to 1 if SF!=OF (SF checks if most significant bit is set, OF checks if most significant bit
									# was changed in the result). 
									# %r11b is the return value, with suffix b for 1 byte (0 = false, 1 = true)
	jl	.LBB0_6						# jump to .LBB0_6 (return true)
	addq	$1, %rbx				# array_length += 1
	movl	%edi, %eax				# %eax = current
	cltd							# extends %eax into %edx by extending the sign bit into all bits of edx
	idivl	%r8d					# %edx = edx:eax%min aka current%min (result of edx:eax/min is stored in %eax but not used here)
	imull	%esi, %edi				# %eax = current*mult
	testl	%edx, %edx				# if (current%min == 0) (does edx&edx, sets flags)
	movl	%r15d, %eax				# %eax = -add
	cmovel	%r10d, %eax				# %eax = +add if ZF=1 (+add)
	addl	%edi, %eax				# %eax += %edi (current*mult+add)
	cltd							# extends the total so far into edx to be used in idivl
	idivl	%ecx					# (current*mult+add)%div, stored in %edx
	movl	%edx, %edi				# %edi = %edx (new value for current)	
	cmpq	$200, %rbx				# if(array_length >= MAXARRAYSIZE)		
	jne	.LBB0_3						# repeat if array_length != MAXARRAYSIZE (equivalent to the >= used in the code, 
									# as array_length is always initialised as 0 and incremented by 1 each time)
	movl	$200, %ebx				# %ebx = MAXARRAYSIZE (array_length has reached the maximum size)
	jmp	.LBB0_7						# return false
.LBB0_1:							# SET RETURN VALUE TO FALSE
	xorl	%ebx, %ebx 				# %ebx = 0
	xorl	%r11d, %r11d			# %r11d = 0
	jmp	.LBB0_7						# return
.LBB0_6:							# INCREMENT array_length
	addl	$1, %ebx				# array_length += 1
.LBB0_7:							# RETURN VALUE AND RESTORE REGISTERS TO ORIGINAL VALUES
	movl	%ebx, (%r9)				# *in_length = array_length 
									# (*in_length is stored in %r9, the brackets are used because *in_length is an address itself)
	movl	%r11d, %eax				# %eax = %r11d (return value)
	popq	%rbx					# rbx is restored
	popq	%r14					# r14 is restored
	popq	%r15					# r15 is restored
	popq	%rbp					# previous base pointer is restored
	.cfi_def_cfa %rsp, 8
	retq							# instruction pointer is moved back to where it was before
.Lfunc_end0:
	.size	badrandom, .Lfunc_end0-badrandom
	.cfi_endproc

	.ident	"clang version 14.0.6 (Red Hat 14.0.6-4.el9_1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
