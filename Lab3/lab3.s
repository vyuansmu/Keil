		.data
msg1:
		.asciz "Enter num1\n"
msg2:
		.asciz "Enter num2\n"

res:
		.asciz "num1 + num2 =%d\n"

str1:		.asciz "%d"

x:		.word 0
y:		.word 0

		.text
.global		main
main:
		ldr r0, =msg1
        bl printf
		ldr r0, =str1
		ldr r1, =x
		bl scanf

		ldr r0, =msg2
		bl printf
		ldr r0, =str1
		ldr r1, =y
		bl scanf


		ldr r0, =x
		ldr r2, [r0]

		ldr r0, =y
		ldr r3, [r0]

		add r1,r2,r3


		ldr r0, =res
		bl printf

stop:		B stop












