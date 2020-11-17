.thumb
.equ PerfectionistID, SkillTester+4

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@hp not at full
ldrb r0, [r4, #0x12] @max hp
ldrb r1, [r4, #0x13] @curr hp
cmp r0, r1
bne End @skip if not max hp

08016bec .thumb
08016bec IsWeaponEffectiveAgainst


mov		r0,r4 @put atkr back into r0

ldr		r0,[r5]
ldr		r0,[r0,#0x28]
ldr		r1,[r5,#0x4]
ldr		r1,[r1,#0x28]
orr		r0,r1
mov		r1,#0x1			@is defender mounted
tst		r0,r1
bne		GoBack

GoBack:
pop		{r4-r5}
pop		{r0}
bx		r0




@has Perfectionist
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, PerfectionistID
.short 0xf800
cmp r0, #0
beq End

@add 30 hit and 15 avoid
mov r1, #0x60
ldrh r0, [r4, r1] @hit
add r0, #30
strh r0, [r4,r1]
mov r1, #0x62
ldrh r0, [r4, r1] @avoid
add r0, #15
strh r0, [r4,r1]

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD PerfectionistID
