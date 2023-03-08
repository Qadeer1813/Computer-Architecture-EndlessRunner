*-----------------------------------------------------------
* Title      : Endless Runner 
* Written by : Qadeer Hussain C00270632
* Date       : 08/03/2023
* Description: Endless Runner Project 
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
*-----------------------------------------------------------
* Section       : Trap Codes
* Description   : Trap Codes used throughout StarterKit 
*-----------------------------------------------------------
* Trap CODES
TC_SCREEN   EQU         33          ; Screen size information trap code
TC_S_SIZE   EQU         00          ; Places 0 in D1.L to retrieve Screen width and height in D1.L
                                    ; First 16 bit Word is screen Width and Second 16 bits is screen Height
TC_KEYCODE  EQU         19          ; Check for pressed keys
TC_DBL_BUF  EQU         92          ; Double Buffer Screen Trap Code
TC_CURSR_P  EQU         11          ; Trap code cursor position
    
TC_EXIT     EQU         09          ; Exit Trapcode

*-----------------------------------------------------------
* Section       : Charater Setup
* Description   : Size of Player and Enemy and properties
* of these characters e.g Starting Positions and Sizes
*-----------------------------------------------------------
PLYR_W_INIT EQU         20          ; Players initial Width
PLYR_H_INIT EQU         20          ; Players initial Height
 
OPPS_INDEX  EQU         02          ; Player Opps Sound Index

ENMY_W_INIT EQU         20          ; Enemy initial Width
ENMY_H_INIT EQU         20          ; Enemy initial Height

TOP_Y_LINE  EQU         108         ; Top Y line start point
BOTTOM_Y_LINE  EQU      342         ; Bottom Y line start point
*-----------------------------------------------------------
* Section       : Game Stats
* Description   : Points, Health
*-----------------------------------------------------------
POINTS      EQU         01          ; Points added
ENEMY_MOVEMENT  EQU  00
*-----------------------------------------------------------
* Section       : Keyboard Keys
* Description   : Spacebar and Escape or two functioning keys
* Spacebar to JUMP and Escape to Exit Game
*-----------------------------------------------------------
ESCAPE      EQU         $1B         ; Escape ASCII Keycode 
UPARROW     EQU         $26         ; UP key ASCII Keycode
DOWNARROW   EQU         $28         ; Down Key ASCII Keycode   
*-----------------------------------------------------------
* Subroutine    : Initialise
* Description   : Initialise game data into memory such as 
* sounds and screen size
*-----------------------------------------------------------
INITIALISE:
    ; Initialise Sounds
    BSR     OPPS_LOAD               ; Load Opps (Collision) Sound into Memory

    ; Screen Size
    MOVE.B  #TC_SCREEN, D0          ; access screen information
    MOVE.L  #TC_S_SIZE, D1          ; placing 0 in D1 triggers loading screen size information
    TRAP    #15                     ; interpret D0 and D1 for screen size
    MOVE.W  D1,         SCREEN_H    ; place screen height in memory location
    SWAP    D1                      ; Swap top and bottom word to retrive screen size
    MOVE.W  D1,         SCREEN_W    ; place screen width in memory location

    ; Place the Player at the center of the screen
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  #00,         PLAYER_X   ; Players X set to 0 Position

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    MOVE.W  #215,       D1          ; Set 225 the spawn for enemy and move to D1
    MOVE.L  D1,         PLAYER_Y    ; Move D1 to Players Y Position

    ; Initialise Player Score
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  #00,         D1         ; Init Score
    MOVE.L  D1,         PLAYER_SCORE
    
    ;Initialize Health
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  #100,       D1          ; Set 100 as the health and move it to D1
    MOVE.L  D1,         HEALTH_VALUE ; Move D1 to Health Value
    
    ; Initial Position for Enemy 1   
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_1   ; Enemy X Position

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    MOVE.W  #110,       D1          ; Set 110 as the spawn and move it to D1
    MOVE.L  D1,         ENEMY_Y_1   ; Move D1 to Enemy y 1

    ; Initial Position for Enemy 2   
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_2   ; Enemy X Position

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    MOVE.W  #145,       D1          ; Set 145 as the spawn and move it to D1
    MOVE.L  D1,         ENEMY_Y_2   ; Move D1 to Enemy Y 2
    
    ; Initial Position for Enemy 3
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_3     ; Enemy X Position
    
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    MOVE.W  #180,       D1          ; Set 180 as the spawn and move it to D1
    MOVE.L  D1,         ENEMY_Y_3   ; Move D1 to Enemy Y 3
        
    ; Initial Position for Enemy 4   
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_4   ; Enemy X Position

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    MOVE.W  #215,       D1          ; Set 215 as the spawn and move it to D1
    MOVE.L  D1,         ENEMY_Y_4   ; Move D1 to Enemy Y 4

    ; Initial Position for Enemy 5   
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_5   ; Enemy X Position

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    MOVE.W  #250,       D1          ; Set 250 as the spawn and move it to D1
    MOVE.L  D1,         ENEMY_Y_5   ; Move D1 to Enemy Y 5
    
    ; Initial Position for Enemy 6 
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_6   ; Enemy X Position

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    MOVE.W  #285,       D1          ; Set 285 as the spawn and move it to D1
    MOVE.L  D1,         ENEMY_Y_6   ; Move D1 to Enemy Y 6
    
    ; Initial Position for Enemy 7 
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_7   ; Enemy X Position

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    MOVE.W  #320,       D1          ; Set 320 as the spawn and move it to D1
    MOVE.L  D1,         ENEMY_Y_7   ; Move D1 to Enemy Y 7
        
    ; Enable the screen back buffer(see easy 68k help)
	MOVE.B  #TC_DBL_BUF,D0          ; 92 Enables Double Buffer
    MOVE.B  #17,        D1          ; Combine Tasks
	TRAP	#15                     ; Trap (Perform action)

    ; Clear the screen (see easy 68k help)
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
	MOVE.W  #$FF00,     D1          ; Fill Screen Clear
	TRAP	#15                     ; Trap (Perform action)

