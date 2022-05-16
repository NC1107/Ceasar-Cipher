; Project: Ceasar Cypher
; Due Date: 04/24/2021
; Description: This program will encrypt a message using a Ceasar Cypher
; Members: Nicholas Conn and Riley Sheehy
%define NEW_LINE 10 
%define SYSCALL_READ 0
%define SYSCALL_WRITE 1
%define STD_IN 0
%define STD_OUT 1
%define MAX_SHIFT_BYTES 3     ;maximum of a 2 digit number
%define MAX_STRING_BYTES 1000
%define MIN_STRING_BYTES 30
%define MUL_VALUE 10
%define ASCII_OFFSET 48
%define ASCII_SIZE 8

extern printf


;whenever you are "dereferencing" ([]) specifcy the number of 
;bytes you are moving in front of the brackets (byte, word, dword, qword)
;it will throw a compiler error without proper byte usage


;functions return the value into the rax register
;so you can grab functions return value from rax after the function call


; The .data section of a computer program contains 
; permanent constants and variables used in computer program. 
        section .data
shiftPrompt: db "Enter a shift value: "                  ;shift value prompt
shiftLen: equ $ - shiftPrompt                            ;length of shiftPrompt
OriginalMessagePrompt: db "Enter original message: "     ;prompt for original message
OriginalMessageLen: equ $ - OriginalMessagePrompt        ;length of the original message
CurrentMessagePrompt: db "Current message: "             ;current message prompt
CurrentMessageLen: equ $ - CurrentMessagePrompt          ;length of the current message
EncyptionPrompt: db "Encryption: "                       ;this is the prompt for the encrypted message
EncyptionLen: equ $ - EncyptionPrompt                    ;length of the encryption prompt
newLine: db "", NEW_LINE                                 ;used to make formatting easier
newLineLen: equ $ - newLine                              ;length of 1


;memory thats reserved but not initialized
        section .bss
userShiftValue: resb MAX_SHIFT_BYTES                     ;user can input_ a number from 0 to 25
userShiftTotalBytes: resb MAX_SHIFT_BYTES                ;store the users shift byte length            
userOriginalMessage: resq 1                              ;user can only input_ a string above 30 characters
userEncrytedMessage: resb MAX_STRING_BYTES               ;user can only input_ a string above 30 characters
shiftValue: resq 1                              ;store the users shift value





        section .text
global ceasar



ceasar:
        ;store the char* from main
        mov qword[userOriginalMessage], rdi
        
        call getUserShift       ; integer shoft value will be stored at shiftValue

        ;print their message back to them
        mov rsi, CurrentMessagePrompt
        mov rdx, CurrentMessageLen
        call print_
        mov rdi, qword[userOriginalMessage]
        call printf

        ;begin handling ceasar cypher
        ;prepare the data and length for ceasar cypher function call
        mov rdi, qword[userOriginalMessage]
        call ceasarCypher
        ;store the encrypted message after the function call
        ;mov qword[userEncrytedMessage], rax
        ;print_ the encrypted message prompt
        mov rsi, EncyptionPrompt
        mov rdx, EncyptionLen
        call print_
        ;print the encrypted message
        mov rdi, qword[userOriginalMessage]
        call printf

        xor rax, rax                                    ;clear the rax register to ensure no error exit code
        ret


print_:
        mov rax, SYSCALL_WRITE                          ;syscall number moved into rax for write function
        mov rdi, STD_OUT                                ;standard output syscalll
        syscall                                         ;calls the write function
        ret                                             ;return to main

input_:
        mov rax, SYSCALL_READ                           ;call read function syscall
        mov rdi, STD_IN                                 ;stdin syscall
        syscall                                         ;returns the number of bytes read
        ret                                             ;returns the value of the read into rax

