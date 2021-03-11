/******************************************************************************
multitasking.c
CSE/EE 5385/7385 Microprocessor Architecture and Interfacing
Multitasking using Keil RTX Real-Time Operating System (RTX-RTOS) 
******************************************************************************/
#include <RTL.h>
#include <stm32f10x_cl.h>
#include "GLCD.h"
OS_TID t_taskA;                        /* assigned task id of task: task_a */
OS_TID t_taskB;                        /* assigned task id of task: task_b */
OS_TID t_taskC;                        /* assigned task id of task: task_c */
OS_MUT mut_GLCD;                       /* Mutex to control GLCD access     */

__task void taskA (void);								/*Task A*/
__task void taskB (void);								/*Task B*/
__task void taskC (void);								/*Task C*/
__task void init (void);

int joystick=100;											/*Joystick offset*/

/*----------------------------------------------------------------------------
 *        Main: Initialize and start RTX Kernel
 *---------------------------------------------------------------------------*/
int main (void) {
  SystemInit();                             /* initialize clocks             */
	
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
	/* End Configure the GPIO for Push Buttons                                 */
	
	/* Configure the GPIO for Joystick  */
  RCC->APB2ENR |=  1 <<  5;             		/* Enable GPIOD clock            */
  GPIOD->CRH   &= 0x00000FFF;
  GPIOD->CRH   |= 0x44444000;
	/*End Configure the GPIO for Joystick  */

  /* Setup GPIO for LEDs                                                     */
  RCC->APB2ENR |=  1 <<  6;                 /* Enable GPIOE clock            */
  GPIOE->CRH    = 0x33333333;               /* Configure the GPIO for LEDs   */
	/*End Setup GPIO for LEDs                                                  */
  
	GLCD_Init();                              /* Initialize the GLCD           */
  GLCD_Clear(White);                        /* Clear the GLCD                */

  os_sys_init (init);                       /* Initialize RTX and start init */
}

/*----------------------------------------------------------------------------
 *        Task 'init': Initialize
 *---------------------------------------------------------------------------*/
__task void init (void) {
  os_mut_init(mut_GLCD);
  
 /********* YOUR CODE GOES HERE *********				*/
 /* Create task A,  Create task B, Create task C*/
	//using the task id's given and initialized at the start under header files
	//os_tsk_create(); creates the task formated from keil docs
	t_taskA = os_tsk_create(taskA,1);                                                      
	t_taskB = os_tsk_create(taskB,1);                                                             
	t_taskC = os_tsk_create(taskC,1);    


 /* Add Delay */
	os_dly_wait(50);	//wait for 50 system ticks

 /* send signal event flag 0x0001 to taskA 			*/
	os_evt_set(0x0001, t_taskA);

 /* Add Delay */
	os_dly_wait(50);
		
 /* send signal event flag 0x0001 to taskB 			*/
	s_evt_set(0x0001, t_taskB);

 /* Add Delay */
	os_dly_wait(50);

 /* send signal event flag 0x0001 to taskC 			*/
	os_dly_wait(50);
//all the requirements have been fullfiled for the lab insctructions of "the main program" section
/************** END *********************				*/
	
  os_tsk_delete_self ();
}

/*----------------------------------------------------------------------------
 *        Task A: Display sequence of strings
 *---------------------------------------------------------------------------*/
__task void taskA (void) {
	/********* YOUR CODE GOES HERE **********/
	/* wait for an event flag 0x0001       */
	os_evt_wait_and (0x0001, 0xffff);

	/*************** END ******************/
  for (;;) {	 /* endless loop */
    /********* YOUR CODE GOES HERE **********/

		/*Acquire and lock the LCD Mutex*/
		os_mut_wait (&mut_GLCD, 0xffff);

		/*Set background color, set text color*/ 
		//from last lab
		GLCD_SetBackColor(Blue);
		GLCD_SetTextColor(Red);

		/*Display "Task A started"*/
		GLCD_DisplayString  ( 0, 0, 1, "Task A started");

		/*display first name, display last name, display student ID on LCD sequentially*/


		GLCD_DisplayString  ( 1,  0, 1, "Victor");
		os_dly_wait (50);
		GLCD_DisplayString  ( 1,  0, 1, "Yuan");
		os_dly_wait (50);
		GLCD_DisplayString  ( 1,  0, 1, "46642210");

    /*Release the mutex*/
		os_mut_release (&mut_GLCD);
    /* Add Delay*/
		os_dly_wait (50);

		/********** END **********/
  }
}

