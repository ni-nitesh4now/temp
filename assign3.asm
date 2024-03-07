	%include "/home/malware/asm/joey_lib_io_v9_release.asm"
	global main
	
	section .data
welcome db "welcome to 19233615 CWK1",10,0
	str_main_menu db 10, \
	"Main Menu", 10, \
	" 1. Add Badger", 10, \
	" 2. List All Badgers", 10, \
	" 3. Search a user given id ", 10, \
	" 4. Delete Badger", 10, \
	" 5. Add staff", 10, \
	" 6. Search id staff", 10, \
	" 7. List All Staffs", 10, \
	" 8. Delete staff", 10, \
	" 9. Exit", 10, \
	"Please Enter Option 1 - 9", 10, 0
	
	; Note - after each string we add bytes of value 10 and zero (decimal). These are ASCII codes for linefeed and NULL, respectively.
	; The NULL is required because we are using null - terminated strings. The linefeed makes the console drop down a line, which saves us having to call "print_nl_new" function separately.
	; In fact, some strings defined here do not have a linefeed character. These are for occations when we don't want the console to drop down a line when the program runs.
	
	str_program_exit db "Program exited normally.", 10, 0
        st_current_year db "enter the current year",10,0
        st_current_month db "enter the current month 1 - 12 ",10,0
        str_option_selected db "Option selected: ", 0
	str_invalid_option db "Invalid option, please try again.", 10, 0
        str_enter_name db "Enter name:",10,0
        str_enter_sex db "Enter gender M / F:", 10, 0
	str_enter_month db "Enter month of birth 1 - 12", 10, 0
	str_enter_year db "Enter year of birth format xxxx 4 digits", 10, 0
	str_enter_stripes db "Enter number of stripes", 10, 0
        str_enter_badgid db "Enter id badger format bxxxxx 6 digits:", 10, 0
	str_enter_homesett db "insert 1 Settfield, 2 Badgerton, 3 Stripeville", 10, 0
        str_enter_mass db "Enter mass:", 10, 0
	str_array_full db "Can't add - storage full.", 10, 0
        str_number_of_badgers db "Number of badgers: ", 0
	str_enter_staffid db "Enter id staff format pxxxxxxx 7 digits:",10, 0
	str_id_avaible db "id avaible available", 10, 0
	str_id_notavaible db "id already exists available", 10, 0
	str_not_exist db "error, try again", 10, 0
	; Here we define the size of the block of memory that we want to reserve to hold the badgers' details
	; A Badger record stores the following fields:
	; id= 8 bytes (string starting with bxxxxxx follow by 6 digits)
	; name = 64 bytes (string up to 63 characters plus a null - terminator)
	;.home_sett=12 ; name of the home sett 1 Settfield Badgerton, Stripeville", 
	; mass = 1 byte (integer number )
	; stripes = 1 byte (we're assuming that we don't have any badgers with stripes over 255)
	;sex = 1 byte only 1 char
	;month = 1 byte ( 1 - 12 )
	;year = 2 byte (4 digits) 2^16
	;staff_id= 9 byte (must start with p + 7 digits and null terminator)
	; User ID = 64 bytes (string up to 63 characters plus a null terminator)
	
	size_badgers_record equ 99
	max_num_badgers equ 500      ; 500 badgers maximum in array (we can make this smaller in debugging for testing array limits etc.)
	size_badgers_array equ size_badgers_record * max_num_badgers ; This calculation is performed at build time and is therefore hard - coded in the final executable.
	; We could have just said something like "size_badgers_array equ 19300". However, this is less human - readable and more difficult to modify the number of badgers / user record fields.
	; The compiled code would be identical in either case.
	
	current_number_of_badgers dq 0 ; this is a variable in memory which stores the number of badgers which have currently been entered into tthe array.
	actual_year dq 0
	actual_month dq 0
	
	;string used in display all badgars
	ID db "ID=", 0
	name db "Name=",0
	st_surname db "Surname=",0
	department db "Department= ",0
	year_of_joining db "Year of joining",0
         email_ask db "email:",0
	home_sett db "home_sett=",0
	mass db "mass=",0
	stripes db "stripes=",0
	gender db "gender=",0
	age db "age=",0
	stid db "staffID=",0
	month db "month=",0
	year db "year=",0
	staffid db "staffid=",0
	stripines db "stripiness=",0
 divider db "----------------------------------------------------------",10,0
	temp_month dq 0
	temp_year dq 0
	temp_mass dq 0
	temp_stripes dq 0
	;staff
        str_number_of_staffs db "Number of staffs: ", 0
	st_salary db "salary=", 0
        surname db "Enter surname=",0
        firstname db "Enter firstname=", 0
        email db "Enter only the prefix of the email xxxxx@jnz.co.uk :", 0
        salary db "Enter starting annual salary in =", 0
	yearOfJoining db "year Of Joining =", 0
        st_service db "year of service=", 0
	empty db "the array is empty", 0
	success db "id deleted correctly ", 0
	pound dq '£'
        year_join db 'Enter year of joining',10, 0
	email_add db "@jnz.co.uk", 0
	ask_department db "insert 1 Park Keeper, 2 Gift shop, 3 Cafe:",10,0
	current_number_of_staffs dq 0
	max_num_staffs equ 100
	size_staff_record equ 219
	size_staff_array equ size_staff_record * max_num_staffs
	;staffid=9 + surname=64 bytes 63 + null term, ;name=64 bytes 63 + null term, email=64 bytes 63 + null term, department =11 + 1 null year=2 byte salary= 4 byte
	;total byte requirement= 219
	;9 + 64 + 64 + 64 + 4 + 12 + 2
	;enums
	Settfield db "Settfield", 0
	Badgerton db "Badgerton", 0
	Stripeville db "Stripeville", 0
	;enums staff
	Park_keeper db "Park Keeper", 0
	Cafe db "Cafe", 0
	Gift_shop db "Gift shop", 0
	section .bss
badgers: resb size_badgers_array; space for max_num_badgers badger records. "resb
staff: resb size_staff_array  ; space for max_num_staffs staff records. "resb
	
	; The ".text" section contains the executable code. This area of memory is generally read - only so that the code cannot be mucked about with at runtime by a mischievous user.
	section .text
add_param_badg:
	
	cmp r12, 1
	je .skip
	mov rax, QWORD[current_number_of_badgers] ; value of current_number_of_badgers
	mov rbx, size_badgers_record ; size_badgers_record is an immediate operand since it is defined at build time.
	mul rbx                      ; calculate address offset (returned in RAX).
	add rcx, rax                 ;
	inc r12
.skip:
	; RAX now contains the offset of the next user record. We need to add it to the base address of badgers record to get the actual address of the next empty user record.
	; calculate address of next unused badgers record in array
	; RCX now contins address of next empty user record in the array, so we can fill up the data.
	mov rsi, r8                  ; address of new string into rsi
	mov rdi, rcx                 ; address of memory slot into rdi
	call copy_string             ; copy string from input buffer into user record in arrayE
	ret
	
	
	
	
check_ifexist_badgers:
	mov r11, QWORD[current_number_of_badgers] ; set the counter
.loop:
	cmp r11, 0                   ; compare if we have only one id
	je .done
	dec r11                      ; dec the counter the id already in the array are at the index r11 - 1
	mov rdi, r8                  ; prepare the register to compare the string
	mov rax, r11                 ; mov the number in rax
	mov rbx, size_badgers_record ; mov the offset in rbx offset 102
	mul rbx                      ; 102 * rax
	add rcx, rax                 ; rcx point to the first index
	mov rsi, rcx                 ; get the value from rcx to rsi
	sub rcx, rax                 ; restore rcx
	call strings_are_equal       ;rax==1 string are equal, 0 not equal
	cmp rax, 1
	je .done
	jmp .loop
.done:
	ret
	
add_badger:
	; Adds a new user into the array
	; We need to check that the array is not full before calling this function. Otherwise buffer overflow will occur.
	; No parameters (we are using the badgers array as a global)
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	lea rcx, [badgers]           ; base address of badgers array
	mov r12, 0
	
	
	
	; get id
.ask_id:
	mov rdi, str_enter_badgid
	call print_string_new        ; print message
	call read_string_new         ; get input from user
	                              ;we need to check the lenght, if already exist and if the 6 digits are all number, and the id must start with b
	mov r8, Qword rax              ; store the value in a register
        call check_ifexist_badgers
	cmp rax, 1                   ; if rax is equal to 1,0 not equal
        jne .check_lenght
        call error
        jmp .ask_id
.check_lenght:                          ; r9 counter lenght compare with the exact lenght
	mov rdi, r8                    ; rdi used in strlen
	call _strlen
	cmp rax, 7                   ;
	jne .ask_id
.check_1_char:
	cld
	cmp byte[r8], 'b'            ;1 check if id starts with b
	jne .ask_id
	inc r8                       ;increment before enter in the loop, i move the poiter to the first digit
.check2_6digits:
	cmp byte[r8], 48             ; check if the other six digits are number
	jl .ask_id
	cmp byte[r8], 57             ;compare ascii value 0=48 <byte[r8]< 9=57
	jg .ask_id
	
	inc r8
	cmp byte[r8], 0
	jne .check2_6digits
	sub r8, rax                  ; rax has the lenght, r8 point to the last byte, so r8 - rax means point to the fisrt char of the id
	
	call add_param_badg
	
	
	; get name
.ask_name_badger:
	add rcx, 8                   ; move along by 64 bytes (which is the size reserved for the forename string)
	mov rdi, str_enter_name
	call print_string_new        ; print message
	call read_string_new         ; get input from user
	mov r8, rax                  ; insert in a secure place the string
	xor r9, r9                   ; initialize counter to count the lenght
