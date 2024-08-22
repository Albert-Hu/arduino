CPU = atmega328p

CFLAGS = -mmcu=$(CPU) -O1 -Wall -DF_CPU=16000000UL
BUILD = build
PORT =


ifeq ($(MAKECMDGOALS),upload)
ifeq ($(PORT),)
$(error PORT is not set)
endif
endif

all:
	mkdir -p $(BUILD)
	avr-gcc $(CFLAGS) -o $(BUILD)/main.elf main.c
	avr-objcopy -O ihex $(BUILD)/main.elf $(BUILD)/main.hex
	avr-size --mcu=$(CPU) --format=avr $(BUILD)/main.elf

upload: all
	avrdude -v -V -p atmega328p -c arduino -P $(PORT) -b57600 -D -U flash:w:$(BUILD)/main.hex:i

clean:
	rm -rf $(BUILD)

.PHONY: build clean
