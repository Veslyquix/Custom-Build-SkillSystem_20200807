.thumb

@inserted inline at 2AEEC

.equ origin, 0x2AAEC
.equ Check_Effectiveness, . + 0x16BEC - origin
.equ Next, . + 0x2AB4A - origin
 
@r6=attacker, r8=defender, r4=attacker+0x5A (attack)
mov		r5,#0    	@value #0 into register 5
cmp		r0,#0    	@if attack is 0, go to label 1?
beq		Label1
mov		r5,r0    	@otherwise, put attack into r5 ?
Label1:
ldrh	r0,[r7]		@attacker's item
mov		r1,r8		@defender into register 1
bl		Check_Effectiveness
cmp		r0,#0  @	
beq		Label2 @
cmp		r0,r5  @
ble		Label2 @
mov		r5,r0 		@break / do nothing
Label2:
mov		r0,#0   	@
ldsh		r0,[r4,r0] @current attack
@cmp		r5,#0    		@needed for weapon MT
@beq		Label3   		@needed for weapon MT 
mul		r0,r5
lsr		r0,#1
Label3:
mov		r5,r0 			@break / do nothing
b		Next
