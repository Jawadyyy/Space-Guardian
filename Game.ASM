;;=============================================================================;;   
;;                          Space Guardians                                    ;;                               
;;=============================================================================;;
;;                      Created by: Jawad Mansoor                              ;;
;;=============================================================================;;

.MODEL SMALL
.STACK 100H

.DATA
    ; Player variables
    x_pos dw 160      ; Player X position
    y_pos dw 184      ; Player Y position (bottom) 
    ; Add these to your .DATA section
    player_speed dw 4      ; Default speed (medium)
    speed_msg db 'Select Speed:$'
    speed_option1 db '1. Slow (2)$'
    speed_option2 db '2. Medium (4)$'
    speed_option3 db '3. Fast (6)$'
    current_speed_msg db 'Current Speed: $'
    slow_msg db 'Slow$'
    med_msg db 'Medium$'
    fast_msg db 'Fast$'         
    
    player_name db 20 dup(0)  ; Buffer for player name
    name_prompt db 'Enter your name(19 char): $'
    score_display db 'Player: $'
    score_display2 db ' - Score: $'
    press_enter_msg db 'Press any key to return to menu...$'
    temp_score_str db '0000$'   ; Temporary buffer for score conversion

    
    ; Bullet variables
    bullet_x dw 0      ; Current bullet X (0 means no bullet)
    bullet_y dw 0      ; Current bullet Y
    bullet_speed dw 3  ; Bullet movement speed
    
    ; Alien variables
    alien_x dw 20      ; Alien X position
    alien_y dw 30      ; Alien Y position
    alien_dir db 1     ; 1=right, 0=left
    alien_speed dw 2   ; Alien speed  
    
    ; Asteroid variables
    asteroid_x dw 0    ; Current asteroid X (0 means no asteroid)
    asteroid_y dw 0    ; Current asteroid Y
    asteroid_speed dw 2 ; Asteroid movement speed
    asteroid_timer dw 0 ; Timer for asteroid appearance
    asteroid_active db 0 ; 1=asteroid active, 0=no asteroid   
    
    ; Game messages
    game_over_msg db '!!!GAME OVER!!!$'
    menu_title db 'SPACE GUARDIANS$'
    menu_option1 db '1. Play Game$'
    menu_option2 db '2. Settings$'
    menu_option3 db '3. Exit$'      
    
    settings_title db 'GAME SETTINGS$'
    settings_option1 db '1. Change Difficulty$'
    settings_option2 db '2. Change Player Speed$'
    settings_option3 db '3. Back to Menu$'  
    
    difficulty_msg db 'Select Difficulty:$'
    difficulty_option1 db '1. Easy$'
    difficulty_option2 db '2. Medium$'
    difficulty_option3 db '3. Hard$'     
    
    current_diff_msg db 'Difficulty: $'
    easy_msg db 'Easy$'
    medium_msg db 'Medium$'
    hard_msg db 'Hard$'
    
    ; Game state
    score dw 0
    score_str db 'Score: 0000$'
    lives db 5         ; Number of lives
    lives_str db 'Lives: 5$'
    game_active db 0   ; 0=menu, 1=game running, 2=settings
    difficulty db 2    ; 1=Easy, 2=Medium, 3=Hard
    
    ; Player sprite (16x16)
    player_sprite DB 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
                  DB 0,0,0,0,0,0,1,2,2,1,0,0,0,0,0,0
                  DB 0,0,0,0,0,0,1,2,2,1,0,0,0,0,0,0
                  DB 0,0,0,0,0,1,1,2,2,1,1,0,0,0,0,0
                  DB 0,0,0,0,1,1,1,2,2,1,1,1,0,0,0,0
                  DB 0,0,0,1,1,1,1,2,2,1,1,1,1,0,0,0
                  DB 0,0,1,1,1,1,1,2,2,1,1,1,1,1,0,0
                  DB 0,1,1,1,1,1,1,2,2,1,1,1,1,1,1,0
                  DB 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1
                  DB 0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0
                  DB 0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0
                  DB 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
                  DB 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
                  DB 0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0
                  DB 0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0
                  DB 0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0

    ; Alien sprite (16x16)
    alien_sprite DB 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
                 DB 0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0
                 DB 0,0,0,1,1,0,1,1,1,1,0,1,1,0,0,0
                 DB 0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0
                 DB 0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0
                 DB 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
                 DB 1,1,0,1,0,1,0,1,1,0,1,0,1,0,1,1
                 DB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                 DB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                 DB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                 DB 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
                 DB 0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0
                 DB 0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0
                 DB 0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0
                 DB 0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0
                 DB 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0   
                 
    asteroid_sprite DB 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
                    DB 0,0,0,0,0,1,2,2,2,2,1,0,0,0,0,0
                    DB 0,0,0,0,1,2,2,2,2,2,2,1,0,0,0,0
                    DB 0,0,0,1,2,2,2,2,2,2,2,2,1,0,0,0
                    DB 0,0,1,2,2,2,2,2,2,2,2,2,2,1,0,0
                    DB 0,1,2,2,2,2,2,2,2,2,2,2,2,2,1,0
                    DB 1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1
                    DB 1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1
                    DB 1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1
                    DB 1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1
                    DB 0,1,2,2,2,2,2,2,2,2,2,2,2,2,1,0
                    DB 0,0,1,2,2,2,2,2,2,2,2,2,2,1,0,0
                    DB 0,0,0,1,2,2,2,2,2,2,2,2,1,0,0,0
                    DB 0,0,0,0,1,2,2,2,2,2,2,1,0,0,0,0
                    DB 0,0,0,0,0,1,2,2,2,2,1,0,0,0,0,0
                    DB 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; Set video mode 13h (320x200, 256 colors)
    MOV AX, 0013H
    INT 10H
    
    ; Hide cursor
    MOV AH, 01H
    MOV CX, 2607H
    INT 10H
    
    ; Initialize mouse
    MOV AX, 0000H
    INT 33H
    MOV AX, 0001H
    INT 33H  
    
    CALL get_player_name
    
    ; Initialize lives string
    MOV AL, lives
    ADD AL, '0'
    MOV lives_str[7], AL
    
    ; Show main menu
    CALL show_menu
    
