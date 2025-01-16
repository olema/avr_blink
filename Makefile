.PHONY: clean

leds_blinking.hex: leds_blinking.asm
	avra -l leds_blinking.lst leds_blinking.asm

clean:
	rm *.hex *.elf *.o *.obj *.lst
