/******************************************************************************
statemachine.c
CSE/EE 5385/7385 Microprocessor Architecture and Interfacing
ARM MCBSTM32C Final Project
******************************************************************************/

#include "stdio.h"
#include <stm32f10x_cl.h>
#include "GLCD.h"
#include <math.h>
#include <stdlib.h>
int c;
int i;
const long led_mask[] = {1<<15, 1<<14, 1<<13, 1<<12, 1<<11, 1<<10, 1<<9, 1<<8};
int state = 0; 
void timer_ms_init();
void wait_ms(int);
void blink();

int main (void) {
  SystemInit();

  /* Configure the GPIO for Push Buttons                                      */
  RCC->APB2ENR |=  1 <<  2;             /* Enable GPIOA clock                 */
  RCC->APB2ENR |=  1 <<  3;             /* Enable GPIOB clock                 */
  RCC->APB2ENR |=  1 <<  4;             /* Enable GPIOC clock                 */
  GPIOA->CRL   &= 0xFFFFFFF0;
  GPIOA->CRL   |= 0x00000004;
  GPIOB->CRL   &= 0x0FFFFFFF;
  GPIOB->CRL   |= 0x40000000;
  GPIOC->CRH   &= 0xFF0FFFFF;
  GPIOC->CRH   |= 0x00400000;
timer_ms_init(); //configures the timer to what I need statically   


  /* Setup GPIO for LEDs*/
  RCC->APB2ENR |=  1 <<  6;             /* Enable GPIOE clock */
  GPIOE->CRH    = 0x33333333;           /* Configure the GPIO for LEDs */

RCC->APB2ENR |= 1<<9; //Enables the clock for ADC-analog digital convertor 
 

 GLCD_Init();                          /* Initialize graphical LCD display   */
  GLCD_Clear(White);                    /* Clear graphical LCD display        */



//---------------------------------------------------------\
//copied the following from lab 6, 
GPIOC->CRL &= 0xFFF0FFFF; //setup and initialize the ADC
ADC1->SQR1 = 0x00000000; 
ADC1->SQR2 = 0x00000000;
ADC1->SQR3 = (14<<0); 
ADC1->SMPR1 = 6 << 12; 
ADC1->SMPR2 = 0x00000000; // these configuration followed the example in the lecture



//--------------------------------------------------------
  for (;;) {   
  //neutral state = 0
switch(state)
{
case 0:
//initial state 
GLCD_DisplayString  ( 0, 8, 1,"Initial State   " );
//wakeup
if ((GPIOA->IDR & (1<<0))) {
state = 1;
} else state = 0;
break;
//------------------------------------------------------------
case 1: //gear 1
GLCD_DisplayString  ( 0, 8, 1,"Gear 1 3 seconds" );
//timer for 3 sec delay
//3 seconds = 3000 ms
wait_ms(3000);
state = 2;
break;
//------------------------------------------------------------ 
case 2: //gear 2
GLCD_DisplayString  ( 0, 8, 1,"Gear 2 5 seconds" );
//wait 5seconds = 5000 ms
wait_ms(5000);
state = 3;
break;
//------------------------------------------------------------ 
/******************************************************************************
statemachine.c
CSE/EE 5385/7385 Microprocessor Architecture and Interfacing
ARM MCBSTM32C Final Project
******************************************************************************/


#include "stdio.h"
#include <stm32f10x_cl.h>
#include "GLCD.h"
#include <math.h>
#include <stdlib.h>
int c;
int i;
const long led_mask[] = {1<<15, 1<<14, 1<<13, 1<<12, 1<<11, 1<<10, 1<<9, 1<<8};
int state = 0; 
void timer_ms_init();
void wait_ms(int);
void blink();

int main (void) {
  SystemInit();
timer_ms_init(); //configures the timer to what I need statically 
  /* Configure the GPIO for Push Buttons                                      */
  RCC->APB2ENR |=  1 <<  2;             /* Enable GPIOA clock                 */
  RCC->APB2ENR |=  1 <<  3;             /* Enable GPIOB clock                 */
  RCC->APB2ENR |=  1 <<  4;             /* Enable GPIOC clock                 */
  GPIOA->CRL   &= 0xFFFFFFF0;
  GPIOA->CRL   |= 0x00000004;
  GPIOB->CRL   &= 0x0FFFFFFF;
  GPIOB->CRL   |= 0x40000000;
  GPIOC->CRH   &= 0xFF0FFFFF;
  GPIOC->CRH   |= 0x00400000;
  
  /* Setup GPIO for LEDs*/
  RCC->APB2ENR |=  1 <<  6;             /* Enable GPIOE clock */
  GPIOE->CRH    = 0x33333333;           /* Configure the GPIO for LEDs */
RCC->APB2ENR |= 1<<9; //Enables the clock for ADC-analog digital convertor 
  GLCD_Init();                          /* Initialize graphical LCD display   */
  GLCD_Clear(White);                    /* Clear graphical LCD display        */



//---------------------------------------------------------\
//copied the following from lab 6, 
GPIOC->CRL &= 0xFFF0FFFF; //setup and initialize the ADC
ADC1->SQR1 = 0x00000000; 
ADC1->SQR2 = 0x00000000;
ADC1->SQR3 = (14<<0); 
ADC1->SMPR1 = 6 << 12; 
ADC1->SMPR2 = 0x00000000; // these configuration followed the example in the lecture



//--------------------------------------------------------
  for (;;) {   
  //neutral state = 0
switch(state)
{
case 0:
//initial state 
GLCD_DisplayString  ( 5, 1, 1,"Initial State   " );
//wakeup
if ((GPIOA->IDR & (1<<0))) {
	
		state = 1;
	
} else state = 0;
break;
//------------------------------------------------------------
case 1: //gear 1

//timer for 3 sec delay
//3 seconds = 3000 ms

TIM4->EGR = 1; //Update timer event
	while (!(TIM4->CNT > 30000)){
		GLCD_DisplayString  ( 5, 1, 1,"Gear 1 3 seconds" );
		state = 2;
		
	}
break;
//------------------------------------------------------------ 
case 2: //gear 2
		TIM4->EGR = 1;
		while (!(TIM4->CNT > 50000)){
GLCD_DisplayString  ( 5, 1, 1,"Gear 2 5 seconds" );
//wait 5seconds = 5000 ms
//wait_ms(5000);
state = 3;
		}
break;
//------------------------------------------------------------ 
case 3: //gear 3
//tamper
GLCD_DisplayString  ( 5, 1, 1,"Gear 3 Waiting  " );
if (!(GPIOC -> IDR & (1<<13)))
{
GLCD_DisplayString  ( 5, 1, 1,"Tamper pressed    " );
state = 2;
break;
} 
//user
if (!(GPIOB -> IDR & (1<<7)))
{
GLCD_DisplayString  ( 5, 1, 1,"User pressed      " );
state = 4;
blink();
break; 
}
state = 3; 
break;
//------------------------------------------------------------ 
case 4: //gear 4
//wait for 6 seconds =  6000 ms


TIM4->EGR = 1;
while (!(TIM4->CNT > 60000)){
		GLCD_DisplayString  ( 5, 1, 1,"Gear 4 6 seconds      " );
}
//wait_ms(6000);
state = 0;
break;
} 
  }
}

void timer_ms_init()
{
RCC->APB1ENR |= (1<<2); //enable clock to timer tim4 from hw
RCC->APB2ENR |=(1)|(1<<3); //enables and the GPIO clock and the alternate function
//the following taken from a example from johnkneenmicrocontrollers examples
TIM4->CR1 = 0x0000; //sets timer to default when configuring
TIM4->SMCR &= !7; // sets the base clock freq at 8Mhz as the clock source
TIM4->PSC = 7999; // 7999 + 1 = 8000 -> Mhz/8000 = 1ms intervals
TIM4->CR1 = 0x0001; //enables timer
//end of configuration
}

void wait_ms(int d)
{
//d is the amt of delay time in miliseconds therefore, the amt of delay time has to be 
//determined before calling this function
TIM4->EGR = 1; //Update timer event
while(!(TIM4->CNT > d))
{

} 

}
void blink()
{
for(c = 8; c>-2; c--) {
GPIOE->ODR |= led_mask[c]; /*Turn LED num on*/
for (i = 0; i < (1000000); i++); //delay can reduce it to speed up the cycle
GPIOE->ODR &= ~led_mask[c]; // turns off the light
}

}
