.include "init.inc"

.org 0
.code16

	jmp $0x7c0, $start

start:
	mov %cs, %ax
	mov %ax, %ds
	mov %ax, %es

	mov $0xb800, %ax
	mov %ax, %es
	mov $0, %di
	movw (msgBack), %ax
	mov $0x7ff, %cx

paint:
	movw %ax, %es:(%di)
	add $2, %di
	dec %cx
	jnz paint

read:
	mov $0x1000, %ax
	mov %ax, %es
	mov $0, %bx

	mov $2, %ah
	mov $1, %al
	mov $0, %ch
	mov $2, %cl
	mov $0, %dh
	mov $0, %dl
	int $0x13

	jc read

	mov $0x3f2, %dx
	xor %al, %al
	outb %al, %dx
	cli
	mov $0xff, %al
	outb %al, $0xA1

	lgdt (gdtr)
	mov %cr0, %eax
	or $0x00000001, %eax
	mov %eax, %cr0
	jmp . + 2
	nop
	nop

	jmpl $sys_code_selector, $0x0000

msgBack:
	.byte '.', 0x67

gdtr:
	.word gdt_end - gdt - 1
	.long gdt + 0x7c00

gdt:
	.long 0, 0
	.long 0x0000ffff, 0x00cf9a01
	.long 0x0000ffff, 0x00cf9201
	.long 0x8000ffff, 0x0040920b
	.long 0x0000ffff, 0x00cffa02
	.long 0x0000ffff, 0x00cff203
	.long 0x0000ffff, 0x00cf9a00
	.long 0x0000ffff, 0x00cf9200
gdt_end:

.org 510
.word 0xaa55