getUserShift:
        mov rsi, shiftPrompt                            ;move shift prompt ("Enter a shift value: ") into rsi
        mov rdx, shiftLen                               ;store the length of string for the buffer size
        call print_                                     ;call the print_ function to output the string
        mov rsi, userShiftValue                         ;store the users shift value in the buffer
        mov rdx, MAX_SHIFT_BYTES                        ;store the max number of bytes the user can input_
        call input_                                     ;call the input_ function to get the users input_
        mov qword[userShiftTotalBytes], rax             ;Store the number of bytes the user input_
        mov r10, rax                                    ; store number of bytes read in
        dec r10                                         ; subtract 1 to ignore newline in main loop

        xor rax, rax                                    ; initalize final integer in rax

        ;; first, check if last char is not \n, meaning this is not the end of the string
        ;; if last char is not \n, clear existing chars in STDIN and try again
        xor r9, r9                                      ; r9b will store the digit we're currently working with
        mov r9b, byte[userShiftValue + r10]
        cmp r9b, NEW_LINE
        je convertChar
        call clearSTDIN
        jmp getUserShift

        ;; rdi contains index to digit we care about
        ;; r10 contains the number of digits to read in
        ;; working left-to-right...
        ;; 1) multiply current number by 10
        ;; 2) add digit pointed to by index
        ;; 3) inc index, and repeat until rightmost digit is reached
        xor rdi, rdi
convertChar:
        ;; move digit into r9b and convert from ASCII number to integer
        xor r9, r9
        mov r9b, byte[userShiftValue + rdi]
        sub r9b, ASCII_OFFSET
        ;; detect non-number ascii chars
        js getUserShift
        cmp r9b, 9
        jg getUserShift
        ;; multiply current number by 10 and add this digit
        mov rdx, 10
        mul rdx
        add rax, r9
        ;; update loop condition, and loop until last digit is read in
        inc rdi
        cmp rdi, r10
        jl convertChar
        ;; done, check that the final value is in acceptable range
        cmp rax, 0                                      ;compare the value to 0
        jl getUserShift                                 ;if the value is less than 0, go back to the beginning of the function
        cmp rax, 25                                     ;compare the value to 25
        jg getUserShift                                 ;if the value is greater than 25, go back to the beginning of the function
        mov qword[shiftValue], rax           ;store the value in ascii if everything is correct
        ret                                             ;leave the function

clearSTDIN:
        ;; repeat read sycall until the last char read in a newline
        ;; requires that rsi be an address where at least 1 byte can be written to
        mov rdx, 1
        call input_
        cmp byte[rsi], NEW_LINE
        jne clearSTDIN
        ret

ceasarCypher:
        ; rdi is a pointer to the string to change
        xor rcx, rcx

readChar:
        xor rax, rax
        mov al, byte[rdi + rcx]                         ;move the current char to the al register

        cmp al, 0                                       ; end cypher at null terminator
        ret

        cmp al, 'A'                                     ;check if char is less than 'A'
        jl increment                                    ;char is not a letter increment 
        
        cmp al, 'Z'                                     ;check if char is an uppercase letter
        jle shiftUpperCharacter                         ;shift the letter 

        cmp al, 'a'                                     ;check if char is less than 'a'
        jl increment                                    ;char is not a letter increment

        cmp al, 'z'                                     ;check if char is a lowercase letter
        jle shiftLowerCharacter                         ;shift the letter 
        jmp increment

shiftUpperCharacter:
        ;al is the bufferuserOriginalMessageTotalBytes]
        ;shift the character and return it
        add rax, qword[shiftValue]           ;add the shift value to the char
        cmp al, 'Z'                                     ;see if it needs to 'wrap back around'
        ja subtract                                     ;if so wrap back
        jmp increment                                   ;else not increment
        

shiftLowerCharacter:
        ;al is the bufferuserOriginalMessageTotalBytes]
        ;shift the character and return it
        add rax, qword[shiftValue]           ;add the shift value to the car
        cmp al, 'z'                                     ;see if it needs to 'wrap back around'
        ja subtract                                     ;if so wrap back
        jmp increment                                   ;else not increment


subtract: 
        sub al, 26                                      ;subtract 26 to wrap around Z->A or z->a
                                                        ;increment


increment:
        mov byte[rdi + rcx], al                         ; store the char we operated on in al
        inc rcx                                      ;add 1 to rcx the incrementing register
        jmp readChar                                ;return to ceasarCypher after incrementing