main_loop:
    CMP game_active, 0
    JE menu_loop
    CMP game_active, 1
    JE game_loop
    CMP game_active, 2
    JE settings_loop
    CMP game_active, -1
    JE exit_game
    
menu_loop:
    CALL handle_menu_input
    JMP main_loop
    
settings_loop:
    CALL handle_settings_input
    JMP main_loop
    
game_loop:
    ; Wait for vertical retrace
    CALL wait_vsync
    
    ; Clear all moving objects
    CALL clear_all
    
    ; Move bullets
    CALL move_bullet
    
    ; Move alien
    CALL move_alien
    
    ; Handle asteroids
    CALL spawn_asteroid
    CALL move_asteroid
    
    ; Check if alien completed traversal
    CALL check_alien_traversal
    
    ; Draw all objects
    CALL draw_all
    
    ; Check keyboard input
    CALL handle_input
    
    CMP game_active, 1  ; Check if still in game mode
    JE game_loop
    
    JMP main_loop
    
exit_game:
    ; Return to text mode
    MOV AX, 0003H
    INT 10H
    
    ; Exit to DOS
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; Show main menu
show_menu PROC
    ; Clear screen
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    
    ; Set cursor position for title
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 5
    MOV DL, 15
    INT 10H
    
    ; Display title
    MOV AH, 09H
    MOV DX, OFFSET menu_title
    INT 21H
    
    ; Set cursor position for option 1
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 8
    MOV DL, 15
    INT 10H
    
    ; Display option 1
    MOV AH, 09H
    MOV DX, OFFSET menu_option1
    INT 21H
    
    ; Set cursor position for option 2
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 10
    MOV DL, 15
    INT 10H
    
    ; Display option 2
    MOV AH, 09H
    MOV DX, OFFSET menu_option2
    INT 21H
    
    ; Set cursor position for option 3
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 12
    MOV DL, 15
    INT 10H
    
    ; Display option 3
    MOV AH, 09H
    MOV DX, OFFSET menu_option3
    INT 21H
    
    RET
show_menu ENDP  

