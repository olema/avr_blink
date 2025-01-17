.PHONY: clean

leds_blinking.hex: leds_blinking.asm
	avra -l leds_blinking.lst leds_blinking.asm

count_button_press.hex: count_button_press.asm
	avra -l count_button_press.lst count_button_press.asm

clean:
	rm *.hex *.elf *.o *.obj *.lst
