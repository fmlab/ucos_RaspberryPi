
#ifndef UART_H_
#define UART_H_

unsigned int uart_lcr ( void );
unsigned int uart_recv ( void );
void uart_send ( unsigned int );
void uart_flush ( void );
void hexstrings ( unsigned int );
void hexstring ( unsigned int );
void uart_init ( void );
void uart_string(char *);
#endif /* UART_H_ */