; Procedure to get player name
get_player_name PROC
    ; Clear screen
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    
    ; Display prompt on line 10
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 10       ; Row
    MOV DL, 10       ; Column
    INT 10H
    
    MOV AH, 09H
    MOV DX, OFFSET name_prompt
    INT 21H
    
    ; Move cursor to next line for input
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 11       ; Row (next line)
    MOV DL, 10       ; Column
    INT 10H
    
    ; Get player name
    MOV AH, 0AH
    MOV DX, OFFSET player_name
    MOV player_name, 19  ; Max length
    INT 21H
    
    ; Null-terminate the name
    MOV BX, OFFSET player_name + 1
    MOV CL, [BX]
    MOV CH, 0
    INC BX
    ADD BX, CX
    MOV BYTE PTR [BX], '$'
    
    RET
get_player_name ENDP

; Updated show_settings procedure with speed display
show_settings PROC
    ; Clear screen
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    
    ; Display settings title
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 5
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET settings_title
    INT 21H
    
    ; Display option 1
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 8
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET settings_option1
    INT 21H
    
    ; Display option 2
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 10
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET settings_option2
    INT 21H
    
    ; Display option 3
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 12
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET settings_option3
    INT 21H
    
    ; Display current difficulty
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 14
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET current_diff_msg
    INT 21H
    
    ; Show current difficulty level
    CMP difficulty, 1
    JE show_easy_diff
    CMP difficulty, 2
    JE show_medium_diff
    
    ; Show hard difficulty
    MOV DX, OFFSET hard_msg
    JMP show_diff_level
    
show_easy_diff:
    MOV DX, OFFSET easy_msg
    JMP show_diff_level
    
show_medium_diff:
    MOV DX, OFFSET medium_msg
    
show_diff_level:
    MOV AH, 09H
    INT 21H
    
    ; Display current speed
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 16
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET current_speed_msg
    INT 21H
    
    ; Show current speed level
    CMP player_speed, 2
    JE show_slow_speed
    CMP player_speed, 4
    JE show_medium_speed
    
    ; Show fast speed
    MOV DX, OFFSET fast_msg
    JMP show_speed_level
    
show_slow_speed:
    MOV DX, OFFSET slow_msg
    JMP show_speed_level
    
show_medium_speed:
    MOV DX, OFFSET med_msg
    
show_speed_level:
    MOV AH, 09H
    INT 21H
    
    RET
show_settings ENDP

show_difficulty PROC
    ; Clear screen
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    
    ; Set cursor position for title
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 5        ; Row
    MOV DL, 15       ; Column
    INT 10H
    
    ; Display title
    MOV AH, 09H
    MOV DX, OFFSET difficulty_msg
    INT 21H
    
    ; Set cursor position for option 1
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 7        ; Row
    MOV DL, 15       ; Column
    INT 10H
    
    ; Display option 1
    MOV AH, 09H
    MOV DX, OFFSET difficulty_option1
    INT 21H
    
    ; Set cursor position for option 2
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 9        ; Row
    MOV DL, 15       ; Column
    INT 10H
    
    ; Display option 2
    MOV AH, 09H
    MOV DX, OFFSET difficulty_option2
    INT 21H
    
    ; Set cursor position for option 3
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 11       ; Row
    MOV DL, 15       ; Column
    INT 10H
    
    ; Display option 3
    MOV AH, 09H
    MOV DX, OFFSET difficulty_option3
    INT 21H
    
    RET
show_difficulty ENDP

handle_menu_input PROC
    ; Check keyboard buffer
    MOV AH, 01H
    INT 16H
    JZ menu_input_done    ; Changed from input_done to menu_input_done
    
    ; Get keyboard input
    MOV AH, 00H
    INT 16H
    
    ; Option 1 - Play Game
    CMP AL, '1'
    JNE menu_check_option2
    CALL initialize_game
    MOV game_active, 1
    JMP menu_input_done
    
menu_check_option2:
    ; Option 2 - Settings
    CMP AL, '2'
    JNE menu_check_option3
    CALL show_settings
    MOV game_active, 2
    JMP menu_input_done
    
menu_check_option3:
    ; Option 3 - Exit
    CMP AL, '3'
    JNE menu_input_done
    MOV game_active, -1
    
menu_input_done:
    RET
handle_menu_input ENDP

; Handle settings input
; Complete handle_settings_input procedure
handle_settings_input PROC
    ; Check keyboard buffer
    MOV AH, 01H
    INT 16H
    JNZ has_input       ; Jump if there is input
    JMP settings_input_done ; Otherwise jump to end
    
has_input:
    ; Get keyboard input
    MOV AH, 00H
    INT 16H
    
    ; Option 1 - Change Difficulty
    CMP AL, '1'
    JNE settings_check_option2
    CALL show_difficulty
    
    ; Wait for difficulty selection
    MOV AH, 00H
    INT 16H
    
    ; Set difficulty
    CMP AL, '1'
    JNE settings_check_medium
    MOV difficulty, 1
    MOV alien_speed, 1
    JMP settings_difficulty_set
    
settings_check_medium:
    CMP AL, '2'
    JNE settings_check_hard
    MOV difficulty, 2
    MOV alien_speed, 2
    JMP settings_difficulty_set
    
settings_check_hard:
    CMP AL, '3'
    JNE settings_difficulty_set
    MOV difficulty, 3
    MOV alien_speed, 3
    
settings_difficulty_set:
    CALL show_settings
    JMP settings_input_done
    
settings_check_option2:
    ; Option 2 - Change Player Speed
    CMP AL, '2'
    JNE settings_check_option3
    CALL show_speed_menu
    
    ; Wait for speed selection
    MOV AH, 00H
    INT 16H
    
    ; Set speed
    CMP AL, '1'
    JNE settings_check_medium_speed
    MOV player_speed, 2  ; Slow
    JMP settings_speed_set
    
settings_check_medium_speed:
    CMP AL, '2'
    JNE settings_check_fast_speed
    MOV player_speed, 4  ; Medium
    JMP settings_speed_set
    
settings_check_fast_speed:
    CMP AL, '3'
    JNE settings_speed_set
    MOV player_speed, 6  ; Fast
    
settings_speed_set:
    CALL show_settings
    JMP settings_input_done
    
settings_check_option3:
    ; Option 3 - Back to Menu
    CMP AL, '3'
    JNE settings_input_done
    CALL show_menu
    MOV game_active, 0
    
settings_input_done:
    RET
handle_settings_input ENDP  

show_speed_menu PROC
    ; Clear screen
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    
    ; Display speed menu options
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 5
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET speed_msg
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 7
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET speed_option1
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 9
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET speed_option2
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 11
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET speed_option3
    INT 21H
    
    RET
show_speed_menu ENDP


; Initialize game state
initialize_game PROC
    ; Reset player position
    MOV x_pos, 160
    MOV y_pos, 184
    
    ; Reset bullet
    MOV bullet_x, 0
    MOV bullet_y, 0
    
    ; Reset alien
    MOV alien_x, 20
    MOV alien_y, 30
    MOV alien_dir, 1
    
    ; Reset score and lives
    MOV score, 0
    MOV lives, 5
    MOV AL, lives
    ADD AL, '0'
    MOV lives_str[7], AL
    
    ; Set video mode 13h (320x200, 256 colors)
    MOV AX, 0013H
    INT 10H
    
    ; Hide cursor
    MOV AH, 01H
    MOV CX, 2607H
    INT 10H
    
    RET
initialize_game ENDP

; Modified draw_all to include asteroid drawing
draw_all PROC
    ; Draw player
    MOV CX, x_pos
    MOV DX, y_pos
    MOV SI, OFFSET player_sprite
    CALL draw_sprite
    
    ; Draw bullet if active
    CMP bullet_x, 0
    JE skip_bullet_draw
    MOV CX, bullet_x
    MOV DX, bullet_y
    MOV AL, 0Ch      ; Red color
    CALL draw_bullet
skip_bullet_draw:
    
    ; Draw alien
    MOV CX, alien_x
    MOV DX, alien_y
    MOV SI, OFFSET alien_sprite
    CALL draw_sprite
    
    ; Draw asteroid if active
    CMP asteroid_active, 1
    JNE skip_asteroid_draw
    MOV CX, asteroid_x
    MOV DX, asteroid_y
    MOV SI, OFFSET asteroid_sprite
    CALL draw_asteroid
skip_asteroid_draw:
    
    ; Display score and lives
    CALL display_score
    CALL display_lives
    RET
draw_all ENDP  

; Display lives in top left corner
display_lives PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    ; Update lives string
    MOV AL, lives
    ADD AL, '0'          ; Convert to ASCII
    MOV lives_str[7], AL ; Update digit in string
    
    ; Set cursor position (top left)
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 1      ; Row 1
    MOV DL, 1      ; Column 1
    INT 10H
    
    ; Display lives string
    MOV AH, 09H
    MOV DX, OFFSET lives_str
    INT 21H
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
display_lives ENDP