*-----------------------------------------------------------
* Subroutine    : Game
* Description   : Game including main GameLoop. GameLoop is like
* a while loop in that it runs forever until interupted
* (Input, Update, Draw). The Enemies Run at Player Jump to Avoid
*-----------------------------------------------------------
GAME:

GAMELOOP:
    MOVEQ   #08,D0                  ; Get time in 1/100 seconds
    TRAP    #15

    MOVE.L  D1,-(SP)                ; Push time on the stack
    
    ; Main Gameloop
    BSR     INPUT                   ; Check Keyboard Input
    BSR     UPDATE_1                ; Update positions 1
    BSR     UPDATE_2                ; Update positions 2
    BSR     UPDATE_3                ; Update positions 3
    BSR     UPDATE_4                ; Update positions 4
    BSR     UPDATE_5                ; Update positions 5
    BSR     UPDATE_6                ; Update positions 6
    BSR     UPDATE_7                ; Update positions 7
    BSR     CHECK_COLLISIONS_1      ; Check for Collisions 1
    BSR     CHECK_COLLISIONS_2      ; Check for Collisions 2
    BSR     CHECK_COLLISIONS_3      ; Check for Collisions 3
    BSR     CHECK_COLLISIONS_4      ; Check for Collisions 4
    BSR     CHECK_COLLISIONS_5      ; Check for Collisions 5
    BSR     CHECK_COLLISIONS_6      ; Check for Collisions 6
    BSR     CHECK_COLLISIONS_7      ; Check for Collisions 7
    BSR     DRAW                    ; Draw the Scene
    
    MOVE.L  (SP)+,D7                ; Move stack to D7
WAIT:
    MOVEQ   #8,D0                   ; Mve this trap 8 to D0
    TRAP    #15
    SUB.L   D7,D1                   ; Subtract previous time from current time
    CMP.B   #02,D1                  ; Compare the the subtracted time
    BMI.S   WAIT                    ; Loop if time not up yet

    BRA     GAMELOOP                ; Loop back to Game loop
*-----------------------------------------------------------
* Subroutine    : Input
* Description   : Process Keyboard Input
*-----------------------------------------------------------
INPUT:
    ; Process Input
    CLR.L   D1                      ; Clear Data Register
    MOVE.B  #TC_KEYCODE,D0          ; Listen for Keys
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  D1,         D2          ; Move last key D1 to D2
    CMP.B   #00,        D2          ; Key is pressed
    BEQ     PROCESS_INPUT           ; Process Key
    TRAP    #15                     ; Trap for Last Key
    ; Check if key still pressed
    CMP.B   #$FF,       D1          ; Is it still pressed
    BEQ     PROCESS_INPUT           ; Process Last Key
    RTS                             ; Return to subroutine
*-----------------------------------------------------------
* Subroutine    : Process Input
* Description   : Branch based on keys pressed
*-----------------------------------------------------------
PROCESS_INPUT:
    MOVE.L  D2,         CURRENT_KEY ; Put Current Key in Memory
    CMP.L   #ESCAPE,    CURRENT_KEY ; Is Current Key Escape
    BEQ     EXIT                    ; Exit if Escape
    CMP.L   #UPARROW,  CURRENT_KEY  ; Is Current Key UP
    BEQ     UP                      ; Up
    CMP.L   #DOWNARROW,CURRENT_KEY  ; Is Current Key Down
    BEQ     DOWN                    ; Down
    RTS                             ; Return to subroutine
*-----------------------------------------------------------
* Subroutine    : Update
* Description   : Main update loop update Player and Enemies
*-----------------------------------------------------------  
UPDATE_1:
    ; Move the Enemy
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  ENEMY_X_1,  D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_ENEMY_POSITION_1  ; Reset Enemy if off Screen
    BRA     MOVE_ENEMY_1
    RTS        

UPDATE_2:
    ; Move the Enemy
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  ENEMY_X_2,  D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_ENEMY_POSITION_2  ; Reset Enemy if off Screen
    BRA     MOVE_ENEMY_2
    RTS   
    
