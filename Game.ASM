;;=============================================================================;;   
;;                          Space Guardians                                    ;;                               
;;=============================================================================;;
;;                      Created by: Jawad Mansoor                              ;;
;;=============================================================================;;

.MODEL SMALL
.STACK 100H

.DATA
    x_pos dw 160     
    y_pos dw 184      
    
    player_speed dw 4      
    speed_msg db 'Select Speed:$'
    speed_option1 db '1. Slow (2)$'
    speed_option2 db '2. Medium (4)$'
    speed_option3 db '3. Fast (6)$'
    current_speed_msg db 'Current Speed: $'
    slow_msg db 'Slow$'
    med_msg db 'Medium$'
    fast_msg db 'Fast$'         
    
    player_name db 20 dup(0)  
    name_prompt db 'Enter your name(19 char): $'
    score_display db 'Player: $'
    score_display2 db ' - Score: $'
    press_enter_msg db 'Press any key to return to menu...$'
    temp_score_str db '0000$' 

    bullet_x dw 0    
    bullet_y dw 0    
    bullet_speed dw 3 
    
    alien_x dw 20     
    alien_y dw 30     
    alien_dir db 1   
    alien_speed dw 2   
    
    asteroid_x dw 0  
    asteroid_y dw 0   
    asteroid_speed dw 2 
    asteroid_timer dw 0
    asteroid_active db 0 
    
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
    
    score dw 0
    score_str db 'Score: 0000$'
    lives db 5       
    lives_str db 'Lives: 5$'
    game_active db 0   
    difficulty db 2    
    
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
    
    MOV AX, 0013H
    INT 10H
    
    MOV AH, 01H
    MOV CX, 2607H
    INT 10H
    
    MOV AX, 0000H
    INT 33H
    MOV AX, 0001H
    INT 33H  
    
    CALL get_player_name
    
    MOV AL, lives
    ADD AL, '0'
    MOV lives_str[7], AL
    
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
    CALL wait_vsync
    
    CALL clear_all
    
    CALL move_bullet
    
    CALL move_alien
    
    CALL spawn_asteroid
    CALL move_asteroid
    
    CALL check_alien_traversal
    
    CALL draw_all
    
    CALL handle_input
    
    CMP game_active, 1  
    JE game_loop
    
    JMP main_loop
    
exit_game:
    MOV AX, 0003H
    INT 10H
    
    MOV AH, 4CH
    INT 21H
MAIN ENDP

;=====================================================================
;                          MENU PROCEDURES
;=====================================================================
show_menu PROC
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 5
    MOV DL, 15
    INT 10H
    
    MOV AH, 09H
    MOV DX, OFFSET menu_title
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 8
    MOV DL, 15
    INT 10H
    
    MOV AH, 09H
    MOV DX, OFFSET menu_option1
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 10
    MOV DL, 15
    INT 10H
    
    MOV AH, 09H
    MOV DX, OFFSET menu_option2
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 12
    MOV DL, 15
    INT 10H
    
    MOV AH, 09H
    MOV DX, OFFSET menu_option3
    INT 21H
    
    RET
show_menu ENDP  

get_player_name PROC
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 10     
    MOV DL, 10       
    INT 10H
    
    MOV AH, 09H
    MOV DX, OFFSET name_prompt
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 11      
    MOV DL, 10       
    INT 10H
    
    MOV AH, 0AH
    MOV DX, OFFSET player_name
    MOV player_name, 19
    INT 21H
    
    MOV BX, OFFSET player_name + 1
    MOV CL, [BX]
    MOV CH, 0
    INC BX
    ADD BX, CX
    MOV BYTE PTR [BX], '$'
    
    RET
get_player_name ENDP

