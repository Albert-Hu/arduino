#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/power.h>
#include <avr/wdt.h>
#include <stdio.h>
#include <string.h>

#include "usb.h"

void HardwareInit(void) {
  // disable watchdog if enabled by bootloader/fuses
  MCUSR &= ~(1 << WDRF);
  wdt_disable();

  // disable clock division
  clock_prescale_set(clock_div_1);

  // init lufa usb CDC device
  USB_Init();
}

// The entry point for the application code
int main(void) {
  uint16_t bytesReceived;
  uint8_t byte;

  HardwareInit();

  GlobalInterruptEnable();

  while (1) {
    bytesReceived = USBBytesReceived();
    while (bytesReceived-- > 0) {
      USBReceiveByte(&byte);
      USBWSendByte(byte);
    }
    USBTask();
  }
}
