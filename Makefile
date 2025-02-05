.PHONY: clean

leds_blinking.hex: leds_blinking.asm
	avra -l $(basename $@).lst $^ 

count_button_press.hex: count_button_press.asm
	avra -l $(basename $@).lst $^ 

count_button_press_int.hex: count_button_press_int.asm
	avra -l $(basename $@).lst $^ 

test.hex: test.S
	avr-as -mmcu=atmega8 -g -gstabs -o $(basename $@).o $^ 
	avr-ld -m avr4 -o $(basename $@).elf $(basename $@).o 
	avr-objcopy -j .text -j .data -O ihex $(basename $@).elf $(basename $@).hex

clean:
	rm *.hex *.elf *.o *.obj *.lst