.check_name_lenght:
	cmp r9, 64                   ;max size name
	jg .ask_name_badger
	mov rdi, r8
	cmp byte[r8], 0              ;last char null byte, loop on this exit from the loop
	je .add_name
	inc r9
	inc r8
	jmp .check_name_lenght
.add_name:
	sub r8, r9                   ; restore r8
	call add_param_badg
	; get home_sett
.ask_homesett:
	
	mov rdi, str_enter_homesett
	call print_string_new        ; print message
	call read_uint_new           ; get input from user
	; inputted number is now in the RAX register
        cmp rax,-1
        je .ask_homesett
	cmp rax, 1
	je .homesett1
	cmp rax, 2
	je .homesett2
	cmp rax, 3
	je .homesett3
	jmp .ask_homesett
.homesett1:
	mov r8, Settfield
	jmp .add_homesett
.homesett2:
	mov r8, Badgerton
	jmp .add_homesett
.homesett3:
	mov r8, Stripeville
	jmp .add_homesett
.add_homesett:
         add rcx, 64                  ; move along by 64 bytes (which is the size reserved for the name string)
	call add_param_badg
	; add mass
.ask_mass:
	
	mov rdi, str_enter_mass      ; ask for the ask_mass
	call print_string_new
	call read_uint_new
        cmp rax,-1 
        je .ask_mass
	mov r8, rax                  ;store mass in a secure place
.add_mass:
	add rcx, 12
	 mov BYTE[rcx], al            ; we are only going to copy the least significant byte of RAX (AL), because our age field is only one byte
	
.ask.stripes:
	
	mov rdi, str_enter_stripes   ; ask for the ask_stripes
	call print_string_new
	call read_uint_new
	
.check_stripes:
	mov rdi, rax
	mov r8, rax
	cmp r8, 255
	jg .ask.stripes
	cmp r8, 0
	jl .ask.stripes
.add_stripes:
	inc rcx
	mov BYTE[rcx], al            ; we are only going to copy the least significant byte of RAX (AL), because our age field is only one byte
	
	
.ask.sex:
	
	mov rdi, str_enter_sex       ; ask for the ask_sex
	call print_string_new
	
	call read_char_new
	mov r8, rax
	
.check_male:
	cmp r8, 'M'
	jne .female
	jmp .add_sex
.female:
	cmp r8, 'F'
	jne .ask.sex
.add_sex:
	inc rcx
	mov BYTE[rcx], al            ; we are only going to copy the least significant byte of RAX (AL), because our age field is only one byte
	call read_string_new         ;we need this because the call read_char_new doesn't read the linefeed char so we move the pointer forward
.ask.month:
	
	mov rdi, str_enter_month     ; ask for the ask_month
	call print_string_new
	
	call read_int_new
        cmp rax,-1
        je .ask.month
	mov r8, rax
.check_month:
	cmp r8, 1
	jl .ask.month
	cmp r8, 12
	jg .ask.month
	inc rcx
	mov BYTE[rcx], al            ; we are only going to copy the least significant byte of RAX (AL), because our age field is only one byte
.ask.year:
	
	mov rdi, str_enter_year      ; ask for the ask_year
	call print_string_new
	call read_uint_new
	; call read_string_new
	; mov r8, rax
	mov r8, rax
	mov rdi, rax
	
	;call atoi
	
.check_ifnumber:
	cmp rax, - 1
	je .ask.year
.check_lenght_year:
	cmp rax, 1000
	jl .ask.year
	cmp rax, 9999
	jg .ask.year
.check_ifvalid:
	cmp rax, qword[actual_year]  ;here compare with current date
	jge .ask.year
	
	inc rcx
	
	;call add_param_badg
	mov word[rcx], ax
	
.ask_staff_id:
	mov rdi, str_enter_staffid   ; ask id user
	call print_string_new        ; print string
	call read_string_new         ; read string
	mov r8, rax                  ; insert in a secure place the string
	
.check_lenght_staff:                ; r9 counter lenght compare with the exact lenght
	mov rdi, r8
	call _strlen
	cmp rax, 8                   ;
	jne .ask_staff_id
.check_char:
	cld
	cmp byte[r8], 'p'            ;1 check if id starts with p
	jne .ask_staff_id
	inc r8                       ;increment before enter in the loop, i move the poiter to the first digit
