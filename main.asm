
; 開始畫面，遊戲畫面(含底陣列)，左、右、下移，旋轉，結束畫面合成(6/9)

;=========================   更新  6/10 BY 姿    ================================

;增加data eliminate_lock、current_row_number  (消除判定會用到) ，變數在 47~51 那裡

;增加 2 個函式 check_up_eliminate ( 檢查有沒有任何一列可以消除 ) 
;              eliminate_line  ( 藉由 current_row_number 消除指定的列，並把該列以上的方塊下移)

;兩個函式在 241 ~323
;================================================================================
.model flat, stdcall
.386
.stack 4096

.DATA 

    ;  variable of fast_down & calculus_col PRO
    MAX_ROW1 DW 0
    MAX_ROW2 DW 0
    MAX_ROW3 DW 0
    MAX_ROW4 DW 0

    ; variable of DRAW_FINALSCORE PRO
    FinalScore DB 'YOUR FINAL SCORE: ', '$'

    ; variables of DRAW_TITLENAME PRO
    TitleName DB 'MAGIC BLOCK', '$'
    PressStart DB 'PRESS ENTER TO START', '$'

    ; variables of DRAW_SCORE PRO
    Score DB 0, '$'
    ScoreIs DB 'Score: $'

    ; variables of draw_area & POSITION_PRINT_STRING PRO
    cursor_row DB 4h
    cursor_column DB 0Dh


    RIGHTIS DB 'Right ', '$'
    LEFTIS DB  'Left ', '$'
    UPIS DB 'Up ', '$'
    DOWNIS DB 'Down ', '$'
    key DW 0

;========== check_up_eliminate 會用到 ==============
    eliminate_lock DW 0     ;等於0代表正在檢查的列並非全滿，不能消除
                            ;等於1則代表正在檢查的列全滿，可以消除
    current_row_number DW 0
;================================================

;================ draw_area用的 =================
    CHARZERO DB ' ','$'
    CHARONE DB '@','$'
    CHARNEW DB 0Dh,0Ah,'$'
;=================================================

;==============================================左右移動會用到==========================================================
    smallblock_start DW 5   ;判斷移動中的方塊的位置在底陣列的哪裡目前假設小方塊從中間開始(!!!最左是0假設從5開始!!!!)
    smallblock_type DW 0    ;!!!!保存現在方塊的種類的編號!!!
    address_test DW 0
    MAX_COL1 DW 0   ;紀錄現在的方塊的形狀從start最遠到有幾列幾行(0代表該列沒有方塊,1代表到第一塊,2代表到第二塊以此類推)
    MAX_COL2 DW 0   ;供右移做判斷用的
    MAX_COL3 DW 0
    MAX_COL4 DW 0
                    ;供判斷左移用的 ( 0代表該列沒有方塊,1代表第一行是空的,2代表第一行是有方塊的 )
    R_COL1 DW 0
    R_COL2 DW 0
    R_COL3 DW 0
    R_COL4 DW 0
;=======================================================================================================================

;==============================================左右移動會用到==========================================================
    square_block DW 2,2,1,1,2,1,1           ;對應的smallblock_type = (1)
    line_block DW 1,4,1,1,1,1               ;(2)
    line_block2 DW 4,1,1,1,1,1,1,1,1        ;(3)

    T_block DW 2,3,0,1,0,3,1,1,1            ;(4)
    T_block2 DW 3,2,1,0,2,1,1,2,1,0         ;(5)
    T_block3 DW 2,3,1,1,1,3,0,1,0           ;(6)
    T_block4 DW 3,2,0,1,2,1,1,2,0,1         ;(7)

    L_block DW 2,3,1,0,0,3,1,1,1            ;(8)
    L_block2 DW 3,2,1,1,2,1,0,2,1,0         ;(9)
    L_block3 DW 2,3,1,1,1,3,0,0,1           ;(10)
    L_block4 DW 3,2,0,1,2,0,1,2,1,1         ;(11)

    Z_block DW 2,3,0,1,1,3,1,1,0            ;(12)
    Z_block2 DW 3,2,1,0,2,1,1,2,0,1         ;(13)
    ;---------------------------------------------------
    block_area1 DW 0,0,0,0,0,1,1,0,0,0,0,1,2 ;一列12行(不包含2),共18列
    block_area2 DW 0,0,0,0,0,1,1,0,0,0,0,1,2
    block_area3 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area4 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area5 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area6 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area7 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area8 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area9 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area10 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area11 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area12 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area13 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area14 DW 0,0,0,0,0,0,0,0,0,0,0,1,2
    block_area15 DW 1,0,0,0,0,0,0,0,0,0,0,1,2
    block_area16 DW 1,1,0,0,0,1,0,0,0,0,0,1,2
    block_area17 DW 1,1,1,1,1,1,0,0,1,0,0,1,2
    block_area18 DW 1,1,1,1,1,1,0,0,1,1,1,1,2
    block_area19 DW 2,2,2,2,2,2,2,2,2,2,2,2,2   ;這一列不用顯示!!只是為了下降判斷停住用的

.CODE
main proc  
    mov ax,@DATA
    mov ds,ax
    ; GRAPHICS MODE
        MOV AH, 0
        MOV AL, 5h
        INT 10h

    ;-------------------------------------
     mov smallblock_type,1      ;設定目前方塊的種類
    ;-------------------------------------

    ; 開始畫面
   DRAWTITLE:
        call DRAW_TITLE         ; 開始畫面背景顏色
        call DRAW_TITLENAME     ; 開始畫面文字
        call DRAW_REC           ; 開始畫面邊框
    
    ; 等待enter按下
    KEY_PRESSED1:
        mov AH,0
        int 16h
        cmp al,13   ; enter的ascii為13
        jne KEY_PRESSED1
    
   ; 清除畫面
   mov ax,5h
   int 10h

   ; 遊戲畫面
   GAMEFRAME:
        call DRAW_BACKGROUND    ; 遊戲畫面背景顏色
        call DRAW_FRAME         ; 遊戲畫面邊框
        call DRAW_SCORE         ; 畫出分數
        ; 思妤的隨機產生方塊
        call draw_area          ; 畫出底陣列
        ; 芷瑞的一格一格下降

    GAMELOOP:
        ; 查詢鍵盤緩衝區，對鍵盤掃描但不等待，如果有則ZF = 0，沒有ZF = 1
        MOV AH,1
        INT 16h
        JZ GAMEFRAME     ; jump if zf = 1，也就是沒有按鍵被按
        mov AH,0
        int 16h
        ; 結束條件
        CMP AL, 13            ; 和enter鍵做比較，暫時的設定: 按enter結束遊戲
        JE DRAWFINALESCORE       ; 如果比較結果為true，則跳到 DRAWFINALESCORE 標籤
        call KEY_PRESSED
        JMP GAMELOOP

   ; 結束畫面
   DRAWFINALESCORE:
       ; 清除畫面
        mov ax,5h
        int 10h
        call DRAW_TITLE
        call DRAW_FINALSCORE
   
   ; 等待enter按下
   KEY_PRESSED3:
        mov AH,0
        int 16h
        cmp al,13   ; enter的ascii為13
        jne KEY_PRESSED3
    
    END_GAME:
        ; 清除畫面
        mov ax,5h
        int 10h
        mov ah,4ch
        int 21h 
        hlt
main ENDP

KEY_PRESSED proc      

    CALL KEY_ACTIONS

    END_KEY_PRESSED1:
        RET 
KEY_PRESSED ENDP

KEY_ACTIONS PROC 

    ; 玩家使用的按鍵

        CMP AH, 75            ; 和左鍵做比較
        JE PLAYER_LEFTKEY     ; 如果比較結果為true，則跳到 PLAYER_LEFTKEY 標籤

        CMP AH, 77            ; 和右鍵做比較
        JE PLAYER_RIGHTKEY    ; 如果比較結果為true，則跳到 PLAYER_RIGHTKEY 標籤

        CMP AH, 72            ; 和上鍵做比較
        JE PLAYER_UPKEY     ; 如果比較結果為true，則跳到 PLAYER_UPKEY 標籤

        CMP AH, 80            ; 和下鍵做比較
        JE PLAYER_DOWNKEY    ; 如果比較結果為true，則跳到 PLAYER_DOWNKEY 標籤
    
    RET

    ; 玩家按下按鍵後執行的程式

        PLAYER_RIGHTKEY:                                    
            MOV key, 4  ;4 MEANS GO RIGHT       
            call do_right                   ;=======================================
            call check_up_eliminate         ;為了測試，先放在按右鍵執行檢查
            RET                             ;======================================
        
        PLAYER_LEFTKEY: 
            MOV key, 3  ;3 MEANS GO LEFT
            call do_left
            RET

        PLAYER_UPKEY:                                   
            MOV key, 1  ;1 MEANS GO UP
            call rotate
            RET        
        
        PLAYER_DOWNKEY: 
            MOV key, 2  ;2 MEANS GO DOWN
            call fast_down
            RET