UPDATE_3:
    ; Move the Enemy
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  ENEMY_X_3,  D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_ENEMY_POSITION_3  ; Reset Enemy if off Screen
    BRA     MOVE_ENEMY_3
    RTS   

UPDATE_4:
    ; Move the Enemy
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  ENEMY_X_4,  D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_ENEMY_POSITION_4  ; Reset Enemy if off Screen
    BRA     MOVE_ENEMY_4
    RTS   

UPDATE_5:
    ; Move the Enemy
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  ENEMY_X_5,  D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_ENEMY_POSITION_5  ; Reset Enemy if off Screen
    BRA     MOVE_ENEMY_5            ; Move the Enemy
    RTS                             ; Return to subroutine
    
UPDATE_6:
    ; Move the Enemy
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  ENEMY_X_6,  D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_ENEMY_POSITION_6  ; Reset Enemy if off Screen
    BRA     MOVE_ENEMY_6
    RTS 

UPDATE_7:
    ; Move the Enemy
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  ENEMY_X_7,  D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_ENEMY_POSITION_7  ; Reset Enemy if off Screen
    BRA     MOVE_ENEMY_7
    RTS   
*-----------------------------------------------------------
* Subroutine    : UP
* Description   : Move the enemy up 3 frames
* By: Qadeer Hussain
*-----------------------------------------------------------
UP:  
    SUB.L   #3, PLAYER_Y
    ; Check if player is out of bounds
   CMP.L   #110, PLAYER_Y ; Stop the player from moving up anymore when player Y valye goes to 110
    BLT     OUT_OF_BOUNDS_UP
    RTS
    
OUT_OF_BOUNDS_UP:
    ; Player is out of bounds, move back into screen
    MOVE.L  #3, D2   ; set D2 to the amount to move
    ADD.L   D2, PLAYER_Y  ; move player down
    RTS
*-----------------------------------------------------------
* Subroutine    : DOWN
* Description   : Move the enemy down 3 frames
* By: Qadeer Hussain
*-----------------------------------------------------------
DOWN:
    ADD.L   #3, PLAYER_Y 
    ; Check if player is out of bounds
    CMP.L   #322, PLAYER_Y  ; Stop the player from moving down anymore when player Y valye goes to 322
    BGE     OUT_OF_BOUNDS_DOWN
    RTS 

OUT_OF_BOUNDS_DOWN:
    ; Player is out of bounds, move back into screen
    MOVE.L  #3, D2  ; set D2 to the amount to move
    NEG.L   D2      ; negate D2 to move upwards
    ADD.L   D2, PLAYER_Y  ; move player up
    RTS
*-----------------------------------------------------------
* Subroutine    : Move Enemy
* Description   : Move Enemy Right to Left
*-----------------------------------------------------------
MOVE_ENEMY_1:
    SUB.L   #05,    ENEMY_X_1   ; Move enemy by X Value
    RTS
     
MOVE_ENEMY_3:
    SUB.L   #05,    ENEMY_X_3   ; Move enemy by X Value
    RTS

MOVE_ENEMY_5:
    SUB.L    #05,   ENEMY_X_5   ; Move enemy by X Value
    RTS
    
MOVE_ENEMY_7:
    SUB.L    #05,   ENEMY_X_7   ; Move enemy by X Value
    RTS
     
MOVE_ENEMY_2:
     SUB.L   #03,   ENEMY_X_2   ; Move enemy by X Value
     RTS
     
MOVE_ENEMY_4:
     SUB.L   #03,   ENEMY_X_4   ; Move enemy by X Value
     RTS
    
MOVE_ENEMY_6:
     SUB.L   #03,   ENEMY_X_6   ; Move enemy by X Value
     RTS  
*-----------------------------------------------------------
* Subroutine    : Reset Enemy
* Description   : Reset Enemy if to passes 0 to Right of Screen
*----------------------------------------------------------- 
RESET_ENEMY_POSITION_1:             ; Reset enemy 1
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_1   ; Enemy X Position
    RTS

RESET_ENEMY_POSITION_2:             ; Reset enemy 1
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_2   ; Enemy X Position
    RTS
    
RESET_ENEMY_POSITION_3:             ; Reset enemy 1
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_3   ; Enemy X Position
    RTS
    
RESET_ENEMY_POSITION_4:             ; Reset enemy 1
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_4   ; Enemy X Position
    RTS
    
RESET_ENEMY_POSITION_5:             ; Reset enemy 1
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_5   ; Enemy X Position
    RTS
    
RESET_ENEMY_POSITION_6:             ; Reset enemy 1
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_6   ; Enemy X Position
    RTS
    
RESET_ENEMY_POSITION_7:             ; Reset enemy 1
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X_7   ; Enemy X Position
    RTS