.check2_7digits:
	cmp byte[r8], 48             ; check if the other six digits are number
	jl .ask_staff_id
	cmp byte[r8], 57             ;compare ascii value 0=48 <byte[r8]< 9=57
	jg .ask_staff_id
	
	inc r8
	cmp byte[r8], 0
	jne .check2_7digits
	sub r8, rax   
	add rcx, 2
	call add_param_badg
	
	;
	inc QWORD[current_number_of_badgers] ; increment our number of badgers counter, since we have just added a record into the array.
	dec r12
	
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	ret                          ; End function add_user
list_all_badgers:
	; Takes no parameters (badgers is global)
	; Lists full details of all badgers in the array
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	lea rsi, [badgers]
	mov rcx, [current_number_of_badgers]
	
	mov r10, 1
.start_loop:
	xor r9, r9
	cmp rcx, 0
	je .finish_loop
	call display_a_badger        ; basically we used this function multiple times
	;
	dec rcx                      ; rcx count the iteration
	cmp r10, 1                   ;
	je .start_loop
.finish_loop:
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	ret
	; End function list_all_badgers
	
display_main_menu:
	; No parameters
	; Prints main menu
	push rdi
	mov rdi, str_main_menu
	call print_string_new
	pop rdi
	ret                          ; End function display_main_menu
ask.date:
	
	mov rdi, st_current_month
	call print_string_new
	call read_uint_new
	cmp rax, 1
	jl .error
	cmp rax, 12
	jg .error
	mov qword[actual_month], rax
	mov rdi, st_current_year
	call print_string_new
	call read_uint_new
	cmp rax, 1000
	jl .error
	cmp rax, 9999
	jg .error
	mov qword[actual_year], rax
	
	ret
.error:
	mov rdi, str_invalid_option
	jmp ask.date
	
	
main:
	mov rbp, rsp                 ; for correct debugging
	; We have these three lines for compatability only
	push rbp
	mov rbp, rsp
	sub rsp, 32
         mov rdi,welcome 
         call print_string_new 
         call print_nl_new
	call ask.date
.menu_loop:
	
	call display_main_menu
	call read_int_new            ; menu option (number) is in RAX
	mov rdx, rax                 ; store value in RDX
	; Print the selected option back to the user
	mov rdi, str_option_selected
	call print_string_new
	mov rdi, rdx
	call print_int_new
	call print_nl_new
	; Now jump to the correct option
	cmp rdx, 1
	je .option_1
	cmp rdx, 2
	je .option_2
	cmp rdx, 3
	je .option_3
	cmp rdx, 4
	je .option_4
	cmp rdx, 5
	je .option_5
	cmp rdx, 6
	je .option_6
	cmp rdx, 7
	je .option_7
	cmp rdx, 8
	je .option_8
        cmp rdx, 9
	je .option_9
	; If we get here, the option was invalid. Display error and loop back to input option.
	mov rdi, str_invalid_option
	call print_string_new
	jmp .menu_loop
	
.option_1:                    ; 1. Add Badger
	; Check that the array is not full
	mov rdx, [current_number_of_badgers] ; This is indirect, hence [] to dereference
	cmp rdx, max_num_badgers     ; Note that max_num_badgers is an immediate operand since it is defined at build - time
	jl .array_is_not_full        ; If current_number_of_badgers < max_num_badgers then array is not full, so add new user.
	mov rdi, str_array_full      ; display "array is full" message and loop back to main menu
	call print_string_new
	jmp .menu_loop
.array_is_not_full:
	call add_badger
	jmp .menu_loop
	
.option_2:                    ; 2. List All badgers
	cmp qword[current_number_of_badgers], 0 ; this is when we don't have record in the array
	je .empty
	call display_number_of_badgers
	call print_nl_new
	call list_all_badgers
	jmp .menu_loop
	;
.option_3:                    ; 3. search for id
	cmp qword[current_number_of_badgers], 0 ; this is when we don't have record in the array
	je .empty
	call ask_user_id_badger
	jmp .menu_loop
.option_4:                    ; delete badger

	cmp qword[current_number_of_badgers], 0 ; this is when we don't have record in the array
	je .empty
	call delete_badger
	jmp .menu_loop

.option_5:                    ; add staff
	mov rdx, [current_number_of_staffs]
	cmp rdx, max_num_staffs      ; Note that max_num_badgers is an immediate operand since it is defined at build - time
	jl .arraystaff_is_not_full   ; If current_number_of_badgers < max_num_badgers then array is not full, so add new use
	mov rdi, str_array_full      ; display "array is full" message and loop back to main menu
	call print_string_new
	jmp .menu_loop
.arraystaff_is_not_full:
	call add_staff
	jmp .menu_loop
.option_6:                    ; seach id staff and print
	cmp qword[current_number_of_staffs], 0 ; this is when we don't have record in the array
	je .empty
	call search_id_staff
	jmp .menu_loop
.option_7:                    ; print all staffs
	cmp qword[current_number_of_staffs], 0 ; this is when we don't have record in the array
	call display_number_of_staffs
	call print_nl_new
	call list_all_staff
	jmp .menu_loop
.option_8:                    ; delete staff
	cmp qword[current_number_of_staffs], 0 ; this is when we don't have record in the array
	je .empty
	call delete_staff
	jmp .menu_loop
	
