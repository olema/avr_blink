; Светодиодная мигалка на микроконтроллере  Atmega8L-8PU
; https://ph0en1x.net/79-avr-asm-first-program-for-microcontroller.html

.includepath "/usr/share/avra/" ; путь для подгрузки .inc файлов
.include "m8def.inc"
.list				; вклюение генерации листинга

.cseg
.org 0x0000

; вектора для ATmega8
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

; -- инициализация стека --
RESET:
	ldi R16, Low(RAMEND)
	out SPL, R16
	ldi R16, High(RAMEND)
	out SPH, R16

; -- analog comparator disable
	ldi R16, 1<<ACD
	out ACSR, R16

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
