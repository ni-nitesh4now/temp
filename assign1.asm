
%include "/home/lubuntu/Desktop/joey.asm"

global main

; The ".data" section is where initialised data in memory is defined. This is where we define strings and other predefined data.
section .data
  
  prnt_badg_art db 10,\
    "======================================================================", 10, \
    "  _____                         _____               __                 ",10, \
    " /__  /  ____   ____           / ___/ __  __ _____ / /_ ___   ____ ___ ",10, \
    "   / /  / __ \ / __ \          \__ \ / / / // ___// __// _ \ / __ `__ \",10, \
    "  / /__/ /_/ // /_/ /         ___/ // /_/ /(__  )/ /_ /  __// / / / / /",10, \
    " /____/\____/ \____/         /____/ \__, //____/ \__/ \___//_/ /_/ /_/ ",10, \
    "                                   /____/                              ",10, \
    "======================================================================", 10,0

  prnt_main_menu db 10,\
                          "Main Menu", 10,\
                          " 1. Add User", 10,\
                          " 2. List All Users", 10, \
                          " 3. Count Users", 10,\
                          " 4. Delete Users", 10,\
                          " 5. Add Badgers", 10,\
                          " 6. List all Badgers", 10,\
                          " 7. Count Badgers", 10,\
                          " 8. Delete Badgers", 10, \
                          " 9. Exit", 10,\
                          "Please Enter Option 1 - 8", 10,\
                          "Warning!! Any wrong input will initiate the main menu to and data entered will be deleted", 10, 0

  prnt_program_exit db "Program exited normally.", 10, 0
  prnt_option_selected db "Option selected: ", 0
  prnt_invalid_option db "Invalid option, please try again.", 10, 0

  department_question db 10,\
                                "Select the number that corresponds with your department", 10,\
                                " 1. Park Keeper", 10,\
                                " 2. Gift Shop", 10,\
                                " 3. Cafe", 10, \
                                "Please Enter Option 1 - 3", 10, 0

  prnt_current_month db "Enter current month:", 10, 0
  prnt_current_year db "Enter current year:", 10, 0
  prnt_enter_surname db "Enter surname:", 10, 0
  prnt_enter_forename db "Enter forename:", 10, 0
  prnt_enter_salary db "Enter salary:", 10, 0
  prnt_enter_year db "Enter starting year:", 10, 0
  prnt_enter_id db "Enter ID & enter the numbers without 'p' i.e. 7 digits only: ", 10, 0
  prnt_enter_email db "Enter email:", 10, 0
  prnt_array_full db "Can't add - storage full.", 10, 0
  prnt_array_empty db "Staff array is empty", 10, 0
  prnt_number_of_users db "Number of users: ", 0
  prnt_error db "Error", 0
  prnt_user_success db "A new user has been added Successfully!! ", 10, 0
  email db "@jnz.co.uk", 0
  park_keeper db "Park Keeper", 0
  gift_shop db "Gift Shop", 0
  cafe db "Cafe", 0


  ;Displaying staff details
  prnt__staff_salary_gbp db " GBP",0
  prnt__staff_letter_p db "p", 0
  prnt__staff db "ID: ", 0
  prnt__year db "Year of Joining: ", 0
  prnt__name db "Full Name: ", 0
  prnt__salary db "Annual Salary: £ ", 0
  prnt__staff_current_salary db "Current Salary: £ ", 0
  prnt__dept db "Deaprtment: ", 0
  prnt__email db "Email: ", 0 

  ;delete staff prompt
  prnt_prompt_user_delete_id db "please enter ID of staff member to delete", 0
  prnt_del_user_id_found db "Staff member ID found", 0
  prnt_del_user_id_notfound db "Staff member ID not found", 0

  size_delete equ 1 ; use this to indicate that the record has been deleted
  size_forename equ 64 ;we define size of block of memory that we want
  size_surname equ 64 ;to reserve and store in size_name_of_field 
  size_id equ 4
  size_dept equ 12
  size_salary equ 4
  size_year_of_joining equ 2
  size_email equ 64

  size_user_record equ size_delete + size_forename + size_surname + size_id + size_dept + size_salary + size_year_of_joining + size_email

  max_num_users equ 100 
  size_users_array equ size_user_record*max_num_users 
  current_number_of_users dq 0 
  current_number_of_badgers dq 0 
  current_year equ 2024
  current_mon equ 1

  prnt_enter_badger_id db "Enter Badgers ID & enter the numbers only without 'b' i.e. 6 digits only:", 10, 0
  prnt_enter_badger_name db "Enter Badger name:", 10, 0
  home_sett db 10,\
                              "Select the number that corresponds with the Home setting of the Badger", 10,\
                              " 1. Settfield", 10,\
                              " 2. Badgerton", 10,\
                              " 3. Stripeville", 10, \
                              "Please Enter Option 1 - 3", 10, 0
  prnt_enter_badger_mass db "Enter Badger mass to the nearest whole KG :", 10, 0
  prnt_enter_badger_stripes db "Enter number of stripes b/w 0-255:", 10, 0
  prnt_enter_badger_sex db "Enter Badger sex:", 10, \
                              " 1. Male", 10, \
                              " 2. Female", 10, 0
  prnt_enter_badger_birth_month db "Enter the birth month of the Badger, ranging (0-11) where ", 10, 0
  prnt_enter_badger_birth_year db "Enter the year Badger was born:", 10, 0
  prnt_number_of_badgers db "Number of Badgers: ", 0
  prnt_badger_birth_format db "number 0 represents January, 1 is February, .... and 11 is December. Default is January, if nothing is entered.", 0

  prnt_enter_badger_keeper db "Please enter the keeper ID of the badger (7 digit number)", 10, 0
  prnt_badger_add_success db "A new Badger is added successfully!!", 10, 0

  settfield db "Settfield", 0
  badgerton db "Badgerton", 0
  stripeville db "Stripeville", 0
  male db "Male", 0
  female db "Female", 0
      
  prnt_del_badg_id_notfound db "No badger with this id was found", 10, 0
  prnt_badg_array_empty db "The badger array is empty", 10, 0
    
    
  prnt__badger_letter_b db "b", 0
  prnt__badger_ID db "Badger ID: ", 0
  prnt__badger_name db "Full Name: ", 0
  prnt__badger_home_sett db "Home Sett: ", 0
  prnt__badger_mass db "Mass: ", 0
  prnt__badger_stripes db "No. of Stripes: ", 0
  prnt__badger_stripiness db "Stripiness: ", 0
  prnt__badger_sex db "Sex: ", 0
  prnt__badger_birth_month db "Badger birth month: ", 0 
  prnt__badger_birth_year db "Badger birth year: ", 0    
  prnt__badger_letter db "b", 0
  prnt__badger_birth db "Badger DOB: ", 0
  prnt__badger_age db "Age: ", 0
  prnt__badger_keeper db "Keeper: ", 0

  prnt_prompt_badg_delete_id db "Please enter badger ID you want to delete", 0
  prnt_badg_id_err db "No badger with this ID exists", 0 
  prnt_del_badg_id_found db "Badger found", 0

  size_badger_id equ 4
  size_badger_name equ 64
  size_badger_home_sett equ 12
  size_badger_mass equ 2
  size_badger_stripes equ 1
  size_badger_sex equ 7
  size_badger_birth_month equ 1
  size_badger_birth_year equ 2


  size_badger_record equ size_delete + size_badger_id + size_badger_name + size_badger_home_sett + size_badger_mass + size_badger_stripes + size_badger_sex + size_badger_birth_month + size_badger_birth_year + size_id
  max_num_badgers equ 500
  size_badgers_array equ size_badger_record * max_num_badgers; Note that max_num_badgers is an immediate operand since it is defined at build-time