.option_9:                    ; 9. Exit
	; In order to exit the program we just display a message and return from the main function.
	mov rdi, str_program_exit
	call print_string_new
	
	xor rax, rax                 ; return zero
	; and these lines are for compatability
	add rsp, 32
	pop rbp
	
	ret                          ; End function main
.empty:
	mov rdi, empty
	call print_string_new
	call print_nl_new
	jmp .menu_loop
	
	
display_number_of_badgers:
	; No parameters
	; Displays number of users in list (to STDOUT)
	push rdi
	mov rdi, str_number_of_badgers
	call print_string_new
	mov rdi, [current_number_of_badgers]
	call print_uint_new
	call print_nl_new
	pop rdi
	ret                          ; End function display_number_of_users
	
	
	
	
	
show_age:
	mov r8, qword[temp_year] ;year of birth
	mov r12, qword[actual_year]
	sub r12, r8 ; age without looking at month
	mov r8, qword[actual_month] ;  mov month in r8 
	cmp r8, qword[temp_month] ;month of birth  of the actual badger
	jle .add_year
	mov r11, r12
	ret
.add_year:
	mov r11, r12
	dec r12
	ret
	
stripiness:
	mov rax, qword[temp_stripes]
	mul qword[temp_mass]
	ret
	
ask_user_id_badger:
	lea rcx, [badgers]
	mov r11, qword [current_number_of_badgers] ;
	mov rdi, str_enter_badgid    ;
	call print_string_new        ;
	call read_string_new         ;
	mov r8, rax
.check_1_char:
	cld
	cmp byte[r8], 'b'            ;1 check if id starts with b
	jne ask_user_id_badger
	xor r9, r9                   ;initialise a counter for the lenght
	inc r9
	inc r8                       ;increment before enter in the loop, i move the poiter to the first digit
.check2_6digits:
	cmp byte[r8], 48             ; check if the other six digits are number
	jl ask_user_id_badger
	cmp byte[r8], 57             ;compare ascii value 0=48 <byte[r8]< 9=57
	jg ask_user_id_badger
	inc r9                       ;counter lenght
	inc r8
	cmp byte[r8], 0              ;last byte must be null
	jne .check2_6digits
.check_lenght:                ; rcx counter lenght compare with the exact lenght
	cmp r9, 7
	jne ask_user_id_badger
	sub r8, r9                   ; restore r8
	call check_ifexist_badgers
	xor r10, r10
	cmp rax, 1                   ; 1
	je .display
	call error                   ; loc.error
	cmp rax, 0
	je ask_user_id_badger
.display:
	call display_a_badger        ;
	ret
display_a_badger:
	mov rdi, ID                  ;
	call print_string_new        ;
	mov rdi, rsi
	call print_string_new        ;
	mov rdi, 32                  ; space
	call print_char_new
	mov rdi, name
	call print_string_new
	add rsi, 8
	lea rdi, [rsi]
	call print_string_new
	call print_nl_new
	mov rdi, home_sett
	call print_string_new
	add rsi, 64                  ;
	lea rdi, [rsi]
	call print_string_new        ;
	call print_nl_new            ;
	mov rdi, mass                ;
	call print_string_new        ;
	add rsi, 12                  ;
	movzx rdi, byte[rsi]         ; mass is 1 byte
	mov byte [temp_mass], dil    ; 1 byte
	call print_uint_new          ;
	call print_nl_new            ;
	mov rdi, stripes
	call print_string_new
	inc rsi
	movzx rdi, byte[rsi]
	mov byte [temp_stripes], dil ; set var to calculate stripiness
	call print_uint_new
	call print_nl_new            ;
	mov rdi, stripines           ;
	call print_string_new        ;
	call stripiness              ;
	mov rdi, rax                 ; rax contains the result
	call print_uint_new          ;
	call print_nl_new            ;
	mov rdi, gender              ;
	call print_string_new        ;
	inc rsi
	movzx rdi, byte[rsi]         ; 1 byte gender M / F
	mov byte [temp_stripes], dil ;
	call print_char_new          ;
	call print_nl_new            ;
	mov rdi, month               ;
	call print_string_new        ;
	inc rsi
	movzx rdi, byte[rsi]
	mov byte [temp_month], dil   ;
	call print_uint_new          ;
	call print_nl_new            ;
	mov rdi, year                ;
	call print_string_new        ;
	inc rsi
	movzx rdi, word[rsi]
	mov word [temp_year], di     ;
	call print_uint_new          ;
	call print_nl_new            ;
	call show_age                ;
	mov rdi, age                 ;
	call print_string_new        ;
	mov rdi, r12
	call print_uint_new          ;
	call print_nl_new            ;
	mov rdi, staffid             ;
	call print_string_new        ;
	add rsi, 2
	lea rdi, [rsi]
	call print_string_new        ;
	call print_nl_new            ;
	 mov rdi,divider
        call print_string_new
	add rsi, 9
	ret
