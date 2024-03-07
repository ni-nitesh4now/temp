%include "/home/malware/joey_lib_io_v9_release.asm"

global main

section .data
    
;*************************************************************************************************************************************************************    
    prompt_present_year db "Enter present year: ", 0
    prompt_present_month db "Enter present month: ", 0
    
    prompt_bid db "Enter the Badger ID: ",10, 0
    prompt_name db "Enter the Badger Name: ",10, 0
    prompt_sett db "Enter the Badger Home Sett: ",10, \
                                               "1. Settfield", 10, \
                                               "2. Badgerton", 10, \
                                               "3. Stripeville", 10, 0
    prompt_mass db "Enter the mass in kilograms (to the nearest whole kg): ",10, 0
    prompt_stripes db "Enter the number of Stripes: ",10, 0
    prompt_sex db "Enter the Badger sex :", 10, \
                                          "1. Male", 10, \
                                          "2. Female", 10, \
                                          "3. Other", 10, 0
                                          
    prompt_b_month db "Enter the Badger's month of Birth: ",10, 0
    prompt_b_year db "Enter the Badger's year of Birth: ",10, 0
    prompt_keeperID db "Enter StaffID of assigned keeper: ",10, 0
                                                                      ;==================Prompts to take input of various staff and badger information======;
    
    prompt_surname db "Enter the Staff surname: ", 0 
    prompt_firstname db "Enter the Staff first name: ", 0
    prompt_sid db "Enter the Staff ID (Format p0000XXX): ", 0
    prompt_dept db "Enter the Staff Department: ", 10, \
							"1. Park Keeper", 10, \
							"2. Gift Shop", 10, \
							"3. Cafe", 10, 0
    prompt_salary db "Enter the annual salary: ", 0 
    prompt_year db "Enter the year of joining: ", 0
    prompt_email db "Enter the Staff Email address: ", 0
    
    prompt_staff_delete db "Enter the StaffID to delete the record: ", 0
    
;************************************************************************************************************************************************************** 
    
    display_bid db "Badger ID (Format b0000XXX): ", 0
    display_badger_name db "Name: ", 0
    display_sett db "Home Setting: ", 0
    display_mass db "Mass: ", 0
    display_stripe db "Stripes: ", 0
    display_stripiness db "Stripiness: ", 0
    display_sex db "Sex: ", 0
    display_dob db "Date of Birth: ", 0
    display_age db "Age: ", 0
    display_keeperID db "Keeper ID: ", 0
                                                                       ;=============Labels to display various staff and badger information===================;
    display_staff_name db "Name: ", 0
    display_sid db "Staff ID: ", 0
    display_dept db "Department: ", 0
    display_start_salary db "Starting Salary: £", 0
    display_current_salary db "Current salary: £", 0 
    display_year db "Year of joining: ", 0
    display_email db "Email: ", 0

;**************************************************************************************************************************************************************    

        menu_prompt db '---Zoo Management Program---', 10
         db '1. Add User', 10
         db '2. Add Badger', 10
         db '3. Delete User', 10
         db '4. Delete Badger', 10
         db '5. Display All Users', 10
         db '6. Display All Badgers', 10                                  ;==================Prompts to display the menu feature==============================;
         db '7. Search and Display Badger by ID', 10
         db '8. Search and Display Staff by ID', 10
         db '0. Exit', 10
         db 'Enter your choice: ',10,0
        menu_len equ $-menu_prompt
    
    you_selected db "You selected ", 0
 
 
;***************************************************************************************************************************************************************
    prompt_badger_count_full db "Badger list full, delete existing record to continue ", 10, 0
    prompt_staff_count_full db "Staff list full, delete existing record to continue ", 10, 0
    prompt_staff_not_found db "Staff does not exist", 10, 0
    prompt_badger_not_found db "Badger does not exist", 10, 0
    prompt_delete_staff_not_found db "No such staff record to delete", 10, 0            ;===============Different Prompts to ask for badger and staff info====;
    prompt_delete_badger_not_found db "No such badger record to delete", 10, 0          ;===============Also for alert prompts===============;
    prompt_dept_not_found db "There is no such department", 10, 0
    prompt_sid_format_error db "Incorrect StaffID format! format is p0000XXX ", 10, 0       
    prompt_bid_format_error db "Incorrect BadgerID format! format is b0000XXX ", 10, 0
    prompt_badger_sett_error db "Error! No such badger home setting", 10, 0
    prompt_badger_mass_error db "Wrong Badger Mass !", 10 ,0
    prompt_badger_stripes_error db "Badger Stripes input error!",10 ,0
    prompt_badger_sex_error db "Wrong Input for badger sex", 10, 0
    prompt_badger_month_error db "Wrong input for birth month", 10, 0
    prompt_sid_not_found db "StaffID not found", 10, 0    
    prompt_bid_not_found db "BadgerID not found", 10, 0
    prompt_no_staff db "Staff record is empty", 10, 0
    prompt_no_badger db "Badger record is empty", 10, 0
    prompt_exit db "Now Exiting ", 10, 0   
    
    prompt_sid_deleted db "Staff record deleted successfuly", 10, 0
    prompt_bid_deleted db "Badger record deleted successfuly", 10 , 0
    
;***************************************************************************************************************************************************************
        
    del_boolean equ 1
    present_year dq 0
    staff_count dq 0                                                              ;========Defining some constants==========================;
    badger_counter dq 0                                                           ;========Also includes counters to keep record of badgers and staff=========;
    present_month dq 0

;***************************************************************************************************************************************************************
      
    bid equ 8 
    name equ 32 
    sett equ 1 
    mass equ 1                                                                     ;=======initialising memory for badger information==========;
    stripes equ 1 
    sex equ 1 
    b_month equ 1 
    b_year equ 4 
    keeperID equ 9 
    
    badger_name_offset_addr equ del_boolean + bid
    sett_offset_addr equ del_boolean + bid + name            
    mass_offset_addr equ del_boolean + bid + name + sett
    stripes_offset_addr equ del_boolean + bid + name + sett + mass
    sex_offset_addr equ del_boolean + bid + name + sett + mass + stripes
    b_month_offset_addr equ del_boolean + bid + name + sett + mass + stripes + sex
    b_year_offset_addr equ del_boolean + bid + name + sett + mass + stripes + sex + b_month
    kid_offset_addr equ del_boolean + bid + name + sett + mass + stripes + sex + b_month + b_year
    
badgers_record_size equ del_boolean + bid + name + sett + mass + stripes + sex + b_month + b_year + keeperID
max_badgers equ 500
badgers_array_size equ badgers_record_size*max_badgers
    
;****************************************************************************************************************************************************************

    
    surname equ 64 
    id equ 9 
    department equ 1                                                             ;=======initialising memory for staff information==========;
    salary equ 4 
    y_joining equ 2 
    email equ 64 
    
    sid_offset_addr EQU del_boolean + surname + surname
    dept_offset_addr EQU del_boolean + surname + surname + id
    year_offset_addr EQU del_boolean + surname + surname + id + department + salary
    salary_offset_addr EQU del_boolean + surname + surname + id + department
    mail_offset_addr EQU del_boolean + surname + surname + id + department + salary + y_joining

staff_record_size equ del_boolean + surname + surname + id + department + salary + y_joining + surname
max_staff equ 100
staff_array_size equ staff_record_size*max_staff

;***************************************************************************************************************************************************************    
        
                
department_1 db "Park Keeper", 0
department_2 db "Gift Shop", 0
department_3 db "Cafe", 0

badger_home_1 db "Settfield", 0
badger_home_2 db "Badgerton", 0
badger_home_3 db "Stripeville" , 0                      ;========Storing Sex, Staff Department and Home Setting==========================================;                                                 

                                                                    
badger_sex_1 db "Male", 0
badger_sex_2 db "Female", 0
badger_sex_3 db "Other", 0

jan db "Jan", 0
feb db "Feb", 0
mar db "Mar", 0
apr db "Apr", 0
may db "May", 0                                     ;=========Storing months and month error===========================================================;
jun db "Jun", 0
jul db "Jul", 0
aug db "Aug", 0
sep db "Sep", 0
oct db "Oct", 0
nov db "Nov", 0
december db "Dec", 0
month_error db "No such month",10, 0


;***************************************************************************************************************************************************************        
                        
    
section .bss
    badgers_arr: resb badgers_array_size
    staff_arr: resb staff_array_size
    buffer_buffer: resb surname
section .text

input_staff_info:
        push rbx
        push rcx
        push rdx
        push rdi
        push rsi
        mov rcx, staff_arr
        mov rbx, 0
            
            .staff_empty_record_loop:
                cmp byte[rcx], 0
                je .staff_counter_inc 
                add rcx, staff_record_size 
                add rbx, staff_record_size          ;Function to find empty space in the staff array and if not found the function skips to the end
                cmp rbx, staff_array_size
                jl .staff_empty_record_loop 
                push rax
                mov rdi, prompt_staff_count_full
                call print_string_new
                pop rax
                jmp .end_staff_input
            
                .staff_counter_inc:
                    mov byte[rcx], 1            ;Flag to identify a record entry
                    inc rcx
                                                
            .input_surname:
		mov rdi, prompt_surname
		call print_string_new
		call read_string_new
		cmp AL, 0                      ;compare for null input
		je .input_surname
		mov rsi, rax                   ;Function to take input for staff surname and store it in memory
		mov rdi, rcx
		call copy_string
		add rcx, surname 
            
            .input_name:
		mov rdi, prompt_firstname 
		call print_string_new
		call read_string_new
		cmp AL, 0 
		je .input_name                ;Function to take input for staff firstname and store it in memory
		mov rsi, rax 
		mov rdi, rcx 
		call copy_string
		add rcx, surname 
		
	   .input_sid:
		mov rdi, prompt_sid 
		call print_string_new         ;Function to take input for the staffID and check the format and then store it in the memory
		call read_string_new 
		
                .sid_format_filter:
			push rsi
			push rax
			push rbx
			push rcx 

			mov rbx, buffer_buffer 
			mov rsi, rax         ;This copies the string into the buffer (buffer_buffer)                     
			mov rdi, rbx 
			call copy_string 
                         mov al, byte[buffer_buffer] 
			cmp al, 0
			je .input_sid        ;Loop starts again if an empty string is entered
                         mov rax, qword[rbx] 
			.checking_first_byte:
			cmp AL, 'p'
			jne .sid_incorrect   ;Function to check the first byte of the entered string which should be "p"
			shr rax, 8 
                         mov rcx, 7 
			.format_loop:
				cmp al, '0'
				jl .sid_incorrect
				cmp al, '9'
				JG .sid_incorrect       ;Function to check the rest of the format
				shr rax, 8
				dec rcx	
				cmp rcx, 0
				jne .format_loop  
			;END LOOP
			.sid_loop_terminate:
			cmp al, 0	                ;Terminant the function if the last character is a null byte
			je .end_filter_check
			
			.sid_incorrect:
			mov rdi, prompt_sid_format_error
			call print_string_new
			call print_nl_new                ;Function to prompt error if the entered StaffID is incorrect (not correct format)
			jmp .input_sid
			
			.end_filter_check:
			pop rcx
			pop rbx
			pop rax
			pop rsi
		        mov rsi, rax 
		        mov rdi, rcx 
		        call copy_string
		        add rcx, id                       ;Here we store the StaffID after the filter check in the memory reserverd
	
	.input_dept:
		mov rdi, prompt_dept
		call print_string_new
		call read_uint_new
		cmp rax, 1
		jl .dept_error                            ;Function to take Staff Department input and store it  
		cmp rax, 3 
		jle .dept_no_error
		.dept_error:
			mov rdi, prompt_dept_not_found
			call print_string_new            ;Prompts an error for invalid department input (other than 1, 2 or 3)
			jmp .input_dept
		.dept_no_error:
		mov rsi, rax
		mov byte[rcx], al 
		add rcx, department                       ;Store the value if the department value is correct (i.e 1, 2 or 3)

	.input_salary:
		mov rdi, prompt_salary
		call print_string_new
		call read_uint_new
		mov qword[rcx], rax                       ;Function to store Staff's salary
		add rcx, salary

	.input_year_of_joining:
		mov rdi, prompt_year
		call print_string_new
		call read_uint_new                        ;Function to store the year of joining
		mov rsi, rax
		mov dword[rcx], EAX
		add rcx, y_joining

	.input_email:
		mov rdi, prompt_email
		call print_string_new
		call read_string_new
		mov rsi, rax                              ;Function to store Staff's email address
		mov rdi, rcx
		call copy_string
		add rcx, surname

	        inc qword[staff_count]                     ;Increment the staff counter because we made a new entry
	.end_staff_input:
            pop rsi
            pop rdi    
            pop rdx
            pop rcx
            pop rbx 
            ret

;===============================================================================================================================================================