section .bss
  users: resb size_users_array
  temp_users: resb size_user_record
  badgers: resb size_badgers_array
  temp_badgers: resb size_badger_record
   
section .text

add_user:
  push rbx
  push rcx
  push rdx
  push rdi
  push rsi
  
  mov rcx, temp_users     ; base address of temp users array
    
  mov byte[rcx], 1
  inc rcx

  ; get user id
  mov rdi, prnt_enter_id
  call print_string_new   ; print message
  call read_uint_new      
  
  mov DWORD[rcx], eax     ; we are only going to copy the least significant byte of RAX (AL), because our age field is only one byte
  cmp rax, 999999
  jle .error
  cmp rax, 10000000
  jge .error

  add rcx, size_id         
  mov rdi, prnt_enter_forename
  call print_string_new   ; print message
  call read_string_new    
  mov rbx, rax
  call string_length
  cmp rax, 63             ; check if string is larger than 63 characters, allowing space for null
  ja .error
  mov rsi, rbx            ; store address in rsi
  mov rdi, rcx            
  call copy_string        

  add rcx, size_forename   
  mov rdi, prnt_enter_surname
  call print_string_new   ; print message
  call read_string_new    
  mov rbx, rax
  call string_length
  cmp rax, 63             ; check if string is larger than 63 characters, allowing space for null
  ja .error
  mov rsi, rbx            ; store address in rsi
  mov rdi, rcx            
  call copy_string        

  add rcx, size_surname    
  mov rdi, prnt_enter_year
  call print_string_new   ; print message
  call read_uint_new      
                          
  mov WORD[rcx], ax       ; we are only going to copy 1 word of RAX
  
  add rcx, size_year_of_joining  
  mov rdi, prnt_enter_salary
  call print_string_new   ; print message
  call read_uint_new      
  mov DWORD[rcx], eax     ; we are only going to copy the least significant byte of RAX (AL), because our age field is only one byte
    
    ;get department
    mov rdi, department_question
    call print_string_new ; print message
    call read_int_new     
    cmp rax, 1
    jne .check_gift_shop
    mov rsi, park_keeper
    jmp .add_department
   .check_gift_shop:
    cmp rax, 2
    jne .check_cafe
    mov rsi, gift_shop
    jmp .add_department
   .check_cafe:
    cmp rax, 3
    jne .department_error
    
    mov rsi, cafe
    jmp .add_department
   .department_error:
    mov rax, -2
    jmp .error
   .add_department:
    add rcx, size_salary 
    mov rdi, rcx        
    call copy_string    ; copy string from into user record in array
      
    ; get email
    mov rdi, prnt_enter_email
    call print_string_new     ; print message
    call read_string_new
    mov rbx, rax
    call string_length
    cmp rax, 63               ; check if string is larger than 63 characters, allowing space for null
    ja .error
    mov rsi, rbx
    lea rsi, [rbx + rax - 10] ; go the last 10 bytes of the user string and check its "@jnz.co.uk"
    lea rdi, [email]
    call strings_are_equal
    cmp rax, 1
    jne .error
    add rcx, size_dept
    mov rsi, rbx
    mov rdi, rcx              ; store address in rsi
    call copy_string          
    call print_nl_new 

    mov rdi, prnt_user_success ; inform user is added successfully!!
    call print_string_new
    call print_nl_new

    ; copy temp array into array 
    mov rcx, users            ; base address of users array
    mov rsi, temp_users
    mov rbx, 0

    ; find an empty spot to copy to
    .find_spot_to_add_user:
      cmp byte[rcx],1
      jne .do_user_copy
      add rcx, size_user_record
      inc rbx
      cmp rbx, max_num_users
      jl .find_spot_to_add_user
    .no_space_user:
      mov rdi, prnt_array_full
      call print_string_new
  
    .do_user_copy:
    mov rdi, rcx                          
    call copy_string

    add rsi, size_delete                  ; delete flag
    lea rdi, [rcx + size_delete]          
    call copy_string

    add rsi, size_id                      ; size ID
    lea rdi, [rcx + size_delete + size_id]  
    call copy_string
    
    add rsi, size_forename                ; forename
    lea rdi, [rcx + size_delete + size_id + size_forename] 
    call copy_string 

    add rsi, size_surname                 ; surname
    lea rdi, [rcx + size_delete + size_forename+size_id+size_surname]
    call copy_string 

    add rsi, size_year_of_joining         ; year of joining
    lea rdi, [rcx + size_delete + size_forename+size_id+size_surname+size_year_of_joining]
    call copy_string 

    add rsi, size_salary                  ; salary
    lea rdi, [rcx + size_delete + size_forename+size_id+size_surname+size_year_of_joining+size_salary]
    call copy_string 

    add rsi, size_dept                    ; department
    lea rdi, [rcx + size_delete + size_forename+size_id+size_surname+size_year_of_joining+size_salary+size_dept]
    call copy_string
    
    inc qword[current_number_of_users]    ; increment our number of users counter, since we have just added a record into the array.
    
    mov rdi, temp_users                   ; clear temp array here
    mov rcx, size_user_record
    xor al, al
    rep stosb
    
    pop rsi    
    pop rdi    
    pop rdx
    pop rcx
    pop rbx 
    ret                                   

   .error:
    mov rdi, temp_users
    mov rcx, size_user_record
    xor al, al
    rep stosb
    
    mov rdi, prnt_error
    call print_string_new
    pop rsi    
    pop rdi    
    pop rdx
    pop rcx
    pop rbx 
    ret ; End function add_user
    
    
list_all_users:                          
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi

    lea rsi, [users]                        ; load base address of the users array into RSI
    mov rcx, 0                              ; we will use RCX for the counter in our loop

  .start_loop:                              ; this is the start of our loop
    mov rdi, rsi                            
    cmp BYTE[rdi], 1                        ; put a check here for the delete flag
    jne .goto_next_user

    mov rdi, prnt__staff                  ; "Staff ID: "
    call print_string_new
    mov rdi, prnt__staff_letter_p         ; prints the "p"
    call print_string_new
  
    mov edi, [rsi + size_delete]            ; the staff ID
    call print_uint_new
    call print_nl_new
    

    mov rdi, prnt__name                   ; "Name: "
    call print_string_new
  
    lea rdi, [rsi + size_delete + size_id ] ; Forname
    call print_string_new
    mov rdi,' '                             ; space character, between forename and surname.
    call print_char_new                     ; print a space
    
    lea rdi, [rsi + size_delete + size_id + size_forename] ; surname
    call print_string_new
    call print_nl_new
    
    mov rdi, prnt__year                   ; Year of Joining:
    call print_string_new
    
    movzx rdi, WORD[rsi + size_delete + size_id+size_forename + size_surname] ; year
    mov rbx, rdi  
    call print_uint_new 
    call print_nl_new
    
    mov rdi, prnt__salary                 ; Salary
    call print_string_new
    
    mov edi, DWORD[rsi + size_delete + size_id+size_forename+size_surname+ size_year_of_joining] 
    call print_uint_new
    mov rdi, prnt__staff_salary_gbp       ; prints the gbp as currency
    call print_string_new 
    call print_nl_new

    mov rdi, prnt__staff_current_salary   ; current salary after adding bonus
    call print_string_new

    movzx rdi, WORD[rsi + size_delete + size_id + size_forename + size_surname] ; start year
    mov rax, current_year
    sub rax, rdi                            ; years_worked = current_year - start_year
    imul rax, 200                           ; bonus = years_worked * 200

    mov edi, DWORD[rsi + size_delete + size_id+size_forename+size_surname+ size_year_of_joining] ; starting salary
    add rdi, rax                            ; current_salary = starting_salary + bonus
    call print_uint_new
    mov rdi, prnt__staff_salary_gbp       ; prints gbp as currency
    call print_string_new
    call print_nl_new

    mov rdi, prnt__dept                   ; Department: 
    call print_string_new
    
    lea rdi, [rsi + size_delete + size_id+size_forename+size_surname+size_year_of_joining + size_salary] ;
    call print_string_new
    call print_nl_new
    
    mov rdi, prnt__email                  ; Email
    call print_string_new
    
    lea rdi, [rsi + size_delete + size_id+size_forename+size_surname+size_year_of_joining+size_salary+size_dept] 
    call print_string_new
    call print_nl_new
    
    call print_nl_new                       ; go to next user record
    .goto_next_user:
    
    add rsi, size_user_record ; move the address to point to the next record in the array
    add rcx, size_user_record ; increment our counter variable
    cmp rcx, size_users_array
    jl .start_loop            ; jump back to the start of the loop (unconditional jump)
  .finish_loop:

    pop rsi    
    pop rdi    
    pop rdx
    pop rcx
    pop rbx
    ret                       

prnt__number_of_users:
    push rdi
    mov rdi, prnt_number_of_users
    call print_string_new
    mov rdi, [current_number_of_users]
    call print_uint_new
    call print_nl_new
    pop rdi    
    ret ; End function prnt__number_of_users

prnt__main_menu:
    push rdi
    mov rdi, prnt_main_menu
    call print_string_new
    pop rdi
    ret ; End function prnt__main_menu

string_length:      ;common function for both badgers and staff for length
    push rcx
    push rbx
    push rdi
    sub rcx,rcx			; this sets the max size to look for to be
    not rcx			    
    mov al, 0       ; We want to look for the byte 0, null terminator
    mov rdi, rbx		; set the start of the string
    cld
    repne scasb			; perform search operation
    sub rdi, rbx		; perform search operation
    dec rdi			    
    mov rax, rdi
    pop rdi
    pop rbx
    pop rcx
    ret




add_badgers:
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    
    mov rcx, temp_badgers                   
    
    mov byte[rcx], 1                        
    inc rcx

    mov rdi, prnt_enter_badger_id            ; get badger id
    call print_string_new 
    call read_uint_new                      
    mov DWORD[rcx], eax                     
    cmp rax, 99999
    jle .badger_error
    cmp rax, 1000000
    jge .badger_error
    add rcx, size_badger_id                  

    mov rdi, prnt_enter_badger_name          ; get badger name
    call print_string_new 
    call read_string_new                    
    mov rbx, rax
    call string_length
    cmp rax, 63                             
    ja .badger_error
    mov rsi, rbx                            ; store address in rsi
    mov rdi, rcx                            
    call copy_string                        
  
    mov rdi, home_sett                      
    call print_string_new 
    call read_int_new                       
    cmp rax, 1                              
    jne .check_badgerton
    mov rsi, settfield
    jmp .add_home_sett
   .check_badgerton:
    cmp rax, 2
    jne .check_stripeville
    mov rsi, badgerton
    jmp .add_home_sett
   .check_stripeville:
    cmp rax, 3
    jne .home_sett_error
    mov rsi, stripeville
    jmp .add_home_sett
   .home_sett_error:
    mov rax, -2
    jmp .badger_error
   .add_home_sett:
    add rcx, size_badger_name
    mov rdi, rcx                          
    call copy_string                      
  
  ;get badger mass
    add rcx, size_badger_home_sett
    mov rdi, prnt_enter_badger_mass
    call print_string_new
    call read_uint_new
    mov WORD[rcx], ax
  
  ;get Badger stripes
    add rcx, size_badger_mass
    mov rdi, prnt_enter_badger_stripes 
    call print_string_new
    call read_uint_new
    mov BYTE[rcx], al
  
  ;get Badger sex
    mov rdi, prnt_enter_badger_sex
    call print_string_new ; print message
    call read_int_new ;read in option
    cmp rax, 1
    jne .check_female
    mov rsi, male
    jmp .add_badger_sex
   .check_female:
    cmp rax, 2
    jne .badger_sex_error
    mov rsi, female
    jmp .add_badger_sex
   .badger_sex_error:
    mov rax, -2
    jmp .badger_error
   .add_badger_sex:
    add rcx, size_badger_stripes
    mov rdi, rcx
    call copy_string 
  
  ;get Badger birth month
    add rcx, size_badger_sex
    mov rdi, prnt_enter_badger_birth_month
    call print_string_new
    mov rdi, prnt_badger_birth_format
    call print_string_new
    call print_nl_new
    call read_uint_new
    mov BYTE[rcx], al
    cmp rax, 12
    jge .badger_error
    add rcx, size_badger_birth_month

  ;get Badger birth year
    mov rdi, prnt_enter_badger_birth_year
    call print_string_new
    call read_uint_new
    mov WORD[rcx], ax
    cmp rax, current_year
    jg .badger_error ; badger birth year should not be greater than current year
    call print_nl_new 
    add rcx, size_badger_birth_year


  ; add badger keeper
    mov rdi, prnt_enter_badger_keeper
    call print_string_new
    call read_uint_new
    ; use the same check/comparison as keeper id
    mov DWORD[rcx], eax ; we are only going to copy the least significant byte of RAX (AL),
    cmp rax, 999999
    jle .badger_error
    cmp rax, 10000000
    jge .badger_error

  ; all details added
    mov rdi, prnt_badger_add_success
    call print_string_new
    call print_nl_new

                                ;copying temp array into badger array
    mov rcx, badgers            ; base address of badgers array
    mov rsi, temp_badgers       ; address of temp_badgers
    mov rbx, 0

    .find_spot_to_add_badger:
      cmp byte[rcx], 1          ; use the first byte of each badger record to figure out if it's been deleted or not
      jne .do_badger_copy
      add rcx, size_badger_record
      inc rbx
      cmp rbx, max_num_badgers
      jl .find_spot_to_add_badger
    .no_space_badger:
      mov rdi,prnt_array_full
      call print_string_new
      
    .do_badger_copy:
    mov rdi, rcx
    call copy_string                    ; copy delete flag
    
    add rsi, size_delete
    lea rdi, [rcx + size_delete]
    call copy_string                    ; copy id

    add rsi, size_badger_id
    lea rdi, [rcx + size_delete + size_badger_id]
    call copy_string                      ; copy badger name
    
    add rsi, size_badger_name
    lea rdi, [rcx +  size_delete + size_badger_name+size_badger_id]
    call copy_string                      ; copy badger sett
    
    add rsi, size_badger_home_sett
    lea rdi, [rcx +  size_delete + size_badger_name+size_badger_id+size_badger_home_sett]
    call copy_string                      ; copy badger mass
    
    add rsi, size_badger_mass 
    lea rdi, [rcx +  size_delete + size_badger_name+size_badger_id+size_badger_home_sett+size_badger_mass]
    call copy_string                      ; copy badger stripes
    
    add rsi, size_badger_stripes
    lea rdi, [rcx +  size_delete + size_badger_name+size_badger_id+size_badger_home_sett+size_badger_mass+size_badger_stripes]
    call copy_string                      ; copy badger sex
    
    add rsi, size_badger_sex
    lea rdi, [rcx +  size_delete + size_badger_name+size_badger_id+size_badger_home_sett+size_badger_mass+size_badger_stripes+size_badger_sex]
    call copy_string                      ; copy badger birth month
    
    add rsi, size_badger_birth_month
    lea rdi, [rcx +  size_delete + size_badger_name+size_badger_id+size_badger_home_sett+size_badger_mass+size_badger_stripes+size_badger_sex+size_badger_birth_month]
    call copy_string                      ; copy badger birth year 

    add rsi, size_badger_birth_year
    lea rdi, [rcx +  size_delete + size_badger_name+size_badger_id+size_badger_home_sett+size_badger_mass+size_badger_stripes+size_badger_sex+size_badger_birth_month + size_badger_birth_year]
    call copy_string                      ; copy badger birth year 

    inc QWORD[current_number_of_badgers]  ; increment our number of users counter, since we have just added a record into the array.
    jmp .end_add_badg
    
   .badger_error:    
    mov rdi, prnt_error
    call print_string_new
    call print_nl_new 


    .end_add_badg:
    ; clear temp array here
    mov rdi, temp_badgers
    mov rcx, size_badger_record
    xor al, al
    rep stosb

    pop rsi    
    pop rdi    
    pop rdx
    pop rcx
    pop rbx 
    ret ; End function add_user

list_all_badgers: 
    ; Takes no parameters (badgers is global)
    ; Lists full details of all badgers in the array
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi

    lea rsi, [badgers]                ; load base address of the badgers array into RSI. In other words, RSI points to the badgers array.
    mov rcx, 0 

  .start_badger_loop:                 ; this is the start of our loop

    mov rdi, rsi                      ; put the pointer to the current record in RDI, to pass to the print_string_new function
    
    cmp byte[rdi], 1                  ; check badger delete flag
    jne .goto_next_badger

    mov rdi, prnt__badger_ID        ; Badger ID:
    call print_string_new

    mov rdi, prnt__badger_letter_b  ; the letter b
    call print_string_new
    
    mov edi, [rsi + size_delete]      ; offset of badger ID
    call print_uint_new
    call print_nl_new
    
    mov rdi, prnt__badger_name      ; display Badger name
    call print_string_new
  
    lea rdi, [rsi + size_delete + size_badger_id] ; offset of badger Name
    call print_string_new
    call print_nl_new

    mov rdi, prnt__badger_home_sett ; display Badger Sett
    call print_string_new

    lea rdi, [rsi + size_delete + size_badger_id + size_badger_name] ; sett
    call print_string_new
    call print_nl_new
    
    ;display Badger mass
    mov rdi, prnt__badger_mass
    call print_string_new
    
    movzx rdi, WORD[rsi + size_delete + size_badger_id+size_badger_name+size_badger_home_sett] ; mass
  
    call print_uint_new ; print the mass
    call print_nl_new
    
    ;display badger stripes
    mov rdi, prnt__badger_stripes
    call print_string_new
    
    movzx rdi, BYTE[rsi + size_delete + size_badger_id+size_badger_name+size_badger_home_sett+size_badger_mass] ; stripes
    
    call print_uint_new 
    call print_nl_new
    
    ; display stripiness
    mov rdi, prnt__badger_stripiness
    call print_string_new

    movzx rax, BYTE[rsi + size_delete + size_badger_id+size_badger_name+size_badger_home_sett+size_badger_mass] ; stripes
    movzx rbx, WORD[rsi + size_delete + size_badger_id+size_badger_name+size_badger_home_sett] ; mass
    mul rbx     ; stripiness = mass * stripes
    mov rdi, rax
    call print_uint_new
    call print_nl_new

    ; display badger sex
    mov rdi, prnt__badger_sex
    call print_string_new
    
    lea rdi, [rsi + size_delete + size_badger_id+size_badger_name+size_badger_home_sett+size_badger_mass+ size_badger_stripes]; move the pointer along by 129 bytes from the base address of the record (combined size of the forename and surname strings, and age) 
    call print_string_new
    call print_nl_new
    
    ; display birth year & month
    mov rdi, prnt__badger_birth
    call print_string_new
    movzx rdi, BYTE[rsi + size_delete + size_badger_id+size_badger_name+size_badger_home_sett+size_badger_mass+size_badger_stripes+size_badger_sex] ; month
    call print_uint_new
    mov rdi, '/'
    call print_char_new

    movzx rdi, WORD[rsi + size_delete + size_badger_id+size_badger_name+size_badger_home_sett+size_badger_mass+size_badger_stripes+size_badger_sex+size_badger_birth_month] ; year

    call print_uint_new
    call print_nl_new

    ; display badger current age    
    mov rdi,prnt__badger_age
    call print_string_new

    movzx rdi, WORD[rsi + size_delete + size_badger_id+size_badger_name+size_badger_home_sett+size_badger_mass+size_badger_stripes+size_badger_sex+size_badger_birth_month] ; year
    mov rax, current_year
    sub rax, rdi ; current_year - badger_birth_year = gives the badger_age
    
    movzx rdi, BYTE[rsi + size_delete + size_badger_id+size_badger_name+size_badger_home_sett+size_badger_mass+size_badger_stripes+size_badger_sex] ; month
    mov rbx, current_mon

    cmp rbx, rdi
    jge .curr_month_greater_than_birth  ; unless current month is before their birthday,
    dec rax
    .curr_month_greater_than_birth:
    mov rdi, rax
    call print_uint_new
    call print_nl_new

    ; assigned keeper
    mov rdi, prnt__badger_keeper
    call print_string_new

    mov rdi, prnt__staff_letter_p
    call print_string_new
    
    mov edi, [rsi + size_delete + size_badger_id+size_badger_name+size_badger_home_sett+size_badger_mass+size_badger_stripes+size_badger_sex+size_badger_birth_month + size_badger_birth_year]
    call print_uint_new
    call print_nl_new
    call print_nl_new
    .goto_next_badger:
    add rsi, size_badger_record               ; move the address to point to the next record in the array
    add rcx, size_badger_record               ; increase our counter variable
    cmp rcx, size_badgers_array
    jl .start_badger_loop                     ; jump back to the start of the loop (unconditional jump)
  .finish_badger_loop: 
    pop rsi    
    pop rdi    
    pop rdx
    pop rcx
    pop rbx
    ret                                       ; End function list_badgers

  delete_badger:                              ; delete badger function
        push rbx
        push rcx
        push rdx
        push rdi
        push rsi

        .read_badg_del_id:                    ; get ID of badger from user
            mov rdi, prnt_prompt_badg_delete_id
            call print_string_new
            call print_nl_new
            call read_uint_new
            cmp rax, 99999                    ; value checks for a valid 6 digit number
            jl .badg_id_err
            cmp rax, 1000000
            jg .badg_id_err
            ; if it doesn't jump, Badger ID is fine

        ; perform search operation to see if this badger id exists
        mov rbx, badgers                          ; base address
        mov rcx, 0                                ; counter
        .start_find_badg_del_loop:
            .find_badg_id_del:
                cmp byte[rbx], 1
                jne .goto_next_badg_delete
                mov edi, dword[rbx + size_delete] ; compare badger ID with user input in rax
                cmp rax, rdi
                je .badg_del_id_found
            .goto_next_badg_delete:               ; go to the next address where a record should be
                add rbx, size_badger_record
                inc rcx
            .do_stop_badg_loop:                   ; check if or if not  youǘe gone over
                cmp rcx, max_num_badgers
                jg .badg_id_err
                jmp .find_badg_id_del
        .end_find_badg_del_loop:
            
        .badg_del_id_found:                       ; record exists with badger ID
            mov rdi, prnt_del_badg_id_found
            call print_string_new
            call print_nl_new
            mov byte[rbx], 0                      ; set the delete flag to 0
            dec qword[current_number_of_badgers]  ; decrease the counter
            jmp .end_badg_del

        .badg_id_err:                             ; record doesn't exist 
            mov rdi, prnt_del_badg_id_notfound
            call print_string_new
            call print_nl_new

        .end_badg_del:
        pop rsi
        pop rdi
        pop rdx
        pop rcx
        pop rbx
        ret