KEY_ACTIONS ENDP


;====================================================  檢查有沒有能消除的列，如果有就消除並加分 (會用到 eliminate_line 消除方塊) ====================================================================

check_up_eliminate PROC             
    pusha
    mov di,OFFSET block_area1       
    mov cx,18                       ;共需檢查18列
    mov current_row_number,0        ;每次呼叫check_up_eliminate都要重設(才能知道現在檢查第幾列，才知道要消除第幾列)
    check_all_row:
        push cx
        mov eliminate_lock,1        ;預設該列可消除
        mov cx,12                   ;一列12行
        mov si,di                   ;把該列第一行位址用si儲存,如果需要消除才知道從哪裡開始
        add current_row_number,1    

        check_a_line:
            mov ax,[di]
            CMP ax,0                ;如果有一行是0就去設eliminate_lock為0
            JE set_lock_0       
            JMP next_col_check      ;非0則可繼續檢查下一行

            set_lock_0:
                mov eliminate_lock,0

            next_col_check :
                add di,2            ;di指向下一行
        loop check_a_line
                                    
        mov bx,eliminate_lock       ;藉由 eliminate_lock值決定是否呼叫消除函式 ( 是1要呼叫，是0就不用 )
        CMP bx,1
        JNE next_row_check          ;不等於1就跳去檢查下一列
        call eliminate_line         ;呼叫消除函式 (si指向該列第一行)
        
        next_row_check:
            add di,2                ;當內迴圈check_a_line結束時剛好停在每列最後一行(指向2的那行)，再加2就會到下一列的頭
        pop cx
    loop check_all_row

    popa
    RET
check_up_eliminate ENDP

;=================用來消除某列 (  check_up_eliminate 會用到 ，加分會動到 Score) ============

eliminate_line PROC                 
    pusha
;---------------------------- step 1  消除滿了的那列 -------------------------

    mov cx,12           ;一列有12行 ( 要把這列的12行的值改成 0)
    start_eliminate:    ;開始改成 0
        mov ax,0
        mov [si],ax
        add si,2
    loop start_eliminate
;-------------------- step 2 把消除列以上的方塊下移 ( 把消掉的那行補好 )-------

    mov di,OFFSET block_area1
                            ;一行一行下移方塊
    mov cx,12               ;一列有12行，共12行要下移
    eliminate_line_change:
        push cx
        mov cx,current_row_number   ;內迴圈要設定成 ( 正在被消除列 ) 的編號 減 1 
        dec cx                      ;  (ex.現在 current_row_number = 13 代表正在消除第13列，在這之上的總共12列需要下移) 
        mov si,di
        add si,26
        mov ax,[di]
        change_a_column:    
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop change_a_column
        mov [di],ax
                                ;下移完成，
        add di,2                ;di會指向第一列的某行，di + 2 讓di指到下一行去繼續執行下移
        pop cx
    loop eliminate_line_change  ;直到12行都下移才結束迴圈

    add Score,1h                ; !!!消除掉一列加1分!!! 有增加 SCORE 的值 
    
    popa
    RET
eliminate_line ENDP




;=============================================== 向右會用到( calculus_col、 screenclr (清螢幕可以用你的取代)、draw_area  ) =======================================================