;=====================================================================
;                         SETTINGS PROCEDURES
;=====================================================================
show_settings PROC
    ; Clear screen
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 5
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET settings_title
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 8
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET settings_option1
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 10
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET settings_option2
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 12
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET settings_option3
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 14
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET current_diff_msg
    INT 21H
    
    CMP difficulty, 1
    JE show_easy_diff
    CMP difficulty, 2
    JE show_medium_diff
    
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
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 16
    MOV DL, 15
    INT 10H
    MOV AH, 09H
    MOV DX, OFFSET current_speed_msg
    INT 21H
    
    CMP player_speed, 2
    JE show_slow_speed
    CMP player_speed, 4
    JE show_medium_speed
    
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
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 5        
    MOV DL, 15     
    INT 10H
    
    MOV AH, 09H
    MOV DX, OFFSET difficulty_msg
    INT 21H
    

    MOV AH, 02H
    MOV BH, 0
    MOV DH, 7        
    MOV DL, 15    
    INT 10H
    
    MOV AH, 09H
    MOV DX, OFFSET difficulty_option1
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 9       
    MOV DL, 15      
    INT 10H
    
    MOV AH, 09H
    MOV DX, OFFSET difficulty_option2
    INT 21H
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 11      
    MOV DL, 15      
    INT 10H
    
    MOV AH, 09H
    MOV DX, OFFSET difficulty_option3
    INT 21H
    
    RET
show_difficulty ENDP

handle_menu_input PROC
    MOV AH, 01H
    INT 16H
    JZ menu_input_done   
    
    MOV AH, 00H
    INT 16H
    
    CMP AL, '1'
    JNE menu_check_option2
    CALL initialize_game
    MOV game_active, 1
    JMP menu_input_done
    
menu_check_option2:
    CMP AL, '2'
    JNE menu_check_option3
    CALL show_settings
    MOV game_active, 2
    JMP menu_input_done
    
menu_check_option3:
    CMP AL, '3'
    JNE menu_input_done
    MOV game_active, -1
    
menu_input_done:
    RET
handle_menu_input ENDP

handle_settings_input PROC
    MOV AH, 01H
    INT 16H
    JNZ has_input   
    JMP settings_input_done
    
has_input:
    MOV AH, 00H
    INT 16H
    
    CMP AL, '1'
    JNE settings_check_option2
    CALL show_difficulty
    
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
    CMP AL, '2'
    JNE settings_check_option3
    CALL show_speed_menu
    
    MOV AH, 00H
    INT 16H
    
    CMP AL, '1'
    JNE settings_check_medium_speed
    MOV player_speed, 2 
    JMP settings_speed_set
    
settings_check_medium_speed:
    CMP AL, '2'
    JNE settings_check_fast_speed
    MOV player_speed, 4  
    JMP settings_speed_set
    
settings_check_fast_speed:
    CMP AL, '3'
    JNE settings_speed_set
    MOV player_speed, 6 
    
settings_speed_set:
    CALL show_settings
    JMP settings_input_done
    
settings_check_option3:
    CMP AL, '3'
    JNE settings_input_done
    CALL show_menu
    MOV game_active, 0
    
settings_input_done:
    RET
handle_settings_input ENDP  

show_speed_menu PROC
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    
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

;=====================================================================
;                         GAME INITIALIZATION
;=====================================================================
initialize_game PROC
    MOV x_pos, 160
    MOV y_pos, 184
    
    MOV bullet_x, 0
    MOV bullet_y, 0
    
    MOV alien_x, 20
    MOV alien_y, 30
    MOV alien_dir, 1
    
    MOV score, 0
    MOV lives, 5
    MOV AL, lives
    ADD AL, '0'
    MOV lives_str[7], AL
    
    MOV AX, 0013H
    INT 10H
    
    MOV AH, 01H
    MOV CX, 2607H
    INT 10H
    
    RET
initialize_game ENDP