delete_user:                                      ; delete user record
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    .read_user_del_id:
        mov rdi, prnt_prompt_user_delete_id
        call print_string_new
        call print_nl_new
        call read_uint_new
        cmp rax, 999999
        jle .error_del
        cmp rax, 10000000
        jge .error_del

    mov rbx, users                          ; base address of user array
    mov rcx, 0                              ; counter
    .find_id_del_loop:
        .find_user_id:
            cmp byte[rbx], 1                ; delete flag must be set to 1
            jne .goto_next_user_delete
            mov edi, dword[rbx + size_delete]
            cmp rax, rdi
            je .found_user_now_delete
            jmp .goto_next_user_delete            
        .goto_next_user_delete:
            add rbx, size_user_record
            inc rcx
        .check_stop_user_loop:
            cmp rcx, max_num_users
            jg .error_del
            jmp .find_user_id
    .end_id_del_loop:

    .found_user_now_delete:
        mov rdi, prnt_del_user_id_found
        call print_string_new
        call print_nl_new
        mov byte[rbx], 0                    ; set the byte to 0
        dec QWORD[current_number_of_users]
        jmp .end_del

    .error_del:
        mov rdi, prnt_del_user_id_notfound
        call print_string_new
        call print_nl_new

    .end_del:
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    ret


