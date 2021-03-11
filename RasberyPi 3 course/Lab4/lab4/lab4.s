            .data
buffer:	    .space 4096
i:		    .word 0
sum:		.word 0
prompt1:	.asciz "Enter text (Esc to end):\n"
str1:		.asciz "%s"
            .text
res:        .asciz "the checksum is %d\n"
.global		main

checksum:
            ldr r9, =sum
            ldr r7, =i    @register tracking byte
            mov r7, #0
            ldr r3, =buffer
            mov r2, #0

            loop:

                ldrb r4, [r3], #1

                add r2, r2, r4     @adds value stored in r4 into val of r2 and store in location of r2
                str r2, [r9]
                add r7, r7, #1
                cmp r7, #4096  @max size
            bne loop

            ldr r0, =str1
            mov pc,lr

main:

		ldr r0, =prompt1
		bl printf	@prints out user prompt

		ldr r0, =str1
		ldr r1, =buffer
		bl scanf	@reads first input into  array
		bl checksum
		ldr r1, =sum
		ldr r1, [r1]
        ldr r0, =res
        bl printf
        @wnd time around
        bl checksum
		ldr r1, =sum
		ldr r1, [r1]
        ldr r0, =res
        bl printf

        mov r0,#0
        mov pc,lr
