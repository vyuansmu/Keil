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

setrow:
        ldrb r0, [r7], #1       @loads 1 byte-character of my name into array and increases pointer count
        strb r0, [r8], #1       @r0 is the temp place holder
        add r2, r2, #1          @width counter increased by 1 for every letter stored
        cmp r2, #11             @compare r2 counter with total width,12
        ldreq   r7, =name       @if r2 = 12 then these 2 instructions exacute
        addeq   r8,r8,#1        @extra filler to make name 12 increments atm, its 11
        bne setrow
        add r1, r1, #1          @height tracker +1 every time a row is completed

        cmp r1, #10             @untill height = 10
        movne r2, #0            @if not then reset width counter and start again
        bne setrow
















else:
