;====================================== ��।������ ��魮�⭮�� ०���
DEFINE_POW_MODE:
		mov	DPTR, #LAMBDA_THR_LINE_ADDR	; �࠭�� ���� �������筮�� ०��� X - ������,	��/��� F - ��������� ���ᥫ�, %
		mov	A, RPM_RT_32	; �������� �窠 �� ����⠬, ����⮢����� �� 32
		movc	A, @A+DPTR
		mov	R1, THR_CODE	; ��������� ���ᥫ�
		clr	C
		subb	A, R1
		mov	RAM_2B.2, C	; 0 - �ਧ��� �몫�祭�� �����⥫�
					; 1 - �ਧ��� ��
					; 2 - ��魮�⭮� �����饭��
					; 3 - �����஢�� ⮯���������
					; 4 - �ਧ��� ���� ॣ㫨஢���� �� ��
					; 5 - �ਧ��� ���������	� ���� ��⮭�樨
					; 6 - �ਧ��� ࠧ�襭�� �த㢪� ���ࡥ�
					; 7 - �ਧ��� ��࠭���� १���⮢ ���祭�� �� ���稪� ��᫮த�
		ret			
		
		
;================================== ����� ALF ��� ०��� ��� ����㧪��
CALC_ALF:
		mov		DPTR, #SOFT_FLAGS_ADDR
		clr		A
		movc	A, @A+DPTR
		jb		ACC.1, CALC_ALF_PRESSURE
		GET_THR
		mov		R3, A
		mov		DPTR, #ALF_BASE_ADDR
		jmp		CALC_ALF_1

CALC_ALF_PRESSURE:
		mov		DPTR, #PRESSURE
		movx	A, @DPTR
		mov		R3, A
		mov		DPTR, #ALF_PRESSURE_ADDR

CALC_ALF_1:
		mov		R2, RPM_RT
		call	Get3DCell
		ret

;================================== ����� ���
CALC_UOZ:
		mov		DPTR, #SOFT_FLAGS_ADDR
		clr		A
		movc	A, @A+DPTR
		jb		ACC.1, CALC_UOZ_PRESSURE
		GET_THR
		mov		R3, A
		mov		DPTR, #UOZ_BASE_ADDR
		jmp		CALC_UOZ_1

CALC_UOZ_PRESSURE:
		mov		DPTR, #PRESSURE
		movx	A, @DPTR
		mov		R3, A
		mov		DPTR, #UOZ_PRESSURE_ADDR

CALC_UOZ_1:
		mov		R2, RPM_RT
		call	Get3DCell
		mov		B, A		; B-Register
		mov		DPTR, #0F802h
		movx	A, @DPTR
		xch		A, B		; B-Register
		clr		C
		subb	A, B		; B-Register
		mov		UOZXX_1, A	; ��� �� ��
		ret
		
		
CALC_EMERGENCY_ALF_UOZ:
		mov	DPTR, #5FFFh	; ���⠢ ᬥ� ���਩��� ०���,
		clr	A
		movc	A, @A+DPTR
		mov	ALF_1, A
		
		mov	A, DEV_FLAGS	; �����	�ࠢ����� �ᯮ���⥫�묨 ��堭������
		anl	A, #4
		jnz	CE_EXIT
		
		mov	DPTR, #7877h	; ��� �� ���ਨ ���� X	- ������ ���������, ��/��� Y -	�������� ����������,$0A��/横� F - ���,	��.�.�.�.
		mov     R2, RPM_RT
		mov     R3, GBC_RT
		call	Get3DCell
		mov	B, A		; B-Register		
		mov	DPTR, #0F802h	; ���४�� ���	�� ��
		movx	A, @DPTR
		xch	A, B		; B-Register
		clr	C
		subb	A, B		; B-Register
		mov	UOZXX_1, A	; ��� �� ��
CE_EXIT:
		ret

		
;=================================== ���樠������ 䫠���
SOFT_FLAGS_INIT:
		mov	DPTR, #6051h	; Hardware flags
		clr	A
		movc	A, @A+DPTR
		mov	Hardware, A
		mov	DPTR, #6052h	; Software flags
		clr	A
		movc	A, @A+DPTR
		mov	Options, A
		
		mov		DPTR, #SOFT_FLAGS_ADDR
		clr		A
		movc	A, @A+DPTR
		mov		C, ACC.0
		mov		Options.0, C	;ࠡ���� ��� ���� (��� ��� ���ᥫ�)
		mov		DPTR, #PART_FLAGS_ADDR
		clr		A
		movc	A, @A+DPTR
		mov		C, ACC.1
		mov		Options.5, C	;����୮-��ࠫ����� ०�� ��� ����襪 ������ 7.2 (2111)
		ret

;===================================== ���樠������ ��᫥ RESET
RESET_INIT:
		clr		IEN0.7
		mov	SP, #SP_VALUE
		call	SOFT_FLAGS_INIT
		mov		DPTR, #PART_FLAGS_ADDR
		clr		A
		movc	A, @A+DPTR
		jnb		ACC.0, OnlineInitExit ; if bit set, then olt ecu