*-----------------------------------------------------------
* Subroutine    : Draw
* Description   : Draw Screen
*-----------------------------------------------------------
DRAW: 
    ; Enable back buffer
    MOVE.B  #94,        D0
    TRAP    #15

    ; Clear the screen
    MOVE.B	#TC_CURSR_P,D0          ; Set Cursor Position
	MOVE.W	#$FF00,     D1          ; Clear contents
	TRAP    #15                     ; Trap (Perform action)

    BSR     DRAW_PLYR_DATA          ; Draw Draw Score, HUD, Player X and Y
    BSR     DRAW_PLAYER             ; Draw Player
    BSR     DRAW_ENEMY_6            ; Draw Enemy No.6
    BSR     DRAW_ENEMY_7            ; Draw Enemy No.7
    BSR     DRAW_ENEMY_1            ; Draw Enemy No.1
    BSR     DRAW_ENEMY_2            ; Draw Enemy No.2
    BSR     DRAW_ENEMY_3            ; Draw Enemy No.3
    BSR     DRAW_ENEMY_4            ; Draw Enemy No.4
    BSR     DRAW_ENEMY_5            ; Draw Enemy No.5
    BSR     DRAW_BOTTOM_LINE        ; Draw bottom line
    BSR     DRAW_TOP_LINE           ; Draw top line
    
    RTS                             ; Return to subroutine
DRAW_TOP_LINE:
    
    MOVE.L  #LIME,       D1         ; Set color
    MOVE.L  #80,         D0         ; Move the pen colour trap to D0   
    TRAP    #15
    
    CLR.L   D1
    MOVE.L  #TOP_Y_LINE,D2          ; Move the Top Y to D2
    MOVE.W  SCREEN_W,  D3           ; Move the screen_W which will be the length of the line to D3
    MOVE.L  #TOP_Y_LINE,D4          ; Move the Top Y to D4
    
    MOVE.L  #84,       D0           ; Trap to draw the line
    TRAP    #15
    
    RTS             
DRAW_BOTTOM_LINE:
    
    MOVE.L  #LIME,       D1         ; Set color
    MOVE.L  #80,         D0         ; Move the pen colour trap to D0
    TRAP    #15
    
    CLR.L   D1
    MOVE.L  #BOTTOM_Y_LINE,D2       ; Move the Bottom Y value to D2
    MOVE.W  SCREEN_W,  D3           ; Move the screen_W which will be the length of the line to D3
    MOVE.L  #BOTTOM_Y_LINE,D4       ; Move the Bottom Y value to D4
    
    MOVE.L  #84,       D0           ; Trap to draw the line
    TRAP    #15 
    
    RTS    
*-----------------------------------------------------------
* Subroutine    : Draw Player Data
* Description   : Draw Player X, Y, Velocity, Gravity and OnGround
*-----------------------------------------------------------
DRAW_PLYR_DATA:
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)

    ; Player Score Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0201,     D1          ; Col 02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     SCORE_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    ; Player Score Value
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0901,     D1          ; Col 09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVE.L  PLAYER_SCORE,D1         ; Move Score to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
    ; Health Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0203,     D1          ; Col 02, Row 03
    TRAP    #15                     ; Trap (Perform action)
    LEA     HEALTH_MSG, A1          ; Health Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Health Value
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0903,     D1          ; Col 09, Row 03
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVE.L  HEALTH_VALUE,D1         ; Move Health to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player X Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0202,     D1          ; Col 02, Row 02
    TRAP    #15                     ; Trap (Perform action)
    LEA     X_MSG,      A1          ; X Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player X
    MOVE.B  #TC_CURSR_P, D0          ; Set Cursor Position
    MOVE.W  #$0502,     D1          ; Col 05, Row 02
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVE.L  PLAYER_X,   D1          ; Move X to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player Y Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1002,     D1          ; Col 10, Row 02
    TRAP    #15                     ; Trap (Perform action)
    LEA     Y_MSG,      A1          ; Y Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player Y
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1202,     D1          ; Col 12, Row 02
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVE.L  PLAYER_Y,   D1          ; Move X to D1.L
    TRAP    #15                     ; Trap (Perform action) 
    
    ; Show Keys Pressed
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$2001,     D1          ; Col 20, Row 1
    TRAP    #15                     ; Trap (Perform action)
    LEA     KEYCODE_MSG, A1         ; Keycode
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    ; Show KeyCode
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$3001,     D1          ; Col 30, Row 1
    TRAP    #15                     ; Trap (Perform action)    
    MOVE.L  CURRENT_KEY,D1          ; Move Key Pressed to D1
    MOVE.B  #03,        D0          ; Display the contents of D1
    TRAP    #15                     ; Trap (Perform action)
    
    ; Show Contols
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$2017,     D1          ; Col 20, Row 19
    TRAP    #15                     ; Trap (Perform action)
    LEA     CONTROLS,   A1        ; Keycode
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    RTS  
*-----------------------------------------------------------
* Subroutines   : Sound Load and Play
* Description   : Initialise game sounds into memory 
* Current Sounds are RUN, JUMP and Opps for Collision
*-----------------------------------------------------------
OPPS_LOAD:
    LEA     OPPS_WAV,   A1          ; Load Wav File into A1
    MOVE    #OPPS_INDEX,D1          ; Assign it INDEX
    MOVE    #71,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_OPPS:
    MOVE    #OPPS_INDEX,D1          ; Load Sound INDEX
    MOVE    #72,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine
*-----------------------------------------------------------
* Subroutine    : Draw Player
* Description   : Draw Player Square
*-----------------------------------------------------------
DRAW_PLAYER:
    ; Set Pixel Colors
    MOVE.L  #WHITE,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  PLAYER_X,   D1          ; X
    MOVE.L  PLAYER_Y,   D2          ; Y
    MOVE.L  PLAYER_X,   D3
    ADD.L   #PLYR_W_INIT,   D3      ; Width
    MOVE.L  PLAYER_Y,   D4 
    ADD.L   #PLYR_H_INIT,   D4      ; Height
    
    ; Draw Player
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

*-----------------------------------------------------------
* Subroutine    : Draw Enemy
* Description   : Draw Enemy Square
*-----------------------------------------------------------    
DRAW_ENEMY_1:                       ; Draw Enemy No.1
    ; Set Pixel Colors
    MOVE.L  #RED,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  ENEMY_X_1,    D1        ; X
    MOVE.L  ENEMY_Y_1,    D2        ; Y
    MOVE.L  ENEMY_X_1,    D3
    ADD.L   #ENMY_W_INIT, D3        ; Width
    MOVE.L  ENEMY_Y_1,    D4 
    ADD.L   #ENMY_H_INIT, D4        ; Height
    
    ; Draw Enemy    
    MOVE.B  #87,        D0          ; Draw Enemy
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

DRAW_ENEMY_2:                       ; Draw Enemy No.2
    ; Set Pixel Colors
    MOVE.L  #RED,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  ENEMY_X_2,    D1        ; X
    MOVE.L  ENEMY_Y_2,    D2        ; Y
    MOVE.L  ENEMY_X_2,    D3
    ADD.L   #ENMY_W_INIT, D3        ; Width
    MOVE.L  ENEMY_Y_2,    D4 
    ADD.L   #ENMY_H_INIT, D4        ; Height
    
    ; Draw Enemy    
    MOVE.B  #87,        D0          ; Draw Enemy
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine
            
DRAW_ENEMY_3:                       ; Draw Enemy No.3
    ; Set Pixel Colors
    MOVE.L  #RED,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  ENEMY_X_3,    D1        ; X
    MOVE.L  ENEMY_Y_3,    D2        ; Y
    MOVE.L  ENEMY_X_3,    D3
    ADD.L   #ENMY_W_INIT, D3        ; Width
    MOVE.L  ENEMY_Y_3,    D4 
    ADD.L   #ENMY_H_INIT, D4        ; Height
    
    ; Draw Enemy    
    MOVE.B  #87,        D0          ; Draw Enemy
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

DRAW_ENEMY_4:                       ; Draw Enemy No.4
    ; Set Pixel Colors
    MOVE.L  #RED,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  ENEMY_X_4,    D1        ; X
    MOVE.L  ENEMY_Y_4,    D2        ; Y
    MOVE.L  ENEMY_X_4,    D3
    ADD.L   #ENMY_W_INIT, D3        ; Width
    MOVE.L  ENEMY_Y_4,    D4 
    ADD.L   #ENMY_H_INIT, D4        ; Height
    
    ; Draw Enemy    
    MOVE.B  #87,        D0          ; Draw Enemy
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine 
    
DRAW_ENEMY_5:                       ; Draw Enemy No.5
    ; Set Pixel Colors
    MOVE.L  #RED,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  ENEMY_X_5,    D1          ; X
    MOVE.L  ENEMY_Y_5,      D2          ; Y
    MOVE.L  ENEMY_X_5,    D3
    ADD.L   #ENMY_W_INIT,   D3      ; Width
    MOVE.L  ENEMY_Y_5,    D4 
    ADD.L   #ENMY_H_INIT,   D4      ; Height
    
    ; Draw Enemy    
    MOVE.B  #87,        D0          ; Draw Enemy
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

DRAW_ENEMY_6:                       ; Draw Enemy No.6
    ; Set Pixel Colors
    MOVE.L  #RED,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  ENEMY_X_6,    D1        ; X
    MOVE.L  ENEMY_Y_6,    D2        ; Y
    MOVE.L  ENEMY_X_6,    D3
    ADD.L   #ENMY_W_INIT,   D3      ; Width
    MOVE.L  ENEMY_Y_6,    D4 
    ADD.L   #ENMY_H_INIT,   D4      ; Height
    
    ; Draw Enemy    
    MOVE.B  #87,        D0          ; Draw Enemy
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine  