error:
	mov rdi, str_not_exist
	call print_string_new        ;
	ret
	
delete_badger:
	push rsi
	push rdi
	push rdx
	push rcx
	push rbx
.start_delete:
	mov rdi, str_enter_badgid    ; ask id user
	call print_string_new        ; print string
	call read_string_new         ; read string
	mov r8, rax                  ; move string in r8, we use r8 in check_ifexist_badgers function
	
	lea rcx, [badgers]           ; use rcx in check_ifexist_badgers
	call check_ifexist_badgers
	cmp rax, 1
	je delete
	call error
	jmp .start_delete
	
	
delete:
	mov rax, size_badgers_record ; size offset in rax
	mov rdi, rsi
	xor r9, r9                   ;use to count the number of byte for each badgers
	cmp byte[rsi + rax], 'b'     ; check if the next badgers id starts with b if not it is the last index and we can override the last 99 bytes
	jne .last_index
	mov rcx, rsi                 ; rsi contains the index of badgers we want to delete
	add rcx, 99                  ; jump to the next badger with rcx
.delete_loop:
	xor r8, r8
	mov r8b, byte[rcx]           ; use r8b to copy one byte at time
	mov [rsi], r8b               ; override id with the next badger id one byte at time
	mov rdi, [rsi]
	;call print_char_new ; use for test
	inc r9                       ; counter
	inc rsi                      ; address rsi
	inc rcx                      ; adrress rcx
	cmp r9, 99                   ;
	je delete
	jmp .delete_loop
	
.last_index:                   ; overwrite last index, we already delete the badgers if not we set the last badgers with null
	
	
	mov r8b, 0
	mov [rsi], r8b
	inc r9
	inc rsi
	cmp r9, 99
	je .exit1
	jmp .last_index
	
.exit1:
        
	mov rdi, success
	call print_string_new
        dec qword[current_number_of_badgers]
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	
	ret
	
add_param_staff:              ; add a param of staff to array
	
	cmp r12, 1                   ; we use this to see if we already use this function in add_staff if we use that
	je .skip
	mov rax, QWORD[current_number_of_staffs] ; value of current_number_of_badgers
	mov rbx, size_staff_record   ; size_badgers_record is an immediate operand since it is defined at build time.
	mul rbx                      ; calculate address offset (returned in RAX).
	add rcx, rax                 ;
	inc r12
.skip:
	; RAX now contains the offset of the next user record. We need to add it to the base address of badgers record to get the actual address of the next empty user record.
	; calculate address of next unused badgers record in array
	; RCX now contins address of next empty user record in the array, so we can fill up the data.
	mov rsi, r8                  ; address of new string into rsi
	mov rdi, rcx                 ; address of memory slot into rdi
	call copy_string             ; copy string from input buffer into user record in array
	ret
	
check_ifexist_staff:          ;check if staff id exists
	mov r11, QWORD[current_number_of_staffs] ; set the counter
.loop:
	cmp r11, 0                   ; compare if we have only one id
	je .done
	dec r11                      ; dec the counter the id already in the array are at the index r11 - 1
	mov rdi, r8                  ; prepare the register to compare the string
	mov rax, r11                 ; mov the number in rax
	mov rbx, size_staff_record   ; mov the offset in rbx offset 102
	mul rbx                      ; 102 * rax
	add rcx, rax                 ; rcx point to the first index
	mov rsi, rcx                 ; get the value from rcx to rsi
	sub rcx, rax                 ; restore rcx
	call strings_are_equal       ;rax==1 string are equal, 0 not equal
	cmp rax, 1
	je .done
	jmp .loop
.done:
	ret
add_staff:
	; Adds a new user into the array
	; We need to check that the array is not full before calling this function. Otherwise buffer overflow will occur.
	; No parameters (we are using the badgers array as a global)
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	mov r12, 0
	lea rcx, [staff]             ; base address of staff array, point to staff address
	
	
	; get id staff
.askstaff_id:

	mov rdi, str_enter_staffid   ; ask id user
	call print_string_new        ; print string
	call read_string_new         ; read string
	mov r8, rax                  ; insert in a secure place the string
	call check_ifexist_staff
	cmp rax, 1                   ; if rax is equal to 1
	je .askstaff_id
	
.check_lenght:                ; r9 counter lenght compare with the exact lenght
	mov rdi, r8
	call _strlen
	cmp rax, 8                   ;
	jne .askstaff_id
.check_1_char:
	cld
	cmp byte[r8], 'p'            ;1 check if id starts with p
	jne .askstaff_id
	inc r8                       ;increment before enter in the loop, i move the poiter to the first digit
