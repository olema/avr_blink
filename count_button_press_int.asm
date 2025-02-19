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
	rjmp RESET 		; Reset Handler
	rjmp EXT_INT0 		; IRQ0 Handler
	reti; rjmp EXT_INT1 ; IRQ1 Handler
	reti; rjmp TIM2_COMP ; Timer2 Compare Handler
	reti; rjmp TIM2_OVF ; Timer2 Overflow Handler
	reti; rjmp TIM1_CAPT ; Timer1 Capture Handler
	reti; rjmp TIM1_COMPA ; Timer1 CompareA Handler
	reti; rjmp TIM1_COMPB ; Timer1 CompareB Handler
	reti; rjmp TIM1_OVF ; Timer1 Overflow Handler
	rjmp TIM0_OVF ; Timer0 Overflow Handler
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
; ******
; ****** обработчик прерывания INT0 (нажатие кнопки) 
; ******
EXT_INT0:		; внешнее прерывание по кнопке
	clr temp	; запрещаем прерывания по кнопке
	out GIMSK, temp	; регистр .equ GIMSK = GICR - general interrupt control register (0x3b)
			;   бит 7 — INT1, маска внешнего прерывания INT1;
			;   бит 6 — INT0, маска внешнего прерывания INT0;
			;   бит 5 — INT2, маска внешнего прерывания INT2;
			;   бит 1 — IVSEL (Interrupt Vector Select);
			;   бит 0 — IVCE (Interrupt Vector Change Enable).
			;
	ldi temp, 0xff	; на всякий случай очищаем регистр флагов прерываний
	out GIFR, temp	; GIFR - General Interrupt Flag Register (.equ	GIFR	= 0x3a)
	sbrs flag, 0	; проверяем бит 0 нашего регистра флагов (r19) 
			; SBRS – Skip if Bit in Register is Set
			; SBRS Rr,b (0 ≤ r ≤ 31, 0 ≤ b ≤ 7)
	rjmp PUSH_PIN	; если 0, то было нажатие
	cbr flag, 1	; иначе было отпускание, очищаем бит 0
			; CBR – Clear Bits in Register
			; Rd ← Rd ∧ (0xFF - K)  (пояснение: ∧ - AND) 
			; CBR Rd,K (16 ≤ d ≤ 31, 0 ≤ K ≤ 255)
	inc counter	; кнопка была отпущена, увеличиваем счетчик
	out PORTB, counter	; выводим счетчик в порт B
	ldi count_time, 50	; интервал 0.2 сек
	rjmp ENT_INT	; на выход
PUSH_PIN:		; было нажатие
	sbr flag, 1	; устанавливаем бит 0
			; SBR – Set Bits in Register
			; Rd ← Rd v K
			; SBR Rd,K 16 ≤ d ≤ 31, 0 ≤ K ≤ 255
	ldi count_time, 128	; интервал 0.5 сек
 
ENT_INT:
	ldi temp,0b00000011	; запуск Timer0, входная частота 1:64
	out TCCR0,temp	; .equ	TCCR0	= 0x33
			; TCCR0 - Timer/Counter0 Control Register
	reti		; конец обработки прерывания кнопки
; ******
; ****** конец обработчика прерывания INT0
; ******
;
; ******
; ****** обработчик прерывания таймера Timer0
; ******
TIM0_OVF:			; обработчик прерывания Timer0
	dec count_time	; в каждом прерывании уменьшаем на 1
	breq END_TIMER	; если 0, то на конец отсчета
	reti		; иначе выход из прерывания
END_TIMER:
	clr temp	; останавливаем таймер
	out TCCR0,temp	;
	sbrc flag,0	; проверяем бит 0 нашего регистра флагов
	rjmp PUSH_TIM	; если 1, то было нажатие
	ldi temp,(1<<ISC01)	; иначе устанавливаем INT0 но спаду
	out MCUCR, temp
	rjmp END_TIM	; на выход
PUSH_TIM:		; если было нажатие
	ldi temp,(1<<ISC01|1<<ISC11)	; устанавливаем INT0 по фронту
	out MCUCR,temp
END_TIM:
	ldi temp,(1<<INT0)	; разрешаем INT0
	out GIMSK,temp
	reti
; ******
; ****** конец обработчика прерывания Timer0
; ******
;
; ******
; ****** начальная инициализация
; ******
RESET:
	ldi temp,low(RAMEND)	; загрузка указателя стека
	out SPL,temp
	ldi temp, high(RAMEND)
	out SPH, temp
	ldi temp,0b00000100	; для второго разряда порта D
	out PORTD,temp		; подтягивающий резистор на всякий случай
	ldi temp,0b11111111	; порт B все контакты на выход
	out DDRB,temp
	clr counter		; очищаем счетчик (r18)
	clr flag		; очищаем наш флаг (r19)
	ldi temp,(1<<TOIE0)	; разрешение прерывания Timer0
	out TIMSK,temp
	ldi temp,(1<<ISC01)	; устанавливаем прерывание INT0 по спаду
				; .equ ISC01 = 1 ; Interrupt Sense Control 0 Bit 1
	out MCUCR,temp		; MCUCR - MCU Control Register
				; bits:
				;	7 - SE - Sleep Enable
				;	6,5,4 - SM2..0 - Sleep Mode Select bits
				;		0 0 0 - Idle
				;		0 0 1 - ADC Noise Reduction
				;		0 1 0 - Power Down 
				;		0 1 1 - Power Save
				;		1 0 0 - Reserved
				;		1 0 1 - Reserved
				;		1 1 0 - Standby (is only available with external crystals or resonators
				;       3,2 – ISC11, ISC10: Interrupt Sense Control 1 Bit 1 and Bit 0 (INT1)
				;		0 0 - The low level of INT1 generates an interrupt request
				;		0 1 - Any logical change on INT1 generates an interrupt request
				;		1 0 - The falling edge of INT1 generates an interrupt request
				;		1 1 - The rising edge of INT1 generates an interrupt request
				;       1,0 – ISC01, ISC00: Interrupt Sense Control 0 Bit 1 and Bit 0 (INT0)
				;		
	ldi temp,(1<<INT0)	; разрешаем прерывание INT0
				; .equ INT0 = 6	; External Interrupt Request 0 Enable
	out GICR,temp
	sei			; разрешаем прерывания
; ******
; ****** основной пустой цикл
; ******
G:
	rjmp G