prnt__number_of_badgers:
                                            ; No parameters
                                            ; Displays number of users in list (to STDOUT)
    push rdi
    mov rdi, prnt_number_of_badgers
    call print_string_new
    mov rdi, [current_number_of_badgers]
    call print_uint_new
    call print_nl_new
    pop rdi    
    ret                                     ; End function prnt__number_of_badgers

main: 
    mov rbp, rsp                            ; for correct debugging
    push rbp
    sub rsp, 32
    
    mov rdi, prnt_badg_art  ; Assuming prnt_badg_art is defined earlier
    call print_string_new
    call print_nl_new

    ; Take input for the current month and set it as the new current month
    mov rdi, prnt_current_month
    call print_string_new
    call read_int_new
    mov [current_mon], rax  ; Set the entered value as the new current month
  
    ; Take input for the current year and set it as the new current year
    mov rdi, prnt_current_year
    call print_string_new
    call read_int_new
    mov [current_year], rax  ; Set the entered value as the new current year

    .menu_loop:
    call prnt__main_menu
    call read_int_new                       ; menu option (number) is in RAX
    mov rdx, rax                            
    mov rdi, prnt_option_selected
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
    ;Display error and loop back to input option in case of any error
    mov rdi, prnt_invalid_option
    call print_string_new
    jmp .menu_loop

  .option_1:                              ; 1. Add User
    mov rdx, [current_number_of_users]    ; This is indirect, hence [] to dereference
    cmp rdx, max_num_users                ; Note that max_num_users is an immediate operand since it is defined at build-time
    jl .array_is_not_full                 ; If current_number_of_users < max_num_users then array is not full, so add new user.
    mov rdi, prnt_array_full               ; display "array is full" message and loop back to main menu
    call print_string_new
    jmp .menu_loop
  .array_is_not_full:
    call print_nl_new
    call add_user
    jmp .menu_loop
    
  .option_2:                              ; 2. List All Users
    call print_nl_new
    call list_all_users
    jmp .menu_loop
    
  .option_3:                              ; 3. Count Users
    call print_nl_new
    call prnt__number_of_users
    jmp .menu_loop 
    
  .option_4:                              ; 4. Delete user 
    call print_nl_new
    mov rdx, current_number_of_users 
    cmp rdx, 0                            
    jg .staff_array_isnt_empty            ; If current_number_of_users <= 0 then array is empty
    mov rdi, prnt_array_empty              ; display array is empty message and loop back to main menu
    call print_string_new
    jmp .menu_loop
  .staff_array_isnt_empty:
    call print_nl_new
    call delete_user
    jmp .menu_loop
    
  .option_5:                              ; 5. Add Badgers
    mov rdx, [current_number_of_badgers]  ; This is indirect, hence [] to dereference
    cmp rdx, max_num_badgers              ; Note that max_num_badgers is an immediate operand since it is defined at build-time
    jl .badger_array_is_not_full          ; If current_number_of_badgers < max_num_badgers then array is not full, so don't add new badger
    mov rdi, prnt_array_full               ; display "array is full" message and loop back to main menu
    call print_string_new
    jmp .menu_loop
  .badger_array_is_not_full:
    call add_badgers
    jmp .menu_loop
  
  .option_6:                              ; 6. List All Badgers
    call print_nl_new
    call list_all_badgers
    jmp .menu_loop

  .option_7:                              ; 7. Count Badgers
    call print_nl_new
    call prnt__number_of_badgers
    jmp .menu_loop 

  .option_8:                              ; 8. delete badgers
    mov rdx, [current_number_of_badgers]  ; This is indirect, hence [] to dereference
    cmp rdx, 0                            ; compare current_number_of_badgers to see if it isn't 0
    jg .badger_array_is_not_empty         ; If current_number_of_users > 0 then array is not empty, so proceed to delete.
    mov rdi, prnt_badg_array_empty         ; display "array is empty" message and loop back to main menu
    call print_string_new
    jmp .menu_loop
  .badger_array_is_not_empty:
    call delete_badger
    jmp .menu_loop
  
  .option_9:                              ; 9. Exit
    mov rdi, prnt_program_exit
    call print_string_new
    xor rax, rax                          
    add rsp, 32
    pop rbp
    ret                                   