;=====================================================================
;                         DRAWING PROCEDURES
;=====================================================================
draw_all PROC
    MOV CX, x_pos
    MOV DX, y_pos
    MOV SI, OFFSET player_sprite
    CALL draw_sprite
    
    CMP bullet_x, 0
    JE skip_bullet_draw
    MOV CX, bullet_x
    MOV DX, bullet_y
    MOV AL, 0Ch     
    CALL draw_bullet
skip_bullet_draw:
    
    MOV CX, alien_x
    MOV DX, alien_y
    MOV SI, OFFSET alien_sprite
    CALL draw_sprite
    
    CMP asteroid_active, 1
    JNE skip_asteroid_draw
    MOV CX, asteroid_x
    MOV DX, asteroid_y
    MOV SI, OFFSET asteroid_sprite
    CALL draw_asteroid
skip_asteroid_draw:
    
    CALL display_score
    CALL display_lives
    RET
draw_all ENDP  

display_lives PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    MOV AL, lives
    ADD AL, '0'        
    MOV lives_str[7], AL
    
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 1    
    MOV DL, 1    
    INT 10H
    
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

display_score PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
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
    
    MOV AX, score
    MOV SI, OFFSET score_str + 10 
    MOV CX, 4                    
    
convert_loop:
    MOV DX, 0
    MOV BX, 10
    DIV BX       
    ADD DL, '0'   
    MOV [SI], DL
    DEC SI
    LOOP convert_loop
    

    MOV AH, 02H
    MOV BH, 0
    MOV DH, 1     
    MOV DL, 25     
    INT 10H
    
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

;=====================================================================
;                         ASTEROID PROCEDURES
;=====================================================================
move_asteroid PROC
    CMP asteroid_active, 1
    JE asteroid_active_yes
    JMP asteroid_done 

asteroid_active_yes:
    MOV AX, asteroid_y
    ADD AX, asteroid_speed
    MOV asteroid_y, AX
    
    CMP AX, 184      ; 200-16
    JL asteroid_check_collision
    
    DEC lives
    MOV asteroid_active, 0
    
    MOV AL, lives
    ADD AL, '0'
    MOV lives_str[7], AL
    
    CMP lives, 0
    JG asteroid_done
    MOV game_active, 0
    CALL show_game_over
    JMP asteroid_done
    
asteroid_check_collision:
    CMP bullet_x, 0
    JE asteroid_no_collision
    
    MOV AX, bullet_x
    CMP AX, asteroid_x
    JL asteroid_no_collision
    ADD AX, 3       ; Bullet width
    MOV BX, asteroid_x
    ADD BX, 16      ; Asteroid width
    CMP AX, BX
    JG asteroid_no_collision
    
    MOV AX, bullet_y
    CMP AX, asteroid_y
    JL asteroid_no_collision
    ADD AX, 3       ; Bullet height
    MOV BX, asteroid_y
    ADD BX, 16      ; Asteroid height
    CMP AX, BX
    JG asteroid_no_collision
    
    MOV asteroid_active, 0
    MOV bullet_x, 0
    MOV bullet_y, 0
    ADD score, 10
    CALL play_collision_sound
    
asteroid_no_collision:
asteroid_done:
    RET
move_asteroid ENDP

spawn_asteroid PROC
    CMP asteroid_active, 1
    JE spawn_done
    
    MOV AH, 00h     
    INT 1Ah       
    MOV AL, DL      
    
    CMP AL, 4       
    JA spawn_done    
    
    MOV AX, DX      
    XOR DX, DX
    MOV BX, 289      
    DIV BX          
    ADD DX, 16      
    MOV asteroid_x, DX
    
    MOV asteroid_y, 10
    
    MOV asteroid_active, 1
    
spawn_done:
    RET
spawn_asteroid ENDP


draw_asteroid PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    MOV AH, 0Ch
    MOV BX, 16      
draw_asteroid_row:
    PUSH CX
    MOV DI, 16       
draw_asteroid_col:
    LODSB          
    CMP AL, 0     
    JE skip_asteroid_pixel
    INT 10H        
