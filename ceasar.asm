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
userShiftValue: resb MAX_SHIFT_BYTES                     ;user can input a number from 0 to 25
userShiftTotalBytes: resb MAX_SHIFT_BYTES                ;store the users shift byte length            
userOriginalMessage: resb MAX_STRING_BYTES               ;user can only input a string above 30 characters
userOriginalMessageTotalBytes: resb MAX_STRING_BYTES     ;store the users string byte length
userEncrytedMessage: resb MAX_STRING_BYTES               ;user can only input a string above 30 characters
userShiftValueInAscii: resb ASCII_SIZE                   ;store the users shift value in ascii





        section .text
global ceasar



caesar:
        call getUserShift

        ;store the byte amount
        
        call getUserString                                      ;stay in this function till user enters correct string length
        mov qword[userOriginalMessageTotalBytes], rax

        ;print_ their message back to them
        mov rsi, CurrentMessagePrompt
        mov rdx, CurrentMessageLen
        call print_
        mov rsi, userOriginalMessage
        mov rdx, qword[userOriginalMessageTotalBytes]
        call print_

        ;begin handling ceasar cypher
        ;prepare the data and length for ceasar cypher function call
        mov rsi, userOriginalMessage
        mov rdx, qword[userOriginalMessageTotalBytes]
        mov rcx, 0
        call ceasarCypher
        ;store the encrypted message after the function call
        ;mov qword[userEncrytedMessage], rax
        ;print_ the encrypted message prompt
        mov rsi, EncyptionPrompt
        mov rdx, EncyptionLen
        call print_
        ;print_ the encrypted message
        mov rsi, userOriginalMessage
        mov rdx, qword[userOriginalMessageTotalBytes]
        call print_

        xor rax, rax                                    ;clear the rax register to ensure no error exit code
        ret                                             ;return to the operating system


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
        call print_                                      ;call the print_ function to output the string
        mov rsi, userShiftValue                         ;store the users shift value in the buffer
        mov rdx, MAX_SHIFT_BYTES                        ;store the max number of bytes the user can input
        call input                                      ;call the input function to get the users input
        mov qword[userShiftTotalBytes], rax             ;Store the number of bytes the user input
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
        mov qword[userShiftValueInAscii], rax           ;store the value in ascii if everything is correct
        ret                                             ;leave the function

; repeat read sycall until the last char read in a newline
; requires that rsi be an address where at least 1 byte can be written to        
clearSTDIN:
        mov rdx, 1
        call input
        cmp byte[rsi], NEW_LINE
        jne clearSTDIN
        ret

;we want to stay here until the string length is greater than 30
getUserString:
        mov rsi, OriginalMessagePrompt                  ;ask user "Enter original message: "
        mov rdx, OriginalMessageLen                     ;store the length of string for the buffer size
        call print_                                      ;print_ the prompt
        mov rsi, userOriginalMessage                    ;store the users string in the buffer
        mov rdx, MAX_STRING_BYTES                       ;store the max number of bytes the user can input
        call input                                      ;call the input function to get the users input
        cmp rax, MIN_STRING_BYTES                       ;compare the value to 30
        jle getUserString                               ;jump if RAX is less than or equal to MIN_STRING_BYTES(30)
        ret                                             ;return the value of rax


ceasarCypher:
        ; is shift value
        ;rsi is orignal message
        ;rdx is orignal message length

        ;loop through all the characters in the string
        ;call helper function with the current character and the shift value
        ;store the result in the current character
        ;increment the current character

        ;validate to make sure the character is a letter
        cmp rcx, rdx                                    ;compare to make sure not done
        jl readChar
        ret

readChar:
        xor rax, rax
        mov al, byte[rsi + rcx]                         ;move the current char to the al register

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
        add rax, qword[userShiftValueInAscii]           ;add the shift value to the char
        cmp al, 'Z'                                     ;see if it needs to 'wrap back around'
        ja subtract                                     ;if so wrap back
        jmp increment                                   ;else not increment
        

shiftLowerCharacter:
        ;al is the bufferuserOriginalMessageTotalBytes]
        ;shift the character and return it
        add rax, qword[userShiftValueInAscii]           ;add the shift value to the car
        cmp al, 'z'                                     ;see if it needs to 'wrap back around'
        ja subtract                                     ;if so wrap back
        jmp increment                                   ;else not increment


subtract: 
        sub al, 26                                      ;subtract 26 to wrap around Z->A
                                                        ;increment


increment:
        mov byte[rsi + rcx], al                         ; store the char we operated on in al
        add rcx, 1                                      ;add 1 to rcx the incrementing register
        jmp ceasarCypher                                ;return to ceasarCypher after incrementing

