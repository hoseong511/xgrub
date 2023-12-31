%include "init.inc"

[org 0]
	jmp 0x7c0:start

%include "a20.inc"

start:
	mov ax, cs
	mov ds, ax
	mov es, ax

	mov ax, 0xb800
	mov es, ax
	mov di, 0
	mov ax, word [msgBack]
	mov cx, 0x7ff

paint:
	mov word [es:di], ax
	add di, 2
	dec cx
	jnz paint

read_setup:
	mov ax, 0x9000
	mov es, ax
	mov bx, 0

	mov ah, 2
	mov al, 2
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_setup

read_kerenel:
	mov ax, 0x8000
	mov es, ax
	mov bx, 0

	mov ah, 2
	mov al, 7
	mov ch, 0
	mov cl, 4
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_kerenel

read_user1:
	mov ax, 0x7000
	mov es, ax
	mov bx, 0

	mov ah, 2
	mov al, 1
	mov ch, 0
	mov cl, 11
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_user1

read_user2:
	mov ax, 0x7000
	mov es, ax
	mov bx, 0x200

	mov ah, 2
	mov al, 1
	mov ch, 0
	mov cl, 12
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_user2

read_user3:
	mov ax, 0x7000
	mov es, ax
	mov bx, 0x400

	mov ah, 2
	mov al, 1
	mov ch, 0
	mov cl, 13
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_user3

read_user4:
	mov ax, 0x7000
	mov es, ax
	mov bx, 0x600

	mov ah, 2
	mov al, 1
	mov ch, 0
	mov cl, 14
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_user4

read_user5:
	mov ax, 0x7000
	mov es, ax
	mov bx, 0x800

	mov ah, 2
	mov al, 1
	mov ch, 0
	mov cl, 15
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_user5

	mov dx, 0x3F2
	xor al, al
	out dx, al

	cli

	call a20_try_loop

	mov al, 0x11
	out 0x20, al
	dw 0x00eb, 0x00eb
	out 0xA0, al
	dw 0x00eb, 0x00eb

	mov al, 0x20
	out 0x21, al
	dw 0x00eb, 0x00eb
	mov al, 0x28
	out 0xA1, al
	dw 0x00eb, 0x00eb

	mov al, 0x04
	out 0x21, al
	dw 0x00eb, 0x00eb
	mov al, 0x02
	out 0xA1, al
	dw 0x00eb, 0x00eb

	mov al, 0x01
	out 0x21, al
	dw 0x00eb, 0x00eb
	out 0xA1, al
	dw 0x00eb, 0x00eb

	mov al, 0xFF
	out 0xA1, al
	dw 0x00eb, 0x00eb
	mov al, 0xFB
	out 0x21, al

	jmp 0x9000:0000

msgBack db '.', 0x70

times 510-($-$$) db 0
dw 0xaa55
 