; Display score in top right corner
display_score PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    ; Initialize score string (in case it was modified)
    MOV score_str[0], 'S'
    MOV score_str[1], 'c'
    MOV score_str[2], 'o'
    MOV score_str[3], 'r'
    MOV score_str[4], 'e'
    MOV score_str[5], ':'
    MOV score_str[6], ' '
    MOV score_str[7], '0'
    MOV score_str[8], '0'
    MOV score_str[9], '0'
    MOV score_str[10], '0'
    MOV score_str[11], '$'
    
    ; Convert score number to string
    MOV AX, score
    MOV SI, OFFSET score_str + 10  ; Point to last digit position
    MOV CX, 4                      ; 4 digits to convert
    
convert_loop:
    MOV DX, 0
    MOV BX, 10
    DIV BX         ; AX = quotient, DX = remainder
    ADD DL, '0'    ; Convert to ASCII
    MOV [SI], DL
    DEC SI
    LOOP convert_loop
    
    ; Set cursor position (top right)
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 1      ; Row 1
    MOV DL, 25     ; Column 25 (right side)
    INT 10H
    
    ; Display score string
    MOV AH, 09H
    MOV DX, OFFSET score_str
    INT 21H
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
display_score ENDP

; Modified clear_all to include asteroid clearing
clear_all PROC
    ; Clear player
    MOV CX, x_pos
    MOV DX, y_pos
    CALL clear_sprite
    
    ; Clear bullet if active
    CMP bullet_x, 0
    JE skip_bullet_clear
    MOV CX, bullet_x
    MOV DX, bullet_y
    CALL clear_bullet
skip_bullet_clear:
    
    ; Clear alien
    MOV CX, alien_x
    MOV DX, alien_y
    CALL clear_sprite
    
    ; Clear asteroid if active
    CMP asteroid_active, 1
    JNE skip_asteroid_clear
    MOV CX, asteroid_x
    MOV DX, asteroid_y
    CALL clear_asteroid
skip_asteroid_clear:
    RET
clear_all ENDP 

; New procedure to handle asteroids
move_asteroid PROC
    CMP asteroid_active, 1
    JE asteroid_active_yes
    JMP asteroid_done  ; Unconditional jump for the far case

asteroid_active_yes:
    ; Move asteroid down
    MOV AX, asteroid_y
    ADD AX, asteroid_speed
    MOV asteroid_y, AX
    
    ; Check if asteroid reached bottom
    CMP AX, 184      ; 200-16
    JL asteroid_check_collision
    
    ; Asteroid reached bottom - deduct life
    DEC lives
    MOV asteroid_active, 0
    
    ; Update lives display
    MOV AL, lives
    ADD AL, '0'
    MOV lives_str[7], AL
    
    ; Check if game over
    CMP lives, 0
    JG asteroid_done
    MOV game_active, 0
    CALL show_game_over
    JMP asteroid_done
    
asteroid_check_collision:
    ; Check collision with bullet
    CMP bullet_x, 0
    JE asteroid_no_collision
    
    ; Check X collision
    MOV AX, bullet_x
    CMP AX, asteroid_x
    JL asteroid_no_collision
    ADD AX, 3       ; Bullet width
    MOV BX, asteroid_x
    ADD BX, 16      ; Asteroid width
    CMP AX, BX
    JG asteroid_no_collision
    
    ; Check Y collision
    MOV AX, bullet_y
    CMP AX, asteroid_y
    JL asteroid_no_collision
    ADD AX, 3       ; Bullet height
    MOV BX, asteroid_y
    ADD BX, 16      ; Asteroid height
    CMP AX, BX
    JG asteroid_no_collision
    
    ; Collision detected
    MOV asteroid_active, 0
    MOV bullet_x, 0
    MOV bullet_y, 0
    ADD score, 10
    CALL play_collision_sound
    
asteroid_no_collision:
asteroid_done:
    RET
move_asteroid ENDP