RESET_OLT_INIT:
		setb	P3.2		; Port 3 (PDIR=0)
					; P3.2 - OltPin	   (��室)
		mov	A, IP0		; Interrupt Priority Register 0
					; 7 - OWDS;
					; 6 - WDTS ����� �� watchdog timer
		jb	ACC.6, OnlineInitExit ;	Accumulator
		orl	P6, #1		; �롮�	����� 64�� 䫥�� ���
		orl	IP1, #10000000b	; Interrupt Priority Register 1
		mov	P3, #111001b	; Port 3 (PDIR=0)
					; #111001
					; P3.0 - KLINE RxD (�室)
					; P3.1 - KLINE TxD (��室)
					; P3.2 - OltPin	   (��室)
					; P3.3 - �������� ���祩 ����襪 ��������� (�室) (ࠡ�⠥� �	�9.6)
					; �3.4 - ���稪 �����ᮢ � 䨫��� ��	(�室)
					; �3.5 - ���稪	᪮��� (�室)
					; �3.6 - ������	�� ���譥� ��� WR(��室)
					; �3.7 - �⥭��	���譥�� ��� RD(��室)
		orl	IP1, #10000000b	; Interrupt Priority Register 1
		mov	P6, #11010000b	; Port 6 (PDIR=0)
					; #11010000
					; P6.0 - �15 - ���᭠�	���� 䫥�� ��� (�롮� ����� 64	��) (��室)
					; �6.1 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Phase 1 (��室)
					; �6.2 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Phase 2 (��室)
					; �6.3 - ��� WE# = Write enable	䫥�� ��� (��室)
					; P6.4 - ��� 57	ࠧꥬ�	��� (�室 ����஢���� ��ਠ�⮢	(��樮�)) (�室)
					; P6.5 - ���� �ࠢ����� 蠣��� �����⥫�� ���� I10,I11,I20,I21 (��室)
					; �6.6 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Err2 (�室)
					; �6.7 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Err1 (�室)

code_E71E:				; CODE XREF: OnlineInit+37j
		mov	DPTR, #0

code_E721:				; CODE XREF: OnlineInit+2Cj
		clr	A		; ����஢���� ��� �� ������ ��� (��� ������୨��)
		movc	A, @A+DPTR
		movx	@DPTR, A
		mov	A, DPL		; Data Pointer,	Low Byte
		jnz	code_E72C
		setb	IEN0.6		; Interrupt Enable Register 0
		setb	IEN1.6		; Interrupt Enable Register 1

code_E72C:				; CODE XREF: OnlineInit+23j
		inc	DPTR
		mov	A, DPH		; Data Pointer,	High Byte
		cjne	A, #0F4h, code_E721 ; '�' ; ����஢���� ��� �� ������ ��� (��� ������୨��)
		mov	A, P6		; Port 6 (PDIR=0)
					; #11010000
					; P6.0 - �15 - ���᭠�	���� 䫥�� ��� (�롮� ����� 64	��) (��室)
					; �6.1 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Phase 1 (��室)
					; �6.2 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Phase 2 (��室)
					; �6.3 - ��� WE# = Write enable	䫥�� ��� (��室)
					; P6.4 - ��� 57	ࠧꥬ�	��� (�室 ����஢���� ��ਠ�⮢	(��樮�)) (�室)
					; P6.5 - ���� �ࠢ����� 蠣��� �����⥫�� ���� I10,I11,I20,I21 (��室)
					; �6.6 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Err2 (�室)
					; �6.7 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Err1 (�室)
		jnb	ACC.0, code_E73C ; Accumulator
		anl	P6, #11111110b	; Port 6 (PDIR=0)
					; #11010000
					; P6.0 - �15 - ���᭠�	���� 䫥�� ��� (�롮� ����� 64	��) (��室)
					; �6.1 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Phase 1 (��室)
					; �6.2 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Phase 2 (��室)
					; �6.3 - ��� WE# = Write enable	䫥�� ��� (��室)
					; P6.4 - ��� 57	ࠧꥬ�	��� (�室 ����஢���� ��ਠ�⮢	(��樮�)) (�室)
					; P6.5 - ���� �ࠢ����� 蠣��� �����⥫�� ���� I10,I11,I20,I21 (��室)
					; �6.6 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Err2 (�室)
					; �6.7 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Err1 (�室)
		sjmp	code_E71E
; ---------------------------------------------------------------------------

code_E73C:				; CODE XREF: OnlineInit+31j
		orl	P6, #1		; Port 6 (PDIR=0)
					; #11010000
					; P6.0 - �15 - ���᭠�	���� 䫥�� ��� (�롮� ����� 64	��) (��室)
					; �6.1 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Phase 1 (��室)
					; �6.2 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Phase 2 (��室)
					; �6.3 - ��� WE# = Write enable	䫥�� ��� (��室)
					; P6.4 - ��� 57	ࠧꥬ�	��� (�室 ����஢���� ��ਠ�⮢	(��樮�)) (�室)
					; P6.5 - ���� �ࠢ����� 蠣��� �����⥫�� ���� I10,I11,I20,I21 (��室)
					; �6.6 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Err2 (�室)
					; �6.7 - ���� �ࠢ����� 蠣��� �����⥫�� ��� Err1 (�室)
		setb	IEN0.6		; Interrupt Enable Register 0
		setb	IEN1.6		; Interrupt Enable Register 1
		mov	DPTR, #0F3F8h
		lcall	ReadDS2401
		setb	IEN0.6		; Interrupt Enable Register 0
		setb	IEN1.6		; Interrupt Enable Register 1
		jnc	OnlineInitExit
		mov	DPTR, #0F3F8h
		clr	A
		mov	B, #8		; B-Register

