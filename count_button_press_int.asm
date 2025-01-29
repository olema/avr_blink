; Программа счет нажатий на кнопку с помощью прерываний
; (Ревич. Программирование AVR на ассемблере. листинг 5.13, стр. 99)
; адаптировано для ассемблера avra и контроллера ATmega8
; Частота 4 МГц

.includepath "/usr/share/avra/"
.include "m8def.inc"
.list

; секция .def
.def temp = r16		; рабочая переменная
.def count_time = r17	; счетчик задержки
.def counter = r18	; счетчик нажатий
.def flag = r19		; регистр флагов: если бит 0 установлен, то обнаружили нажатие и переходим к обнаружению отпускания

.cseg
.org 0x0

; векторы прерываний
	rjmp RESET ; Reset Handler
	rjmp EXT_INT0 ; IRQ0 Handler
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

; ====== программа =======
EXT_INT0:		; внешнее прерывание по кнопке
	clr temp	; запрещаем прерывания по кнопке
	out GIMSK, temp	; регистр .equ GIMSK = GICR - general interrupt control register (0x3b)
	