.check2_7digits:
	cmp byte[r8], 48             ; check if the other six digits are number
	jl .askstaff_id
	cmp byte[r8], 57             ;compare ascii value 0=48 <byte[r8]< 9=57
	jg .askstaff_id
	
	inc r8
	cmp byte[r8], 0
	jne .check2_7digits
	sub r8, rax                  ; rax has the lenght, r8 point to the last byte, so r8 - rax means point to the fisrt char of the id
	call add_param_staff
	;
	
	
	;add param and increment position
	
	
	
	
.ask_surname:
	mov rdi, surname
	call print_string_new        ; print message
	call read_string_new         ; get input from user
	mov r8, Qword rax            ; store the value in a register
	mov rdi, r8                  ; prepare for strlen
	call _strlen
	cmp rax, 64
	jge .ask_surname
	add rcx, 9
	call add_param_staff
	
.ask_name:
	mov rdi, name
	call print_string_new        ; print message
	call read_string_new         ; get input from user
	
	;we need to check the lenght, if already exist and if the 6 digits are all number, and the id must start with b
	mov r8, Qword rax            ; store the value in a register
	mov rdi, r8
	call _strlen
	cmp rax, 64
	jge .ask_name
	add rcx, 64
	call add_param_staff
	
.ask_email:
	
	mov rdi, email
	call print_string_new
	call print_nl_new
	call read_string_new
	mov r8, rax                  ; insert in a secure place the string
	mov rdi, r8                  ; prepare strlen
	mov r10, email_add
	call _strlen
	
	add r8, rax
; we need to concat two string the read string + @jnz.ac.uk	
.build_email:
	xor r13, r13                 ; set 0 r13
	mov r13b, byte[r10]          ;use r13 as temp variable
	
	cmp byte[r10], 0
	je .check_email
	mov [r8], r13b
	mov r13b, [r8]
	;mov rdi, r8
	;call print_char_new
	inc r8
	inc rax
	inc r10
	jmp .build_email
.check_email:
	sub r8, rax                  ;reset r8, now r8 point at the beginning of the email
	; mov rdi, r8
	; call print_string_new ; lines used for test
	call _strlen
	cmp rax, 64
	jge .ask_email
	add rcx, 64
	call add_param_staff         ;add param
.ask_yearjoin:
	mov rdi, year_join
	call print_string_new
	
	call read_uint_new
	
	mov r8, rax
	
.check_ifnumber:
	cmp rax, - 1                 ; result of read_uint_new if its not a interger rax contains - 1
	je .ask_yearjoin
.check_lenght_year:
	cmp r8, 1000
	jl .ask_yearjoin
	cmp r8, 9999
	jg .ask_yearjoin
.check_ifvalid:
	cmp r8, qword[actual_year]   ;here compare with current date
	jg .ask_yearjoin
	
.add_yearjoin:
	add rcx, 64
	mov word[rcx], r8w           ;2 byte are stored in r8 we get this bite using r8b

	
.ask_Department:
	; move along by 64 bytes (which is the size reserved for the name string)
	mov rdi, ask_department
	call print_string_new        ; print message
	call read_uint_new           ; get input from user rax get the value
	; inputted number is now in the RAX register
	cmp rax, 1
	je .Department
	cmp rax, 2
	je .Department2
	cmp rax, 3
	je .Department3
	jmp .ask_Department
.Department:
	mov r8, Park_keeper
	jmp .add_Department
.Department2:
	mov r8, Cafe
	jmp .add_Department
.Department3:
	mov r8, Gift_shop
	jmp .add_Department
.add_Department:
	;add posix
	add rcx, 2
	call add_param_staff
	
.ask_salary:
	mov rdi, salary
	call print_string_new        ; print message
	call read_uint_new           ; get input from user rax get the value
	
	
	mov r8, rax
	cmp rax, - 1
	je .ask_salary
        add rcx, 12
	mov dword[rcx], r8d          ; we use dword because we reserved 4 byte for the salary
	inc qword[current_number_of_staffs]
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	
	ret
	
	
search_id_staff:
	lea rcx, [staff]
	mov rdi, rcx
	mov r11, qword [current_number_of_staffs] ;
	mov rdi, str_enter_staffid   ;
	call print_string_new        ;
	call read_string_new         ;
	mov r8, rax
	call check_ifexist_staff
	cmp rax, 1                   ; if rax is equal to 1
	je .display
	call error                   ; loc.error
	cmp rax, 0
	je search_id_staff
.display:
	call display_a_staff 
	ret
	
