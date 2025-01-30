.PHONY: clean

leds_blinking.hex: leds_blinking.asm
	avra -l leds_blinking.lst leds_blinking.asm

count_button_press.hex: count_button_press.asm
	avra -l $(basename $@).lst $^ 

count_button_press_int.hex: count_button_press.asm
	avra -l $(basename $@).lst $^ 

test.hex: test.S
	avr-as -mmcu=atmega8 -g -gstabs -o test.o test.S
	avr-ld -m avr4 -o test.elf test.o
	avr-objcopy -j .text -j .data -O ihex test.elf test.hex

clean:
	rm *.hex *.elf *.o *.obj *.lst