skip_asteroid_pixel:
    INC CX        
    DEC DI
    JNZ draw_asteroid_col
    POP CX         
    INC DX         
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


clear_asteroid PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    
    MOV AH, 0Ch
    MOV AL, 0      
    MOV BX, 16     
    
clear_asteroid_row:
    PUSH CX        
    MOV DI, 16    
clear_asteroid_col:
    INT 10H        
    INC CX        
    DEC DI
    JNZ clear_asteroid_col
    POP CX          
    INC DX         
    DEC BX
    JNZ clear_asteroid_row
    
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
clear_asteroid ENDP

;=====================================================================
;                         ALIEN MOVEMENT
;=====================================================================
move_alien PROC
    CMP alien_dir, 1
    JNE alien_left
    ; Move right
    MOV AX, alien_x
    ADD AX, alien_speed
    MOV alien_x, AX
    CMP AX, 304
    JL alien_move_done
    MOV alien_dir, 0
    JMP alien_move_done
alien_left:
    MOV AX, alien_x
    SUB AX, alien_speed
    MOV alien_x, AX
    CMP AX, 0
    JG alien_move_done
    MOV alien_dir, 1
alien_move_done:
    RET
move_alien ENDP

check_alien_traversal PROC
    CMP alien_x, 0
    JLE wrap_to_right
    
    MOV AX, alien_x
    CMP AX, 304
    JL no_wrap_needed 
    
wrap_to_left:
    DEC lives
    MOV AL, lives
    ADD AL, '0'
    MOV lives_str[7], AL
    
    CMP lives, 0
    JLE game_over
    
    ; Wrap to left side
    MOV alien_x, 20 
    MOV alien_dir, 1
    
    MOV CX, 10
delay_loop:
    CALL wait_vsync
    LOOP delay_loop
    RET
    
wrap_to_right:
    MOV alien_x, 284 
    MOV alien_dir, 0 
    RET
    
no_wrap_needed:
    RET
    
game_over:
    MOV game_active, 0
    CALL show_game_over
    
    MOV AH, 00H
    INT 16H
    
    CALL show_menu
    RET
check_alien_traversal ENDP

;=====================================================================
;                         GAME OVER SCREEN
;=====================================================================
show_game_over PROC
    MOV AH, 0Fh
    INT 10h
    PUSH AX 
    
    MOV AX, 0003h
    INT 10h
    
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 10
    MOV DL, 10
    INT 10h
    
    MOV AH, 09h
    MOV DX, OFFSET score_display  ; "Player: "
    INT 21h
    
    MOV DX, OFFSET player_name + 2  ; Skip length bytes
    INT 21h
    
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 11
    MOV DL, 10
    INT 10h
    
    MOV AH, 09h
    MOV DX, OFFSET score_display2  ; "Score: "
    INT 21h
    
    MOV AX, score
    CALL display_number
    
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 13
    MOV DL, 10
    INT 10h
    
    MOV AH, 09h
    MOV DX, OFFSET press_enter_msg
    INT 21h
    
    MOV AH, 00h
    INT 16h
    
    POP AX
    MOV AH, 00h
    INT 10h
    
    CALL show_menu
    MOV game_active, 0
    RET
show_game_over ENDP

display_number PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
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

;=====================================================================
;                         INPUT HANDLING
;=====================================================================
handle_input PROC
    ; Check keyboard buffer
    MOV AH, 01H
    INT 16H
    JZ game_check_mouse 
    
    MOV AH, 00H
    INT 16H
    
    CMP AL, 32
    JNE game_check_arrows
    CALL try_fire_bullet
    JMP game_check_mouse
    
game_check_arrows:
    CMP AH, 4BH   
    JNE game_check_right
    CALL move_left
    JMP game_check_mouse
    
game_check_right:
    CMP AH, 4DH    
    JNE game_check_escape
    CALL move_right
    JMP game_check_mouse
    