DS2401Clear:				; CODE XREF: OnlineInit+55j
		movx	@DPTR, A
		inc	DPTR
		djnz	B, DS2401Clear	; B-Register

OnlineInitExit:				; CODE XREF: OnlineInit+9j
					; OnlineInit+4Aj
		jmp	Init
		

;===================================== ���䨣��஢���� ���⮢ ��室���� �ࠩ��� TLE6240
INIT_TLE6240:
		mov		DPTR, #PART_FLAGS_ADDR
		clr		A
		movc	A, @A+DPTR
		jnb		ACC.2, NOT_KALINA 			;�஢���� ������ (५� ���⨫��� � ��)
		
		mov	DPTR, #0F9A7h
		movx	A, @DPTR
		mov		B, A
		setb	ACC.3
		movx	@DPTR, A
		
		mov	DPTR, #0F9A8h
		movx	A, @DPTR
		mov		C, B.3
		mov		ACC.5, C
		mov		C, B.7
		mov		ACC.7, C
		movx	@DPTR, A
		
NOT_KALINA:
		anl	P9, #7Fh	; Port 9 (PDIR=0)
		mov	A, #0F0h ; '�'
		call	TLE6240_SEND_SPI
		mov	DPTR, #0F9A7h
		movx	A, @DPTR
		call	TLE6240_SEND_SPI
		orl	P9, #80h	; Port 9 (PDIR=0)
		anl	P9, #7Fh	; Port 9 (PDIR=0)
		mov	A, #0FFh
		call	TLE6240_SEND_SPI
		mov	DPTR, #0F9A8h
		movx	A, @DPTR
		call	TLE6240_SEND_SPI
		orl	P9, #80h	; Port 9 (PDIR=0)
		ret

TLE6240_SEND_SPI:
		mov	R3, #8

code_B172:				; CODE XREF: code_B170+9j
		rlc	A
		mov	P5.3, C		; Port 5 (PDIR=0)
		setb	P5.4		; Port 5 (PDIR=0)
		clr	P5.4		; Port 5 (PDIR=0)
		djnz	R3, code_B172
		ret
		
;==========================    ���. �㭪樨 ����� CE   ===================
CE_FUNC:
		mov	DPTR, #CE_FUNC_STATE
		movx	A, @DPTR
		mov		B, A
		mov	DPTR, #CE_RPM1_ADDR   ;����� ������樨 ���窨 ������ CE
		clr	A
		movc	A, @A+DPTR
		jb	ACC.7, CE_TWAT_TEST ; Accumulator
		mov	R0, A
		mov	DPTR, #CE_RPM2_ADDR    ;����� ��襭�� CE
		clr	A
		movc	A, @A+DPTR
		jb	ACC.7, CE_TWAT_TEST ; Accumulator
		mov	R1, A
		mov	DPTR, #FUEL_CUTOFF_RPM
		movx	A, @DPTR
		clr	C
		subb	A, R0
		mov	R2, A		; B-Register
		clr	C
		subb	A, RPM
		jc	CE_RPM_SET_EXIT
		mov	A, R2		; B-Register
		clr	C
		subb	A, R1
		clr	C
		subb	A, RPM
		anl		C, B.7
		jc		CE_RPM_SET_EXIT

CE_TWAT_TEST:
		clr		B.7
		mov	DPTR, #CE_TWAT_ERROR_ADDR  ; ���祭�� ��ॣ�⮣� �����⥫�
		clr	A
		movc	A, @A+DPTR
		clr	C
		subb	A, TWAT	; ����饥 ���祭�� ����	(⥬������ �����⥫�)
		jc	CE_TWAT_ERROR
		mov		B, #0
		jmp CE_FUNC_EXIT
		
CE_TWAT_ERROR:
		mov		A, B
		anl		A, #3Fh
		jz	CE_TWAT_INVERT
		dec		B
		setb	C
		jmp		CE_FUNC_EXIT

CE_TWAT_INVERT:
		jb		B.6, CE_TWAT_HIDE
		mov		B, #54h
		setb	C
		jmp		CE_FUNC_EXIT

CE_TWAT_HIDE:
		mov		B, #0Ah
		clr		C
		jmp		CE_FUNC_EXIT

CE_RPM_SET_EXIT:
		mov		B, #80h

CE_FUNC_EXIT:
		mov		A, B
		mov		DPTR, #CE_FUNC_STATE
		movx	@DPTR, A
		mov		RAM_2E.0, C
		ret
		

$INCLUDE(j7es_dad.asm)