input_badger_info:
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    mov rcx, badgers_arr	
    mov rbx, 0
	
    .badger_empty_record_loop:
        cmp byte[rcx], 0
	je .badger_counter_inc 
	add rcx, badgers_record_size 
	add rbx, badgers_record_size
	cmp rbx, badgers_array_size                ;The same entry as the Staff Input function
	jl .badger_empty_record_loop 
	push rax
	mov rdi, prompt_badger_count_full
	call print_string_new
	pop rax
	jmp .end_badger_input 
	

	.badger_counter_inc:
		mov byte[rcx], 1                  ;Flag to identify a record entry
		inc rcx 

        .badgerid:
            mov rdi, prompt_bid
            call print_string_new
            call read_string_new                   ;Function to take  BadgerId input and check the format and store it if the format is correct
            .bid_format_filter:
                push rsi
                push rax
                push rbx
                push rcx 
                mov rbx, buffer_buffer 
                mov rsi, rax 
                mov rdi, rbx 
                call copy_string 
                mov AL, byte[buffer_buffer] 
                cmp AL, 0
                je .badgerid 
                mov rax, qword[rbx]
                
                .checking_first_byte_bid:
                        
		  cmp AL, 'b'
		  jne .bid_incorrect 
		  shr rax, 8 
			
			; The next 7 characters must all be digits
		  mov rcx, 6 ; counter to check next 7 characters
                .format_loop_bid:
                    
			;START LOOP
		  cmp AL, '0'
		  jl .bid_incorrect
		  cmp AL, '9'
		  JG .bid_incorrect
				
		  shr rax, 8
		  dec rcx	
		  cmp rcx, 0
		  jne .format_loop_bid  
			
                .bid_loop_terminate:
		  cmp AL, 0	                  ;If the last byte is null, the filter loop ends
	          je .end_filter_check_bid
			
                .bid_incorrect:
		  mov rdi, prompt_bid_format_error
		  call print_string_new
		  call print_nl_new               ;Prompts error message if the BadgerID is incorrect format
		  jmp .badgerid
			
            .end_filter_check_bid:
		pop rcx
		pop rbx
		pop rax
		pop rsi
		mov rsi, rax 
		mov rdi, rcx 
		call copy_string
		add rcx, bid 
	
        .badgername:
            mov rdi, prompt_name
            call print_string_new
            call read_string_new
            cmp al, 0                               ;Function to take input for badger name and store it                                   
            je .badgername
            mov rsi, rax
            mov rdi, rcx
            call copy_string
            add rcx, name
        .badgersett:
            mov rdi, prompt_sett
            call print_string_new
            call read_uint_new
            cmp rax, 1                              ;Function to take input for badger home sett and store it 
            jl .sett_error
            cmp rax, 4
            jl .sett_noerror
            .sett_error:
                mov rdi, prompt_badger_sett_error
                call print_string_new
                jmp .badgersett
            .sett_noerror:
                mov rsi, rax
                mov byte[rcx], al
                add rcx, sett
            
        .badgermass:
            mov rdi, prompt_mass
            call print_string_new
            call read_uint_new                      ;Function to take input for badger mass and store it
            cmp al, 0
            jg .badgermass_noerror
            .badgermass_error:
                mov rdi, prompt_badger_mass_error
                call print_string_new               ;Error for less than 0 value
                jmp .badgermass
            .badgermass_noerror:                
            mov rsi, rax                            ;Store if no error
            mov byte[rcx], al
            add rcx, mass
        .badgerstripes:
            mov rdi, prompt_stripes
            call print_string_new                   ;Function to take input for badger stripes and store it
            call read_uint_new
            cmp rax, 0
            jg .badgerstripes_noerror
            .badgerstripes_error:
                mov rdi, prompt_badger_stripes_error
                call print_string_new               ;Error for less than 0
                jmp .badgerstripes
            .badgerstripes_noerror:
            mov rsi, rax
            mov byte[rcx], al                       ;Store if no error
            add rcx, stripes
        .badgersex:
            mov rdi, prompt_sex
            call print_string_new                   ;Function to take input for badger sex and store it
            call read_uint_new
            cmp rax, 1
            jl .badger_sex_error                    
            cmp rax, 4
            jl .badger_sex_noerror
            .badger_sex_error:
                mov rdi, prompt_badger_sex_error
                call print_string_new               ;Error for invalid value
                jmp .badgersex
            .badger_sex_noerror:
                mov rsi, rax
                mov byte[rcx], al                   ;Store if no error
                add rcx, sex
        .badgerbirthmonth:
            mov rdi, prompt_b_month
            call print_string_new
            call read_uint_new
            cmp rax, 1                              ;Function to take input for badger's birth month and store
            jl .badger_month_error
            cmp rax, 13
            jl .badger_month_noerror
            .badger_month_error:
                mov rdi, prompt_badger_month_error
                call print_string_new               ;Error for invalid value
                jmp .badgerbirthmonth
            .badger_month_noerror:
                mov rsi, rax                            
                mov byte[rcx], al                   ;Store if no error
                add rcx, b_month
        .badgerbirthyear:
            mov rdi, prompt_b_year
            call print_string_new
            call read_uint_new
            mov rsi, rax                            ;Function to take input for badger's year of birth and store it
            mov dword[rcx], eax
            add rcx, b_year
        .keeperid:
            mov rdi, prompt_keeperID
            call print_string_new                   ;Function to take input for Keeper's ID
            call read_string_new
            .kid_format_filter:
			push rsi
			push rax
			push rbx
			push rcx 

			mov rbx, buffer_buffer 
			mov rsi, rax 
			mov rdi, rbx             ;Function to check format of Keeper's ID                 
			call copy_string 
                         mov AL, byte[buffer_buffer]
			cmp AL, 0
			je .keeperid 
			mov rax, qword[rbx] 
			.checking_first_byte:
			cmp AL, 'p'              ;Checking Byte to Byte
			jne .kid_incorrect 
			shr rax, 8 
			mov rcx, 7
			.format_loop:
				cmp AL, '0'
				jl .kid_incorrect
				cmp AL, '9'
				JG .kid_incorrect   ;This part checks for each digit entered and decrements value to go to the next iteration
				shr rax, 8
				dec rcx	
				cmp rcx, 0
				jne .format_loop  
				.kid_loop_terminate:
                                       cmp AL, 0	               ;This part terminates the loop when null byte is reached
		                      je .end_filter_check
			
			.kid_incorrect:
			mov rdi, prompt_sid_format_error
			call print_string_new        
			call print_nl_new                ;Error for invalid Keeper's ID format
			jmp .keeperid
			
			.end_filter_check:
			 pop rcx
			 pop rbx
			 pop rax
			 pop rsi
		         mov rsi, rax 
		         mov rdi, rcx                     ;End filter check and store the value
		         call copy_string
		         add rcx, bid 
		
            

        .end_badger_input:
            inc qword[badger_counter]
            pop rsi
            pop rdi    
            pop rdx
            pop rcx
            pop rbx
            ret

;===============================================================================================================================================================


