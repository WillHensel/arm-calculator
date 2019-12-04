        .text
        .global _start

_start:
        MOV     R5, SP @save the stack pointer to check later
        LDR     R0, =welcome_prompt
        BL      puts

loop:
        LDR     R0, =request_str
        BL      printf

        LDR     R0, =input_str
        LDR     R1, =input_str_sz
        LDR     R2, =stdin
        LDR     R2, [R2]
        BL      fgets

        LDR     R0, =input_str
        LDR     R1, =num_format_in
        LDR     R2, =x
        BL      sscanf

        CMP     R0, #1
        BNE     check_quit

        LDR     R0, =x
        LDR     R0, [R0]
        PUSH    {R0}
        BL      loop

check_quit:
        LDR     R0, =input_str
        LDRB    R0, [R0]
        CMP     R0, #0x71
        BNE     check_add

        MOV     R0, #0
        BL      exit

check_add:
        LDR     R0, =input_str
        LDRB    R0, [R0]
        CMP     R0, #0x2B
        BNE     check_sub
        BL      add_in

check_sub:
        CMP     R0, #0x2D
        BNE     input_err
        BL      subtract_in

add_in:
        ADD     R0, SP, #4
        CMP     R5, R0      @check if there are enough operators on the stack
        BEQ     operator_err
        POP     {R1, R2}
        LDR     R0, =num_format_out
        ADD     R1, R1, R2
        PUSH    {R1}
        BL      printf
        BL      loop

subtract_in:
        ADD     R0, SP, #4
        CMP     R5, R0      @check if there are enough operators on the stack
        BEQ     operator_err
        POP     {R2, R3}
        LDR     R0, =num_format_out
        SUB     R1, R3, R2
        PUSH    {R1}
        BL      printf
        BL      loop

input_err:
        LDR     R0, =input_err_str
        BL      puts
        BL      loop

operator_err:
        LDR     R0, =operator_err_str
        BL      puts
        BL      loop

        .data
welcome_prompt:
    .asciz  "Enter integers and operators in RPN"
request_str:
    .asciz  "> "
num_format_in:
    .asciz  "%d"
num_format_out:
    .asciz  ">> %d\n"
input_err_str:
    .asciz  "Error: incorrect input"
operator_err_str:
    .asciz  "Error: Not enough numbers in stack to perform operation"
input_str:
    .space  15 @largest 32-bit signed integer is 10 characters long. 15 gives a buffer.
    .equ    input_str_sz, (.-input_str)
x:  .word 0
