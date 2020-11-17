.thumb

@r0=attacker's item id, r1=defender battle struct, then effectiveness ptr v1
@r4 = effectiveness pointer by POP, r5 = defender battle struct 

.equ NullifyID, SkillTester+4

push	{r4-r7,r14}
mov		r4,r0
mov		r5,r1
ldr		r0,[r5,#0x4]
cmp		r0,#0
beq		RetFalse
mov		r0,r4
ldr		r3,=#0x80176D0		@get effectiveness pointer
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		RetFalse			@if weapon isn't effective, end
ldr		r1,[r5,#0x4] 	@class pointer of defender I think
mov		r6,#0x50
ldr		r6,[r1,r6]			@class weaknesses
cmp		r6,#0
beq		RetFalse			@if class has no weaknesses, end

mov		r4,r0				@save effectiveness ptr
mov		r7,#0				@inventory slot counter
ProtectiveItemsLoop:
lsl		r0,r7,#1
add		r0,#0x1E
ldrh	r0,[r5,r0]
cmp		r0,#0
beq		EffectiveWeaponLoop
mov		r1,#0xFF	@class pointer is N/A now
and		r0,r1
ldr		r3,=#0x80177B0		@get_item_data
mov		r14,r3
.short	0xF800
ldr		r1,[r0,#0x8]		@weapon abilities
mov		r2,#0x80
lsl		r2,#0x7				@delphi shield bit, aka 'protector item'
tst		r1,r2
beq		NextItem
ldr		r1,[r0,#0x10]		@pointer to classes it protects
cmp		r1,#0
beq		NextItem
ldrh	r1,[r1,#2]
bic		r6,r1				@remove bits that are protected from the class weaknesses bitfield
cmp		r6,#0
beq		RetFalse
NextItem:
add		r7,#1
cmp		r7,#4
ble		ProtectiveItemsLoop

EffectiveWeaponLoop:
ldrh	r1,[r4,#2]			@bitfield of types this weapon is effective against
cmp		r1,#0
beq		RetFalse
and		r1,r6				@see if they have bits in common
cmp		r1,#0
bne		NullifyCheck
add		r4,#4
b		EffectiveWeaponLoop

NullifyCheck:
mov		r0,r5
ldr		r1,NullifyID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
bne		RetFalse
ldrb	r0,[r4,#0x1]		@coefficient of effectiveness pointer

mov r8, r7
ldr r7,=#0x203A4EC @attacker struct
mov	r14,r3
cmp		r0,#1
beq		Ineffective
cmp		r0,#0
beq		No_Effect
mov r3, #0x64 		@0x64 entry as battle hit
mov r2,r7 		@attacker battle struct					
ldsh r2, [r7, r3] 	@hit 
add r2, r2, #30		@+30 attacker 
strh r2, [r7, r3] 	@put our hit back into attacker battle struct

mov r2,r5 		@defender battle struct					
ldsh r2, [r5, r3] 	@hit 
sub r2, r2, #15		@-15 hit for defender
strh r2, [r5, r3] 	@put their hit back into r5 

mov	r3,r14
mov     r7, r8
b	GoBack


Ineffective:
mov r3, #0x64 		@0x64 entry as battle hit
mov r2,r7 		@attacker battle struct					
ldrh r2, [r7, r3] 	@hit 
sub r2, r2, #15		@-15 attacker 
strh r2, [r7, r3] 	@put our hit back into attacker battle struct

mov r3, #0x5A 		@0x5A entry as attack //subtracting att didn't work properly
mov r2,r7 		@attacker battle struct					
ldrh r2, [r7, r3] 	@dmg 
add r2, r2, #3		@-15 attacker 
strh r2, [r7, r3] 	@put our att back into attacker battle struct

mov	r3,r14
mov     r7, r8
b	GoBack

No_Effect:
mov r3, #0x64 		@0x64 entry as battle hit
mov r2,r7 		@attacker battle struct					
ldsh r2, [r7, r3] 	@hit 
sub r2, r2, #50		@-50 hit attacker 
strh r2, [r7, r3] 	@put our hit back into attacker battle struct

mov r3, #0x5A 		@0x64 entry as battle hit
mov r2,r7 		@attacker battle struct					
ldsh r2, [r7, r3] 	@hit 
sub r2, r2, #50		@-50 attack 
strh r2, [r7, r3] 	@put our att back into attacker battle struct

mov	r3,r14
mov     r7, r8
b	GoBack

RetFalse:
mov		r0,#0

GoBack:
pop		{r4-r7}
pop		{r1}
bx		r1

.ltorg
SkillTester:
@