game_check_escape:
    CMP AL, 1BH  
    JNE game_check_mouse
    MOV game_active, 0
    CALL show_menu
    
game_check_mouse:
    MOV AX, 0003H 
    INT 33H
    ; Left button pressed?
    TEST BX, 1
    JZ game_input_done
    
    CALL try_fire_bullet
    
game_input_done:
    RET
handle_input ENDP

;=====================================================================
;                         PLAYER MOVEMENT
;=====================================================================
move_left PROC
    PUSH CX
    PUSH DX
    MOV CX, x_pos
    MOV DX, y_pos
    CALL clear_sprite
    POP DX
    POP CX
    
    CMP x_pos, 1
    JLE no_move_left
    
    MOV AX, player_speed
    SUB x_pos, AX
    
no_move_left:
    RET
move_left ENDP

move_right PROC
    PUSH CX
    PUSH DX
    MOV CX, x_pos
    MOV DX, y_pos
    CALL clear_sprite
    POP DX
    POP CX
    
    CMP x_pos, 304
    JGE no_move_right
    
    MOV AX, player_speed
    ADD x_pos, AX
    
no_move_right:
    RET
move_right ENDP

try_fire_bullet PROC
    CMP bullet_x, 0
    JNE no_fire
    MOV AX, x_pos
    ADD AX, 7
    MOV bullet_x, AX
    MOV AX, y_pos
    SUB AX, 16
    MOV bullet_y, AX
no_fire:
    RET
try_fire_bullet ENDP

;=====================================================================
;                         BULLET HANDLING
;=====================================================================
move_bullet PROC
    CMP bullet_x, 0
    JE bullet_done
    
    MOV AX, bullet_y
    SUB AX, bullet_speed
    MOV bullet_y, AX
    
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

check_collision PROC
    ; Check if bullet is active
    CMP bullet_x, 0
    JE no_collision
    
    ; Check if bullet is within alien's X range
    MOV AX, bullet_x
    CMP AX, alien_x
    JL no_collision
    ADD AX, 3       
    MOV BX, alien_x
    ADD BX, 16   
    CMP AX, BX
    JG no_collision
    
    ; Check if bullet is within alien's Y range
    MOV AX, bullet_y
    CMP AX, alien_y
    JL no_collision
    ADD AX, 3      
    MOV BX, alien_y
    ADD BX, 16      
    CMP AX, BX
    JG no_collision
    
    MOV alien_x, 20    
    MOV alien_y, 30
    MOV bullet_x, 0    
    MOV bullet_y, 0
    
    ; Increase score
    INC score
    
    ; Play collision sound
    CALL play_collision_sound
    
    STC             
    RET
    
no_collision:
    CLC              
    RET
check_collision ENDP

;=====================================================================
;                         SOUND EFFECTS
;=====================================================================
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

;=====================================================================
;                         GRAPHICS ROUTINES
;=====================================================================
draw_sprite PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    MOV AH, 0Ch
    MOV BX, 16     
draw_row:
    PUSH CX
    MOV DI, 16     
draw_col:
    LODSB           
    CMP AL, 0       
    JE skip_pixel
    INT 10H         
skip_pixel:
    INC CX         
    DEC DI
    JNZ draw_col
    POP CX         
    INC DX         
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
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    
    MOV AH, 0Ch
    MOV AL, 0       
    MOV BX, 16      
    
clear_row:
    PUSH CX         
    MOV DI, 16     
    
clear_col:
    INT 10H        
    INC CX          
    DEC DI
    JNZ clear_col
    
    POP CX          
    INC DX          
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
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    
    MOV AH, 0Ch
    MOV BX, 3       
bullet_row:
    PUSH CX
    MOV DI, 3      
bullet_col:
    INT 10H         
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
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    
    MOV AH, 0Ch
    MOV AL, 0       
    MOV BX, 3       
clear_b_row:
    PUSH CX
    MOV DI, 3       
clear_b_col:
    INT 10H         
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
