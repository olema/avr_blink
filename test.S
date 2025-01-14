	.data

	.section .text
	.org 0x0000

	.global main

main:
	ldi r16, 10
M1:
	inc r16
	rjmp M1
