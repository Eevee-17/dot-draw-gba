@define BLACK %0000000000000000 ; -bbbbbgggggrrrrr
@define WHITE %0111111111111111 ; "


b start
@include header.h


COLBLACK
@dcw BLACK, BLACK

COLWHITE
@dcw WHITE, WHITE


start
ldr r0,=0x04000000 ; I/O

ldr r1,=%0000010000000011 ; turn on BG2, set BG mode to 3
str r1,[r0]

ldr r1,[COLWHITE]
str r1,[r0,0xD4] ; DMA 3 source address

ldr r1,=0x06000000 ; VRAM
str r1,[r0,0xD8] ; DMA 3 destination address

ldr r2,[COLBLACK] ; initial dot color
ldr r3,=240 ; initial x-pos represented by x = x-pos px * 2
ldr r4,=38400 ; initial y-pos represented by y = y-pos px * 240 * 2

clearScreen
ldr r5,=(0x85000000|19200) ; 0x85000000 (check binary): enable DMA, set 32-bit transfer type, and set as fixed source. 19200: 240px * 160px / 2
str r5,[r0,0xDC] ; DMA 3 control

b drawDot

mainLoop
; wait for VBlank
waitVBEnd
ldrh r5,[r0,0x06] ; V counter
cmp r5,0
bne waitVBEnd
waitVBStart
ldrh r5,[r0,0x06] ; "
cmp r5,160
bne waitVBStart

ldr r5,[r0,0x0130] ; key input register

ldr r6,=75840 ; 75840 = 158px * 240 * 2
cmp r4,r6
tstle r5,0x80 ; test for D-pad Down pressed
addeq r4,r4,480 ; 480 = 1px * 240 * 2

ldr r6,=480 ; 480 = 1px * 240 * 2
cmp r4,r6
tstge r5,0x40 ; test for D-pad Up pressed
subeq r4,r4,480 ; 480 = 1px * 240 * 2

ldr r6,=2 ; 2 = 1px * 2
cmp r3,r6
tstge r5,0x20 ; test for D-pad Left pressed
subeq r3,r3,2 ; 2 = 1px * 2

ldr r6,=476 ; 476 = 238px * 2
cmp r3,r6
tstle r5,0x10 ; test for D-pad Right pressed
addeq r3,r3,2 ; 2 = 1px * 2

tst r5,0x01 ; test for A pressed
ldr r2,[COLBLACK]
ldreq r2,[COLWHITE]

tst r5,0x02 ; test for B pressed
beq clearScreen

drawDot ; note: the formula for the position in VRAM to draw a point is y * 240 + x
add r5,r3,r4
strh r2,[r1,r5]
b mainLoop