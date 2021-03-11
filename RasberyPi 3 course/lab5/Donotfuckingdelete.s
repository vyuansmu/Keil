     .data
        .equ    i_red,   0
        .equ    i_green, 1
        .equ    i_blue,  2
        .equ    i_size,  4
        .equ    NULL,    0
name:   .asciz  "victor yuan"
width:  .word   12
height:  .word   10

        .text

.global main

main:

        ldr r4, =width
        ldr r4, [r4]
        ldr r5, =height
        ldr r5, [r5]

        mul r6, r4,r5
        add r0,r6,r6, lsl #1
        bl malloc
        cmp r0, #NULL
        beq else
        mov r8, r0          @r8 now holds my array
        mov r1, #0         @height
        mov r2, #0        @width
        mov r0, #0

        ldr r7, =name
        bl setrow


        @now part2 of the lab converting to grey scale
        @using r1,2,3 for values for scalar multiple of rgb
        mov r1, #54
        mov r2, #184
        mov r3, #18
        sub r8, r8, #120
        mov r11, #0 @counter, i want rgb2grey to happen 40 times since 120 chracters in my array 3 chracters required for each grey scale conversion

        bl rgb2grey


        mov r0,#0
        mov pc,lr


setrow:
        ldrb r0, [r7], #1       @loads 1 byte-character of my name into array and increases pointer count
        strb r0, [r8], #1       @r0 is the temp place holder
        add r2, r2, #1          @width counter increased by 1 for every letter stored

        cmp r2, #11             @compare r2 counter with total width,12
        ldreq   r7, =name       @if r2 = 12 then these 2 instructions exacute
        addeq   r8,r8,#1        @extra filler to make name 12 increments atm, its 11
        moveq r2, #0          @resets name setter portion

        add r1, r1, #1          @needs to add up to 120 to end
        cmp r1, #110         @remember to change back
        blt setrow
        movge pc, lr


rgb2grey:
        ldrb r4, [r8], #1
        ldrb r5, [r8], #1
        ldrb r6, [r8]   @moved the shift to strb

        mul r7,r1,r4
        mul r9,r2,r5
        mul r10, r3,r6

        add r7, r7,r9       @r7 = r7 + r9
        add r7, r7,r10      @r7= r7+ r9+r10

        lsr r7, #8          @divide by 256
        strb r7,[r8], #1    @store back into array at the last spot
        add r11,r11, #1
        cmp r11, #40
        blt rgb2grey
        movge   pc,lr

else:
