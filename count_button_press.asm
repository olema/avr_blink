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
	rjmp RESET ; Reset Handler
	reti; rjmp EXT_INT0 ; IRQ0 Handler
	reti; rjmp EXT_INT1 ; IRQ1 Handler
	reti; rjmp TIM2_COMP ; Timer2 Compare Handler
	reti; rjmp TIM2_OVF ; Timer2 Overflow Handler
	reti; rjmp TIM1_CAPT ; Timer1 Capture Handler
	reti; rjmp TIM1_COMPA ; Timer1 CompareA Handler
	reti; rjmp TIM1_COMPB ; Timer1 CompareB Handler
	reti; rjmp TIM1_OVF ; Timer1 Overflow Handler
	reti; rjmp TIM0_OVF ; Timer0 Overflow Handler
	reti; rjmp SPI_STC ; SPI Transfer Complete Handler
	reti; rjmp USART_RXC ; USART RX Complete Handler
	reti; rjmp USART_UDRE ; UDR Empty Handler
	reti; rjmp USART_TXC ; USART TX Complete Handler
	reti; rjmp ADC ; ADC Conversion Complete Handler
	reti; rjmp EE_RDY ; EEPROM Ready Handler
	reti; rjmp ANA_COMP ; Analog Comparator Handler
	reti; rjmp TWSI ; Two-wire Serial Interface Handler
	reti; rjmp SPM_RDY ; Store Program Memory Ready Handler

; инициализация стека
RESET:
	ldi temp, Low(RAMEND)
	out SPL, temp
	ldi temp, High(RAMEND)
	out SPH, temp
; программа
	ldi temp, 0b00000100	; для второго разряда порта D
	out PORTD, temp		; вкл подтягивающего резистора
	ldi temp, 0b11111111	; 
	out DDRB, temp		; порт B все контакты на выход
