.thumb

@inserted inline at 2AEEC // Adding onto this will probably overwrite data, then

.equ origin, 0x2AAEC
@.equ Check_Effectiveness, . + 0x16BEC - origin
.equ Check_Effectiveness,  0x8016BEC
.equ Next, . + 0x2AB4A - origin
 
@r6=attacker, r8=defender, r4=attacker+0x5A (attack)

push { r14 }

mov		r5,#0
cmp		r0,#0			@if attack is 0, go to label 1?
beq		Label1
mov		r5,r0			@otherwise, put attack into r5 ?

Label1:
ldrh	r0,[r7]		@attacker's item
mov		r1,r8			@defender into register 1

@ldr r3,=#0x8016BEC		@check effectiveness pointer

ldr r3,=Check_Effectiveness
mov r14,r3
.short 0xF800

@bl		Check_Effectiveness
cmp		r0,#0			@ dunno but commenting out 
beq		Label2			@ 2 lines at a time didn't make
cmp		r0,r5			@ a quickly noticable
ble		Label2			@ difference 
mov		r5,r0			@no effectiveness I think
b		GoBack

Label2:
mov		r0,#0
ldsh	r0,[r4,r0]	@current attack
cmp		r5,#0			@commenting these 2 lines out seems to
beq		Label3			@remove weapon MT entirely

mul		r0,r5			@must be MT times effectiveness coefficient
lsr		r0,#1			@it is effective
b		GoBack

@push {r6}
@ldr r6,=#0x203A4EC @attacker struct
@mov r3, #0x64 		@0x64 entry as battle hit
@mov r2,r6 		@attacker battle struct					
@ldr r2, [r6, r3] 	@hit 
@add r2, r2, #30		@+30 attacker 
@str r2, [r6, r3] 	@put our hit back into attacker battle struct
@pop {r6}


@mov r2,r5 		@defender battle struct					
@ldr r2, [r5, r3] 	@hit 
@sub r2, r2, #15		@-15 hit for defender
@str r2, [r5, r3] 	@put our hit back into r7 

@added these lines	
@mov r2,r6 			
@mov r5, #0x64 				@atkr into register 4 @hit is 0x60 entry into attacker
@ldr r2, [r6, r5] 			@hit 
@add r2, r2, #30			@+30 hit. 
@str r2, [r6, r5] 			@put our hit back into r0 maybe?
@added these lines

@added these lines
@mov r2, r8
@add     r1,#0x62    @Move to the defender's avoid.
@ldrh    r2,[r1]     @Load the defender's avoid into r2.
@sub     r2,#10    @subtract 10 from the attacker's avoid
@strh    r2, [r6, r1]     @Store defender avoid


@mov r2, r6 				@atkr into register 2
@mov r1, #0x60
@ldrh r2, [r6, r1] 			@hit 
@add r2, r2, #30				@+30 hit. 
@strh r2, [r4, r1] 			@put our hit back into r6 maybe?
@added these lines			@this instead seems to add +30 dmg to effective weapons

Label3:
mov		r5,r0			@no effectiveness 
b		GoBack


GoBack:
pop {r0}
bx    r0