; New procedure to spawn asteroids randomly
spawn_asteroid PROC
    CMP asteroid_active, 1
    JE spawn_done
    
    ; Get random number (0-255) in AL
    MOV AH, 00h      ; Get system time
    INT 1Ah          ; CX:DX = clock ticks
    MOV AL, DL       ; Use low byte for randomness
    
    ; Check if we should spawn (about 1 in 60 chance)
    CMP AL, 4        ; Adjust this value (0-255) for spawn frequency
    JA spawn_done     ; If random > threshold, don't spawn
    
    ; Generate random X position (16-304)
    MOV AX, DX       ; Use different part of random value
    XOR DX, DX
    MOV BX, 289      ; 304-16+1
    DIV BX           ; DX = remainder (0-288)
    ADD DX, 16       ; DX = 16-304
    MOV asteroid_x, DX
    
    ; Set Y position to top
    MOV asteroid_y, 10
    
    ; Activate asteroid
    MOV asteroid_active, 1
    
spawn_done:
    RET
spawn_asteroid ENDP

; New procedure to draw 16x16 asteroid
draw_asteroid PROC
    ; Input: CX=X, DX=Y, SI=sprite address
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    MOV AH, 0Ch
    MOV BX, 16       ; Height (16 rows)
draw_asteroid_row:
    PUSH CX
    MOV DI, 16       ; Width (16 columns)
draw_asteroid_col:
    LODSB            ; Get pixel color
    CMP AL, 0        ; Transparent?
    JE skip_asteroid_pixel
    INT 10H          ; Draw pixel
skip_asteroid_pixel:
    INC CX           ; Next column
    DEC DI
    JNZ draw_asteroid_col
    POP CX           ; Restore column
    INC DX           ; Next row
    DEC BX
    JNZ draw_asteroid_row
    
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
draw_asteroid ENDP

; New procedure to clear 16x16 asteroid
clear_asteroid PROC
    ; Input: CX=X, DX=Y
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    
    MOV AH, 0Ch
    MOV AL, 0       ; Black color
    MOV BX, 16      ; Height (16 rows)
    
clear_asteroid_row:
    PUSH CX         ; Save starting X position
    MOV DI, 16      ; Width (16 columns)
clear_asteroid_col:
    INT 10H         ; Draw black pixel
    INC CX          ; Move to next column
    DEC DI
    JNZ clear_asteroid_col
    POP CX          ; Restore starting X position
    INC DX          ; Move to next row
    DEC BX
    JNZ clear_asteroid_row
    
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
clear_asteroid ENDP

move_alien PROC
    ; Move alien (left-to-right)
    CMP alien_dir, 1
    JNE alien_left
    ; Move right
    MOV AX, alien_x
    ADD AX, alien_speed
    MOV alien_x, AX
    ; Check if reached right edge
    CMP AX, 304      ; 320-16
    JL alien_move_done
    MOV alien_dir, 0 ; Change direction
    JMP alien_move_done
alien_left:
    ; Move left
    MOV AX, alien_x
    SUB AX, alien_speed
    MOV alien_x, AX
    ; Check if reached left edge
    CMP AX, 0
    JG alien_move_done
    MOV alien_dir, 1 ; Change direction
alien_move_done:
    RET
move_alien ENDP

check_alien_traversal PROC
    ; Check if alien moved past left boundary (<= 0)
    CMP alien_x, 0
    JLE wrap_to_right
    
    ; Check if alien moved past right boundary (>= 304)
    MOV AX, alien_x
    CMP AX, 304
    JL no_wrap_needed  ; If not past boundary, we're done
    
wrap_to_left:
    ; Deduct life when wrapping from right to left
    DEC lives
    MOV AL, lives
    ADD AL, '0'
    MOV lives_str[7], AL
    
    ; Check if game over
    CMP lives, 0
    JLE game_over
    
    ; Wrap to left side
    MOV alien_x, 20  ; Small margin from left edge
    MOV alien_dir, 1 ; Keep moving right
    
    ; Small delay after losing life
    MOV CX, 10
delay_loop:
    CALL wait_vsync
    LOOP delay_loop
    RET
    
wrap_to_right:
    ; Wrap to right side (no life deduction)
    MOV alien_x, 284 ; 304-20 (small margin from right edge)
    MOV alien_dir, 0 ; Keep moving left
    RET
    
no_wrap_needed:
    RET
    
game_over:
    MOV game_active, 0
    CALL show_game_over
    
    ; Wait for key press
    MOV AH, 00H
    INT 16H
    
    CALL show_menu
    RET
check_alien_traversal ENDP