DRAW_ENEMY_7:                       ; Draw Enemy No.7
    ; Set Pixel Colors
    MOVE.L  #RED,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  ENEMY_X_7,    D1        ; X
    MOVE.L  ENEMY_Y_7,    D2        ; Y
    MOVE.L  ENEMY_X_7,    D3
    ADD.L   #ENMY_W_INIT, D3        ; Width
    MOVE.L  ENEMY_Y_7,    D4 
    ADD.L   #ENMY_H_INIT, D4        ; Height
    
    ; Draw Enemy    
    MOVE.B  #87,        D0          ; Draw Enemy
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine              
;----------------------------------------------------------
* Subroutine    : Collision Check
* Description   : Axis-Aligned Bounding Box Collision Detection
* Algorithm checks for overlap on the 4 sides of the Player and 
* Enemy rectangles
* PLAYER_X <= ENEMY_X + ENEMY_W &&
* PLAYER_X + PLAYER_W >= ENEMY_X &&
* PLAYER_Y <= ENEMY_Y + ENEMY_H &&
* PLAYER_H + PLAYER_Y >= ENEMY_Y
*-----------------------------------------------------------
CHECK_COLLISIONS_1:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2

PLAYER_X_LTE_TO_ENEMY_X_1_PLUS_W:
    MOVE.L  PLAYER_X,   D1          ; Move Player X to D1
    MOVE.L  ENEMY_X_1,  D2          ; Move Enemy X to D2
    ADD.L   ENMY_W_INIT,D2          ; Set Enemy width X + Width
    CMP.L   D1,         D2          ; Do the Overlap ?
    BLE     PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_1  ; Less than or Equal ?
    BRA     COLLISION_CHECK_DONE   ; If not no collision
    
PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_1:     ; Check player is not  
    ADD.L   PLYR_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X_1,  D2          ; Move Enemy X to D2
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     PLAYER_Y_LTE_TO_ENEMY_Y_1_PLUS_H  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE   ; If not no collision
   
PLAYER_Y_LTE_TO_ENEMY_Y_1_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y_1,  D2          ; Move Enemy Y to D2
    ADD.L   ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BLE     PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_1  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision
    
PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_1:     ; Less than or Equal 
    MOVE.L  PLAYER_Y,   D1
    ADD.L   PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y_1,  D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     COLLISION              ; Collision !
    BRA     COLLISION_CHECK_DONE    ; If not no collision
*------------------------------------------------------------------------------ 
CHECK_COLLISIONS_2:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2

PLAYER_X_LTE_TO_ENEMY_X_2_PLUS_W:
    MOVE.L  PLAYER_X,   D1          ; Move Player X to D1
    MOVE.L  ENEMY_X_2,  D2          ; Move Enemy X to D2
    ADD.L   ENMY_W_INIT,D2          ; Set Enemy width X + Width
    CMP.L   D1,         D2          ; Do the Overlap ?
    BLE     PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_2  ; Less than or Equal ?
    BRA     COLLISION_CHECK_DONE   ; If not no collision
    
PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_2:     ; Check player is not  
    ADD.L   PLYR_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X_2,  D2          ; Move Enemy X to D2
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     PLAYER_Y_LTE_TO_ENEMY_Y_2_PLUS_H  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE   ; If not no collision
   
PLAYER_Y_LTE_TO_ENEMY_Y_2_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y_2,  D2          ; Move Enemy Y to D2
    ADD.L   ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BLE     PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_2  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision
    
PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_2:     ; Less than or Equal ?
    MOVE.L  PLAYER_Y,   D1
    ADD.L   PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y_2,  D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     COLLISION              ; Collision !
    BRA     COLLISION_CHECK_DONE    ; If not no collision
*--------------------------------------------------------------------------------- 
CHECK_COLLISIONS_3:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2

PLAYER_X_LTE_TO_ENEMY_X_3_PLUS_W:
    MOVE.L  PLAYER_X,   D1          ; Move Player X to D1
    MOVE.L  ENEMY_X_3,  D2          ; Move Enemy X to D2
    ADD.L   ENMY_W_INIT,D2          ; Set Enemy width X + Width
    CMP.L   D1,         D2          ; Do the Overlap ?
    BLE     PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_3  ; Less than or Equal ?
    BRA     COLLISION_CHECK_DONE    ; If not no collision

PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_3:     ; Check player is not  
    ADD.L   PLYR_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X_3,  D2          ; Move Enemy X to D2
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     PLAYER_Y_LTE_TO_ENEMY_Y_3_PLUS_H  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision
   
PLAYER_Y_LTE_TO_ENEMY_Y_3_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y_3,  D2          ; Move Enemy Y to D2
    ADD.L   ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BLE     PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_3  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision
    
PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_3:     ; Less than or Equal ?
    MOVE.L  PLAYER_Y,   D1
    ADD.L   PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y_3,  D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     COLLISION              ; Collision !
    BRA     COLLISION_CHECK_DONE    ; If not no collision
*--------------------------------------------------------------------------------
CHECK_COLLISIONS_4:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2

PLAYER_X_LTE_TO_ENEMY_X_4_PLUS_W:
    MOVE.L  PLAYER_X,   D1          ; Move Player X to D1
    MOVE.L  ENEMY_X_4,  D2          ; Move Enemy X to D2
    ADD.L   ENMY_W_INIT,D2          ; Set Enemy width X + Width
    CMP.L   D1,         D2          ; Do the Overlap ?
    BLE     PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_4  ; Less than or Equal ?
    BRA     COLLISION_CHECK_DONE    ; If not no collision

PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_4:     ; Check player is not  
    ADD.L   PLYR_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X_4,  D2          ; Move Enemy X to D2
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     PLAYER_Y_LTE_TO_ENEMY_Y_4_PLUS_H  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision
   
PLAYER_Y_LTE_TO_ENEMY_Y_4_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y_4,  D2          ; Move Enemy Y to D2
    ADD.L   ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BLE     PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_4  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision 
    
PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_4:     ; Less than or Equal ?
    MOVE.L  PLAYER_Y,   D1
    ADD.L   PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y_4,  D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     COLLISION               ; Collision !
    BRA     COLLISION_CHECK_DONE    ; If not no collision
*---------------------------------------------------------------------------------
CHECK_COLLISIONS_5:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
    
PLAYER_X_LTE_TO_ENEMY_X_5_PLUS_W:
    MOVE.L  PLAYER_X,   D1          ; Move Player X to D1
    MOVE.L  ENEMY_X_5,  D2          ; Move Enemy X to D2
    ADD.L   ENMY_W_INIT,D2          ; Set Enemy width X + Width
    CMP.L   D1,         D2          ; Do the Overlap ?
    BLE     PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_5  ; Less than or Equal ?
    BRA     COLLISION_CHECK_DONE    ; If not no collision
    
PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_5:     ; Check player is not  
    ADD.L   PLYR_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X_5,  D2          ; Move Enemy X to D2
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     PLAYER_Y_LTE_TO_ENEMY_Y_5_PLUS_H  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision
   
PLAYER_Y_LTE_TO_ENEMY_Y_5_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y_5,  D2          ; Move Enemy Y to D2
    ADD.L   ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BLE     PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_5  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision 
    
PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_5:     ; Less than or Equal ?
    MOVE.L  PLAYER_Y,   D1
    ADD.L   PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y_5,  D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     COLLISION               ; Collision !
    BRA     COLLISION_CHECK_DONE    ; If not no collision
*----------------------------------------------------------------------------------
CHECK_COLLISIONS_6:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
    
PLAYER_X_LTE_TO_ENEMY_X_6_PLUS_W:
    MOVE.L  PLAYER_X,   D1          ; Move Player X to D1
    MOVE.L  ENEMY_X_6,  D2          ; Move Enemy X to D2
    ADD.L   ENMY_W_INIT,D2          ; Set Enemy width X + Width
    CMP.L   D1,         D2          ; Do the Overlap ?
    BLE     PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_6  ; Less than or Equal ?
    BRA     COLLISION_CHECK_DONE    ; If not no collision
    
PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_6:     ; Check player is not  
    ADD.L   PLYR_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X_6,  D2          ; Move Enemy X to D2
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     PLAYER_Y_LTE_TO_ENEMY_Y_6_PLUS_H  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision
   
PLAYER_Y_LTE_TO_ENEMY_Y_6_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y_6,  D2          ; Move Enemy Y to D2
    ADD.L   ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BLE     PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_6  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision 
    
PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_6:     ; Less than or Equal ?
    MOVE.L  PLAYER_Y,   D1
    ADD.L   PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y_6,  D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     COLLISION               ; Collision !
    BRA     COLLISION_CHECK_DONE    ; If not no collision
*---------------------------------------------------------------------------------
CHECK_COLLISIONS_7:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
    
PLAYER_X_LTE_TO_ENEMY_X_7_PLUS_W:
    MOVE.L  PLAYER_X,   D1          ; Move Player X to D1
    MOVE.L  ENEMY_X_7,  D2          ; Move Enemy X to D2
    ADD.L   ENMY_W_INIT,D2          ; Set Enemy width X + Width
    CMP.L   D1,         D2          ; Do the Overlap ?
    BLE     PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_7  ; Less than or Equal ?
    BRA     COLLISION_CHECK_DONE    ; If not no collision
    
PLAYER_X_PLUS_W_LTE_TO_ENEMY_X_7:     ; Check player is not  
    ADD.L   PLYR_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X_7,  D2          ; Move Enemy X to D2
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     PLAYER_Y_LTE_TO_ENEMY_Y_7_PLUS_H  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision
   
PLAYER_Y_LTE_TO_ENEMY_Y_7_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y_7,  D2          ; Move Enemy Y to D2
    ADD.L   ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BLE     PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_7  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE    ; If not no collision 
    
PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y_7:     ; Less than or Equal ?
    MOVE.L  PLAYER_Y,   D1
    ADD.L   PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y_7,  D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     COLLISION               ; Collision !
    BRA     COLLISION_CHECK_DONE    ; If not no collision
*---------------------------------------------------------------------------------
COLLISION_CHECK_DONE:               ; No Collision Update points
    ADD.L   #POINTS,    D1          ; Move points upgrade to D1
    ADD.L   PLAYER_SCORE,D1         ; Add to current player score
    MOVE.L  D1,PLAYER_SCORE        ; Update player score in memory
    RTS                             ; Return to subroutine

    