do_right PROC 
    pusha
    call calculus_col       ;利用方塊種類設定MAX_COL1~4(供判定能否右移)
    mov di,OFFSET block_area1

    mov cx,smallblock_start
    toward_to_start1:
        add di,2
    loop toward_to_start1    ;迴圈結束後di紀錄的位址是小方塊的起始位址

    ;- step1 ----確認現在這個小方塊右邊一格是不是1或2,必須不是才能右移-----------

    CMP MAX_COL1,0          ;(如果是0代表小方塊第一列列沒有1,不用判斷此列右邊是否有1)
    JE checkrow2         ;不用判斷就跳去
    mov si,di               ;把小方塊開始位址(第一列最左)存進si
    mov cx,MAX_COL1         ;假設MAX_COL1=1(代表最右的一在第一格)所以CX設一,跑到隔壁看是不是1或2
                            ;同理MAX_COL1=2 CX=2 ,跑到隔壁的隔壁(即移動兩次)看裡面是不是1 or 2,以此類推
    address_row1:            
        add si,2            ;因為是WORD所以地址是加二
    loop address_row1
    mov bx,[si]
    CMP bx,0                ;該位置內容為0則繼續判斷第二列
    JE checkrow2
    JMP RIGHT_FINAL        ;如果內容不為0(可能是1或2)表示旁邊有東西或到底了,不能右移,直接結束函數

    checkrow2:   
    CMP MAX_COL2,0          ;(如果是0代表小方塊第一列列沒有1,不用判斷此列右邊是否有1)
    JE checkrow3            ;不用判斷就跳去判斷下一列
    mov si,di               ;di儲存小方塊第一列起始位址(跳到第二列的起始要 + 13*2 )
    add si,26               
    mov cx,MAX_COL2
    address_row2:            
        add si,2            ;因為是WORD所以地址是加二
    loop address_row2
    mov bx,[si]
    CMP bx,0
    JE checkrow3
    JMP RIGHT_FINAL 

    checkrow3:
    CMP MAX_COL3,0
    JE checkrow4
    mov si,di
    add si,52               ;小方塊第三列開頭位址是smallblock_start位址+26*2
    mov cx,MAX_COL3
    address_row3:              
        add si,2            ;因為是WORD所以地址是加二
    loop address_row3   
    mov bx,[si]
    CMP bx,0
    JE checkrow4
    JMP RIGHT_FINAL

    checkrow4:
    CMP MAX_COL4,0          ;可以開始換元素(確認四列都可以右移)
    JE Rstart
    mov si,di
    add si,78               ;小方塊第四列開頭位址是smallblock_start位址+39*2
    mov cx,MAX_COL4
    address_row4:              
        add si,2            ;因為是WORD所以地址是加二
    loop address_row4
    mov bx,[si]
    CMP bx,0
    JE Rstart           ;確認四列旁邊都是空的就開始右移交換元素
    JMP RIGHT_FINAL

    ;- step2 --------------四列檢查完後開始右移------------------------------------------------
    Rstart:
    mov ax,smallblock_type  ;確定方塊種類來對應不同的移動元素交換方式
    CMP ax,1
    JE square_rchange
    CMP ax,2
    JE line_rchange1
    CMP ax,3
    JE line_rchange2
    CMP ax,4
    JE T_rchange1
    CMP ax,5
    JE T_rchange2
    CMP ax,6
    JE T_rchange3
    CMP ax,7
    JE T_rchange4
    CMP ax,8
    JE L_rchange1
    CMP ax,9
    JE L_rchange2
    CMP ax,10
    JE L_rchange3
    CMP ax,11
    JE L_rchange4
    CMP ax,12
    JE Z_rchange1
    CMP ax,13
    JE Z_rchange2
    JMP RIGHT_FINAL
    ;*************************( 1 )*********************
    square_rchange:
    push di
    mov si,di
    add si,2                  ;0的右邊第一個元素位址要加2(WORD)
    mov cx,2                    
    mov ax,[di]                 
    squareRmove1:             ;換第一列元素
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop squareRmove1
    mov [di],ax	
    ;換第二列元素
    pop di      ;把小方塊第一列的起始位址放回di
    add di,26   ;讓di指向第二列起始
    mov si,di   
    add si,2    ;第二個元素位址要加2(WORD)
    mov cx,2                    
    mov ax,[di]  
    squareRmove2:             
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop squareRmove2
    mov [di],ax
    inc smallblock_start    ;確定右移完(起始編號會多一)
    JMP RIGHT_FINAL
    ;*************************( 2 )*********************
    line_rchange1:
    mov si,di           ;di是第一列的起始
    add si,2            ;si指向右邊一個元素
    mov cx,4
    mov ax,[di]
    line_block1_Rmove:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop line_block1_Rmove
    mov [di],ax
    inc smallblock_start
    JMP RIGHT_FINAL
    ;*************************( 3 )*******************
    line_rchange2:
    push di     ;保存第一列起始位置的地址
    mov si,di   ;只需要直接交換,不需用迴圈
    add si,2    
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di      ;還原位址
    push di     ;再保存
    add di,26   ;指向小方塊第二列起始
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di
    push di     ;再保存
    add di,52   ;指向小方塊第三列起始
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di
    push di     ;再保存
    add di,78   ;指向小方塊第四列起始
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di      ;有PUSH就要記得POP
    inc smallblock_start
    JMP RIGHT_FINAL
    ;**********************( 4 )****( T1 )*************
    T_rchange1:
    push di
    add di,2        ;T1的第一列元素交換從第二格開始(第一格沒東西)
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di              ;還原di
    add di,26           ;讓di指向第二列的起始
    mov si,di           
    add si,2            ;si指向di右邊一個元素
    mov cx,3
    mov ax,[di]
    T_block1_Rmove2:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop T_block1_Rmove2
    mov [di],ax
    inc smallblock_start
    JMP RIGHT_FINAL
    ;***********************( 5 )****( T2 )************
    T_rchange2:
    push di
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di
    push di
    add di,26
    mov si,di
    add si,2
    mov cx,2
    mov ax,[di]
    T_block2_Rmove2:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop T_block2_Rmove2
    mov [di],ax
    pop di
    add di,52
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    inc smallblock_start
    JMP RIGHT_FINAL
    ;**********************( 6 )****( T3 )*************
    T_rchange3:
    push di
    mov si,di
    add si,2
    mov cx,3
    mov ax,[di]
    T_block3_Rmove1:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop T_block3_Rmove1
    mov [di],ax
    pop di
    add di,26
    add di,2
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    inc smallblock_start
    JMP RIGHT_FINAL
    ;***********************( 7 )****( T4 )**************
    T_rchange4:
    push di
    add di,2
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di
    push di
    add di,26
    mov si,di
    add si,2
    mov cx,2
    mov ax,[di]
    T_block4_Rmove2:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop T_block4_Rmove2
    mov [di],ax
    pop di
    add di,52
    add di,2
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    inc smallblock_start
    JMP RIGHT_FINAL
    ;**********************( 8 )****( L1 )******************
    L_rchange1:
    push di
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di
    add di,26
    mov si,di
    add si,2
    mov cx,3
    mov ax,[di]
    L_block1_Rmove2:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop L_block1_Rmove2
    mov [di],ax
    inc smallblock_start
    JMP RIGHT_FINAL
    ;*************************( 9 )****( L2 )*****************
    L_rchange2:
    push di
    mov si,di
    add si,2
    mov cx,2
    mov ax,[di]
    L_block2_Rmove1:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop L_block2_Rmove1
    mov [di],ax
    pop di
    push di
    add di,26
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di
    add di,52
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    inc smallblock_start
    JMP RIGHT_FINAL
    ;*************************( 10 )****( L3 )****************
    L_rchange3:
    push di
    mov si,di
    add si,2
    mov cx,3
    mov ax,[di]
    L_block3_Rmove1:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop L_block3_Rmove1
    mov [di],ax
    pop di
    add di,26
    add di,4    ;第二列從第三行才是方塊本體(+2 +2)
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    inc smallblock_start
    JMP RIGHT_FINAL
    ;*************************( 11 )****( L4 )****************
    L_rchange4:
    push di
    add di,2        ;方塊本體從第二格開始
    mov si,di       
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di          ;還原位址
    push di         ;再保存
    add di,26       ;di指向小方塊第二列
    add di,2        ;第二列第二格
    mov si,di
    add si,2        ;第二列第三格
    mov ax,[di]     ;交換元素
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di          ;還原位址
    add di,52       ;指向第三列
    mov si,di
    add si,2
    mov cx,2        ;跑迴圈交換元素
    mov ax,[di]
    L_block4_Rmove3:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop L_block4_Rmove3
    mov [di],ax
    inc smallblock_start
    JMP RIGHT_FINAL
    ;*************************( 12 )****( Z1 )****************
    Z_rchange1:
    push di
    add di,2
    mov si,di
    add si,2
    mov cx,2        ;跑迴圈交換元素
    mov ax,[di]
    Z_block1_Rmove1:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop Z_block1_Rmove1
    mov [di],ax
    pop di
    add di,26
    mov si,di
    add si,2
    mov cx,2        ;跑迴圈交換元素
    mov ax,[di]
    Z_block1_Rmove2:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop Z_block1_Rmove2
    mov [di],ax
    inc smallblock_start
    JMP RIGHT_FINAL
    ;*************************( 13 )****( Z2 )****************
    Z_rchange2:
    push di
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di
    push di
    add di,26
    mov si,di
    add si,2
    mov cx,2        ;跑迴圈交換元素
    mov ax,[di]
    Z_block2_Rmove2:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop Z_block2_Rmove2
    mov [di],ax
    pop di
    add di,52      ;指向小方塊第三列
    add di,2       ;從第二格才是方塊本體
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    inc smallblock_start
    JMP RIGHT_FINAL

    RIGHT_FINAL:
  
    ; 清除畫面
    mov ax,5h
    int 10h

    call DRAW_BACKGROUND    ; 遊戲畫面背景顏色
    call DRAW_FRAME         ; 遊戲畫面邊框
    call DRAW_SCORE         ; 畫出分數
    call draw_area          ;畫出刷新陣列

    popa
    RET
do_right ENDP


;===================================================== 向左( calculus_col、 screenclr (清螢幕可以用你的取代)、draw_area  ) ===========================================================

