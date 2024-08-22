#include <avr/interrupt.h>
#include <avr/wdt.h>


#define USART_BAUDRATE (57600)
#define USART_UBRR1H (((F_CPU / (16UL * USART_BAUDRATE)) - 1) >> 8)
#define USART_UBRR1L ((F_CPU / (16UL * USART_BAUDRATE)) - 1)

static void UartWriteByte(const char c) {
  loop_until_bit_is_set(UCSR0A, UDRE0);
  UDR0 = c;
}

static char UartReadByte() {
  loop_until_bit_is_set(UCSR0A, RXC0);
  return UDR0;
}

static void HardwareInit(void) {
  cli();

  MCUSR &= ~(1 << WDRF);

  wdt_disable();

  UBRR0H = USART_UBRR1H;
  UBRR0L = USART_UBRR1L;

  UCSR0B = (1 << TXEN0) | (1 << RXEN0);

  UCSR0C = (1 << USBS0) | (3 << UCSZ00);

  sei();
}

int main(void) {

  HardwareInit();

  while (1) {
    UartWriteByte(UartReadByte());
  }
}