show_game_over PROC
    ; Save current video mode
    MOV AH, 0Fh
    INT 10h
    PUSH AX  ; Save video mode
    
    ; Clear screen and set text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Display player name (line 10)
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 10
    MOV DL, 10
    INT 10h
    
    MOV AH, 09h
    MOV DX, OFFSET score_display  ; "Player: "
    INT 21h
    
    ; Display player name
    MOV DX, OFFSET player_name + 2  ; Skip length bytes
    INT 21h
    
    ; Display score (line 11)
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 11
    MOV DL, 10
    INT 10h
    
    MOV AH, 09h
    MOV DX, OFFSET score_display2  ; "Score: "
    INT 21h
    
    ; Display score value
    MOV AX, score
    CALL display_number
    
    ; Wait for any key (line 13)
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 13
    MOV DL, 10
    INT 10h
    
    MOV AH, 09h
    MOV DX, OFFSET press_enter_msg
    INT 21h
    
    ; Wait for any key
    MOV AH, 00h
    INT 16h
    
    ; Restore original video mode
    POP AX
    MOV AH, 00h
    INT 10h
    
    ; Return to menu
    CALL show_menu
    MOV game_active, 0
    RET
show_game_over ENDP

display_number PROC
    ; Input: AX = number to display
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ; Handle zero case
    CMP AX, 0
    JNE not_zero
    MOV AH, 02h
    MOV DL, '0'
    INT 21h
    JMP display_done
    
not_zero:
    MOV CX, 0
    MOV BX, 10
    
divide_loop:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE divide_loop
    
print_loop:
    POP DX
    ADD DL, '0'
    MOV AH, 02h
    INT 21h
    LOOP print_loop
    
display_done:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
display_number ENDP

; Input handling during game
handle_input PROC
    ; Check keyboard buffer
    MOV AH, 01H
    INT 16H
    JZ game_check_mouse    ; Changed from check_mouse to game_check_mouse
    
    ; Get keyboard input
    MOV AH, 00H
    INT 16H
    
    ; Spacebar pressed?
    CMP AL, 32
    JNE game_check_arrows
    CALL try_fire_bullet
    JMP game_check_mouse
    
game_check_arrows:
    ; Handle movement
    CMP AH, 4BH      ; Left arrow
    JNE game_check_right
    CALL move_left
    JMP game_check_mouse
    
game_check_right:
    CMP AH, 4DH      ; Right arrow
    JNE game_check_escape
    CALL move_right
    JMP game_check_mouse
    
game_check_escape:
    CMP AL, 1BH      ; ESC key
    JNE game_check_mouse
    MOV game_active, 0
    CALL show_menu
    
game_check_mouse:
    ; Check mouse input
    MOV AX, 0003H    ; Get mouse status
    INT 33H
    ; Left button pressed?
    TEST BX, 1
    JZ game_input_done
    
    CALL try_fire_bullet
    
game_input_done:
    RET
handle_input ENDP

; Player movement
move_left PROC
    ; Clear current position first
    PUSH CX
    PUSH DX
    MOV CX, x_pos
    MOV DX, y_pos
    CALL clear_sprite
    POP DX
    POP CX
    
    CMP x_pos, 1
    JLE no_move_left
    
    ; Use player_speed instead of hardcoded value
    MOV AX, player_speed
    SUB x_pos, AX
    
    ; Draw at new position will happen in main loop
no_move_left:
    RET
move_left ENDP

move_right PROC
    ; Clear current position first
    PUSH CX
    PUSH DX
    MOV CX, x_pos
    MOV DX, y_pos
    CALL clear_sprite
    POP DX
    POP CX
    
    CMP x_pos, 304
    JGE no_move_right
    
    ; Use player_speed instead of hardcoded value
    MOV AX, player_speed
    ADD x_pos, AX
    
    ; Draw at new position will happen in main loop
no_move_right:
    RET
move_right ENDP

try_fire_bullet PROC
    CMP bullet_x, 0
    JNE no_fire
    ; Set bullet position (center of player)
    MOV AX, x_pos
    ADD AX, 7
    MOV bullet_x, AX
    MOV AX, y_pos
    SUB AX, 16
    MOV bullet_y, AX
no_fire:
    RET
try_fire_bullet ENDP

