#include "uart.h"
#include "ucos/includes.h"

void userApp2(void * args)
{
	while(1)
	{
		uart_string("in userApp2");
		OSTimeDly(100);
	}
}

void userApp1(void * args)
{

	while(1)
	{
		uart_string("in userApp1");
		OSTimeDly(100);
	}
}
