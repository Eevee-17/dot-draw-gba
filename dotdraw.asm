@define WHITE %0111111111111111 ; -bbbbbgggggrrrrr


b start
@include header.asm

COLWHITE:
@dcw WHITE, WHITE


start:
mov r0,0x04000000 ; I/O

@dcd 0xE51F1078; ldr r1,=%0000010000000011 ; turn on BG2, set BG mode to 3 ; Optimization note: I need to set r1 to 0x0403. I got lucky, and 0x0403 can be found in the header in a good spot for the GBA to access it.
str r1,[r0]

ldr r1,[COLWHITE]
str r1,[r0,0xD4] ; DMA 3 source address

mov r1,0x06000000 ; VRAM
str r1,[r0,0xD8] ; DMA 3 destination address

; Optimization note: r2 is zero-filled on start, so I don't need to set it to zero.
mov r3,0xF0; 0xF0 = 240 ; initial x-pos represented by x = x-pos px * 2
mov r4,0x9600; 0x9600 = 38400 ; initial y-pos represented by y = y-pos px * 240 * 2

clearScreen:
ldr r5,=(0x85000000|#19200) ; 0x85000000 (check binary): enable DMA, set 32-bit transfer type, and set as fixed source. 19200: 240px * 160px / 2
str r5,[r0,0xDC] ; DMA 3 control

b drawDot

mainLoop:
; wait for VBlank
waitVBEnd:
ldrh r5,[r0,0x06] ; V counter
cmp r5,#0
bne waitVBEnd
waitVBStart:
ldrh r5,[r0,0x06] ; "
cmp r5,#160
bne waitVBStart

ldr r5,[r0,0x0130] ; key input register

ldr r6,=#75840 ; 75840 = 158px * 240 * 2
cmp r4,r6
tstle r5,0x80 ; test for D-pad Down pressed
addeq r4,r4,#480 ; 480 = 1px * 240 * 2

mov r6,0x1E0; 0x1E0 = 480 ; 480 = 1px * 240 * 2
cmp r4,r6
tstge r5,0x40 ; test for D-pad Up pressed
subeq r4,r4,#480 ; 480 = 1px * 240 * 2

mov r6,0x2 ; 2 = 1px * 2
cmp r3,r6
tstge r5,0x20 ; test for D-pad Left pressed
subeq r3,r3,#2 ; 2 = 1px * 2

ldr r6,=#476 ; 476 = 238px * 2
cmp r3,r6
tstle r5,0x10 ; test for D-pad Right pressed
addeq r3,r3,#2 ; 2 = 1px * 2

tst r5,0x02 ; test for B pressed
beq clearScreen

tst r5,0x01 ; test for A pressed
beq mainLoop

drawDot: ; note: the formula for the position in VRAM to draw a point is y * 480 + x * 2 (or 2 * (y * 240 + x))
add r5,r3,r4
strh r2,[r1,r5]
b mainLoop
