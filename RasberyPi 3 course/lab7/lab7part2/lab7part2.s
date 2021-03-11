
        .data
str1:   .asciz  "%s"
num:    .asciz  "%s%s%s%s%s%s%s"
p1:     .word   0
p2:     .word   0
prompt1: .asciz "Enter a 4 binimal base 2 number(Only Binary!)\n"
ans:    .asciz  "The number you entered is %d."
ans2:  .asciz "%d\n"


        .text
        .global main

main:
        ldr r0, =prompt1
        bl printf
        ldr r0, =str1
        ldr r1, =num
        bl scanf
        ldr r4,=num
         mov r1, #0
    count:                      //counts amt of lsl needed
        ldrb r5, [r4],#1
        cmp  r5, #0x2e
        addne r1, #1
        bne   count
        ldr r0, =p1

        sub r4,r4, r1         //resets r4
        sub r4, #1
        sub r1, #1
    loop:

        ldrb r5, [r4], #1       //all values in r5 should be 0 or 1

        cmp r5, #0x2e   //compare byte to .
        streq r7, [r0]
        beq afterDec           //if the byte is not equal to . then cont untill . is seen

        sub r6, r5, #0x30 //conversion to 0 or 1
        lsl r6, r1      //if r6 is 0 then left shifting it by 2^(r1) wont matter
        add r7, r7, r6
        sub r1, r1, #1      //decrease the shift counter by 1
        b   loop



    afterDec:

        ldr r0, =p2

        mov r1, #100
        mov r2, #50
        mul r2, r2, r1
        mul r2, r2, r1
        mul r2, r2, r1  //do this 3 times for 50,000,000
        mov r1, #0
        mov r7, #0  //r7 still holds the number
        //at the start of the loop r2 holds 50,000,000
        //goal to have it become 00,390,625 at the end
        //to do this divide 50m by 2, 7 times lsr, 1 each time
    loop2:
        ldrb r5, [r4], #1
        sub  r6, r5, #0x30
        mul r6, r6, r2     //r6 is either 0 or 1 r2 is 50m divided by 2 every time it loops
        add r7, r7, r6
        lsr r2, #1
        add r1, #1
        cmp r1, #8
        blt loop2

        str r7, [r0]





        ldr r7, =p1
        ldr r7, [r7]
        mov r6, r7          //r6,r7 both holds binary _ _ _ _ number






        ldr r1, =p1
        ldr r1, [r1]
        ldr r0, =ans
        bl printf

        ldr r1, =p2
        ldr r1, [r1]
        ldr r0, =ans2
        bl printf





        mov r0,#0
        mov pc,lr