do_left PROC
    pusha
    call calculus_col       ;利用方塊種類設定 R_COL1~4(供判定能否左移)
    mov di,OFFSET block_area1
    mov cx,smallblock_start
    toward_to_start2:
        add di,2
    loop toward_to_start2    ;迴圈結束後di紀錄的位址是小方塊的起始位址(小心不能動到,需要di時記得push、pop)

    ;- step 1 ---------------------------------

    CMP R_COL1,0        ; R_COL1~4可能等於 (0,1,2,3)
    JE L_checkrow2      ;0代表該列沒方塊不用判斷,1代表該列的方塊在右一格(需判斷現在指的這格有沒有東西擋住)
    mov si,di           ;2代表此列此格有方塊,因此要確認左一格有沒有方塊擋住
                        ;3比較特殊,只出現在 L3方塊第二列,代表指的這格右移兩格才是方塊本體,因此需判斷現在這格的右一格有沒有東西擋住
                        ;(因為特殊情況只出現在檢查第二列時才有可能發生所以只有檢查第二列時才特別另判斷 R_COL2 是否為3)
    mov cx,R_COL1        
    dec cx              ;R_COL1等於2 代表要判左移一格是否為空
    lead_to_row1:     ;等於1則表示要判斷該格是否為空 因此才迴圈數等於R_COL1減一(3要另外處理,先別管)
        sub si,2
    loop lead_to_row1
    mov bx,[si]
    CMP bx,0            ;是0就判斷下一列,不是零直接結束
    JE L_checkrow2 
    JMP LEFT_FINAL

    L_checkrow2: 
    CMP R_COL2,0        ; R_COL2可能等於 (0,1,2,3)
    JE L_checkrow3      
    CMP R_COL2,3        ;是3就要特別處理
    JE special_case_for3

    mov si,di
    add si,26
    mov cx,R_COL2
    dec cx
    lead_to_row2:     ;等於1則表示要判斷該格是否為空 因此才迴圈數等於R_COL1減一(3 已經跳到另外處理那邊,不用管)
        sub si,2
    loop lead_to_row2
    mov bx,[si]
    CMP bx,0
    JE L_checkrow3 
    JMP LEFT_FINAL

    special_case_for3:      ;處理R_COL2=3的情況
    mov si,di
    add si,26
    add si,2            ;右移一格判斷內容
    mov bx,[si]
    CMP bx,0            ;是0就判斷下一列,不是0就結束
    JE L_checkrow3 
    JMP LEFT_FINAL

    L_checkrow3:    ;判斷第三列
    CMP R_COL3,0        
    JE L_checkrow4      
    mov si,di       
    add si,52
    mov cx,R_COL3        
    dec cx             
    lead_to_row3:     
        sub si,2
    loop lead_to_row3
    mov bx,[si]
    CMP bx,0            
    JE L_checkrow4 
    JMP LEFT_FINAL

    L_checkrow4:
    CMP R_COL4,0        
    JE L_start     
    mov si,di    
    add si,78
    mov cx,R_COL4        
    dec cx             
    lead_to_row4:     
        sub si,2
    loop lead_to_row4
    mov bx,[si]
    CMP bx,0            
    JE L_start
    JMP LEFT_FINAL

    ;- step 2 開始交換 ---------------------

    L_start:
    mov ax,smallblock_type  ;確定方塊種類來對應不同的移動元素交換方式
    CMP ax,1
    JE square_lchange
    CMP ax,2
    JE line_lchange1
    CMP ax,3
    JE line_lchange2
    CMP ax,4
    JE T_lchange1
    CMP ax,5
    JE T_lchange2
    CMP ax,6
    JE T_lchange3
    CMP ax,7
    JE T_lchange4
    CMP ax,8
    JE L_lchange1
    CMP ax,9
    JE L_lchange2
    CMP ax,10
    JE L_lchange3
    CMP ax,11
    JE L_lchange4
    CMP ax,12
    JE Z_lchange1
    CMP ax,13
    JE Z_lchange2

    JMP LEFT_FINAL
    ;**********************(1)***********************************
    square_lchange:
    push di
    add di,2    ;指向小方塊最後一個為1的方格
    mov si,di
    sub si,2   ;讓si指向di前一格
    mov cx,2    ;設定迴圈
    mov ax,[di]
    square_block_Lmove1:    ;交換第一列元素
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop square_block_Lmove1
    mov [di],ax
    pop di
    add di,26   ;讓di指向第二列
    add di,2    ;第二格
    mov si,di
    sub si,2    ;si指向di左一格
    mov cx,2    ;設定迴圈
    mov ax,[di]
    square_block_Lmove2:    ;交換第二列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop square_block_Lmove2
    mov [di],ax
    dec smallblock_start    ;左移起始編號要減一
    JMP LEFT_FINAL
    ;**********************(2)***********************************
    line_lchange1:
    add di,6     ;讓di指向最右的一(跳三格要加2*3)
    mov si,di
    sub si,2
    mov cx,4
    mov ax,[di]
    line_block_Lmove1:    ;交換第一列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop line_block_Lmove1
    mov [di],ax
    dec smallblock_start    ;左移起始編號要減一
    JMP LEFT_FINAL
    ;**********************(3)***********************************
    line_lchange2:
    push di
    mov si,di
    sub si,2
    mov ax,[di]
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    push di
    add di,26   ;指向第二列的1
    mov si,di
    sub si,2
    mov ax,[di]
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    push di
    add di,52
    mov si,di
    sub si,2
    mov ax,[di]
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    add di,78
    mov si,di
    sub si,2
    mov ax,[di]
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start    ;左移起始編號要減一
    JMP LEFT_FINAL
    ;**********************(4)******( T1 )*************************
    T_lchange1:
    push di
    add di,2    ;從第一列第二格開始
    mov si,di   
    sub si,2    ;si指向di 左一格
    mov ax,[di]
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    add di,26   ;指向第二列起始
    add di,4    ;指向第二列最後一格1(+2+2)
    mov si,di      
    sub si,2    ;si指向di左一格
    mov cx,3
    mov ax,[di]
    T_block1_Lmove2:    ;交換第二列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop T_block1_Lmove2
    mov [di],ax
    dec smallblock_start
    JMP LEFT_FINAL
    ;**********************(5)********( T2 )***********************
    T_lchange2:
    push di
    mov si,di
    sub si,2    
    mov ax,[di]     ;交換第一列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    push di
    add di,26
    add di,2    ;di指向第二列第二格
    mov si,di
    sub si,2    ;si指向di前一格
    mov cx,2
    mov ax,[di]
    T_block2_Lmove2:    ;交換第二列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop T_block2_Lmove2
    mov [di],ax
    pop di
    add di,52       ;di指向第三列起始
    mov si,di
    sub si,2
    mov ax,[di]     ;交換第三列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start
    JMP LEFT_FINAL
    ;**********************(6)********( T3 )***********************
    T_lchange3:
    push di
    add di,4    ;di指向第一列第三格
    mov si,di
    sub si,2
    mov cx,3
    mov ax,[di]
    T_block3_Lmove1:    ;交換第一列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop T_block3_Lmove1
    mov [di],ax
    pop di
    add di,26   ;讓di指向第二列
    add di,2    ;第二列第二格
    mov si,di   
    sub si,2    ;si指向di左一格
    mov ax,[di]     ;交換第二列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start
    JMP LEFT_FINAL
    ;**********************(7)********( T4 )***********************
    T_lchange4:
    push di
    add di,2    ;指向第一列第二格
    mov si,di
    sub si,2
    mov ax,[di]     ;交換第一列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    push di
    add di,26
    add di,2    ;di 指向第二列第二格
    mov si,di
    sub si,2
    mov cx,2
    mov ax,[di]
    T_block4_Lmove2:    ;交換第二列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop T_block4_Lmove2
    mov [di],ax
    pop di
    add di,52           ;讓di指向第三列
    add di,2            ;第二格
    mov si,di
    sub si,2
    mov ax,[di]     ;交換第三列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start    ;移完起始編號要減一
    JMP LEFT_FINAL

    ;**********************(8)********( L1 )***********************
    L_lchange1:
    push di
    mov si,di
    sub si,2
    mov ax,[di]     ;交換第一列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    add di,26       ;di指向第二列第一格
    add di,4        ;向右移兩格
    mov si,di
    sub si,2
    mov cx,3
    mov ax,[di]
    L_block1_Lmove2:    ;交換第二列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop L_block1_Lmove2
    mov [di],ax
    dec smallblock_start
    JMP LEFT_FINAL
    ;**********************(9)********( L2 )***********************
    L_lchange2:
    push di
    add di,2
    mov si,di
    sub si,2
    mov cx,2
    mov ax,[di]
    L_block2_Lmove1:    ;交換第一列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop L_block2_Lmove1
    mov [di],ax
    pop di
    push di
    add di,26           ;指向第二列
    mov si,di
    sub si,2
    mov ax,[di]     ;交換第二列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    add di,52       ;指向第三列
    mov si,di
    sub si,2
    mov ax,[di]     ;交換第三列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start
    JMP LEFT_FINAL
    ;**********************(10)********( L3 )***********************
    L_lchange3:
    push di
    add di,4    ;指向第一列第三格
    mov si,di
    sub si,2
    mov cx,3
    mov ax,[di]
    L_block3_Lmove1:    ;交換第一列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop L_block3_Lmove1
    mov [di],ax
    pop di
    add di,26
    add di,4    ;指向第二列第三格
    mov si,di
    sub si,2
    mov ax,[di]     ;交換第二列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start
    JMP LEFT_FINAL
    ;**********************(11)********( L4 )***********************
    L_lchange4:
    push di
    add di,2
    mov si,di
    sub si,2
    mov ax,[di]     ;交換第一列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    push di
    add di,26       ;指向第二列
    add di,2        ;指向第二格
    mov si,di
    sub si,2
    mov ax,[di]     ;交換第二列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    add di,52
    add di,2
    mov si,di
    sub si,2
    mov cx,2
    mov ax,[di]
    L_block4_Lmove3:    ;交換第三列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop L_block4_Lmove3
    mov [di],ax
    dec smallblock_start
    JMP LEFT_FINAL
    ;**********************(12)********( Z1 )***********************
    Z_lchange1:
    push di
    add di,4    ;di指向第一列第三格
    mov si,di
    sub si,2
    mov cx,2
    mov ax,[di]
    Z_block1_Lmove1:    ;交換第一列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop Z_block1_Lmove1
    mov [di],ax

    pop di
    add di,26   ;di指向第二列
    add di,2    ;指向第二格
    mov si,di   
    sub si,2
    mov cx,2
    mov ax,[di]
    Z_block1_Lmove2:    ;交換第二列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop Z_block1_Lmove2
    mov [di],ax
    dec smallblock_start
    JMP LEFT_FINAL
    ;**********************(13)********( Z2 )***********************
    Z_lchange2:
    push di
    mov si,di
    sub si,2
    mov ax,[di]     ;交換第一列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    push di
    add di,26       ;di指向第二列
    add di,2
    mov si,di       
    sub si,2
    mov cx,2
    mov ax,[di]
    Z_block2_Lmove2:    ;交換第二列
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop Z_block2_Lmove2
    mov [di],ax
    pop di
    add di,52           ;di指向第三列
    add di,2            ;指向第二格
    mov si,di
    sub si,2            
    mov ax,[di]     ;交換第三列
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start
    JMP LEFT_FINAL

    LEFT_FINAL:

    ; 清除畫面
    mov ax,5h
    int 10h

    call DRAW_BACKGROUND    ; 遊戲畫面背景顏色
    call DRAW_FRAME         ; 遊戲畫面邊框
    call DRAW_SCORE         ; 畫出分數
    call draw_area

    popa
    ret
