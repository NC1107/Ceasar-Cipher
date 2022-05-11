; Project: Project 4
; Due Date: 04/24/2021
; Description: This program will do everything and more
%define NEW_LINE 10 
%define SYSCALL_READ 0
%define SYSCALL_WRITE 1
%define STD_IN 0
%define STD_OUT 1
%define MAX_CHOICE_LENGTH 1
%define ARR_SIZE 10
extern getUserMessage
extern displayUserMessages
extern malloc



;********************************************************************************************
; Setup Array with all 10 original messages                                          *INCOMPLETE*
; make those elements addressable                                                    *INCOMPLETE*
; make arrays dynamically sized                                                      *INCOMPLETE*
; make menu repeat until quit is chosen                                              *INCOMPLETE*
; get user input for choice                                                          *INCOMPLETE*
; create the c functions for the menu                                                *INCOMPLETE*
; everything else                                                                    *INCOMPLETE*
;********************************************************************************************






 section .data

        ;menu prompts
        l0: db "Encrpytion menu options:", NEW_LINE
        l0Len: equ $ - l0
        l1: db "s - show current messages", NEW_LINE
        l1Len: equ $ - l1
        l2: db "r - read new message", NEW_LINE
        l2Len: equ $ - l2
        l3: db "c - caesar cipher", NEW_LINE
        l3Len: equ $ - l3
        l4: db "f - frequency decrypt", NEW_LINE
        l4Len: equ $ - l4
        l5: db "q - quit program", NEW_LINE
        l5Len: equ $ - l5
        l6: db "Enter your choice: "
        l6Len: equ $ - l6


        orignalMessage: db "This is the original message.", NEW_LINE,0
        orignalMessageLen: equ $ - orignalMessage

        




section .bss
        menuChoice: resb 1

        ;reserve 10 indexes for the message
        messageArray: resb 10

        ;keep track of how many insertions the user has made
        ;ONCE THIS HITS 9, IT MUST BE RESET TO 0
        insertionIndex: resd 8
        

section .text
        global main


main:

        call printMenu

        ;testing printing the array of strings

        call displayUserMessages
        
        xor rax, rax
        ret



;prints the menu and leaves
printMenu:
        mov rsi, l0
        mov rdx, l0Len
        call print
        mov rsi, l1
        mov rdx, l1Len
        call print
        mov rsi, l2
        mov rdx, l2Len
        call print
        mov rsi, l3
        mov rdx, l3Len
        call print
        mov rsi, l4
        mov rdx, l4Len
        call print
        mov rsi, l5
        mov rdx, l5Len
        call print
        mov rsi, l6
        mov rdx, l6Len
        call print
        ret


;skips input and just dips
getMenuChoice:
        mov rsi, menuChoice                         ;store the users shift value in the buffer
        mov rdx, MAX_CHOICE_LENGTH                        ;store the max number of bytes the user can input
        call input    
        ;print user choice
        mov rsi, menuChoice
        mov rdx, MAX_CHOICE_LENGTH
        call print
        ret


print:                                                  ;move prompt to rsi, length to rdx
        mov rax, SYSCALL_WRITE                          ;syscall number moved into rax for write function
        mov rdi, STD_OUT                                ;standard output syscalll
        syscall                                         ;calls the write function
        ret  

input:
        mov rax, SYSCALL_READ                           ;call read function syscall
        mov rdi, STD_IN                                 ;stdin syscall
        syscall                                         ;returns the number of bytes read
        ret                                             ;returns the value of the read into rax


initializeMessageArray:
    