; Светодиодная мигалка на микроконтроллере  Atmega8L-8PU
; https://ph0en1x.net/79-avr-asm-first-program-for-microcontroller.html

.INCLUDEPATH "/usr/share/avra/" ; путь для подгрузки .inc файлов
.INCLUDE "m8def.inc"
.LIST				; вклюение генерации листинга

.CSEG
.ORG 0x0000

; -- инициализация стека --
LDI R16, Low(RAMEND)
OUT SPL, R16
LDI R16, High(RAMEND)
OUT SPH, R16

.equ Delay = 5

; -- устанавливаем каналы PD0 и PD1 порта PORTD (PD) на вывод --
LDI R16, 0b00000011
OUT DDRD, R16

Start:
	SBI PORTD, PORTD0	; set bit 0 port D
	CBI PORTD, PORTD1	; clear bit 1 port D
	RCALL Wait
	SBI PORTD, PORTD1
	CBI PORTD, PORTD0
	RCALL Wait
	RJMP Start

Wait:
	LDI R17, Delay
WLoop0:
	LDI R18, 50
WLoop1:
	LDI R19, 0xC8
WLoop2:
	DEC R19
	BRNE WLoop2
	DEC R18
	BRNE WLoop1
	DEC R17
	BRNE WLoop0
RET

Program_name: .DB "Simple LEDs blinking program"
