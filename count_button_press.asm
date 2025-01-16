; Программа счета нажатий в двоичном коде
; (Ревич. Программирование AVR на ассемблере. листинг 5.11, стр. 95)
; адаптировано для ассемблера avra и контроллера ATmega8

.includepath "/usr/share/avra/"
.include "m8def.inc"
.list

.def temp = r16		; рабочая переменная
.def razr0 = r17	; разряды задержки
.def razr1 = r18
.def razr2 = r19
.def counter = r20	; счетчик

.cseg
.org 0x0

; вектора прерываний

; инициализация стека
RESET:
	ldi temp, Low(RAMEND)
	out SPL, temp
	ldi temp, High(RAMEND)
	out SPH, temp
