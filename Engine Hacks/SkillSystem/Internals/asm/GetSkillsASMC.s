
	.thumb

	@ unit loading routine

	@ 8017ef4 handles supports, this oughta be a good place to branch off imo

	@ jumptohack at 8017EF4

	lAutoloadSkills   = EALiterals+0x00
@	lGetSkills        = EALiterals+0x04
@	lChargeupTable    = EALiterals+0x08

	BWLTable = 0x0203E884

	.macro blh to, reg=r3
		ldr \reg, =\to
		mov lr, \reg
		.short 0xf800
	.endm

.global GetSkillsASMC
.type GetSkillsASMC, %function

GetSkillsASMC: @ Input is in memory slot 0x1.

	@r0 contains ram data
	push {r4-r7, lr}
	ldr r0, =#0x202CFBC @added
	mov r5, r0


ldr r1, =0x030004BC
ldr r0, [ r1 ] @ r1 has unit pointer to refresh learned skills of.
	@ldr r0, =#0x880437C @knoll's unit pointer
	str r0, [r5] 		@insert our own unit pointer here and test




	@r0 is 202CFBC
	@[0203A4FF]!

	@ let's uh clear out the existing skills first... just in case


	ldr  r4, [r5]	@0804A64 Morva's unit pointer

	@ldr r2, =#0x0203A4EC	@attacker	
	@mov r1, #0x13
	@ldrsb r2, [r2,r1] @curr hp
	@mov r1, #3
	@strb r1, [r2, #3]

	ldrb r4, [r4, #4] @char num in r4 @0x41


	cmp r4, #0x46
	bhi no_skills

	ldr r0, =BWLTable
	lsl r1, r4, #4 @ r1 = char*0x10
	add r0, r1
	add r0, #1 @ start at byte 1, not 0

	mov  r1, #0
	strb r1, [r0]
	strb r1, [r0, #1]
	strb r1, [r0, #2]
	strb r1, [r0, #3]

	ldr r3, lAutoloadSkills

	mov r0, r5 @ arg r0 = Unit

	bl BXR3

no_skills:
	@ avoid skill forgetting issues after loading units that learn more than 4 skills
	mov  r0, #0
	ldr  r1, =0x0202BCDE
	strh r0,[r1]

	@ original
	mov r0, r5
	blh 0x080281C8
	ldr r6, =0x08017EFD
	bx  r6

BXR3:
	bx r3

	@ AddCharge:
	@ push {r4}
	@ mov r0, r5 @char data
	@ ldr r2, lGetSkills
	@ mov lr, r2
	@ .short 0xf800
	@ mov r4, r0 @ skill buffer
	@ Main_loop: @ loop through skills checking if they're chargeable
	@ ldrb r1, [r4]
	@ cmp r1, #0
	@ beq End_main
	@   ldr r0, lChargeupTable
	@   Loop:
	@   ldrb r2,[r0]
	@   add r0,#2
	@   cmp r2,#0
	@   beq Next
	@   cmp r2,r1
	@   bne Loop
	@   sub r0,#0x1
	@   ldrb r0,[r0]
	@   add r0,#0x10
	@   mov r2,#0x47
	@   strb r0,[r5,r2]
	@   Next:
	@   add r4, #1
	@   b Main_loop
	@ End_main:
	@ pop {r4}

	.pool
	.align

EALiterals:
	@ POIN (AutoloadSkills|1)
	@ POIN (Skill_Getter|1)
	@ POIN ChargeupTable