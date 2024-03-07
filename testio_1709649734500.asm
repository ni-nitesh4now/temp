; Test program for I/O

; Build with the build script:
; ./build_asm_vX.sh test-io.asm 
; (Replace X with current version number)

; OR
; To build: 
; nasm -g -f elf64 -o test-io.o test-io.asm
; To link:
; gcc test-io.o /usr/lib/libasm_io.a -no-pie -o test-io
; (Manually pointing the linker to "libasm_io.a" archive file.)
; or
; gcc test-io.o -lasm_io -no-pie -o test-io
; (Using the "-lasm_io" switch.)

; You'll need to point this to your version of the IO library
; the %include path is an absolute path - change this if you want
%include "/usr/local/include/libasm_io.inc"

global main

section .data
 	echo_request:	db	"Please enter a number: ",0
 	echo_number: 	db	"The number you entered was:",0
 	echo_bye:	db	"Goodbye!",0

section .text

main:
 	; We have these three lines for compatability only
 	push rbp
 	mov rbp, rsp
 	sub rsp,32

 	; We load up the message to ask for a number
 	mov rdi, QWORD echo_request
 	call print_string

; we read in an int
 	call read_int
 	push rax		; we save the int for safety's sake

 	; we print out our message
 	mov rdi, QWORD echo_number
 	call print_string
 	call print_nl

 	; we copy back the int we saved and print it
 	pop rdi
 	call print_int
 	call print_nl

	; we print our goodbye message
 	mov rdi, QWORD echo_bye
 	call print_string	
 	call print_nl

 	; and these lines are for compatability
 	add rsp, 32
 	pop rbp

 	ret
