        .data
str1:   .asciz  "%s"
num:    .asciz  "%s%s%s%s%s%s%s"
p1:     .word   0
p2:     .word   0
prompt1: .asciz "enter a 4 decimal base 10 number\n"
ans:   .asciz  "The number you entered is %x."
ansp1:   .asciz  "%x"
ansp2:   .asciz  "%x\n"
hex1:   .word   0
hex2:   .word   0
hex3:   .word   0
hex4:   .word   0

        .text
        .global main

main:
        mov r7, #0


        ldr r0, =prompt1
        bl printf
        ldr r0, =str1
        ldr r1, =num
        bl scanf
        ldr r4,=num

        ldr r0, =p1
        mov r1, #10
    loop:

        ldrb r5, [r4], #1
        cmp r5, #0x2e
        mulne r7, r7, r1
        subne r6, r5, #0x30 //now r6 holds first first digit
        addne r7, r7, r6

        bne loop

        str r7, [r0]
        //shifts it 1 more time to ignore 2e
        //ends loop once 0x2e is detected,and stores total DECIMAL num in p1

        ldr r0, =p2
        mov r7, #0 //resets register for the 2nd half of the number after decimal
        mov r2, #0  //4 decimal palces

    loop2:


        ldrb r5, [r4], #1
        sub  r6, r5, #0x30
        add r7, r7, r6


        add r2, #1
        cmp r2, #4
        mulne r7, r7, r1
        bne loop2

        str r7, [r0]            //makes a copy of the number and store it at "p2:"
        mov r6, r7              //makes a copy of the number into r6
        lsl r7, #4

        mov r12, #105           //these 3 lines
        mul r7, r7,r12          //.
        lsr r7, #20             //are = dividing by 10,000, chop off the digits at the end

        ldr r0, =hex1
        str r7, [r0]

        mov r12, #100
        mul r7, r7, r12
        mul r7, r7, r12         //multiply by 100 2 times is = mul by 10,000 other ways of doing this aswell

        lsl r6, #4
        sub r6, r6, r7
//at this point hex1, the first number after the heximal(radix, decimal for hex numbers) is stored repeat this 3 more times
//for total of 3 decimal? heximal? places
        mov r7, r6
        lsl r7, #4
        mov r12, #105
        mul r7, r7,r12
        lsr r7, #20
        ldr r0, =hex2
        str r7, [r0]
        mov r12, #100
        mul r7, r7, r12
        mul r7, r7, r12
        lsl r6, #4
        sub r6, r6, r7
//heximal place 2 completed
        mov r7, r6
        lsl r7, #4
        mov r12, #105
        mul r7, r7,r12
        lsr r7, #20
        ldr r0, =hex3
        str r7, [r0]
        mov r12, #100
        mul r7, r7, r12
        mul r7, r7, r12
        lsl r6, #4
        sub r6, r6, r7
//hex3 complete
        mov r7, r6
        lsl r7, #4
        mov r12, #105
        mul r7, r7,r12
        lsr r7, #20
        ldr r0, =hex4
        str r7, [r0]
        mov r12, #100
        mul r7, r7, r12
        mul r7, r7, r12
        lsl r6, #4
        sub r6, r6, r7
//hex4 complete now to write the print out statement


        ldr r10, =p1
        ldr r11, =p2
        ldr r10, [r10]
        ldr r11, [r11]

        ldr r1, =p1
        ldr r1, [r1]
        ldr r0, =ans
        bl printf


        ldr r1, =hex1
        ldr r1, [r1]
        ldr r0, =ansp1
        bl printf

        ldr r1, =hex2
        ldr r1, [r1]
        ldr r0, =ansp1
        bl printf

        ldr r1, =hex3
        ldr r1, [r1]
        ldr r0, =ansp1
        bl printf

        ldr r1, =hex4
        ldr r1, [r1]
        ldr r0, =ansp2      //switched to ansp2 for the "/n for formating issues"
        bl printf









        mov r0,#0
        mov pc,lr