do_left ENDP

;========================================================( ! 下降 ! )======================================================================

fast_down PROC
    pusha
    call calculus_col       ;利用方塊種類設定 R_COL1~4(供判定能否左移)
    mov di,OFFSET block_area1
    mov cx,smallblock_start
    toward_to_start3:
        add di,2
    loop toward_to_start3    ;迴圈結束後di紀錄的位址是小方塊的起始位址(小心不能動到,需要di時記得push、pop)

;---------------------------------------------step1 判斷小方塊正下面有沒有障礙------------------------------------------------------

    CMP MAX_ROW1,0      ;假設MAX_ROW1=0則代表此行沒有方塊,不須判斷有沒有障礙物擋住,直接跳下一行檢查
    JE D_check_colu2    
    mov si,di           
    mov cx,MAX_ROW1
    address_down_colu1:
        add si,26
    loop address_down_colu1
    mov ax,0
    CMP [si],ax
    JE D_check_colu2    ;沒有東西(方塊或底線)擋住就去下一行檢查
    JMP Down_final      ;有東西擋住就結束


    D_check_colu2:
        CMP MAX_ROW2,0
        JE D_check_colu3 
        mov si,di
        add si,2            ;si移到第二行
        mov cx,MAX_ROW2
        address_down_colu2:
            add si,26
        loop address_down_colu2
        mov ax,0
        CMP [si],ax
        JE D_check_colu3    ;沒有東西(方塊或底線)擋住就去下一行檢查
    JMP Down_final      ;有東西擋住就結束


    D_check_colu3 :
        CMP MAX_ROW3,0
        JE D_check_colu4 
        mov si,di           ;di值保存方塊起始位址不變
        add si,4            ;si移到第三行
        mov cx,MAX_ROW3
        address_down_colu3:
            add si,26
        loop address_down_colu3
        mov ax,0
        CMP [si],ax
        JE D_check_colu4    ;沒有東西(方塊或底線)擋住就去下一行檢查
    JMP Down_final      ;有東西擋住就結束

    D_check_colu4:
        CMP MAX_ROW4,0
        JE D_change_start 
        mov si,di           ;di值保存方塊起始位址不變
        add si,6            ;si移到第四行
        mov cx,MAX_ROW4
        address_down_colu4:
            add si,26
        loop address_down_colu4
        mov ax,0
        CMP [si],ax
        JE D_change_start    ;沒有東西(方塊或底線)擋住就去下一行檢查
    JMP Down_final      ;有東西擋住就結束
;---------------------------------- step 2 把方塊下移 --------------------------------------------------
    D_change_start:
        mov ax,smallblock_type      ;依照方塊種類決定交換(下降)方式
        CMP ax,1
        JE squaredown
        CMP ax,2
        JE lineblock1_down
        CMP ax,3
        JE lineblock2_down
        CMP ax,4
        JE T_block1_down
        CMP ax,5
        JE T_block2_down
        CMP ax,6
        JE T_block3_down
        CMP ax,7
        JE T_block4_down
        CMP ax,8
        JE L_block1_down
        CMP ax,9
        JE L_block2_down
        CMP ax,10
        JE L_block3_down
        CMP ax,11
        JE L_block4_down
        CMP ax,12
        JE Z_block1_down
        CMP ax,13
        JE Z_block2_down
    squaredown:
        push di
        mov si,di
        add si,26
        mov cx,2
        mov ax,[di]
        square_block_down1:    ;交換第一行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop square_block_down1
        mov [di],ax
        pop di

        add di,2
        mov si,di
        add si,26
        mov cx,2
        mov ax,[di]
        square_block_down2:    ;交換第二行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop square_block_down2
        mov [di],ax
        add smallblock_start,13
    JMP Down_final
    ;******************************( 2 )*****************************
    lineblock1_down:
        push di
        mov si,di
        add si,26       ;交換第一行
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        push di
        add di,2        ;第二行
        mov si,di
        add si,26       ;交換第二行
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        push di
        add di,4        ;移到第三行
        mov si,di
        add si,26       ;交換第三行
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        add di,6
        mov si,di
        add si,26       ;交換第四行
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        add smallblock_start,13
    JMP Down_final
    ;********************************( 3 )****************************
    lineblock2_down:
        mov si,di
        add si,26
        mov cx,4
        mov ax,[di]
        line_block2_down1:    ;交換第二行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop line_block2_down1
        mov [di],ax
        add smallblock_start,13
    JMP Down_final
    ;********************************( 4 )*******************************
    T_block1_down:
        push di
        add di,26       ;交換第一行(方塊從第二列才開始有)
        mov si,di
        add si,26
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        push di
        add di,2
        mov si,di
        add si,26
        mov cx,2
        mov ax,[di]
        T_block1_down2:    ;交換第二行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop T_block1_down2
        mov [di],ax
        pop di
        add di,4            ;第三行
        add di,26           ;從第二列方塊開始
        mov si,di
        add si,26
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        add smallblock_start,13
    JMP Down_final
    ;********************************( 5 )*******************************
    T_block2_down:
        push di
        mov si,di
        add si,26
        mov cx,3
        mov ax,[di]
        T_block2_down1:    ;交換第1行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop T_block2_down1
        mov [di],ax
        pop di
        add di,2           ;交換第二行
        add di,26          ;第二行方塊從第二列開始
        mov si,di
        add si,26          
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        add smallblock_start,13
    JMP Down_final
    ;********************************( 6 )*******************************
    T_block3_down:
        push di
        mov si,di   ;第一行交換
        add si,26
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        push di
        add di,2    ;第二行
        mov si,di
        add si,26
        mov cx,2
        mov ax,[di]
        T_block3_down2:    ;交換第2行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop T_block3_down2
        mov [di],ax
        pop di
        add di,4    ;到第三行
        mov si,di   
        add si,26
        mov ax,[si] ;第三行交換
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        add smallblock_start,13
    JMP Down_final
    ;********************************( 7 )*******************************
    T_block4_down:
        push di
        add di,26
        mov si,di
        add si,26
        mov ax,[si] ;第一行交換
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        add di,2    ;第二行
        mov si,di
        add si,26
        mov cx,3
        mov ax,[di]
        T_block4_down2:    ;交換第2行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop T_block4_down2
        mov [di],ax
        add smallblock_start,13
    JMP Down_final
    ;********************************( 8 )*******************************
    L_block1_down:
    push di
    mov si,di
    add si,26
    mov cx,2
    mov ax,[di]
    L_block1_down1:    ;交換第1行
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,26
    loop L_block1_down1
    mov [di],ax
    pop di
    push di
    add di,2           ;di要移到第二行的第二列
    add di,26
    mov si,di
    add si,26
    mov ax,[si] ;第二行交換
    mov bx,[di]
    mov [si],bx
    mov [di],ax
    pop di
    add di,4           ;di要移到第三行的第二列
    add di,26
    mov si,di
    add si,26
    mov ax,[si]        ;第三行交換
    mov bx,[di]
    mov [si],bx
    mov [di],ax
    add smallblock_start,13
    JMP Down_final
    ;********************************( 9 )*******************************
    L_block2_down:
        push di
        mov si,di
        add si,26
        mov cx,3
        mov ax,[di]
        L_block2_down1:    ;交換第1行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop L_block2_down1
        mov [di],ax
        pop di
        add di,2            ;到第二行
        mov si,di           
        add si,26
        mov ax,[si]         ;第二行交換
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        add smallblock_start,13
    JMP Down_final
    ;********************************( 10 )*******************************
    L_block3_down:
        push di
        mov si,di           
        add si,26
        mov ax,[si]         ;第一行交換
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        push di
        add di,2            ;第二行
        mov si,di
        add si,26
        mov ax,[si]         ;第二行交換
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        add di,4            ;第三行
        mov si,di
        add si,26
        mov cx,2
        mov ax,[di]
        L_block3_down3:    ;交換第3行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop L_block3_down3
        mov [di],ax
        add smallblock_start,13
    JMP Down_final
    ;********************************( 11 )*******************************
    L_block4_down:
        push di
        add di,52       ;di到第一行第三列
        mov si,di
        add si,26
        mov ax,[si]         ;第1行交換
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        add di,2        ;di到第二行
        mov si,di
        add si,26
        mov cx,3
        mov ax,[di]
        L_block4_down2:    ;交換第2行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop L_block4_down2
        mov [di],ax
        add smallblock_start,13
    JMP Down_final
    ;********************************( 12 )*******************************
    Z_block1_down:
        push di
        add di,26
        mov si,di
        add si,26
        mov ax,[si]         ;第1行交換
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        push di
        add di,2
        mov si,di
        add si,26
        mov cx,2
        mov ax,[di]
        Z_block1_down2:    ;交換第2行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop Z_block1_down2
        mov [di],ax
        pop di
        add di,4
        mov si,di
        add si,26
        mov ax,[si]         ;第三行交換
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        add smallblock_start,13
    JMP Down_final
    ;********************************( 13 )*******************************
    Z_block2_down:
        push di
        mov si,di
        add si,26
        mov cx,2
        mov ax,[di]
        Z_block2_down1:    ;交換第2行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop Z_block2_down1
        mov [di],ax
        pop di
        add di,2
        add di,26
        mov si,di
        add si,26
        mov cx,2
        mov ax,[di]
        Z_block2_down2:    ;交換第2行
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop Z_block2_down2
        mov [di],ax
        add smallblock_start,13
    JMP Down_final

   

    Down_final:
        ; 清除畫面
        mov ax,5h
        int 10h

        call DRAW_BACKGROUND    ; 遊戲畫面背景顏色
        call DRAW_FRAME         ; 遊戲畫面邊框
        call DRAW_SCORE         ; 畫出分數
        call draw_area
    popa
    ret
