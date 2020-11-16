.thumb
.org 0x0

@r0=battle struct
mov		r2, r0		@BattleUnit

@If you're far distance, then Magic Motion.
ldr		r1,=0x0203e120	@gSomethingRelatedToAnimAndDistance
ldrh	r0,[r1]
cmp		r0,#0x00        @Check Distance != 0
bne		RangeMotion		@range motion.

@If not Arena, Melee Motion.
@in Arena, Distance is 0.
ldr		r1,=0x0203E1E4 @gBoolIsArena
ldr		r0,[r1]
cmp		r0,#0x00
beq		MeleeMotion

@If not Arena and weapon->range >=2 , then RangeMotion
mov		r0,r2
add		r0,#0x48
ldrh	r0,[r0]   @ItemID
lsl		r0,#0x18
lsr		r0,#0x18

mov		r1,#0x24
mul		r0,r1
ldr		r1,ItemTable
add		r1,r0

mov		r0, #0x19    @Weapon Range
ldrb	r0, [r1 ,r0]

mov		r1, #0xf
and		r0, r1

cmp		r0, #0x2     @if range >= 2
bge		RangeMotion

MeleeMotion:
mov 	r0,#0x0
b		Exit

RangeMotion:
mov 	r0,#0x1

Exit:
bx		r14

.ltorg
ItemTable:
@
