.data

.balign 4
return: .word 0

.balign 4
printPattern: .asciz "%s\n"

.balign 4
printPatternC: .asciz "%c\n"

.balign 4
printTestString: .asciz "I ran \n"


.balign 4 
postfixStr: .skip 250 

.balign 4 
initalStr: .word 250



.text 
.global main
main:
    ldr r0,=return
    str lr,[r0]
    ldr r1,[r1, #4] @grabs the command line arg
    ldr r2,=initalStr
    str r1,[r2]
    mov r2,#0 @ counter through string
    ldr r10,=postfixStr @ new string
    mov r5,#0 @ what type of operation it is 
    mov r6,#0 @ length of stack 
    ldr r9,=initalStr
    ldr r9,[r9]
    mov r3,#95
    b postfix_conversion

convert_back_to_ascii:
    cmp r5, #2 @is open parenthesis 
    moveq r5,#0
    cmp r5, #1 @is close parenthesis
    moveq r5,#0
    cmp r5, #5 @is mult
    moveq r5,#42
    cmp r5, #6 @is add
    moveq r5,#43
    cmp r5, #7 @is minus
    moveq r5,#45
    cmp r5, #4 @is division
    moveq r5,#47
    cmp r5, #3 @is exp
    moveq r5,#94
    cmp r5, #8
    moveq r5,#0

    bx lr

cont_pop:
    @ cmp r8,#2
    @ beq cont_pop_par
    cmp r6,#0
    moveq r5,r8
    beq swap_open_par_2
    @ streq r5, [sp, #-4]!
    @ addeq r6,#1
    @ beq postfix_conversion
    ldr r5, [sp], #4
    bl convert_back_to_ascii
    cmp r5,#0
    subeq r6,#1
    beq cont_pop
    str r5,[r10,r2]
    add r2,#1
    sub r6,#1
    b cont_pop

cont_pop_par:
    ldr r5, [sp], #4
    sub r6,#1
    cmp r5,#8
    beq postfix_conversion
    bl convert_back_to_ascii
    str r5,[r10,r2]
    add r2,#1
    b cont_pop_par

swap_open_par_2:
    cmp r5,#1
    moveq r5,#8
    str r5, [sp, #-4]!
    add r6,#1
    b postfix_conversion 


swap_open_par:
    cmp r5,#1
    moveq r5,#8
    bx lr 

stack_manager:
    cmp r5,#2
    beq cont_pop_par
    cmp r5,#1
    strne r3,[r10,r2]
    addne r2,#1
    cmp r6,#0
    bleq swap_open_par
    streq r5, [sp, #-4]! @ pusheq{r5}
    addeq r6,#1
    beq postfix_conversion
    mov r8, r5
    ldr r5, [sp], #4 @ pop{r5}
    cmp r8,r5
    str r5, [sp, #-4]! @ push{r5}
    bge cont_pop
    mov r5,r8
    bl swap_open_par
    str r5, [sp, #-4]! @ push{r5}
    add r6,#1
    
    
postfix_conversion:
    
    ldrb r4,[r9],#1
    @ mov r1,r4
    @ ldr r0,=printPatternC
    @ bl printf 
    cmp r4, #0x00
    streq r3,[r10,r2]
    addeq r2,#1
    beq end_conversion
    cmp r4, #40 @is open parenthesis 
    moveq r5,#1
    beq stack_manager
    cmp r4, #41 @is close parenthesis
    moveq r5,#2
    beq stack_manager
    cmp r4, #42 @is mult
    moveq r5,#5
    beq stack_manager
    cmp r4, #43 @is add
    moveq r5,#6
    beq stack_manager
    cmp r4, #45 @is minus
    moveq r5,#7
    beq stack_manager
    cmp r4, #47 @is division
    moveq r5,#4
    beq stack_manager
    cmp r4, #94 @is exp
    moveq r5,#3
    beq stack_manager

    str r4,[r10,r2]
    add r2,#1
    b postfix_conversion
    



end_conversion:
    cmp r6,#0
    beq calculate
    ldr r5, [sp], #4
    bl convert_back_to_ascii
    str r5,[r10,r2]
    add r2,#1
    sub r6,#1
    b end_conversion

calculate: 
    ldr r1,=postfixStr
    ldr r0,=printPattern
    bl printf 

exit:
    ldr lr,=return
    ldr lr,[lr]
    bx lr

.global printf


