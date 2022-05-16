; Project: Project 4
; Due Date: 04/24/2021
; Description: This program will do everything and more
%define NEW_LINE 10 
%define SYSCALL_READ 0
%define SYSCALL_WRITE 1
%define STD_IN 0
%define STD_OUT 1
%define MAX_CHOICE_LENGTH 2
%define ARR_SIZE 10
%include 'extraCreditGame.asm'
%include 'ceasar.asm'
%define MAX_MESSAGE_SIZE 1000
extern displayUserMessages
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
        l6: db "Enter your choice: ", 
        l6Len: equ $ - l6
        l7: db "Enter what array you want to call caesar cipher on (0-9): ", 
        l7Len: equ $ - l7
        
        extraCred: db "EXTRA CREDIT MESSAGE WORKING", NEW_LINE
        extraCredLen equ $ - extraCred

        ; ending these messages with null terminator since they will be used in C functions
        orignalMessage: db "This is the original message.", NEW_LINE,0 ; 
        orignalMessageLen: equ $ - orignalMessage
        invalidOption: db "Invalid option! please try again!", NEW_LINE,0
        invalidOptionLen: equ $ - invalidOption

section .bss
        menuChoice: resb MAX_CHOICE_LENGTH              ;holds user's choice, 1 char, [s,r,c,f,q] and the new line
        messageArray: resq ARR_SIZE                     ;reserve 10 pointers for the message
        insertionIndex: resb MAX_CHOICE_LENGTH          ;keep track of how many insertions the user has made ONCE THIS HITS 10, IT MUST BE RESET TO 0
        ceasarChoice: resb MAX_CHOICE_LENGTH            ;holds the user's choice of what array to call ceasar on 
        shiftValue: resb 1                              ;holds the user's shift value for ceasar 
        zCount: resb ARR_SIZE                           ;holds the number of z's given
        strings: resb MAX_MESSAGE_SIZE * 10             ;hold 10 strings

section .text
        global main

main:   
        mov byte[insertionIndex], 0     ; the first read index will be 0...
                                        ; incremented each read that's made
        call initializeMessageArray     ; fill the buffer in memory with originalMessage and...
                                        ; store the location of each string in messageArray

choice:

        call printMenu
        ;get user input menu choice
        call getMenuChoice
        ;; check that at least 2 chars were read in
        cmp rax, 2
        jl invalidInput
        ;; check that the second char is newline (ie. user did not enter 'ab\n')
        ;; this means there is still garbage in STDIN, it must be emptied
        cmp byte[menuChoice + 1], 10
        jne invalidInputClearSTDIN
        
        mov al, byte[menuChoice]

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

;skips input and just dips
getMenuChoice:
        mov rsi, menuChoice                               ;store the users shift value in the buffer
        mov rdx, MAX_CHOICE_LENGTH                        ;store the max number of bytes the user can input
        call input    
        ret

showMessage:
        mov rdi, messageArray
        call displayUserMessages
        jmp choice                                ;return to choice

readMessage:
        mov rdi, messageArray
        xor rsi, rsi
        mov sil, byte[insertionIndex]
        call readUserMessage
        inc byte[insertionIndex]        ; increment insertionIndex after read
        ;; insertionIndex must be 0-9, take the modulo 10
        cmp byte[insertionIndex], 10
        jl choice                      ; insertionIndex is 0-9, this operation is over
        mov byte[insertionIndex], 0     ; otherwise, reset insertionIndex to 0
        jmp choice                                        ;return to choice

ceasarCypherCall:
        call getCypherChoice                            ;get the array the user wants to use
        call getUserShift
        mov qword[shiftValue], rax                      ;get the user shift value
        mov rax, 8
        mul qword[shiftValue]                           ;used to choose what string is selected
        mov qword[shiftValue], rax
        ;mov rdi, qword[array + shiftValue]             ;move the array into the paramater
        ;call 
        jmp choice                                        ;return to choice

frequencyDecrypt:
        mov rdi, messageArray
        call decryptString
        jmp choice                                        ;return to choice

extraCredit:
        mov rsi, invalidOption
        mov rdx, invalidOptionLen
        call print
        add byte[zCount], 1                             ;increment the number of z's
        cmp byte[zCount], 4
        je SnazzyExtraCreditProgram
        jmp choice                                        ;return to choice

invalidInputClearSTDIN:
        ;; will also clear any bytes remaining in STDIN...
        ;; ONLY jmp here if you have not read in a newline when you expected to
        mov rsi, menuChoice
        call clearSTDIN_

invalidInput:
        mov rsi, invalidOption          
        mov rdx, invalidOptionLen
        call print

        jmp choice                                        ;return to choice

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


;get the choice of array 
getCypherChoice:
        mov rsi, l7                                     ;print out what string to be manipulated
        mov rdx, l7Len
        call print
        mov rax, STD_IN
        mov rdi, SYSCALL_READ
        mov rsi, ceasarChoice
        mov rdx, MAX_CHOICE_LENGTH
        syscall                                      ;input what string to be manipulated

        cmp byte[ceasarChoice], '0'
        jl getCypherChoice

        cmp byte[ceasarChoice], '9'
        jg getCypherChoice

        cmp byte[ceasarChoice], NEW_LINE
        je getCypherChoice

        ;implement ceasar part here
        ; sub byte[ceasarChoice], 48                     ;convert from ascii to decimal 
        ; mov byte[ceasarChoice], rsi
        ret

;store the original message in all elements of the array
;rdi stores the pointer to 
initializeMessageArray:
        mov r10, strings
        xor r11, r11
.loopNewString:
        mov qword[messageArray + 8*r11], r10               ;set to default message
        xor rcx, rcx                            ; use rcx to keep track of byte in the string
.loopStringDeepCopy:
        mov al, byte[orignalMessage + rcx]
        mov byte[r10 + rcx], al
        inc rcx
        cmp al, 0                               ; keep copying chars until null terminator
        jne initializeMessageArray.loopStringDeepCopy

        add r10, MAX_STRING_BYTES                       ;next reserved memory is 1000 away
        inc r11                                         ;next element in 2d array
        cmp r11, ARR_SIZE
        jl initializeMessageArray.loopNewString

        ret

exit:
        ;; nominal exit
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
        call game
        jmp choice

clearSTDIN_:
        ;; repeat read sycall until the last char read in a newline
        ;; requires that rsi be an address where at least 1 byte can be written to
        mov rdx, 1
        call input
        cmp byte[rsi], NEW_LINE
        jne clearSTDIN_
        ret