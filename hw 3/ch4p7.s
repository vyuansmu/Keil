		.data
val3:		.word 1







		.text
.global		main

a: @10
		mov r1, #10
		mov r0, #0

		loop1:
		add r0, r0, r3
		sub r1, r1, #1
		cmp r1, #0
		bgt loop1
		mov pc, lr

b: @100	
		mov r1, #100
		mov r0, #0

		loop1:
		add r0, r0, r3
		sub r1, r1, #1
		cmp r1, #0
		bgt loop1
		mov pc, lr

c: @575
		mov r1, #575
		mov r0, #0

		loop1:
		add r0, r0, r3
		sub r1, r1, #1
		cmp r1, #0
		bgt loop1
		mov pc, lr

d: @123

		mov r1, #123
		mov r0, #0

		loop1:
		add r0, r0, r3
		sub r1, r1, #1
		cmp r1, #0
		bgt loop1
		mov pc, lr



main: 
		

		bl a
		bl b
		bl c
		bl d