fast_down ENDP


;======================================== (   !  旋轉 !     ) ==========================================================================
rotate PROC             ;函數直接用方塊類型判斷是否能旋轉,以及旋轉後的結果
    pusha
    mov di,OFFSET block_area1
    mov cx,smallblock_start
    toward_to_start4:
        add di,2            ;將di指向小方塊現在的起點(方便判斷能否旋轉)
    loop toward_to_start4    

    mov ax,smallblock_type
    CMP ax,1                ;正方塊不用旋轉
    JE rot_final
    CMP ax,2
    JE rot_line1
    CMP ax,3
    JE rot_line2
    CMP ax,4
    JE rot_T1
    CMP ax,5
    JE rot_T2
    CMP ax,6
    JE rot_T3
    CMP ax,7
    JE rot_T4
    CMP ax,8
    JE rot_L1
    CMP ax,9
    JE rot_L2
    CMP ax,10
    JE rot_L3
    CMP ax,11
    JE rot_L4
    CMP ax,12
    JE rot_Z1
    CMP ax,13
    JE rot_Z2
;*************************************( 2 )**************************************************
    rot_line1:
        mov si,di
        mov cx,3
        check_line1_rot:        ;確認旋轉後要到的位置是空的才能旋轉,否則直接結束
            add si,26       
            mov ax,[si]
            CMP ax,0
            JNE rot_final
        loop check_line1_rot
                                ;確認可以旋轉後開始變更方塊形狀及種類編號
        mov si,di
        mov cx,3
        line1_change_add:       ;新增1改變方塊形狀
            add si,26
            mov ax,1
            mov [si],ax
        loop line1_change_add
        mov si,di
        mov cx,3
        line1_change_delete:       ;刪掉1改變方塊形狀
            add si,2
            mov ax,0
            mov [si],ax
        loop line1_change_delete
        mov smallblock_type,3       ;修改現在方塊種類編號
        JMP rot_final
;*************************************( 3 )**************************************************
    rot_line2:
        mov si,di
        mov cx,3
        check_line2_rot:        ;確認旋轉後要到的位置是空的才能旋轉,否則直接結束
            add si,2       
            mov ax,[si]
            CMP ax,0
            JNE rot_final
        loop check_line2_rot
                                ;開始旋轉
        mov si,di
        mov cx,3
        line2_change_delete:       ;刪掉1改變方塊形狀
            add si,26
            mov ax,0
            mov [si],ax
        loop line2_change_delete
        mov si,di
        mov cx,3
        line2_change_add:     ;新增1改變方塊形狀
            add si,2
            mov ax,1
            mov [si],ax
        loop line2_change_add
        mov smallblock_type,2
    JMP rot_final
;*************************************( 4 )**************************************************
    rot_T1:
        mov si,di
        mov ax,[si]     ;第一列第一行
        CMP ax,0
        JNE rot_final
        mov si,di
        add si,52       ;第三列第一行
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;-----------------判斷都是0就開始可以變更方塊
        mov si,di
        mov ax,1
        mov [si],ax         ;加上新方塊
        add si,52
        mov [si],ax
        ;-----------------
        mov si,di
        add si,2            ;拿掉舊方塊
        mov ax,0
        mov [si],ax
        mov si,di
        add si,4        ;第二列第二行
        add si,26       
        mov [si],ax
        mov smallblock_type,5   ;更改方塊類型編號
    JMP rot_final
;*************************************( 5 )**************************************************
    rot_T2:
        mov si,di
        mov cx,2
        check_T2_rot:        ;確認旋轉後要到的位置是空的才能旋轉,否則直接結束
            add si,2       
            mov ax,[si]
            CMP ax,0
            JNE rot_final
        loop check_T2_rot
        ;變更方塊
        mov si,di
        mov cx,2
        T2_change_add:      ;加新方塊
            add si,2
            mov ax,1
            mov [si],ax
        loop T2_change_add
        mov si,di
        mov cx,2
        T2_change_delete:      ;刪舊方塊
            add si,26
            mov ax,0
            mov [si],ax
        loop T2_change_delete
        mov smallblock_type,6  
    JMP rot_final
;*************************************( 6 )**************************************************
    rot_T3:
        mov si,di
        add si,26               ;確認第二列第一行
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        mov si,di
        add si,2                ;第三列第二行
        add si,52
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;---------------------
        mov si,di
        mov ax,0                ;刪掉舊方塊
        mov [si],ax
        add si,4    
        mov [si],ax
        ;---------------------
        mov si,di
        mov ax,1                ;新增新方塊
        add si,26               ;第二列第一行
        mov [si],ax
        mov si,di
        add si,2                ;第三列第二行
        add si,52
        mov [si],ax
        mov smallblock_type,7  
    JMP rot_final
;*************************************( 7 )**************************************************
    rot_T4:
        mov si,di
        add si,4        ;第三行
        add si,26       ;第二列
        mov ax,[si]
        CMP ax,0
        ;------------------
        mov si,di       ;新增方塊
        add si,4        ;第三行
        add si,26       ;第二列
        mov ax,1
        mov [si],ax
        ;------------------
        mov si,di
        mov ax,0        ;刪方塊
        add si,2        ;第二行
        add si,52       ;第三列
        mov [si],ax
        ;-----------------
        mov smallblock_type,4 
    JMP rot_final
;*************************************( 8 )**************************************************
    rot_L1:
        mov si,di
        add si,2        ;第一列第二行
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        mov si,di
        add si,52       ;第三列第一行
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;------------------
        mov si,di
        mov ax,1        ;新增方塊
        add si,2        ;第一列第二行
        mov [si],ax
        mov si,di
        add si,52       ;第三列第一行
        mov [si],ax
        ;------------------
        mov si,di
        mov ax,0        ;刪掉多餘舊方塊
        add si,2        
        add si,26
        mov [si],ax
        add si,2
        mov [si],ax
        ;-----------------
        mov smallblock_type,9 
    JMP rot_final

;*************************************( 9 )**************************************************
    rot_L2:
        mov si,di
        add si,4        ;到第三行
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        add si,26       ;第三行第二列
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;--------------
        mov si,di
        mov ax,1        ;新增方塊
        add si,4
        mov [si],ax
        add si,26
        mov [si],ax
        ;--------------
        mov si,di
        mov ax,0        ;刪方塊
        add si,26
        mov [si],ax
        add si,26
        mov [si],ax
        ;-----------------
        mov smallblock_type,10 
    JMP rot_final