output_staff_info:
    push rcx
    push rdx
    push rdi
    push rsi
    push rbx
    lea rsi, [staff_arr]
    mov rcx,0 
    mov r8,qword[staff_count]

    
    .staff_output_loop:
    
        .delete_staff_check:
			movzx rdi, byte[rsi]         ;Record existence counter
			cmp rdi, 1
			jne .next_staff_record
			call print_nl_new

            .printfullname:
                mov rdi, display_staff_name
                call print_string_new
                lea rdi, [rsi + del_boolean]
                call print_string_new                 ;Function to print staff name (both first name and last name together)
                mov rdi, ' '
                call print_char_new
                lea rdi, [rsi + del_boolean + surname]
                call print_string_new
                call print_nl_new
            
            
            .printsid:
                mov rdi, display_sid
                call print_string_new
                lea rdi, [rsi + sid_offset_addr]
                call print_string_new               ;Function to print StaffID
                call print_nl_new
                lea rdi, [rsi + dept_offset_addr]
            
            
            .printdepartment:
                movzx rdi, byte[rsi + dept_offset_addr]
                .department_1:
                    cmp rdi, 1
                    jne .department_2
                    push rdi
                    mov rdi, department_1           ;Function to print Department 
                    call print_string_new
                    call print_nl_new
                    pop rdi
                    jmp .department_loop_end
                    
                .department_2:
                    cmp rdi, 2
                    jne .department_3
                    push rdi
                    mov rdi, department_2
                    call print_string_new
                    call print_nl_new
                    pop rdi
                    jmp .department_loop_end
                
                .department_3:
                    cmp rdi, 3
                    jne .department_error
                    push rdi
                    mov rdi, department_3
                    call print_string_new
                    call print_nl_new
                    pop rdi
                    jmp .department_loop_end
                
                
                .department_error:
                    push rdi
                    mov rdi, prompt_dept_not_found
                    call print_string_new        ;Error for invalid department
                    call print_nl_new
                    pop rdi
                    jmp .department_loop_end
                    
                .department_loop_end:
            
            .printsalary:
                mov rdi, display_start_salary
                call print_string_new
                movsx rdi, dword[rsi + salary_offset_addr]  ;Function to print original salary
                call print_uint_new
                call print_nl_new
                
                .printcurrentsalary:
                mov rdi, display_current_salary     
                call print_string_new
                push rsi
                push rdi
                push rax
                push rbx
                push rcx
                push rdx
                
                
                movzx rdi, word[rsi + year_offset_addr]
                mov rax, qword[present_year]
                sub rax, rdi
                imul rax, 200                                   ;Function to calculate and print current salary
                movzx rdi, word[rsi + salary_offset_addr]
                add rdi, rax
                call print_uint_new
                call print_nl_new
                
                pop rdx
                pop rcx
                pop rbx
                pop rax
                pop rdi
                pop rsi
                
                
            .printyear:
                mov rdi, display_year
                call print_string_new
                movsx rdi, word[rsi + year_offset_addr]         ;Function to print year of joining 
                call print_uint_new
                call print_nl_new
                
            .printemail:
                mov rdi, display_email
                call print_string_new
                lea rdi, [rsi + mail_offset_addr]               ;Function to print the email address
                call print_string_new
                call print_nl_new
            
            
            .next_staff_record:
                add rsi, staff_record_size
                add rcx, staff_record_size
                dec r8
                cmp r8, 0                              ;Move on to the next record
                je .staff_output_loop_end
                jmp .staff_output_loop
        
    .staff_output_loop_end:
    pop rcx
    pop rdx
    pop rdi
    pop rsi
    pop rbx
    ret
    
