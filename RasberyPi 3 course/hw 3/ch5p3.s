		.data
max:		.word 0


		.text
.global		main

max1:					@r1 = a r2 = b
		mov r1, #1		@a = 1 b =2 r1= 
		mov r2, #2
		cmp r1, r2
		bgt else
		mov r3, [r2]
		b after
		else: mov r3, [r1]
		after: ldr r0, =max
		str r3, [r0]
		
		mov pc, lr



main:
		bl max1


		mov r0, #0
		mov pc, lr