;*************************************( 10 )**************************************************
    rot_L3:
        mov si,di
        add si,52   ;第一行第三列
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        mov si,di
        add si,2    ;第二行
        add si,26   ;第二列
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        add si,26   ;第二行第三列
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;----------------
        mov si,di
        mov ax,1        ;新增方塊
        add si,52
        mov [si],ax
        mov si,di
        add si,2    ;第二行
        add si,26   ;第二列
        mov [si],ax
        add si,26    ;第二行第三列
        mov [si],ax
        ;----------------
        mov si,di
        mov ax,0       ;刪除多餘舊方塊
        mov [si],ax
        add si,4
        mov [si],ax
        add si,26
        mov [si],ax
        mov smallblock_type,11 
    JMP rot_final
;*************************************( 11 )**************************************************
    rot_L4:
        mov si,di
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        add si,26
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        mov si,di
        add si,4        ;第三行
        add si,26       ;第二列
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;------------------
        mov si,di
        mov ax,1        ;新增
        mov [si],ax
        add si,26
        mov [si],ax
        mov si,di
        add si,4        ;第三行
        add si,26       ;第二列
        mov [si],ax
        ;------------------
        mov si,di
        mov ax,0
        add si,2
        mov [si],ax
        mov si,di
        add si,52
        mov [si],ax
        add si,2
        mov [si],ax
        ;------------------
        mov smallblock_type,8 
    JMP rot_final

;*************************************( 12 )**************************************************
    rot_Z1:
        mov si,di
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        add si,2
        add si,52
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;------------------
        mov si,di
        mov ax,1
        mov [si],ax
        add si,2
        add si,52
        mov [si],ax
        ;------------------
        mov si,di
        mov ax,0
        add si,2
        mov [si],ax
        add si,2
        mov [si],ax
        ;------------------
        mov smallblock_type,13 
    JMP rot_final

;*************************************( 13 )**************************************************
    rot_Z2:
        mov si,di
        add si,2
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        add si,2
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;------------------
        mov si,di
        mov ax,1
        add si,2
        mov [si],ax
        add si,2
        mov [si],ax
        ;------------------
        mov si,di
        mov ax,0
        mov [si],ax
        add si,2
        add si,52
        mov [si],ax
        mov smallblock_type,12
    JMP rot_final


    rot_final:
        ; 清除畫面
        mov ax,5h
        int 10h

        call DRAW_BACKGROUND    ; 遊戲畫面背景顏色
        call DRAW_FRAME         ; 遊戲畫面邊框
        call DRAW_SCORE         ; 畫出分數
        call draw_area
    popa
    ret
rotate ENDP

;畫陣列用的
draw_area proc near

    push AX
    push BX
    push CX
    push DX
    mov si, OFFSET block_area1
    mov cursor_row,4h		; 初始化底陣列開頭指標的row
    mov cursor_column, 0Dh	; 初始化底陣列開頭指標的column

    mov cx, 234
    L1:
    mov bx,0
    CMP [si],bx
    JE dzero
    mov bx,1
    CMP [si],bx
    JE done
    mov bx,2
    CMP [si],bx
    JE new
    dzero:
    mov dh, cursor_row
    mov dl, cursor_column
    mov bx, OFFSET CHARZERO
    call POSITION_PRINT_STRING
    JMP L2
    done:
    mov dh, cursor_row
    mov dl, cursor_column
    mov bx,OFFSET CHARONE
    call POSITION_PRINT_STRING
    JMP L2
    new:
    mov bx,OFFSET CHARNEW
    call POSITION_PRINT_STRING
    mov cursor_column, 0Dh
    add cursor_row, 1
    add si,2    ;下一個字元
    JMP DRAW_FINAL
    L2:
    add si,2    ;下一個字元
    add cursor_column, 1
    JMP DRAW_FINAL

    DRAW_FINAL:
    LOOP L1

    pop DX
    pop CX
    pop BX
    pop AX
    RET
draw_area ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 在特定位置印出字串             ;
; Input:                         ;
;         dh: row                ;
;         dl: column             ;
;         bx: address of string  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
POSITION_PRINT_STRING proc near

    push bx     ; 避免 address of string 被改變

    ;;;;;;;;;;;;;;;;;;;;;;
    ; 把游標放在特定位置 ;
    ;;;;;;;;;;;;;;;;;;;;;;
    mov ah, 2
    xor bh, bh  ;圖形模式下bh要設為0
    int 10h

    ;;;;;;;;;;;;
    ; 畫出字串 ;
    ;;;;;;;;;;;;
    mov ah, 9
    pop dx      ; 將address of string 放到dx裡
    int 21h


    RET
POSITION_PRINT_STRING ENDP

screenclr proc 
    pusha   
    mov ax,0600h    ;request scroll screen
    mov cx,0        ;upper left location
    mov dx,184fh    ;lower right location
    int 10h         ;call bios
    mov ah,0        ;request set cursor location(鼠標)
    mov bh,0        ;page number 0
    int 10h         
    popa            
    ret
screenclr endp


;===================================================== !向右和向左會用到! ==========================================================================

calculus_col proc       ;利用smallblock_type決定MAX_COL1~4 供右移使用
    pusha
    mov bx,0                    ;清空暫存,用bx保留該列到第幾行
    mov MAX_COL1,0
    mov MAX_COL2,0
    mov MAX_COL3,0
    mov MAX_COL4,0
    mov R_COL1,0
    mov R_COL2,0
    mov R_COL3,0
    mov R_COL4,0
    mov MAX_ROW1,0
    mov MAX_ROW2,0
    mov MAX_ROW3,0
    mov MAX_ROW4,0
    mov bx,smallblock_type
    CMP bx,1 
    JE cal_square
    CMP bx,2
    JE cal_line
    CMP bx,3
    JE cal_line2
    CMP bx,4
    JE cal_T
    CMP bx,5
    JE cal_T2
    CMP bx,6
    JE cal_T3
    CMP bx,7
    JE cal_T4
    CMP bx,8
    JE cal_L
    CMP bx,9
    JE cal_L2
    CMP bx,10
    JE cal_L3
    CMP bx,11
    JE cal_L4
    CMP bx,12
    JE cal_Z
    CMP bx,13
    JE cal_Z2
    JMP calculus_final
    cal_square:
        mov MAX_COL1,2
        mov MAX_COL2,2
        mov MAX_COL3,0
        mov MAX_COL4,0
        mov R_COL1,2
        mov R_COL2,2
        mov R_COL3,0
        mov R_COL4,0
        mov MAX_ROW1,2
        mov MAX_ROW2,2
        mov MAX_ROW3,0
        mov MAX_ROW4,0
    JMP calculus_final
    cal_line:
        mov MAX_COL1,4
        mov MAX_COL2,0
        mov MAX_COL3,0
        mov MAX_COL4,0
        mov R_COL1,2
        mov R_COL2,0
        mov R_COL3,0
        mov R_COL4,0
        mov MAX_ROW1,1
        mov MAX_ROW2,1
        mov MAX_ROW3,1
        mov MAX_ROW4,1
    JMP calculus_final
    cal_line2:
        mov MAX_COL1,1
        mov MAX_COL2,1
        mov MAX_COL3,1
        mov MAX_COL4,1
        mov R_COL1,2
        mov R_COL2,2
        mov R_COL3,2
        mov R_COL4,2
        mov MAX_ROW1,4
        mov MAX_ROW2,0
        mov MAX_ROW3,0
        mov MAX_ROW4,0
    JMP calculus_final
    cal_T:
        mov MAX_COL1,2
        mov MAX_COL2,3
        mov MAX_COL3,0
        mov MAX_COL4,0
        mov R_COL1,1
        mov R_COL2,2
        mov R_COL3,0
        mov R_COL4,0
        mov MAX_ROW1,2
        mov MAX_ROW2,2
        mov MAX_ROW3,2
        mov MAX_ROW4,0
    JMP calculus_final
    cal_T2:
        mov MAX_COL1,1
        mov MAX_COL2,2
        mov MAX_COL3,1
        mov MAX_COL4,0
        mov R_COL1,2
        mov R_COL2,2
        mov R_COL3,2
        mov R_COL4,0
        mov MAX_ROW1,3
        mov MAX_ROW2,2
        mov MAX_ROW3,0
        mov MAX_ROW4,0
    JMP calculus_final
    cal_T3:
        mov MAX_COL1,3
        mov MAX_COL2,2
        mov MAX_COL3,0
        mov MAX_COL4,0
        mov R_COL1,2
        mov R_COL2,1
        mov R_COL3,0
        mov R_COL4,0
        mov MAX_ROW1,1
        mov MAX_ROW2,2
        mov MAX_ROW3,1
        mov MAX_ROW4,0
    JMP calculus_final
    cal_T4:
        mov MAX_COL1,2
        mov MAX_COL2,2
        mov MAX_COL3,2
        mov MAX_COL4,0
        mov R_COL1,1
        mov R_COL2,2
        mov R_COL3,1
        mov R_COL4,0
        mov MAX_ROW1,2
        mov MAX_ROW2,3
        mov MAX_ROW3,0
        mov MAX_ROW4,0
    JMP calculus_final
    cal_L:
        mov MAX_COL1,1
        mov MAX_COL2,3
        mov MAX_COL3,0
        mov MAX_COL4,0
        mov R_COL1,2
        mov R_COL2,2
        mov R_COL3,0
        mov R_COL4,0
        mov MAX_ROW1,2
        mov MAX_ROW2,2
        mov MAX_ROW3,2
        mov MAX_ROW4,0
    JMP calculus_final
    cal_L2:
        mov MAX_COL1,2
        mov MAX_COL2,1
        mov MAX_COL3,1
        mov MAX_COL4,0
        mov R_COL1,2
        mov R_COL2,2
        mov R_COL3,2
        mov R_COL4,0
        mov MAX_ROW1,3
        mov MAX_ROW2,1
        mov MAX_ROW3,0
        mov MAX_ROW4,0
    JMP calculus_final
    cal_L3:
        mov MAX_COL1,3
        mov MAX_COL2,3
        mov MAX_COL3,0
        mov MAX_COL4,0
        mov R_COL1,2
        mov R_COL2,3
        mov R_COL3,0
        mov R_COL4,0
        mov MAX_ROW1,1
        mov MAX_ROW2,1
        mov MAX_ROW3,2
        mov MAX_ROW4,0
    JMP calculus_final
    cal_L4:
        mov MAX_COL1,2
        mov MAX_COL2,2
        mov MAX_COL3,2
        mov MAX_COL4,0
        mov R_COL1,1
        mov R_COL2,1
        mov R_COL3,2
        mov R_COL4,0
        mov MAX_ROW1,3
        mov MAX_ROW2,3
        mov MAX_ROW3,0
        mov MAX_ROW4,0
    JMP calculus_final
    cal_Z:
        mov MAX_COL1,3
        mov MAX_COL2,2
        mov MAX_COL3,0
        mov MAX_COL4,0
        mov R_COL1,1
        mov R_COL2,2
        mov R_COL3,0
        mov R_COL4,0
        mov MAX_ROW1,2
        mov MAX_ROW2,2
        mov MAX_ROW3,1
        mov MAX_ROW4,0
    JMP calculus_final
    cal_Z2:
        mov MAX_COL1,1
        mov MAX_COL2,2
        mov MAX_COL3,2
        mov MAX_COL4,0
        mov R_COL1,2
        mov R_COL2,2
        mov R_COL3,1
        mov R_COL4,0
        mov MAX_ROW1,2
        mov MAX_ROW2,3
        mov MAX_ROW3,0
        mov MAX_ROW4,0
    JMP calculus_final
    calculus_final:
    popa
    RET