;===============================================================================================================================================================
        
    
output_badger_info:
    push rbx
    push rcx
    push rdi
    push rsi
    push rdx
    lea rsi, [badgers_arr]
    mov rcx, 0
    mov r9, qword[badger_counter]
        
                
    .badger_output_loop:
    
        .delete_badger_check:
            movzx rdi, byte[rsi]            
            cmp rdi, 1                      ;Record existence counter
            jne .next_badger_record
            call print_nl_new
                
        .printbid:
            mov rdi, display_bid
            call print_string_new
            lea rdi, [rsi + del_boolean]    ;Function to print BadgerID
            call print_string_new
            call print_nl_new
            
        .printname:
            mov rdi, display_badger_name
            call print_string_new
            lea rdi, [rsi + badger_name_offset_addr]        ;Function to print Badger name
            call print_string_new
            call print_nl_new
        .printsett:
            mov rdi, display_sett
            call print_string_new
            movzx rdi, byte[rsi + sett_offset_addr]
            
            .badger_home1:
                cmp rdi, 1
                jne .badger_home2
                push rdi
                mov rdi, badger_home_1              ;Function to print Badger Home Setting
                call print_string_new
                pop rdi
                jmp .end_print_home
                
            .badger_home2:
                cmp rdi, 2
                jne .badger_home3
                push rdi
                mov rdi, badger_home_2
                call print_string_new
                pop rdi
                jmp .end_print_home
                
            .badger_home3:
                cmp rdi, 3
                jne .badger_home_error
                push rdi
                mov rdi, badger_home_3
                call print_string_new
                pop rdi
                jmp .end_print_home
                
            .badger_home_error:
                push rdi
                mov rdi, prompt_badger_sett_error
                call print_string_new           ;Error for invalid Badger home setting
                pop rdi
                jmp .end_print_home
                
        
        .end_print_home:
            call print_nl_new
        .printmass:
            mov rdi, display_mass
            call print_string_new
            movzx rdi, byte[rsi + mass_offset_addr]         ;Function to print badger mass
            call print_uint_new             
            call print_nl_new
            
        .printstripes:
            mov rdi, display_stripe            
            call print_string_new
            movzx rdi, byte[rsi + stripes_offset_addr]      ;function to print badger stripes
            call print_uint_new
            call print_nl_new

        .printstripiness:
            mov rdi, display_stripiness
            call print_string_new
            movzx rax, byte[rsi + mass_offset_addr]
            movzx rbx, byte[rsi + stripes_offset_addr]      ;Function to calculate and print badger's stripiness
            mul rbx
            mov rdi, rax
            call print_uint_new
            call print_nl_new
            
        .printsex:
            mov rdi, display_sex
            call print_string_new                           ;Function to print badger's sex
            movzx rdi, byte[rsi + del_boolean + id + name + sett + mass + stripes]
            
            .sex1:
                cmp rdi, 1
                jne .sex2
                push rdi
                mov rdi, badger_sex_1
                call print_string_new
                pop rdi
                jmp .endsex
                
            .sex2:
                cmp rdi, 2
                jne .sex3
                push rdi
                mov rdi, badger_sex_2
                call print_string_new
                pop rdi
                jmp .endsex
                
            .sex3:                
                cmp rdi, 3
                jne .sexerror
                push rdi
                mov rdi, badger_sex_3
                call print_string_new
                pop rdi
                jmp .endsex
                
                
            .sexerror:
            push rdi
            mov rdi, prompt_badger_sex_error
            call print_string_new               ;Error for invalid sex input
            pop rdi
            jmp .endsex
        .endsex:
        call print_nl_new
        .printbadgerdob:
            mov rdi, display_dob
            call print_string_new               ;Function to print badger's date of birth
            
            .dobmonth:
                movzx rdi, byte[rsi + b_month_offset_addr]
                        cmp rdi, 12
                        jg .print_month_error                   ;The followiung part is to print the month selected
                        cmp rdi, 1
                        jl .print_month_error
                        .print_jan:
                        cmp rdi, 1
                        jne .print_feb
                        push rdi
                        mov rdi, jan
            	       call print_string_new
		          pop rdi
			jmp .end_print_badgerdob
			.print_feb:
			cmp rdi, 2
			jne .print_mar
			push rdi
			mov rdi, feb
			call print_string_new
			pop rdi
			jmp .end_print_badgerdob
			.print_mar:
			cmp rdi, 3
			jne .print_apr
			push rdi
			mov rdi, mar
			call print_string_new
			pop rdi
			jmp .end_print_badgerdob
			.print_apr:
			cmp rdi, 4
			jne .print_may
			push rdi
			mov rdi, apr
			call print_string_new
			pop rdi
			jmp .end_print_badgerdob
			.print_may:
			cmp rdi, 5
			jne .print_jun
			push rdi
			mov rdi, may
			call print_string_new
			pop rdi
			jmp .end_print_badgerdob
			.print_jun:
			cmp rdi, 6
			jne .print_jul
			push rdi
			mov rdi, jun
			call print_string_new
			pop rdi
			jmp .end_print_badgerdob
			.print_jul:
			cmp rdi, 7
			jne .print_aug
			push rdi
			mov rdi, jul
			call print_string_new
			pop rdi
			jmp .end_print_badgerdob
			.print_aug:
			cmp rdi, 8
			jne .print_sep
			push rdi
			mov rdi, aug
			call print_string_new
			pop rdi
			jmp .end_print_badgerdob
			.print_sep:
			cmp rdi, 9
			jne .print_oct
			push rdi
			mov rdi, sep
			call print_string_new
			pop rdi
			jmp .end_print_badgerdob
			.print_oct:
			cmp rdi, 10
			jne .print_nov
			push rdi
			mov rdi, oct
			call print_string_new
			pop rdi
			jmp .end_print_badgerdob
			.print_nov:
			cmp rdi, 11
			jne .print_december
			push rdi
			mov rdi, nov
			call print_string_new
			pop rdi
			jmp .end_print_badgerdob
			.print_december:
			cmp rdi, 12
			jne .print_month_error
			push rdi
			mov rdi, december
			call print_string_new
			pop rdi
			jmp .end_print_badgerdob
			.print_month_error:
			push rdi
			mov rdi, month_error
			call print_string_new            ;Error for invalid month input
			pop rdi  
			jmp .end_print_badgerdob  
            .end_print_badgerdob:
            mov rdi, ' '
            call print_char_new
            
            .printbadgeryear:
                mov edi, [rsi + b_year_offset_addr]     ;Function to print year of birth
                call print_uint_new
                call print_nl_new
            .enddob:
            .print_age:
                mov rdi, display_age
                call print_string_new
                push rax
                push rbx
                
                movzx rdi, word[rsi + b_year_offset_addr]       ;Function to calculate and print badger's age
                mov rax, present_year
                sub rax, rdi
                
                movzx rdi, byte[rsi + b_year_offset_addr]
                mov rbx, present_month
                cmp rbx, rdi
                jge .no_subtract
                sub rax, 1
                .no_subtract:
                    call print_uint_new
                    call print_nl_new
                    pop rbx
                    pop rax
                    
            .printkeeperid:
                mov rdi, display_keeperID
                call print_string_new
                lea rdi, [rsi + kid_offset_addr]            ;Function to print the Keeper's ID
                call print_string_new
                call print_nl_new
                
        .next_badger_record:
                add rsi, badgers_record_size
                add rcx, badgers_record_size
                dec r9
                cmp r9, 0                              ;Move on to the next record
                je .end_badger_output_loop
                jmp .badger_output_loop
    .end_badger_output_loop:            
    pop rbx
    pop rcx
    pop rdi
    pop rsi
    pop rdx
    ret
        