/*----------------------------------------------------------------------------
 *        Task B: Bargraph control
 *---------------------------------------------------------------------------*/
__task void taskB (void) {
	/********* YOUR CODE GOES HERE **********/

	/* wait for an event flag 0x0001       */
		os_evt_wait_and (0x0001, 0xffff);


	/*************** END ******************/
  for (;;) {           /* endless loop */		
	 /********* YOUR CODE GOES HERE **********/

	 /*Acquire and lock the LCD Mutex				*/
		os_mut_wait (&mut_GLCD, 0xffff);	//control of the mutex is the same as before 

	 /*Display "Task B started"  */
		GLCD_SetBackColor(Blue);
		GLCD_SetTextColor(Red);
		GLCD_DisplayString  ( 2,  0, 1, "Task B started");
		
	
	 /*Adjust offset according to joystick position	*/
	if ((GPIOD->IDR &=1<<13)==0)          /Right
	{
		joystick+=10;
		if (joystick>=1024)
		{
			joystick=1024;
		}	
	}
/----------------------------------------------------------------------------------
	if ((GPIOD->IDR &=1<<15)==0)        	/Left
	{
		joystick-=10;
		if (joystick<=0)
		{
			joystick=0;
		}
	}
/----------------------------------------------------------------------------------
	 /*Display bargraph				*/
		
		GLCD_Bargraph (20,200,300,40,joystick);



	 /*Release the mutex		 */

		os_mut_release(&mut_GLCD);

	/*************** END ******************/
		}
}

/*----------------------------------------------------------------------------
 *        Task C: Push buttons state
 *---------------------------------------------------------------------------*/
__task void taskC (void) {
	/********* YOUR CODE GOES HERE **********/
	/* wait for an event flag 0x0001       */
		os_evt_wait_and (0x0001, 0xffff);

	/*************** END ******************/
  for (;;) {            /* endless loop*/		
		/********* YOUR CODE GOES HERE **********/

		/*Acquire and lock the LCD Mutex*/
			os_mut_wait (&mut_GLCD, 0xffff)

		/*Set background color, set text color*/
			GLCD_SetBackColor(Blue);
			GLCD_SetTextColor(Red);

		/*Display "Task C started" */
			GLCD_DisplayString(5,0,1, " Task C started" );
			
		/*display User, Tamper, WakeUp, buttons state*/
			/user
			if ( !(GPIOB -> IDR & (1<<7)))
			{
				GLCD_DisplayString  ( 9,  0, 1, "User Pressed");
				os_dly_wait (50);

			}	else 	GLCD_DisplayString  ( 9,  0, 1, "");  
			
			/tamper
			if ( !(GPIOC -> IDR & (1<<13)))
			{
				GLCD_DisplayString  ( 9,  0, 1, "Tamper Pressed");
				os_dly_wait (50);

			}	else 	GLCD_DisplayString  ( 9,  0, 1, "");  
			

			/wakeup
			if ( !(GPIOA -> IDR & (1<<0)))
			{
				GLCD_DisplayString  ( 9,  0, 1, "Wakeup Pressed");
				os_dly_wait (50);

			}	else 	GLCD_DisplayString  ( 9,  0, 1, "");  

	

			
    /*Release the mutex*/
		os_mut_release (&mut_GLCD);
		os_dly_wait (50);
			
		/********** END **********/
		}
}
/*----------------------------------------------------------------------------
 * end of file
 *---------------------------------------------------------------------------*/

