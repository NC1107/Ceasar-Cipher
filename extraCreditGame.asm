

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