;===============================================================================================================================================================
        
    
delete_staff_record:
    push rsi
    push rax
    push rbx
    push rcx
    push rdx
    push rdi
    
    mov rdi, prompt_staff_delete
    call print_string_new
    call read_string_new                ;Print the delete prompt
    
    mov rbx, buffer_buffer
    mov rsi, rax
    mov rdi, rbx                        
    call copy_string
    
    lea rsi, [staff_arr]                ;Move the address to staff array
    mov rcx, 0
    mov rbx, 0
    
    .locate_sid:
        .check_record_deleted:
          ;  movzx rdi, byte[rsi]
           ; cmp rdi, 1                  ;Checking if there is a record or not
           cmp qword[staff_count],0
           je .record_deleted
           jmp .check_next_record
    
        .staff_found:
            push rbx
            push rsi
            push rdi
            lea rdi, [rsi + sid_offset_addr]    ;If there is a staff, then load it into the memory
            lea rsi, [buffer_buffer]
            call strings_are_equal
            cmp rax, 0
            pop rdi
            pop rsi
            pop rbx
            je .check_next_record
            
            
        .delete_found_staff:
            mov rbx, 1
            mov byte[rsi], 0
            dec qword[staff_count]              ;Decrement the staff counter
            jmp .end_delete_staff_record
            
        .check_next_record:
            add rsi, staff_record_size          ;Remove the counter and memory
            add rcx, staff_record_size
            cmp rcx, staff_arr
            jg .end_delete_staff_record
            jmp .staff_found
            
    .end_delete_staff_record:
        cmp rbx, 1
        jne .sid_not_found
        mov rdi, prompt_sid_deleted     ;Prompt the staff record is deleted
        call print_string_new
        call print_nl_new
        jmp .record_deleted
        
    .sid_not_found:
        mov rdi, prompt_sid_not_found
        call print_string_new       ;Error if staff record is not found
        call print_nl_new
        
    .record_deleted:
        pop rsi
        pop rdi
        pop rdx
        pop rax
        pop rcx
        pop rbx
        ret

;===============================================================================================================================================================
        
                        
delete_badger_record:
    push rax
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    mov rdi, prompt_bid
    call print_string_new
    call read_string_new
    mov rbx, buffer_buffer
    mov rsi, rax
    mov rdi, rbx                    ;Load the badger array into the memory
    call copy_string
    lea rsi, [badgers_arr]         
    mov rcx, 0
    mov rbx, 0
    .locate_bid:
        .check__badger_record_deleted:
            movzx rdi, byte[rsi]        ;Check if there is a record or not
            cmp rdi, 1
            jne .check_badger_next_record
    
        .badger_found:
            push rbx
            push rsi
            push rdi
            lea rdi, [rsi + del_boolean]
            lea rsi, [buffer_buffer]
            call strings_are_equal      ;If there is a record then load it into the memory
            cmp rax, 0
            pop rdi
            pop rsi
            pop rbx
            je .check_badger_next_record
            
            
        .delete_found_badger:
            mov rbx, 1
            mov byte[rsi], 0            ;Decrement the badger counter 
            dec qword[badger_counter]
            jmp .end_delete_badger_record
            
        .check_badger_next_record:
            add rsi, badgers_record_size
            add rcx, badgers_record_size
            cmp rcx, badgers_arr            ;Move to the next record and match again
            jg .end_delete_badger_record
            jmp .locate_bid
            
    .end_delete_badger_record:
        cmp rbx, 1
        jne .bid_not_found
        mov rdi, prompt_bid_deleted
        call print_string_new               ;Confirm deleted and exit
        call print_nl_new
        jmp .badger_record_deleted
        
    .bid_not_found:
        mov rdi, prompt_bid_not_found
        call print_string_new               ;Error if badger record not found
        call print_nl_new
        
    .badger_record_deleted:
        pop rsi
        pop rdi
        pop rdx
        pop rax
        pop rcx
        pop rbx
        ret
        
;===========================================================I couldn't get the search part to work sadly :-(===================================================================================        

list_badger_by_bid:
    push rax
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    
    .read_search_bid:
        mov rdi, prompt_bid
        call print_string_new
        call print_nl_new
    
    .search_record:
        mov rbx, buffer_buffer
        mov rsi, rax
        mov rdi, rbx
        call copy_string
        lea rsi, [badgers_arr]
        mov rcx, 0
        mov rbx, 0
        
        .find_bid_loop:
            .check_if_deleted:
                movzx rdi, byte[rsi]
                cmp rdi, 1
                jne .check_next_bid
                
            .check_bid:
                push rbx
                push rsi
                push rdi
                lea rdi, [rsi + del_boolean]
                lea rsi, [buffer_buffer]
                call strings_are_equal
                cmp rax, 0
                pop rdi
                pop rsi
                pop rbx
                je .check_next_bid
                
            .bid_found:
                mov rbx, 1
                push rax
                call output_badger_info
                pop rax
                jmp .end_find_bid_loop
                    
        
            .check_next_bid:
                add rsi, badgers_record_size
                add rcx, badgers_record_size
                cmp rcx, badgers_arr
                jg .end_find_bid_loop
                jmp .find_bid_loop
                
                
        .end_find_bid_loop:
            cmp rbx, 1
            jne .invalid_bid
            jmp .end_bid_check
        .invalid_bid:
            mov rdi,prompt_bid_not_found
            call print_string_new
            call print_nl_new

    .end_bid_check:
        pop rdi
        pop rax
        pop rbx
        pop rcx
        pop rdi
        pop rsi
        pop rdx
        ret
        
;====================================================================I couldn't get the search part to work sadly :-(===========================================================================================

