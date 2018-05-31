    .data
int_format_string: .asciz " %d"
select_number: .asciz "Select a number (1. Push 2. Pop 3. Stack print 4. Exit): "
type_number_push: .asciz "Type a value to push: "
print_popped_value: .asciz "The popped value is: %d\n"
print_stack1: .asciz "The stack content is:  %d, %d, %d, "
print_stack2: .asciz "%d, %d COUNTER: %d\n"
print_stack_overflow: .asciz "Stack Overflow\n"
print_stack_empty: .asciz "Stack empty\n"

    .align
menu:   .word 0
top:  .word 0
stack:  .word 0, 0, 0, 0, 0

    .text
    .global main
    .extern printf



main:
    stmfd r13!, {r14}
    ldr r7, =stack
    mov r10, #0 @ Stack counter

loop:
    @ Printf Select number
    ldr r0, =select_number
    bl printf

    @ Scanf input number
    ldr r0, =int_format_string
    ldr r1, =menu
    bl scanf
    
    ldr r1, =menu
    ldr r0, [r1]

    @ Switch case
    cmp r0, #1
    bleq push

    cmp r0, #2
    bleq pop

    cmp r0, #3
    bleq print

    cmp r0, #4
    bleq exit

    b loop

push: @ Push subroutine
    stmfd r13!, {r0-r9, r14}

    @ Printf type value to push
    ldr r0, =type_number_push
    bl printf

    @ Scanf input number
    ldr r0, =int_format_string
    ldr r1, =top
    bl scanf

    @ Check if size stack eq 5
    cmp r10, #5
    bleq overflow

    @ Save in top
    ldr r1, =top
    ldr r0, [r1]

    @ Move elems in stack
    ldr r1, [r7, #12]
    str r1, [r7, #16]

    ldr r1, [r7, #8]
    str r1, [r7, #12]

    ldr r1, [r7, #4]
    str r1, [r7, #8]

    ldr r1, [r7]
    str r1, [r7, #4]

    @ Add to the top of stack
    str r0, [r7]

    @ Increment stack counter
    add r10, r10, #1
    
    ldmfd r13!, {r0-r9, pc}

pop: @ Pop subroutine
    stmfd r13!, {r0-r9, r14}

    @ Check if size stack eq 0
    cmp r10, #0
    bleq empty

    @ Printf popped value
    ldr r0, =print_popped_value
    ldr r1, [r7]
    bl printf

    @ Move elems in stack
    ldr r1, [r7, #4]
    str r1, [r7]

    ldr r1, [r7, #8]
    str r1, [r7, #4]

    ldr r1, [r7, #12]
    str r1, [r7, #8]

    ldr r1, [r7, #16]
    str r1, [r7, #12]

    mov r1, #0
    str r1, [r7, #16]

    @ Decrement stack counter
    sub r10, r10, #1
    
    ldmfd r13!, {r0-r9, pc}

print: @ Print stack subroutine
    stmfd r13!, {r0-r12, r14}

    ldr r0, =print_stack1
    ldr r1, [r7]
    ldr r2, [r7, #4]
    ldr r3, [r7, #8]
    bl printf

    ldr r0, =print_stack2
    ldr r1, [r7, #12]
    ldr r2, [r7, #16]
    bl printf

    ldmfd r13!, {r0-r12, pc}

overflow: @ Print stack overflow
    stmfd r13!, {r0-r12, r14}

    ldr r0, =print_stack_overflow
    bl printf
    bl loop

    ldmfd r13!, {r0-r12, pc}

empty: @ Print stack empty
    stmfd r13!, {r0-r12, r14}

    ldr r0, =print_stack_empty
    bl printf
    bl loop

    ldmfd r13!, {r0-r12, pc}

exit:
    ldmfd r13!, {pc}