display_a_staff: ; this function receive rsi containing the staff array pointed to the position of the staff to print
	mov rdi, ID                  ;
	call print_string_new        ;
	mov rdi, rsi
	call print_string_new        ;
	call print_nl_new

	;surname
	mov rdi, st_surname
	call print_string_new
	add rsi, 9
	lea rdi, [rsi]
	call print_string_new
        	call print_nl_new


	;name
	mov rdi, name
	call print_string_new
	add rsi, 64
	lea rdi, [rsi]
	call print_string_new
        	call print_nl_new

	
	;email
	mov rdi, email_ask
	call print_string_new

	add rsi, 64                  ;
	lea rdi, [rsi]
	call print_string_new        ;
       	call print_nl_new

	          ;
	; year_join
	mov rdi, yearOfJoining       ; year_of_joining
	call print_string_new        ;
	add rsi, 64
	movzx rdi, word[rsi]
	call print_uint_new          ;
        	call print_nl_new

           ;
	;years of service
	mov word [temp_year], di     ;
	mov rdi, st_service
	call print_string_new
	call service                 ; rax return years of service
	mov rdi, rax
	call print_uint_new
        	call print_nl_new

	
	;deparment
	mov rdi, department          ;
	call print_string_new        ;
	add rsi, 2                   ;
	lea rdi, [rsi]               ; deparment 12 bytes
        call print_string_new        ;
	call print_nl_new            ;
	
	;salary
	mov rdi, st_salary
	call print_string_new        ;
        mov rdi, 32                  ; space
	call print_char_new
	
	mov rdi, pound
	call print_string_new
	add rsi, 12
	movsx rdi, dword[rsi]
	call count_salary
	call print_uint_new
        	call print_nl_new
        mov rdi,divider
        call print_string_new


	add rsi, 4
	ret
list_all_staff:
	; Takes no parameters (badgers is global)
	; Lists full details of all badgers in the array
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	lea rsi, [staff]
	mov rcx, [current_number_of_staffs]
	
	mov r10, 1
.start_loop:
	xor r9, r9
	cmp rcx, 0
	je .finish_loop
	call display_a_staff         ; basically we used this function multiple times
	;
	dec rcx                      ; rcx count the iteration
	cmp r10, 1                   ;
	je .start_loop
.finish_loop:
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	ret
	; End function list_all_badgers
	
display_number_of_staffs:
	; No parameters
	; Displays number of staffs in list (to STDOUT)
	push rdi
	mov rdi, str_number_of_staffs
	call print_string_new
	mov rdi, [current_number_of_staffs]
	call print_uint_new
	call print_nl_new
	pop rdi
	ret
	
	
delete_staff:
	push rsi
	push rdi
	push rdx
	push rcx
	push rbx
        lea rcx, [staff]
.start1:

	mov rdi, str_enter_staffid   ; ask id user
	call print_string_new        ; print string
	call read_string_new         ; read string
	mov r8, rax                  ; move string in r8, we use r8 in check_ifexist_badgers function
	
	             
	call check_ifexist_staff ; use rcx in check_ifexist_badger ; return rax 1 if exist 0 if not exist
	cmp rax, 1
	je .delete
	call error
	jmp .start1

	.delete:
	mov rax, size_staff_record   ; size one staff in rax
	mov rdi, rsi
	xor r9, r9                   ;use to count the number of byte for each badgers
	cmp byte[rsi + rax], 'p'     ; check if the next badgers id starts with b if not it is the last index and we can override the last 99 bytes
	jne .last_index
	mov rcx, rsi                 ; rsi contains the index of badgers we want to delete
	add rcx, size_staff_record   ; jump to the next badger with rcx
.delete_loop:
	xor r8, r8
	mov r8b, byte[rcx]           ; use r8b to copy one byte at time
	mov [rsi], r8b               ; override id with the next badger id one byte at time
	mov rdi, [rsi]
	;call print_char_new ; use for test
	inc r9                       ; counter
	inc rsi                      ; address rsi
	inc rcx                      ; adrress rcx
	cmp r9, size_staff_record    ;
	je .delete
	jmp .delete_loop
	
.last_index:                  ; overwrite last index, we already delete the badgers if not we set the last badgers with null
	mov r8b, 0
	mov [rsi], r8b
	inc r9
	inc rsi
	cmp r9, size_staff_record
	je .exit1
	jmp .last_index
	
.exit1:
	mov rdi, success
	call print_string_new
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	dec qword[current_number_of_staffs]
	ret
	
	
	
_strlen:                      ; to use this move the string from the register to rdi, 
	xor r9, r9
_strlen_:
	cmp [rdi], byte 0            ; null byte  condition
	jz _strlen_null              ; yes,  out
	inc r9                       ; char is ok, count it
	inc rdi                      ; move to next char
	jmp _strlen_                 
	
_strlen_null:
	mov rax, r9                  ; r9 = the length (put in rax)    
	xor r9,r9                  
	ret                          ; get out rax contains the lenght
	
	
service: ; rax return year of service
	xor rax, rax
	mov rax, qword[actual_year]
	sub rax, qword[temp_year]
	ret
	
count_salary:
	call service                 ; rax contains
	xor r8, r8
	mov r8, 200
	mul r8
	add rdi, rax
	ret