list_staff_by_sid:
    push rax
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    
    .read_search_sid:
        mov rdi, prompt_sid
        call print_string_new
        call print_nl_new
    
    .search_record_sid:
        mov rbx, buffer_buffer
        mov rsi, rax
        mov rdi, rbx
        call copy_string
        lea rsi, [staff_arr]
        mov rcx, 0
        mov rbx, 0
        
        .find_sid_loop:
            .check_if_deleted_sid:
                movzx rdi, byte[rsi]
                cmp rdi, 1
                jne .check_next_sid
                
            .check_sid:
                push rbx
                push rsi
                push rdi
                lea rdi, [rsi + del_boolean]
                lea rsi, [buffer_buffer]
                call strings_are_equal
                cmp rax, 0
                pop rbx
                pop rsi
                pop rdi
                je .check_next_sid
                
            .sid_found:
                mov rbx, 1
                push rax
                call output_staff_info
                pop rax
                jmp .end_find_sid_loop
                    
        
            .check_next_sid:
                add rsi, staff_record_size
                add rcx, staff_record_size
                cmp rcx, staff_arr
                jg .end_find_sid_loop
                jmp .find_sid_loop
                
                
        .end_find_sid_loop:
            cmp rbx, 1
            jne .invalid_sid
            jmp .end_sid_check
        .invalid_sid:
            mov rdi,prompt_sid_not_found
            call print_string_new
            call print_nl_new

    .end_sid_check:
        pop rdi
        pop rax
        pop rbx
        pop rcx
        pop rdi
        pop rsi
        pop rdx
        ret                
        

;===============================================================================================================================================================
present_date_input:
    push rsi
    push rbx
    push rax
    push rcx
    push rdi
    .year_input:
        mov rdi, prompt_present_year
        call print_string_new           ;Function to prompt for present year and store it
        call read_uint_new
        mov dword[present_year], eax
        jmp .month_input
        
    .wrong_month:
        mov rdi, month_error            ;Error if invalid month input
        call print_string_new
        
    .month_input:
        mov rdi, prompt_present_month
        call print_string_new
        call read_uint_new              ;Function to prompt for present month and store it 
        cmp rax, 12
        jg .wrong_month
        mov byte[present_month], al

    pop rax
    pop rdi
    pop rsi
    pop rcx
    pop rbx
    ret        

;===============================================================================================================================================================
                                                                                
        
menu_prompt_function:
    push rdi
    mov rdi, menu_prompt        ;Function to print the menu display                    
    call print_string_new
    pop rdi
        ret
        
;===============================================================================================================================================================


main:

    mov rbp, rsp
    push rbp
    mov rbp, rsp
    sub rsp, 32
        .main_function:
            call present_date_input     ;Command to call the present date function
        .menu_display:
            
           call menu_prompt_function    ;Calling the menu display
           call read_int_new            ;Take input
           mov rdx, rax
           mov rdi, you_selected        ;Selection Prompt
           call print_string_new
           mov rdi, rdx
           call print_int_new
           call print_nl_new
           
           
            .processing_option:
                
                cmp rdx, 1
                je .option1
                cmp rdx, 2
                je .option2
                cmp rdx, 3
                je .option3
                cmp rdx, 4
                je .option4
                cmp rdx, 5
                je .option5         ;Code to compare the menu input and jump to the respective function accordingly
                cmp rdx, 6
                je .option6
                cmp rdx, 7
                je .option7
                cmp rdx, 8
                je .option8
                cmp rdx, 0
                je .option0
                
                
        .option1:
            mov rax, qword[staff_count]
            cmp rax, max_staff
            jl .sufficient_staff_space
            mov rdi, prompt_staff_count_full        ;Code to call the Staff input function
            call print_string_new
            jmp .menu_display
           .sufficient_staff_space:
            call input_staff_info
            jmp .menu_display
            
        .option2:
            mov rax, qword[badger_counter]
            cmp rax, max_badgers
            jl .sufficient_badger_space            ;Code to call the Badger input function
            mov rdi, prompt_badger_count_full
            call print_string_new
            jmp .menu_display
           .sufficient_badger_space:
            call input_badger_info
            jmp .menu_display
            
        .option3:
            mov rdx, qword[staff_count]           ;Code to call the Delete staff function
            cmp rdx, 0
            jg .proceed
            mov rdi, prompt_no_staff
            call print_string_new
            jmp .menu_display
            .proceed:
                call delete_staff_record
                jmp .menu_display 
            
        .option4:
            mov rdx, qword[badger_counter]
            cmp rdx, 0
            jg .proceed_badger                  ;Code to call the Delete badger function
            mov rdi, prompt_no_badger
            call print_string_new
            jmp .menu_display
            .proceed_badger:
                call delete_badger_record
                jmp .menu_display 
            
        .option5:
            call output_staff_info
            jmp .menu_display                 ;Function to call the staff output function
            
        .option6:
            jmp output_badger_info
            
        .option7:
            mov rdx, [badger_counter]
            cmp rdx, 0
            jg .records_exist_badger
            mov rdi, prompt_no_badger
            call print_string_new
            jmp .menu_display
            .records_exist_badger:
                call list_badger_by_bid
                jmp .menu_display
            
        .option8:    
            mov rdx, [staff_count]
            cmp rdx, 0
            jg .records_exist_staff
            mov rdi, prompt_no_staff
            call print_string_new
            jmp .menu_display
            .records_exist_staff:
                call list_staff_by_sid
                jmp .menu_display
            
        .option0:
            mov rdi, prompt_exit
            call print_string_new       ;Code to exit the program
            
            
    .end_main:            
        xor rax, rax
        add rsp, 32
        pop rbp
        ret
            
;======================================================================END OF PROGRAM===========================================================================
