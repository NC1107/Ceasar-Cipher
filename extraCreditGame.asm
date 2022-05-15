%define NEW_LINE 10 
%define SYSCALL_READ 0
%define SYSCALL_WRITE 1
%define STD_IN 0
%define STD_OUT 1
%define MAX_CHOICE_LENGTH 1
%define ARR_SIZE 10






section .data







section .bss





section .text
        global game



game:
    call playGame

    xor rax, rax
    



playGame:
    
        mov rax, 1
        mov rdi, 1
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 1
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rax, 1
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        syscall
        jmp game