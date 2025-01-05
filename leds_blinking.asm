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
	SBI PORTD
