
; �}�l�e���A�C���e��(�t���}�C)�A���B�k�B�U���A����A�����e���X��(6/9)

;=========================   ��s  6/10 BY ��    ================================

;�W�[data eliminate_lock�Bcurrent_row_number  (�����P�w�|�Ψ�) �A�ܼƦb 47~51 ����

;�W�[ 2 �Ө禡 check_up_eliminate ( �ˬd���S������@�C�i�H���� ) 
;              eliminate_line  ( �ǥ� current_row_number �������w���C�A�ç�ӦC�H�W������U��)

;��Ө禡�b 241 ~323
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

;========== check_up_eliminate �|�Ψ� ==============
    eliminate_lock DW 0     ;����0�N���b�ˬd���C�ëD�����A�������
                            ;����1�h�N���b�ˬd���C�����A�i�H����
    current_row_number DW 0
;================================================

;================ draw_area�Ϊ� =================
    CHARZERO DB ' ','$'
    CHARONE DB '@','$'
    CHARNEW DB 0Dh,0Ah,'$'
;=================================================

;==============================================���k���ʷ|�Ψ�==========================================================
    smallblock_start DW 5   ;�P�_���ʤ����������m�b���}�C�����̥ثe���]�p����q�����}�l(!!!�̥��O0���]�q5�}�l!!!!)
    smallblock_type DW 0    ;!!!!�O�s�{�b������������s��!!!
    address_test DW 0
    MAX_COL1 DW 0   ;�����{�b��������Ϊ��qstart�̻��즳�X�C�X��(0�N��ӦC�S�����,1�N���Ĥ@��,2�N���ĤG���H������)
    MAX_COL2 DW 0   ;�ѥk�����P�_�Ϊ�
    MAX_COL3 DW 0
    MAX_COL4 DW 0
                    ;�ѧP�_�����Ϊ� ( 0�N��ӦC�S�����,1�N��Ĥ@��O�Ū�,2�N��Ĥ@��O������� )
    R_COL1 DW 0
    R_COL2 DW 0
    R_COL3 DW 0
    R_COL4 DW 0
;=======================================================================================================================

;==============================================���k���ʷ|�Ψ�==========================================================
    square_block DW 2,2,1,1,2,1,1           ;������smallblock_type = (1)
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
    block_area1 DW 0,0,0,0,0,1,1,0,0,0,0,1,2 ;�@�C12��(���]�t2),�@18�C
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
    block_area19 DW 2,2,2,2,2,2,2,2,2,2,2,2,2   ;�o�@�C�������!!�u�O���F�U���P�_����Ϊ�

.CODE
main proc  
    mov ax,@DATA
    mov ds,ax
    ; GRAPHICS MODE
        MOV AH, 0
        MOV AL, 5h
        INT 10h

    ;-------------------------------------
     mov smallblock_type,1      ;�]�w�ثe���������
    ;-------------------------------------

    ; �}�l�e��
   DRAWTITLE:
        call DRAW_TITLE         ; �}�l�e���I���C��
        call DRAW_TITLENAME     ; �}�l�e����r
        call DRAW_REC           ; �}�l�e�����
    
    ; ����enter���U
    KEY_PRESSED1:
        mov AH,0
        int 16h
        cmp al,13   ; enter��ascii��13
        jne KEY_PRESSED1
    
   ; �M���e��
   mov ax,5h
   int 10h

   ; �C���e��
   GAMEFRAME:
        call DRAW_BACKGROUND    ; �C���e���I���C��
        call DRAW_FRAME         ; �C���e�����
        call DRAW_SCORE         ; �e�X����
        ; �䧱���H�����ͤ��
        call draw_area          ; �e�X���}�C
        ; ��窺�@��@��U��

    GAMELOOP:
        ; �d����L�w�İϡA����L���y�������ݡA�p�G���hZF = 0�A�S��ZF = 1
        MOV AH,1
        INT 16h
        JZ GAMEFRAME     ; jump if zf = 1�A�]�N�O�S������Q��
        mov AH,0
        int 16h
        ; ��������
        CMP AL, 13            ; �Menter�䰵����A�Ȯɪ��]�w: ��enter�����C��
        JE DRAWFINALESCORE       ; �p�G������G��true�A�h���� DRAWFINALESCORE ����
        call KEY_PRESSED
        JMP GAMELOOP

   ; �����e��
   DRAWFINALESCORE:
       ; �M���e��
        mov ax,5h
        int 10h
        call DRAW_TITLE
        call DRAW_FINALSCORE
   
   ; ����enter���U
   KEY_PRESSED3:
        mov AH,0
        int 16h
        cmp al,13   ; enter��ascii��13
        jne KEY_PRESSED3
    
    END_GAME:
        ; �M���e��
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

    ; ���a�ϥΪ�����

        CMP AH, 75            ; �M���䰵���
        JE PLAYER_LEFTKEY     ; �p�G������G��true�A�h���� PLAYER_LEFTKEY ����

        CMP AH, 77            ; �M�k�䰵���
        JE PLAYER_RIGHTKEY    ; �p�G������G��true�A�h���� PLAYER_RIGHTKEY ����

        CMP AH, 72            ; �M�W�䰵���
        JE PLAYER_UPKEY     ; �p�G������G��true�A�h���� PLAYER_UPKEY ����

        CMP AH, 80            ; �M�U�䰵���
        JE PLAYER_DOWNKEY    ; �p�G������G��true�A�h���� PLAYER_DOWNKEY ����
    
    RET

    ; ���a���U�������檺�{��

        PLAYER_RIGHTKEY:                                    
            MOV key, 4  ;4 MEANS GO RIGHT       
            call do_right                   ;=======================================
            call check_up_eliminate         ;���F���աA����b���k������ˬd
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


;====================================================  �ˬd���S����������C�A�p�G���N�����å[�� (�|�Ψ� eliminate_line �������) ====================================================================

check_up_eliminate PROC             
    pusha
    mov di,OFFSET block_area1       
    mov cx,18                       ;�@���ˬd18�C
    mov current_row_number,0        ;�C���I�scheck_up_eliminate���n���](�~�ા�D�{�b�ˬd�ĴX�C�A�~���D�n�����ĴX�C)
    check_all_row:
        push cx
        mov eliminate_lock,1        ;�w�]�ӦC�i����
        mov cx,12                   ;�@�C12��
        mov si,di                   ;��ӦC�Ĥ@���}��si�x�s,�p�G�ݭn�����~���D�q���̶}�l
        add current_row_number,1    

        check_a_line:
            mov ax,[di]
            CMP ax,0                ;�p�G���@��O0�N�h�]eliminate_lock��0
            JE set_lock_0       
            JMP next_col_check      ;�D0�h�i�~���ˬd�U�@��

            set_lock_0:
                mov eliminate_lock,0

            next_col_check :
                add di,2            ;di���V�U�@��
        loop check_a_line
                                    
        mov bx,eliminate_lock       ;�ǥ� eliminate_lock�ȨM�w�O�_�I�s�����禡 ( �O1�n�I�s�A�O0�N���� )
        CMP bx,1
        JNE next_row_check          ;������1�N���h�ˬd�U�@�C
        call eliminate_line         ;�I�s�����禡 (si���V�ӦC�Ĥ@��)
        
        next_row_check:
            add di,2                ;���j��check_a_line�����ɭ�n���b�C�C�̫�@��(���V2������)�A�A�[2�N�|��U�@�C���Y
        pop cx
    loop check_all_row

    popa
    RET
check_up_eliminate ENDP

;=================�ΨӮ����Y�C (  check_up_eliminate �|�Ψ� �A�[���|�ʨ� Score) ============

eliminate_line PROC                 
    pusha
;---------------------------- step 1  �������F�����C -------------------------

    mov cx,12           ;�@�C��12�� ( �n��o�C��12�檺�ȧ令 0)
    start_eliminate:    ;�}�l�令 0
        mov ax,0
        mov [si],ax
        add si,2
    loop start_eliminate
;-------------------- step 2 ������C�H�W������U�� ( �����������ɦn )-------

    mov di,OFFSET block_area1
                            ;�@��@��U�����
    mov cx,12               ;�@�C��12��A�@12��n�U��
    eliminate_line_change:
        push cx
        mov cx,current_row_number   ;���j��n�]�w�� ( ���b�Q�����C ) ���s�� �� 1 
        dec cx                      ;  (ex.�{�b current_row_number = 13 �N���b������13�C�A�b�o���W���`�@12�C�ݭn�U��) 
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
                                ;�U�������A
        add di,2                ;di�|���V�Ĥ@�C���Y��Adi + 2 ��di����U�@��h�~�����U��
        pop cx
    loop eliminate_line_change  ;����12�泣�U���~�����j��

    add Score,1h                ; !!!�������@�C�[1��!!! ���W�[ SCORE ���� 
    
    popa
    RET
eliminate_line ENDP




;=============================================== �V�k�|�Ψ�( calculus_col�B screenclr (�M�ù��i�H�ΧA�����N)�Bdraw_area  ) =======================================================

do_right PROC 
    pusha
    call calculus_col       ;�Q�Τ�������]�wMAX_COL1~4(�ѧP�w��_�k��)
    mov di,OFFSET block_area1

    mov cx,smallblock_start
    toward_to_start1:
        add di,2
    loop toward_to_start1    ;�j�鵲����di��������}�O�p������_�l��}

    ;- step1 ----�T�{�{�b�o�Ӥp����k��@��O���O1��2,�������O�~��k��-----------

    CMP MAX_COL1,0          ;(�p�G�O0�N��p����Ĥ@�C�C�S��1,���ΧP�_���C�k��O�_��1)
    JE checkrow2         ;���ΧP�_�N���h
    mov si,di               ;��p����}�l��}(�Ĥ@�C�̥�)�s�isi
    mov cx,MAX_COL1         ;���]MAX_COL1=1(�N��̥k���@�b�Ĥ@��)�ҥHCX�]�@,�]��j���ݬO���O1��2
                            ;�P�zMAX_COL1=2 CX=2 ,�]��j�����j��(�Y���ʨ⦸)�ݸ̭��O���O1 or 2,�H������
    address_row1:            
        add si,2            ;�]���OWORD�ҥH�a�}�O�[�G
    loop address_row1
    mov bx,[si]
    CMP bx,0                ;�Ӧ�m���e��0�h�~��P�_�ĤG�C
    JE checkrow2
    JMP RIGHT_FINAL        ;�p�G���e����0(�i��O1��2)��ܮ��䦳�F��Ψ쩳�F,����k��,�����������

    checkrow2:   
    CMP MAX_COL2,0          ;(�p�G�O0�N��p����Ĥ@�C�C�S��1,���ΧP�_���C�k��O�_��1)
    JE checkrow3            ;���ΧP�_�N���h�P�_�U�@�C
    mov si,di               ;di�x�s�p����Ĥ@�C�_�l��}(����ĤG�C���_�l�n + 13*2 )
    add si,26               
    mov cx,MAX_COL2
    address_row2:            
        add si,2            ;�]���OWORD�ҥH�a�}�O�[�G
    loop address_row2
    mov bx,[si]
    CMP bx,0
    JE checkrow3
    JMP RIGHT_FINAL 

    checkrow3:
    CMP MAX_COL3,0
    JE checkrow4
    mov si,di
    add si,52               ;�p����ĤT�C�}�Y��}�Osmallblock_start��}+26*2
    mov cx,MAX_COL3
    address_row3:              
        add si,2            ;�]���OWORD�ҥH�a�}�O�[�G
    loop address_row3   
    mov bx,[si]
    CMP bx,0
    JE checkrow4
    JMP RIGHT_FINAL

    checkrow4:
    CMP MAX_COL4,0          ;�i�H�}�l������(�T�{�|�C���i�H�k��)
    JE Rstart
    mov si,di
    add si,78               ;�p����ĥ|�C�}�Y��}�Osmallblock_start��}+39*2
    mov cx,MAX_COL4
    address_row4:              
        add si,2            ;�]���OWORD�ҥH�a�}�O�[�G
    loop address_row4
    mov bx,[si]
    CMP bx,0
    JE Rstart           ;�T�{�|�C���䳣�O�Ū��N�}�l�k���洫����
    JMP RIGHT_FINAL

    ;- step2 --------------�|�C�ˬd����}�l�k��------------------------------------------------
    Rstart:
    mov ax,smallblock_type  ;�T�w��������ӹ������P�����ʤ����洫�覡
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
    add si,2                  ;0���k��Ĥ@�Ӥ�����}�n�[2(WORD)
    mov cx,2                    
    mov ax,[di]                 
    squareRmove1:             ;���Ĥ@�C����
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop squareRmove1
    mov [di],ax	
    ;���ĤG�C����
    pop di      ;��p����Ĥ@�C���_�l��}��^di
    add di,26   ;��di���V�ĤG�C�_�l
    mov si,di   
    add si,2    ;�ĤG�Ӥ�����}�n�[2(WORD)
    mov cx,2                    
    mov ax,[di]  
    squareRmove2:             
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop squareRmove2
    mov [di],ax
    inc smallblock_start    ;�T�w�k����(�_�l�s���|�h�@)
    JMP RIGHT_FINAL
    ;*************************( 2 )*********************
    line_rchange1:
    mov si,di           ;di�O�Ĥ@�C���_�l
    add si,2            ;si���V�k��@�Ӥ���
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
    push di     ;�O�s�Ĥ@�C�_�l��m���a�}
    mov si,di   ;�u�ݭn�����洫,���ݥΰj��
    add si,2    
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di      ;�٭��}
    push di     ;�A�O�s
    add di,26   ;���V�p����ĤG�C�_�l
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di
    push di     ;�A�O�s
    add di,52   ;���V�p����ĤT�C�_�l
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di
    push di     ;�A�O�s
    add di,78   ;���V�p����ĥ|�C�_�l
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di      ;��PUSH�N�n�O�oPOP
    inc smallblock_start
    JMP RIGHT_FINAL
    ;**********************( 4 )****( T1 )*************
    T_rchange1:
    push di
    add di,2        ;T1���Ĥ@�C�����洫�q�ĤG��}�l(�Ĥ@��S�F��)
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di              ;�٭�di
    add di,26           ;��di���V�ĤG�C���_�l
    mov si,di           
    add si,2            ;si���Vdi�k��@�Ӥ���
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
    add di,4    ;�ĤG�C�q�ĤT��~�O�������(+2 +2)
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
    add di,2        ;�������q�ĤG��}�l
    mov si,di       
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di          ;�٭��}
    push di         ;�A�O�s
    add di,26       ;di���V�p����ĤG�C
    add di,2        ;�ĤG�C�ĤG��
    mov si,di
    add si,2        ;�ĤG�C�ĤT��
    mov ax,[di]     ;�洫����
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    pop di          ;�٭��}
    add di,52       ;���V�ĤT�C
    mov si,di
    add si,2
    mov cx,2        ;�]�j��洫����
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
    mov cx,2        ;�]�j��洫����
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
    mov cx,2        ;�]�j��洫����
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
    mov cx,2        ;�]�j��洫����
    mov ax,[di]
    Z_block2_Rmove2:
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,2
    loop Z_block2_Rmove2
    mov [di],ax
    pop di
    add di,52      ;���V�p����ĤT�C
    add di,2       ;�q�ĤG��~�O�������
    mov si,di
    add si,2
    mov ax,[di]
    mov bx,[si]
    mov [si],ax
    mov [di],bx
    inc smallblock_start
    JMP RIGHT_FINAL

    RIGHT_FINAL:
  
    ; �M���e��
    mov ax,5h
    int 10h

    call DRAW_BACKGROUND    ; �C���e���I���C��
    call DRAW_FRAME         ; �C���e�����
    call DRAW_SCORE         ; �e�X����
    call draw_area          ;�e�X��s�}�C

    popa
    RET
do_right ENDP


;===================================================== �V��( calculus_col�B screenclr (�M�ù��i�H�ΧA�����N)�Bdraw_area  ) ===========================================================

do_left PROC
    pusha
    call calculus_col       ;�Q�Τ�������]�w R_COL1~4(�ѧP�w��_����)
    mov di,OFFSET block_area1
    mov cx,smallblock_start
    toward_to_start2:
        add di,2
    loop toward_to_start2    ;�j�鵲����di��������}�O�p������_�l��}(�p�ߤ���ʨ�,�ݭndi�ɰO�opush�Bpop)

    ;- step 1 ---------------------------------

    CMP R_COL1,0        ; R_COL1~4�i�൥�� (0,1,2,3)
    JE L_checkrow2      ;0�N��ӦC�S������ΧP�_,1�N��ӦC������b�k�@��(�ݧP�_�{�b�����o�榳�S���F��צ�)
    mov si,di           ;2�N���C���榳���,�]���n�T�{���@�榳�S������צ�
                        ;3����S��,�u�X�{�b L3����ĤG�C,�N������o��k�����~�O�������,�]���ݧP�_�{�b�o�檺�k�@�榳�S���F��צ�
                        ;(�]���S���p�u�X�{�b�ˬd�ĤG�C�ɤ~���i��o�ͩҥH�u���ˬd�ĤG�C�ɤ~�S�O�t�P�_ R_COL2 �O�_��3)
    mov cx,R_COL1        
    dec cx              ;R_COL1����2 �N��n�P�����@��O�_����
    lead_to_row1:     ;����1�h��ܭn�P�_�Ӯ�O�_���� �]���~�j��Ƶ���R_COL1��@(3�n�t�~�B�z,���O��)
        sub si,2
    loop lead_to_row1
    mov bx,[si]
    CMP bx,0            ;�O0�N�P�_�U�@�C,���O�s��������
    JE L_checkrow2 
    JMP LEFT_FINAL

    L_checkrow2: 
    CMP R_COL2,0        ; R_COL2�i�൥�� (0,1,2,3)
    JE L_checkrow3      
    CMP R_COL2,3        ;�O3�N�n�S�O�B�z
    JE special_case_for3

    mov si,di
    add si,26
    mov cx,R_COL2
    dec cx
    lead_to_row2:     ;����1�h��ܭn�P�_�Ӯ�O�_���� �]���~�j��Ƶ���R_COL1��@(3 �w�g����t�~�B�z����,���κ�)
        sub si,2
    loop lead_to_row2
    mov bx,[si]
    CMP bx,0
    JE L_checkrow3 
    JMP LEFT_FINAL

    special_case_for3:      ;�B�zR_COL2=3�����p
    mov si,di
    add si,26
    add si,2            ;�k���@��P�_���e
    mov bx,[si]
    CMP bx,0            ;�O0�N�P�_�U�@�C,���O0�N����
    JE L_checkrow3 
    JMP LEFT_FINAL

    L_checkrow3:    ;�P�_�ĤT�C
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

    ;- step 2 �}�l�洫 ---------------------

    L_start:
    mov ax,smallblock_type  ;�T�w��������ӹ������P�����ʤ����洫�覡
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
    add di,2    ;���V�p����̫�@�Ӭ�1�����
    mov si,di
    sub si,2   ;��si���Vdi�e�@��
    mov cx,2    ;�]�w�j��
    mov ax,[di]
    square_block_Lmove1:    ;�洫�Ĥ@�C����
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop square_block_Lmove1
    mov [di],ax
    pop di
    add di,26   ;��di���V�ĤG�C
    add di,2    ;�ĤG��
    mov si,di
    sub si,2    ;si���Vdi���@��
    mov cx,2    ;�]�w�j��
    mov ax,[di]
    square_block_Lmove2:    ;�洫�ĤG�C
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop square_block_Lmove2
    mov [di],ax
    dec smallblock_start    ;�����_�l�s���n��@
    JMP LEFT_FINAL
    ;**********************(2)***********************************
    line_lchange1:
    add di,6     ;��di���V�̥k���@(���T��n�[2*3)
    mov si,di
    sub si,2
    mov cx,4
    mov ax,[di]
    line_block_Lmove1:    ;�洫�Ĥ@�C
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop line_block_Lmove1
    mov [di],ax
    dec smallblock_start    ;�����_�l�s���n��@
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
    add di,26   ;���V�ĤG�C��1
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
    dec smallblock_start    ;�����_�l�s���n��@
    JMP LEFT_FINAL
    ;**********************(4)******( T1 )*************************
    T_lchange1:
    push di
    add di,2    ;�q�Ĥ@�C�ĤG��}�l
    mov si,di   
    sub si,2    ;si���Vdi ���@��
    mov ax,[di]
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    add di,26   ;���V�ĤG�C�_�l
    add di,4    ;���V�ĤG�C�̫�@��1(+2+2)
    mov si,di      
    sub si,2    ;si���Vdi���@��
    mov cx,3
    mov ax,[di]
    T_block1_Lmove2:    ;�洫�ĤG�C
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
    mov ax,[di]     ;�洫�Ĥ@�C
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    push di
    add di,26
    add di,2    ;di���V�ĤG�C�ĤG��
    mov si,di
    sub si,2    ;si���Vdi�e�@��
    mov cx,2
    mov ax,[di]
    T_block2_Lmove2:    ;�洫�ĤG�C
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop T_block2_Lmove2
    mov [di],ax
    pop di
    add di,52       ;di���V�ĤT�C�_�l
    mov si,di
    sub si,2
    mov ax,[di]     ;�洫�ĤT�C
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start
    JMP LEFT_FINAL
    ;**********************(6)********( T3 )***********************
    T_lchange3:
    push di
    add di,4    ;di���V�Ĥ@�C�ĤT��
    mov si,di
    sub si,2
    mov cx,3
    mov ax,[di]
    T_block3_Lmove1:    ;�洫�Ĥ@�C
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop T_block3_Lmove1
    mov [di],ax
    pop di
    add di,26   ;��di���V�ĤG�C
    add di,2    ;�ĤG�C�ĤG��
    mov si,di   
    sub si,2    ;si���Vdi���@��
    mov ax,[di]     ;�洫�ĤG�C
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start
    JMP LEFT_FINAL
    ;**********************(7)********( T4 )***********************
    T_lchange4:
    push di
    add di,2    ;���V�Ĥ@�C�ĤG��
    mov si,di
    sub si,2
    mov ax,[di]     ;�洫�Ĥ@�C
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    push di
    add di,26
    add di,2    ;di ���V�ĤG�C�ĤG��
    mov si,di
    sub si,2
    mov cx,2
    mov ax,[di]
    T_block4_Lmove2:    ;�洫�ĤG�C
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop T_block4_Lmove2
    mov [di],ax
    pop di
    add di,52           ;��di���V�ĤT�C
    add di,2            ;�ĤG��
    mov si,di
    sub si,2
    mov ax,[di]     ;�洫�ĤT�C
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start    ;�����_�l�s���n��@
    JMP LEFT_FINAL

    ;**********************(8)********( L1 )***********************
    L_lchange1:
    push di
    mov si,di
    sub si,2
    mov ax,[di]     ;�洫�Ĥ@�C
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    add di,26       ;di���V�ĤG�C�Ĥ@��
    add di,4        ;�V�k�����
    mov si,di
    sub si,2
    mov cx,3
    mov ax,[di]
    L_block1_Lmove2:    ;�洫�ĤG�C
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
    L_block2_Lmove1:    ;�洫�Ĥ@�C
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop L_block2_Lmove1
    mov [di],ax
    pop di
    push di
    add di,26           ;���V�ĤG�C
    mov si,di
    sub si,2
    mov ax,[di]     ;�洫�ĤG�C
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    add di,52       ;���V�ĤT�C
    mov si,di
    sub si,2
    mov ax,[di]     ;�洫�ĤT�C
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start
    JMP LEFT_FINAL
    ;**********************(10)********( L3 )***********************
    L_lchange3:
    push di
    add di,4    ;���V�Ĥ@�C�ĤT��
    mov si,di
    sub si,2
    mov cx,3
    mov ax,[di]
    L_block3_Lmove1:    ;�洫�Ĥ@�C
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop L_block3_Lmove1
    mov [di],ax
    pop di
    add di,26
    add di,4    ;���V�ĤG�C�ĤT��
    mov si,di
    sub si,2
    mov ax,[di]     ;�洫�ĤG�C
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
    mov ax,[di]     ;�洫�Ĥ@�C
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    push di
    add di,26       ;���V�ĤG�C
    add di,2        ;���V�ĤG��
    mov si,di
    sub si,2
    mov ax,[di]     ;�洫�ĤG�C
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
    L_block4_Lmove3:    ;�洫�ĤT�C
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
    add di,4    ;di���V�Ĥ@�C�ĤT��
    mov si,di
    sub si,2
    mov cx,2
    mov ax,[di]
    Z_block1_Lmove1:    ;�洫�Ĥ@�C
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop Z_block1_Lmove1
    mov [di],ax

    pop di
    add di,26   ;di���V�ĤG�C
    add di,2    ;���V�ĤG��
    mov si,di   
    sub si,2
    mov cx,2
    mov ax,[di]
    Z_block1_Lmove2:    ;�洫�ĤG�C
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
    mov ax,[di]     ;�洫�Ĥ@�C
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    pop di
    push di
    add di,26       ;di���V�ĤG�C
    add di,2
    mov si,di       
    sub si,2
    mov cx,2
    mov ax,[di]
    Z_block2_Lmove2:    ;�洫�ĤG�C
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        sub si,2
    loop Z_block2_Lmove2
    mov [di],ax
    pop di
    add di,52           ;di���V�ĤT�C
    add di,2            ;���V�ĤG��
    mov si,di
    sub si,2            
    mov ax,[di]     ;�洫�ĤT�C
    mov bx,[si]
    mov [di],bx
    mov [si],ax
    dec smallblock_start
    JMP LEFT_FINAL

    LEFT_FINAL:

    ; �M���e��
    mov ax,5h
    int 10h

    call DRAW_BACKGROUND    ; �C���e���I���C��
    call DRAW_FRAME         ; �C���e�����
    call DRAW_SCORE         ; �e�X����
    call draw_area

    popa
    ret
do_left ENDP

;========================================================( ! �U�� ! )======================================================================

fast_down PROC
    pusha
    call calculus_col       ;�Q�Τ�������]�w R_COL1~4(�ѧP�w��_����)
    mov di,OFFSET block_area1
    mov cx,smallblock_start
    toward_to_start3:
        add di,2
    loop toward_to_start3    ;�j�鵲����di��������}�O�p������_�l��}(�p�ߤ���ʨ�,�ݭndi�ɰO�opush�Bpop)

;---------------------------------------------step1 �P�_�p������U�����S����ê------------------------------------------------------

    CMP MAX_ROW1,0      ;���]MAX_ROW1=0�h�N����S�����,�����P�_���S����ê���צ�,�������U�@���ˬd
    JE D_check_colu2    
    mov si,di           
    mov cx,MAX_ROW1
    address_down_colu1:
        add si,26
    loop address_down_colu1
    mov ax,0
    CMP [si],ax
    JE D_check_colu2    ;�S���F��(����Ω��u)�צ�N�h�U�@���ˬd
    JMP Down_final      ;���F��צ�N����


    D_check_colu2:
        CMP MAX_ROW2,0
        JE D_check_colu3 
        mov si,di
        add si,2            ;si����ĤG��
        mov cx,MAX_ROW2
        address_down_colu2:
            add si,26
        loop address_down_colu2
        mov ax,0
        CMP [si],ax
        JE D_check_colu3    ;�S���F��(����Ω��u)�צ�N�h�U�@���ˬd
    JMP Down_final      ;���F��צ�N����


    D_check_colu3 :
        CMP MAX_ROW3,0
        JE D_check_colu4 
        mov si,di           ;di�ȫO�s����_�l��}����
        add si,4            ;si����ĤT��
        mov cx,MAX_ROW3
        address_down_colu3:
            add si,26
        loop address_down_colu3
        mov ax,0
        CMP [si],ax
        JE D_check_colu4    ;�S���F��(����Ω��u)�צ�N�h�U�@���ˬd
    JMP Down_final      ;���F��צ�N����

    D_check_colu4:
        CMP MAX_ROW4,0
        JE D_change_start 
        mov si,di           ;di�ȫO�s����_�l��}����
        add si,6            ;si����ĥ|��
        mov cx,MAX_ROW4
        address_down_colu4:
            add si,26
        loop address_down_colu4
        mov ax,0
        CMP [si],ax
        JE D_change_start    ;�S���F��(����Ω��u)�צ�N�h�U�@���ˬd
    JMP Down_final      ;���F��צ�N����
;---------------------------------- step 2 �����U�� --------------------------------------------------
    D_change_start:
        mov ax,smallblock_type      ;�̷Ӥ�������M�w�洫(�U��)�覡
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
        square_block_down1:    ;�洫�Ĥ@��
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
        square_block_down2:    ;�洫�ĤG��
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
        add si,26       ;�洫�Ĥ@��
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        push di
        add di,2        ;�ĤG��
        mov si,di
        add si,26       ;�洫�ĤG��
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        push di
        add di,4        ;����ĤT��
        mov si,di
        add si,26       ;�洫�ĤT��
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        add di,6
        mov si,di
        add si,26       ;�洫�ĥ|��
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
        line_block2_down1:    ;�洫�ĤG��
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
        add di,26       ;�洫�Ĥ@��(����q�ĤG�C�~�}�l��)
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
        T_block1_down2:    ;�洫�ĤG��
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop T_block1_down2
        mov [di],ax
        pop di
        add di,4            ;�ĤT��
        add di,26           ;�q�ĤG�C����}�l
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
        T_block2_down1:    ;�洫��1��
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop T_block2_down1
        mov [di],ax
        pop di
        add di,2           ;�洫�ĤG��
        add di,26          ;�ĤG�����q�ĤG�C�}�l
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
        mov si,di   ;�Ĥ@��洫
        add si,26
        mov ax,[si]
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        push di
        add di,2    ;�ĤG��
        mov si,di
        add si,26
        mov cx,2
        mov ax,[di]
        T_block3_down2:    ;�洫��2��
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop T_block3_down2
        mov [di],ax
        pop di
        add di,4    ;��ĤT��
        mov si,di   
        add si,26
        mov ax,[si] ;�ĤT��洫
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
        mov ax,[si] ;�Ĥ@��洫
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        add di,2    ;�ĤG��
        mov si,di
        add si,26
        mov cx,3
        mov ax,[di]
        T_block4_down2:    ;�洫��2��
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
    L_block1_down1:    ;�洫��1��
        mov bx,[si]
        mov [si],ax
        mov ax,bx
        add si,26
    loop L_block1_down1
    mov [di],ax
    pop di
    push di
    add di,2           ;di�n����ĤG�檺�ĤG�C
    add di,26
    mov si,di
    add si,26
    mov ax,[si] ;�ĤG��洫
    mov bx,[di]
    mov [si],bx
    mov [di],ax
    pop di
    add di,4           ;di�n����ĤT�檺�ĤG�C
    add di,26
    mov si,di
    add si,26
    mov ax,[si]        ;�ĤT��洫
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
        L_block2_down1:    ;�洫��1��
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop L_block2_down1
        mov [di],ax
        pop di
        add di,2            ;��ĤG��
        mov si,di           
        add si,26
        mov ax,[si]         ;�ĤG��洫
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
        mov ax,[si]         ;�Ĥ@��洫
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        push di
        add di,2            ;�ĤG��
        mov si,di
        add si,26
        mov ax,[si]         ;�ĤG��洫
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        add di,4            ;�ĤT��
        mov si,di
        add si,26
        mov cx,2
        mov ax,[di]
        L_block3_down3:    ;�洫��3��
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
        add di,52       ;di��Ĥ@��ĤT�C
        mov si,di
        add si,26
        mov ax,[si]         ;��1��洫
        mov bx,[di]
        mov [si],bx
        mov [di],ax
        pop di
        add di,2        ;di��ĤG��
        mov si,di
        add si,26
        mov cx,3
        mov ax,[di]
        L_block4_down2:    ;�洫��2��
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
        mov ax,[si]         ;��1��洫
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
        Z_block1_down2:    ;�洫��2��
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
        mov ax,[si]         ;�ĤT��洫
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
        Z_block2_down1:    ;�洫��2��
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
        Z_block2_down2:    ;�洫��2��
            mov bx,[si]
            mov [si],ax
            mov ax,bx
            add si,26
        loop Z_block2_down2
        mov [di],ax
        add smallblock_start,13
    JMP Down_final

   

    Down_final:
        ; �M���e��
        mov ax,5h
        int 10h

        call DRAW_BACKGROUND    ; �C���e���I���C��
        call DRAW_FRAME         ; �C���e�����
        call DRAW_SCORE         ; �e�X����
        call draw_area
    popa
    ret
fast_down ENDP


;======================================== (   !  ���� !     ) ==========================================================================
rotate PROC             ;��ƪ����Τ�������P�_�O�_�����,�H�α���᪺���G
    pusha
    mov di,OFFSET block_area1
    mov cx,smallblock_start
    toward_to_start4:
        add di,2            ;�Ndi���V�p����{�b���_�I(��K�P�_��_����)
    loop toward_to_start4    

    mov ax,smallblock_type
    CMP ax,1                ;��������α���
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
        check_line1_rot:        ;�T�{�����n�쪺��m�O�Ū��~�����,�_�h��������
            add si,26       
            mov ax,[si]
            CMP ax,0
            JNE rot_final
        loop check_line1_rot
                                ;�T�{�i�H�����}�l�ܧ����Ϊ��κ����s��
        mov si,di
        mov cx,3
        line1_change_add:       ;�s�W1���ܤ���Ϊ�
            add si,26
            mov ax,1
            mov [si],ax
        loop line1_change_add
        mov si,di
        mov cx,3
        line1_change_delete:       ;�R��1���ܤ���Ϊ�
            add si,2
            mov ax,0
            mov [si],ax
        loop line1_change_delete
        mov smallblock_type,3       ;�ק�{�b��������s��
        JMP rot_final
;*************************************( 3 )**************************************************
    rot_line2:
        mov si,di
        mov cx,3
        check_line2_rot:        ;�T�{�����n�쪺��m�O�Ū��~�����,�_�h��������
            add si,2       
            mov ax,[si]
            CMP ax,0
            JNE rot_final
        loop check_line2_rot
                                ;�}�l����
        mov si,di
        mov cx,3
        line2_change_delete:       ;�R��1���ܤ���Ϊ�
            add si,26
            mov ax,0
            mov [si],ax
        loop line2_change_delete
        mov si,di
        mov cx,3
        line2_change_add:     ;�s�W1���ܤ���Ϊ�
            add si,2
            mov ax,1
            mov [si],ax
        loop line2_change_add
        mov smallblock_type,2
    JMP rot_final
;*************************************( 4 )**************************************************
    rot_T1:
        mov si,di
        mov ax,[si]     ;�Ĥ@�C�Ĥ@��
        CMP ax,0
        JNE rot_final
        mov si,di
        add si,52       ;�ĤT�C�Ĥ@��
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;-----------------�P�_���O0�N�}�l�i�H�ܧ���
        mov si,di
        mov ax,1
        mov [si],ax         ;�[�W�s���
        add si,52
        mov [si],ax
        ;-----------------
        mov si,di
        add si,2            ;�����¤��
        mov ax,0
        mov [si],ax
        mov si,di
        add si,4        ;�ĤG�C�ĤG��
        add si,26       
        mov [si],ax
        mov smallblock_type,5   ;����������s��
    JMP rot_final
;*************************************( 5 )**************************************************
    rot_T2:
        mov si,di
        mov cx,2
        check_T2_rot:        ;�T�{�����n�쪺��m�O�Ū��~�����,�_�h��������
            add si,2       
            mov ax,[si]
            CMP ax,0
            JNE rot_final
        loop check_T2_rot
        ;�ܧ���
        mov si,di
        mov cx,2
        T2_change_add:      ;�[�s���
            add si,2
            mov ax,1
            mov [si],ax
        loop T2_change_add
        mov si,di
        mov cx,2
        T2_change_delete:      ;�R�¤��
            add si,26
            mov ax,0
            mov [si],ax
        loop T2_change_delete
        mov smallblock_type,6  
    JMP rot_final
;*************************************( 6 )**************************************************
    rot_T3:
        mov si,di
        add si,26               ;�T�{�ĤG�C�Ĥ@��
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        mov si,di
        add si,2                ;�ĤT�C�ĤG��
        add si,52
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;---------------------
        mov si,di
        mov ax,0                ;�R���¤��
        mov [si],ax
        add si,4    
        mov [si],ax
        ;---------------------
        mov si,di
        mov ax,1                ;�s�W�s���
        add si,26               ;�ĤG�C�Ĥ@��
        mov [si],ax
        mov si,di
        add si,2                ;�ĤT�C�ĤG��
        add si,52
        mov [si],ax
        mov smallblock_type,7  
    JMP rot_final
;*************************************( 7 )**************************************************
    rot_T4:
        mov si,di
        add si,4        ;�ĤT��
        add si,26       ;�ĤG�C
        mov ax,[si]
        CMP ax,0
        ;------------------
        mov si,di       ;�s�W���
        add si,4        ;�ĤT��
        add si,26       ;�ĤG�C
        mov ax,1
        mov [si],ax
        ;------------------
        mov si,di
        mov ax,0        ;�R���
        add si,2        ;�ĤG��
        add si,52       ;�ĤT�C
        mov [si],ax
        ;-----------------
        mov smallblock_type,4 
    JMP rot_final
;*************************************( 8 )**************************************************
    rot_L1:
        mov si,di
        add si,2        ;�Ĥ@�C�ĤG��
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        mov si,di
        add si,52       ;�ĤT�C�Ĥ@��
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;------------------
        mov si,di
        mov ax,1        ;�s�W���
        add si,2        ;�Ĥ@�C�ĤG��
        mov [si],ax
        mov si,di
        add si,52       ;�ĤT�C�Ĥ@��
        mov [si],ax
        ;------------------
        mov si,di
        mov ax,0        ;�R���h�l�¤��
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
        add si,4        ;��ĤT��
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        add si,26       ;�ĤT��ĤG�C
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;--------------
        mov si,di
        mov ax,1        ;�s�W���
        add si,4
        mov [si],ax
        add si,26
        mov [si],ax
        ;--------------
        mov si,di
        mov ax,0        ;�R���
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
        add si,52   ;�Ĥ@��ĤT�C
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        mov si,di
        add si,2    ;�ĤG��
        add si,26   ;�ĤG�C
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        add si,26   ;�ĤG��ĤT�C
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;----------------
        mov si,di
        mov ax,1        ;�s�W���
        add si,52
        mov [si],ax
        mov si,di
        add si,2    ;�ĤG��
        add si,26   ;�ĤG�C
        mov [si],ax
        add si,26    ;�ĤG��ĤT�C
        mov [si],ax
        ;----------------
        mov si,di
        mov ax,0       ;�R���h�l�¤��
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
        add si,4        ;�ĤT��
        add si,26       ;�ĤG�C
        mov ax,[si]
        CMP ax,0
        JNE rot_final
        ;------------------
        mov si,di
        mov ax,1        ;�s�W
        mov [si],ax
        add si,26
        mov [si],ax
        mov si,di
        add si,4        ;�ĤT��
        add si,26       ;�ĤG�C
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
        ; �M���e��
        mov ax,5h
        int 10h

        call DRAW_BACKGROUND    ; �C���e���I���C��
        call DRAW_FRAME         ; �C���e�����
        call DRAW_SCORE         ; �e�X����
        call draw_area
    popa
    ret
rotate ENDP

;�e�}�C�Ϊ�
draw_area proc near

    push AX
    push BX
    push CX
    push DX
    mov si, OFFSET block_area1
    mov cursor_row,4h		; ��l�Ʃ��}�C�}�Y���Ъ�row
    mov cursor_column, 0Dh	; ��l�Ʃ��}�C�}�Y���Ъ�column

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
    add si,2    ;�U�@�Ӧr��
    JMP DRAW_FINAL
    L2:
    add si,2    ;�U�@�Ӧr��
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
; �b�S�w��m�L�X�r��             ;
; Input:                         ;
;         dh: row                ;
;         dl: column             ;
;         bx: address of string  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
POSITION_PRINT_STRING proc near

    push bx     ; �קK address of string �Q����

    ;;;;;;;;;;;;;;;;;;;;;;
    ; ���Щ�b�S�w��m ;
    ;;;;;;;;;;;;;;;;;;;;;;
    mov ah, 2
    xor bh, bh  ;�ϧμҦ��Ubh�n�]��0
    int 10h

    ;;;;;;;;;;;;
    ; �e�X�r�� ;
    ;;;;;;;;;;;;
    mov ah, 9
    pop dx      ; �Naddress of string ���dx��
    int 21h


    RET
POSITION_PRINT_STRING ENDP

screenclr proc 
    pusha   
    mov ax,0600h    ;request scroll screen
    mov cx,0        ;upper left location
    mov dx,184fh    ;lower right location
    int 10h         ;call bios
    mov ah,0        ;request set cursor location(����)
    mov bh,0        ;page number 0
    int 10h         
    popa            
    ret
screenclr endp


;===================================================== !�V�k�M�V���|�Ψ�! ==========================================================================

calculus_col proc       ;�Q��smallblock_type�M�wMAX_COL1~4 �ѥk���ϥ�
    pusha
    mov bx,0                    ;�M�żȦs,��bx�O�d�ӦC��ĴX��
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

; �e�X�}�l�e�������
DRAW_REC proc near

    push AX
    push BX
    push CX
    push DX

    ;Draw Frame, DX����Y�y��, CX����X�y��
        mov AH, 0CH
        mov AL, 0Fh     ; color

        
        mov CX, 270D
        mov DX, 30      
        UPPER: 
            int 10H
            dec CX
            cmp CX, 50D
        jnz UPPER ;��:200
                        
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
        jnz RIGHT;�e:180
                        
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

; �e�X�}�l�e�����I���C��
DRAW_TITLE proc near

    push AX
    push BX
    push CX
    push DX

    mov AH,0Bh
    mov BH, 1   ; �]�w�զ�L(�e����)
    mov BL, 0   ; �e����n��0�A�I����~����k��ܥX��
    mov BH, 0   ; �]�w�I����
    mov BL, 10  ; color�A10: light green
    int 10h

    pop DX
    pop CX
    pop BX
    pop AX

    RET
DRAW_TITLE ENDP

; �e�X�}�l�e�������D�򴣥ܦr��
DRAW_TITLENAME proc near

    push AX
    push BX
    push CX
    push DX

    ; ���ʴ��
        mov DL,0Fh  
        mov DH,6h   
        mov BH,0   
        mov AH,02h
        int 10h

    ;���D�e���P���
        mov DX,OFFSET TitleName 
     mov AH,09H      
        int 21h         
    ;���ʴ��
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


    ; ���ʴ��
        mov DL,0Fh  ; column
        mov DH,2h   ; row
        mov BH,0    ; page number Alwayes 0 'draw in the same page'
        mov AH,02h
        int 10h

    ; �e�X����

        mov DX,OFFSET ScoreIs  ; ��� "Score:""
	    mov AH,09H      
        int 21h         ; AH: 09, int 21h : ��X�@�ӥH"$"�������r�����ܾ�

        mov BL,13       ; Score���r���C��]�w
        mov AL,Score    ; �L�X����
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
    mov BH, 1   ; �]�w�զ�L(�e����)
    mov BL, 0   ; �e����n��0�A�I����~����k��ܥX��
    mov BH, 0   ; �]�w�I����
    mov BL, 0Eh ; color�A 14:����
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

    ;Draw Frame, DX����Y�y��, CX����X�y��
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

    ; ���ʴ��
        mov DL,0Ah      ; column
        mov DH,0Ah       ; row
        mov BH,0   
        mov AH,02h
        int 10h

    
        mov DX,OFFSET FinalScore
        mov AH,09H      
        int 21h          

        mov BL,13       ; Score���r���C��]�w
        mov AL,Score    ; �L�X����
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