            .data
p:          .word 0
n:          .word 0
d:          .word 0
q:          .word 0
avg:        .word 0
prompt1:    .asciz "this week enter # of penny\n"
prompt2:    .asciz "this week enter # of nickel\n"
prompt3:    .asciz "this week enter # of dime\n"
prompt4:    .asciz "this week enter # of quarter\n"
acp:        .asciz "you have #%d number of pennies\n"
acn:        .asciz "you have #%d number of nickels\n"
acd:        .asciz "you have #%d number of dimes\n"
acq:        .asciz "you have #%d number of quarters\n"
str1:		.asciz "%d"
aValD:      .asciz "You have $%d"
aValC:      .asciz ".%d \n"
wklyAD:      .asciz "Your weekly avg is $%d"
wklyAC:      .asciz ".%d \n"
yestAD:      .asciz "Your yearly est is $%d"
yestAC:      .asciz ".%d \n"
            .text
        .global main

main:
        mov r6, #0          @loop counter should go up to 4 for 4 weeks
        mov r7, #0
        mov r8, #0
        mov r9, #0
        mov r10, #0


loop:
       //pennies
        ldr r0, =prompt1
        bl printf
        ldr r0, =str1
        ldr r1, =p
        bl scanf
        ldr r1, =p
        ldr r1,[r1]
        add r7, r7,r1     @load value of peny into  r7


        //nickels
        ldr r0, =prompt2
        bl printf
        ldr r0, =str1
        ldr r1, =n
        bl scanf
        ldr r1, =n
        ldr r1,[r1]
        add r8,r8,r1

        //dimes
        ldr r0, =prompt3
        bl printf
        ldr r0, =str1
        ldr r1, =d
        bl scanf
        ldr r1, =d
        ldr r1,[r1]
        add r9,r9,r1


        //q's
        ldr r0, =prompt4
        bl printf
        ldr r0, =str1
        ldr r1, =q
        bl scanf
        ldr r1, =q
        ldr r1,[r1]
        add r10,r10, r1

add r6, r6, #1   //r6 is loop counter
cmp r6, #4         //4 is the controll variable in this case 4 weeks
blt loop
        ldr r1, =p
        ldr r2, =n
        ldr r3, =d
        ldr r4, =q

        str r7, [r1]
        str r8, [r2]
        str r9, [r3]
        str r10, [r4]


        ldr r1, =p
        ldr r1, [r1]
        ldr r0, =acp
        bl printf

        ldr r1, =n
        ldr r1, [r1]
        ldr r0, =acn
        bl printf

        ldr r1, =d
        ldr r1, [r1]
        ldr r0, =acd
        bl printf

        ldr r1, =q
        ldr r1, [r1]
        ldr r0, =acq
        bl printf

@#of coins has been printed


        mov r6, #0
        ldr r1, =p
        ldr r2, =n
        ldr r3, =d
        ldr r4, =q

        ldr r1, [r1]
        ldr r2, [r2]
        ldr r3, [r3]
        ldr r4, [r4]

        mov r7, #5
        mov r8, #10
        mov r9, #25
        mov r11, #82
        //r1 does not need mul bc it would be just X *1
        mul r2, r2, r7 //nickel
        mul r3, r3, r8  //dime
        mul r4, r4, r9  //quater values

        add r6, r6, r1
        add r6, r6, r2
        add r6, r6, r3
        add r6, r6, r4  @r6 holds the total sum in cents only convert to decimal?
        mov r8, r6         //r8 now holds a copy of original total value in cents
        mul r6,r6, r11          @division
        lsr r7, r6, #13         @fuck you, holds dollar amount with cents truncated
        mov r9, #100            @holds constant for multiplication


        mul r9, r7, r9
        sub r8, r8, r9      @r7 has dollars r6 has cents



        mov r1, r7
        ldr r0, =aValD
        bl printf


        mov r1, r8
        ldr r0, =aValC
        bl printf
        add r10, r8,r9




        lsr r10, #2   //4 weeks divide by 4

        mov r0, #82
        mov r11,r10         //makes of current value of r10
        mul r10, r10, r0          @division by 100
        lsr r7, r10, #13            @dollar amt is held in r7

        mov r0, #100
        mul r8, r0, r7
        sub r8, r11, r8

        mov r1, r7
        ldr r0, =wklyAD
        bl printf


        mov r1, r8
        ldr r0, =wklyAC
        bl printf
//yearly estimate
        mov r0, #52
        mul r10, r11,r0         //yearly estimate in cents, -> convert now

        mov r0, #82
        mov r11,r10             //copy
        mul r10,r10,r0
        lsr r7, r10, #13

        mov r0, #100
        mul r8, r0, r7
        sub r8, r11, r8

        mov r1, r7
        ldr r0, =yestAD
        bl printf

        mov r1, r8
        ldr r0, =yestAC
        bl printf


        mov r0,#0
        mov pc,lr