; Bullet handling
move_bullet PROC
    CMP bullet_x, 0
    JE bullet_done
    
    ; Move bullet up
    MOV AX, bullet_y
    SUB AX, bullet_speed
    MOV bullet_y, AX
    
    ; Check if bullet reached top
    CMP AX, 10
    JL remove_bullet
    
    ; Check collision with alien
    CALL check_collision
    JC bullet_done
    
    RET
    
remove_bullet:
    MOV bullet_x, 0
    MOV bullet_y, 0
    
bullet_done:
    RET
move_bullet ENDP

; Update the check_collision procedure
check_collision PROC
    ; Check if bullet is active
    CMP bullet_x, 0
    JE no_collision
    
    ; Check if bullet is within alien's X range
    MOV AX, bullet_x
    CMP AX, alien_x
    JL no_collision
    ADD AX, 3       ; Bullet width
    MOV BX, alien_x
    ADD BX, 16      ; Alien width
    CMP AX, BX
    JG no_collision
    
    ; Check if bullet is within alien's Y range
    MOV AX, bullet_y
    CMP AX, alien_y
    JL no_collision
    ADD AX, 3       ; Bullet height
    MOV BX, alien_y
    ADD BX, 16      ; Alien height
    CMP AX, BX
    JG no_collision
    
    ; Collision detected - reset alien and bullet
    MOV alien_x, 20      ; Reset to starting position
    MOV alien_y, 30
    MOV bullet_x, 0      ; Remove bullet
    MOV bullet_y, 0
    
    ; Increase score
    INC score
    
    ; Play collision sound
    CALL play_collision_sound
    
    STC               ; Set carry flag to indicate collision
    RET
    
no_collision:
    CLC               ; Clear carry flag
    RET
check_collision ENDP

; Add this new procedure for sound
play_collision_sound PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ; Play a beep
    MOV AH, 02H
    MOV DL, 07H
    INT 21H
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
play_collision_sound ENDP

; Drawing procedures
draw_sprite PROC
    ; Input: CX=X, DX=Y, SI=sprite address
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    MOV AH, 0Ch
    MOV BX, 16      ; Height
draw_row:
    PUSH CX
    MOV DI, 16      ; Width
draw_col:
    LODSB           ; Get pixel color
    CMP AL, 0       ; Transparent?
    JE skip_pixel
    INT 10H         ; Draw pixel
skip_pixel:
    INC CX          ; Next column
    DEC DI
    JNZ draw_col
    POP CX          ; Restore column
    INC DX          ; Next row
    DEC BX
    JNZ draw_row
    
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
draw_sprite ENDP

clear_sprite PROC
    ; Input: CX=X, DX=Y
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    
    MOV AH, 0Ch
    MOV AL, 0       ; Black color
    MOV BX, 16      ; Height (16 rows)
    
clear_row:
    PUSH CX         ; Save starting X position
    MOV DI, 16      ; Width (16 columns)
    
clear_col:
    INT 10H         ; Draw black pixel
    INC CX          ; Move to next column
    DEC DI
    JNZ clear_col
    
    POP CX          ; Restore starting X position
    INC DX          ; Move to next row
    DEC BX
    JNZ clear_row
    
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
clear_sprite ENDP

draw_bullet PROC
    ; Input: CX=X, DX=Y, AL=color
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    
    MOV AH, 0Ch
    MOV BX, 3       ; Height
bullet_row:
    PUSH CX
    MOV DI, 3       ; Width
bullet_col:
    INT 10H         ; Draw pixel
    INC CX
    DEC DI
    JNZ bullet_col
    POP CX
    INC DX
    DEC BX
    JNZ bullet_row
    
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
draw_bullet ENDP

clear_bullet PROC
    ; Input: CX=X, DX=Y
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    
    MOV AH, 0Ch
    MOV AL, 0       ; Black
    MOV BX, 3       ; Height
clear_b_row:
    PUSH CX
    MOV DI, 3       ; Width
clear_b_col:
    INT 10H         ; Draw black pixel
    INC CX
    DEC DI
    JNZ clear_b_col
    POP CX
    INC DX
    DEC BX
    JNZ clear_b_row
    
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
clear_bullet ENDP

wait_vsync PROC
    MOV DX, 3DAH
vsync1:
    IN AL, DX
    TEST AL, 8
    JZ vsync1
    RET
wait_vsync ENDP

END MAIN