calculus_col endp

; 畫出開始畫面的邊框
DRAW_REC proc near

    push AX
    push BX
    push CX
    push DX

    ;Draw Frame, DX控制Y座標, CX控制X座標
        mov AH, 0CH
        mov AL, 0Fh     ; color

        
        mov CX, 270D
        mov DX, 30      
        UPPER: 
            int 10H
            dec CX
            cmp CX, 50D
        jnz UPPER ;長:200
                        
        mov CX, 270D
        mov DX, 190D     
        LOWER: 
            int 10H
            dec CX
            cmp CX, 50D
        jnz LOWER


        mov CX, 270D
        mov DX, 190D    
        RIGHT: 
            int 10H
            dec DX 
            cmp DX, 30
        jnz RIGHT;寬:180
                        
        mov CX, 50D
        LEFT: 
            int 10H
            inc DX 
            cmp DX, 190     
        jnz  LEFT

    pop DX
    pop CX
    pop BX
    pop AX
    
    RET
DRAW_REC ENDP

; 畫出開始畫面的背景顏色
DRAW_TITLE proc near

    push AX
    push BX
    push CX
    push DX

    mov AH,0Bh
    mov BH, 1   ; 設定調色盤(前景色)
    mov BL, 0   ; 前景色要為0，背景色才有辦法顯示出來
    mov BH, 0   ; 設定背景色
    mov BL, 10  ; color，10: light green
    int 10h

    pop DX
    pop CX
    pop BX
    pop AX

    RET
DRAW_TITLE ENDP

; 畫出開始畫面的標題跟提示字串
DRAW_TITLENAME proc near

    push AX
    push BX
    push CX
    push DX

    ; 移動游標
        mov DL,0Fh  
        mov DH,6h   
        mov BH,0   
        mov AH,02h
        int 10h

    ;標題畫面與選單
        mov DX,OFFSET TitleName 
     mov AH,09H      
        int 21h         
    ;移動游標
          mov DL,0Ah  
        mov DH,13h   
        mov BH,0   
        mov AH,02h
        int 10h
        
        mov DX,OFFSET PressStart 
     mov AH,09H      
        int 21h   

     pop DX
     pop CX
     pop BX
     pop AX
     
     RET
DRAW_TITLENAME ENDP

DRAW_SCORE proc near

    push AX
    push BX
    push CX
    push DX


    ; 移動游標
        mov DL,0Fh  ; column
        mov DH,2h   ; row
        mov BH,0    ; page number Alwayes 0 'draw in the same page'
        mov AH,02h
        int 10h

    ; 畫出分數

        mov DX,OFFSET ScoreIs  ; 顯示 "Score:""
	    mov AH,09H      
        int 21h         ; AH: 09, int 21h : 輸出一個以"$"結尾的字串到顯示器

        mov BL,13       ; Score的字體顏色設定
        mov AL,Score    ; 印出分數
        add AL,'0'
        mov AH,0eh     
        int 10h
        
   pop DX
   pop CX
   pop BX
   pop AX
     
     RET
DRAW_SCORE ENDP

DRAW_BACKGROUND proc near

    push AX
    push BX
    push CX
    push DX
    
    mov AH,0Bh
    mov BH, 1   ; 設定調色盤(前景色)
    mov BL, 0   ; 前景色要為0，背景色才有辦法顯示出來
    mov BH, 0   ; 設定背景色
    mov BL, 0Eh ; color， 14:黃色
    int 10h

    pop DX
    pop CX
    pop BX
    pop AX

    RET
DRAW_BACKGROUND ENDP

DRAW_FRAME proc near

    push AX
    push BX
    push CX
    push DX

    ;Draw Frame, DX控制Y座標, CX控制X座標
        mov AH, 0CH
        mov AL, 0Eh     ; color

        
        mov CX, 200D
        mov DX, 30      
        UPPER_FRAME: 
            int 10H
            dec CX
            cmp CX, 102D
        jnz UPPER_FRAME 
                        
        mov CX, 200D
        mov DX, 176D     
        LOWER_FRAME: 
            int 10H
            dec CX
            cmp CX, 102D
        jnz LOWER_FRAME


        mov CX, 200D
        mov DX, 176D    
        RIGHT_FRAME: 
            int 10H
            dec DX 
            cmp DX, 30
        jnz RIGHT_FRAME
                        
        mov CX, 102D
        LEFT_FRAME: 
            int 10H
            inc DX 
            cmp DX, 176     
        jnz LEFT_FRAME 

    pop DX
    pop CX
    pop BX
    pop AX
    
    RET
DRAW_FRAME ENDP

DRAW_FINALSCORE proc near

    push AX
    push BX
    push CX
    push DX

    ; 移動游標
        mov DL,0Ah      ; column
        mov DH,0Ah       ; row
        mov BH,0   
        mov AH,02h
        int 10h

    
        mov DX,OFFSET FinalScore
        mov AH,09H      
        int 21h          

        mov BL,13       ; Score的字體顏色設定
        mov AL,Score    ; 印出分數
        add AL,'0'
        mov AH,0eh     
        int 10h

     pop DX
     pop CX
     pop BX
     pop AX
     
     RET
DRAW_FINALSCORE ENDP

END main