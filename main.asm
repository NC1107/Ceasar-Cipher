; Project: Project 4
; Due Date: 04/24/2021
; Description: This program will do everything and more
%include 'ceasar.asm'
%include 'extraCreditGame.asm'
%define NEW_LINE 10 
%define SYSCALL_READ 0
%define SYSCALL_WRITE 1
%define STD_IN 0
%define STD_OUT 1
%define MAX_CHOICE_LENGTH 1
%define ARR_SIZE 10
extern displayUserMessages
extern malloc
extern resizeArray
extern decryptString
extern readUserMessage



;********************************************************************************************
; Setup Array with all 10 original messages                                          *INCOMPLETE*
; make those elements addressable                                                    *INCOMPLETE*
; make arrays dynamically sized                                                      *INCOMPLETE*
; make menu repeat until quit is chosen                                              *COMPLETE*
; get user input for choice                                                          *COMPLETE*
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
        l7: db "Enter what array you want to call caesar cipher on: "
        l7Len: equ $ - l7

        extraCred: db "EXTRA CREDIt SHIT WORKING", NEW_LINE
        extraCredLen equ $ - extraCred

        ; ending these messages with null terminator since they will be used in C functions
        orignalMessage: db "This is the original message.", NEW_LINE,0 ; 
        orignalMessageLen: equ $ - orignalMessage
        invalidOption: db "Invalid option! please try again!", NEW_LINE,0
        invalidOptionLen: equ $ - invalidOption

section .bss
        menuChoice: resb 1         ;holds user's choice, 1 char, [s,r,c,f,q]
        messageArray: resb 10      ;reserve 10 indexes for the message
        insertionIndex: resd 8     ;keep track of how many insertions the user has made ONCE THIS HITS 9, IT MUST BE RESET TO 0
        ceasarChoice: resb 1       ;holds the user's choice of what array to call ceasar on 
        shiftValue: resb 1         ;holds the user's shift value for ceasar 

        zCount: resb 10            ;holds the number of z's given

         

section .text
        global main


main:   
        call printMenu
        ;get user input menu choice
        call getMenuChoice
        mov al, byte[rsi]
        cmp al, 's'                             ;printing the current meeages
        je showMessage
        cmp al, 'S'                             ;printing the current meeages
        je showMessage
        cmp al, 'r'                             ;read new meeages
        je readMessage      
        cmp al, 'R'                             ;read new meeages
        je readMessage                        
        cmp al, 'c'                             ;caesar cipher
        je ceasarCypherCall
        cmp al, 'C'                             ;caesar cipher
        je ceasarCypherCall
        cmp al, 'f'                             ;frequency decrypt    
        je frequencyDecrypt
        cmp al, 'F'                             ;frequency decrypt   
        je frequencyDecrypt
        cmp al, 'q'                             ;quit program
        je exit
        cmp al, 'Q'                             ;quit program
        je exit
        cmp al, 'z'                             ;extra credit
        je extraCredit
        
        jmp invalidInput                        ;otherwise invalid input
        
        ;testing printing the array of strings
        ;call displayUserMessages


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

getMenuChoice:
        mov rsi, menuChoice                               ;store the users shift value in the buffer
        mov rdx, MAX_CHOICE_LENGTH                        ;store the max number of bytes the user can input
        call input    
        ;print user choice
        ; mov rsi, menuChoice
        ; mov rdx, MAX_CHOICE_LENGTH
        ; call print
        cmp byte[rsi], NEW_LINE
        je getMenuChoice
        ret

showMessage:
        ;mov rdi, array
        ;call displayUserMessages
        jmp main                                        ;return to main

;mov rax, array
;mov rsi, location
readMessage:
        jmp main                                        ;return to main

ceasarCypherCall:
        call getCypherChoice                            ;get the array the user wants to use
        call getUserShift
        mov qword[shiftValue], rax                      ;get the user shift value
        mov rax, 8
        mul qword[shiftValue]                           ;used to choose what string is selected
        mov qword[shiftValue], rax
        ;mov rdi, qword[array + shiftValue]             ;move the array into the paramater

        jmp main                                        ;return to main

frequencyDecrypt:
        ;mov rdi, array
        ;call decryptString
        jmp main                                        ;return to main

extraCredit:    
        add byte[zCount], 1                             ;increment the number of z's
        cmp byte[zCount], 4
        je SnazzyExtraCreditProgram
        jmp main                                        ;return to main

invalidInput:
        mov rsi, invalidOption
        mov rdx, invalidOptionLen
        call print

        jmp main                                        ;return to main

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

getCypherChoice:                                        ;get the choice of array 

        mov rsi, l7
        mov rdx, l7Len
        call input 

        cmp byte[rsi], '0'
        jl getCypherChoice

        cmp byte[rsi], '9'
        jg getCypherChoice

        sub qword[ceasarChoice], 48                     ;convert from ascii to decimal 
        mov qword[ceasarChoice], rsi
        ret

initializeMessageArray:                                 ;store the original message in all elements of the array

    
 
exit:                                                   ; nominal exit
    mov rax, 60
    xor rdi, rdi
    syscall



SnazzyExtraCreditProgram:
        ;reset zCount
        mov byte[zCount], 0
        ;print extra credit prompt
        mov rsi, extraCred
        mov rdx, extraCredLen
        call print
        call extraGame