COLLISION:
    BSR     PLAY_OPPS               ; Play Opps Wav
    SUB.L   #20, HEALTH_VALUE       ; Sub 20 from Health everytime there is a collison
    IF.L    (HEALTH_VALUE) <EQ> #0 THEN     ; If the = 0 then
    
            MOVE.B	#TC_CURSR_P,D0          ; Set Cursor Position
	        MOVE.W	#$FF00,     D1          ; Clear contents
	        TRAP    #15                     ; Trap (Perform action)
	        
	        BSR     DRAW_PLYR_DATA          ; Draw Draw Score, HUD, Player X and Y
            BSR     DRAW_PLAYER             ; Draw Player
            BSR     DRAW_ENEMY_1            ; Draw Enemey 1
            BSR     DRAW_ENEMY_2            ; Draw Enemey 2
            BSR     DRAW_ENEMY_3            ; Draw Enemey 3
            BSR     DRAW_ENEMY_4            ; Draw Enemey 4
            BSR     DRAW_ENEMY_5            ; Draw Enemey 5
            BSR     DRAW_ENEMY_6            ; Draw Enemey 6
            BSR     DRAW_ENEMY_7            ; Draw Enemey 7
            BSR     DRAW_BOTTOM_LINE        ; Draw bottom line
            BSR     DRAW_TOP_LINE           ; Draw bottom line

            MOVE.B  #94,        D0
            TRAP    #15
            
            BSR EXIT
    ENDI
    RTS                             ; Return to subroutine   
*-----------------------------------------------------------
* Subroutine    : EXIT
* Description   : Exit message and End Game
*-----------------------------------------------------------
EXIT:
    ; Show if Exiting is Running
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$4004,     D1          ; Col 40, Row 1
    TRAP    #15                     ; Trap (Perform action)
    LEA     EXIT_MSG,   A1          ; Exit
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #TC_EXIT,   D0          ; Exit Code
    TRAP    #15                     ; Trap (Perform action)
    SIMHALT

*-----------------------------------------------------------
* Section       : Messages
* Description   : Messages to Print on Console, names should be
* self documenting
*-----------------------------------------------------------
SCORE_MSG       DC.B    'Score : ', 0       ; Score Message
KEYCODE_MSG     DC.B    'KeyCode : ', 0     ; Keycode Message
;---------------------------------------------------------
UP_MSG          DC.B    'Up....', 0       ; Up Message
DOWN_MSG        DC.B    'Down....', 0       ; Down Message
;-----------------------------------------------------------
X_MSG           DC.B    'X:', 0             ; X Position Message
Y_MSG           DC.B    'Y:', 0             ; Y Position Message
HEALTH_MSG      DC.B    'Health : ',0       ; Health message
CONTROLS        DC.B    'Controls Up and Down key',0
EXIT_MSG        DC.B    'Exiting....', 0    ; Exit Message
*-----------------------------------------------------------
* Section       : Graphic Colors
* Description   : Screen Pixel Color
*-----------------------------------------------------------
WHITE           EQU     $00FFFFFF
RED             EQU     $000000FF
LIME            EQU     $0000FF00 
*-----------------------------------------------------------
* Section       : Screen Size
* Description   : Screen Width and Height
*-----------------------------------------------------------
SCREEN_W        DS.W    01  ; Reserve Space for Screen Width
SCREEN_H        DS.W    01  ; Reserve Space for Screen Height

*-----------------------------------------------------------
* Section       : Keyboard Input
* Description   : Used for storing Keypresses
*-----------------------------------------------------------
CURRENT_KEY     DS.L    01  ; Reserve Space for Current Key Pressed

*-----------------------------------------------------------
* Section       : Character Positions
* Description   : Player and Enemy Position Memory Locations
*-----------------------------------------------------------
PLAYER_X        DS.L    01  ; Reserve Space for Player X Position
PLAYER_Y        DS.L    01  ; Reserve Space for Player Y Position
PLAYER_SCORE    DS.L    01  ; Reserve Space for Player Score
HEALTH_VALUE    DS.L    01  ; Reserve Space for Health Value

ENEMY_X_1       DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y_1       DS.L    01  ; Reserve Space for Enemy Y Position

ENEMY_X_2       DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y_2       DS.L    01  ; Reserve Space for Enemy Y Position

ENEMY_X_3       DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y_3       DS.L    01  ; Reserve Space for Enemy Y Position

ENEMY_X_4       DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y_4       DS.L    01  ; Reserve Space for Enemy Y Position

ENEMY_X_5       DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y_5       DS.L    01  ; Reserve Space for Enemy Y Position

ENEMY_X_6       DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y_6       DS.L    01  ; Reserve Space for Enemy Y Position

ENEMY_X_7       DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y_7       DS.L    01  ; Reserve Space for Enemy Y Position

*-----------------------------------------------------------
* Section       : Sounds
* Description   : Sound files, which are then loaded and given
* an address in memory, they take a longtime to process and play
* so keep the files small. Used https://voicemaker.in/ to 
* generate and Audacity to convert MP3 to WAV
*-----------------------------------------------------------
OPPS_WAV        DC.B    'opps.wav',0        ; Collision Opps

    END    START        ; last line of source





  



































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
