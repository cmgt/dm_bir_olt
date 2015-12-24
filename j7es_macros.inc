GET_THR MACRO
		mov	DPTR, #THR_CURRENT
		movx	A, @DPTR
		mov	DPTR, #THR_MAP_ADDR
		movc	A, @A+DPTR
ENDM

FILL_TWAT_ARGS MACRO
		mov		DPTR, #0F887h
		movx	A, @DPTR
		mov		R2, A
		mov		DPTR, #0F888h
		movx	A, @DPTR
		mov		R3, A
ENDM

;Инициализация нулями
INIT_DB_ZERO MACRO COUNT_BYTE
REPT COUNT_BYTE
	db	0
ENDM
ENDM

ALIGN_NOP MACRO ADDRESS
jmp ADDRESS
REPT ADDRESS - $
	db	0
ENDM
ENDM

FILL_NOP MACRO COUNT_NOP
REPT COUNT_NOP
	nop
ENDM
ENDM

;======================================================= Полный расчет GBC по ДАД
CALC_DAD_GBC_VALUE MACRO
		call	CALC_DAD_VALUE
		GET_THR
		mov		R3, A
		mov		R2, RPM_RT
		mov		DPTR, #DAD_KGBC_ADDR
		call	Get3DCell
		mov	B, A
		mov	DPTR, #FCHARGE_GBC_VALUE_ADDR
		movx	A, @DPTR
		mov	R0, A
		inc	DPL
		movx	A, @DPTR
		mov	R1, A
		mov	A, B
		add	A, #40h
		mov	B, A
		clr	A
		addc	A, #0
		mov	MD0, B
		mov	MD4, R0
		mov	MD1, A
		mov	MD5, R1
		FILL_NOP 4
		mov	A, MD0
		mov	R0, MD1
		mov	R1, MD2
		mov	A, MD3
		clr	C
		mov	A, R1
		rrc	A
		mov	R1, A
		mov	A, R0
		rrc	A
		mov	R0, A

		;============= Фильтрация GBC
		mov	DPTR, #DAD_FILTER_XX_ADDR	; Коэффициент фильтра для ХХ,
		jb	RAM_2B.1, CALC_DAD_GBC_VALUE_1
		mov	DPTR, #DAD_FILTER_ADDR	; Коэффициент фильтра в	рабочем	режиме,
CALC_DAD_GBC_VALUE_1:
		clr	A
		movc	A, @A+DPTR
		mov	B, A		; B-Register
		mov	DPTR, #0F82Ch	; GBC
		movx	A, @DPTR
		mov	R2, A
		inc	DPL		
		movx	A, @DPTR
		mov	R3, A
		call	SUB_R0R1_R2R3
		call	MUL_R0R1_NEG_B
		call	ADD_R0R1_R2R3
		mov	A, R1
		movx	@DPTR, A
		dec	DPL
		mov	A, R0
		movx	@DPTR, A
		; ============ Конец фильтрации
		
		mov	DPTR, #0F82Eh	; GBC 
		mov	A, R0
		movx	@DPTR, A
		inc	DPL		
		mov	A, R1
		movx	@DPTR, A
		
		mov	A, RPM
		jnz	CALC_DAD_GBC_VALUE_2
		mov	R0, #0
		mov	R1, #0
		jmp	CALC_DAD_GBC_VALUE_3

CALC_DAD_GBC_VALUE_2:
		mov	MD0, #0E8h 
		mov	MD4, R0
		mov	MD1, #3
		mov	MD5, R1
		FILL_NOP 4
		mov	R0, MD0
		mov	R1, MD1
		mov	R2, MD2
		mov	R3, MD3
		clr	IEN0.7
		mov	A, RAM_38
		mov	B, RAM_39
		setb	IEN0.7
		mov	MD0, R0
		mov	MD1, R1
		mov	MD2, R2
		mov	MD3, R3
		mov	MD4, A
		mov	MD5, B
		FILL_NOP 6
		mov	R0, MD0
		mov	R1, MD1
		mov	A, MD2
		mov	A, MD3
		mov	A, MD4
		mov	A, MD5

CALC_DAD_GBC_VALUE_3:
		mov	DPTR, #0F808h
		mov	A, R0
		movx	@DPTR, A
		inc	DPL
		mov	A, R1
		movx	@DPTR, A
ENDM

CALC_DAD_DIAG MACRO
		jnb	Options.0, CALC_DAD_DIAG_EXIT
		jnb	RAM_2B.0, CALL_DAD_DIAG
		mov	B, #3
		lcall	ReadADC
		mov	DPTR, #0F80Ch
		movx	@DPTR, A
		
CALL_CALC_COARSE_DAD_VALUE:
		clr	RAM_28.4
		lcall	CALC_COARSE_DAD_VALUE
		jb	RAM_28.4, CALL_CALC_COARSE_DAD_VALUE

CALL_DAD_DIAG:				; CODE XREF: RESET_0+840j
		call	DAD_DIAG
CALC_DAD_DIAG_EXIT:
ENDM

;===================================  Скорость обеднения или обогащения смеси ========================
ALF_CHANGE_LIMIT MACRO
code_B067:
		mov	DPTR, #0F833h
		movx	A, @DPTR
		mov	B, A
		clr	C
		subb	A, ALF_1
		jz	ALF_CHANGE_LIMIT_6
		jnc	ALF_CHANGE_LIMIT_2
		mov	DPTR, #6077h	; Макс.	скорость обеднения смеси, 1/сек.
		clr	A
		movc	A, @A+DPTR
		add	A, B
		cjne	A, ALF_1, ALF_CHANGE_LIMIT_1

ALF_CHANGE_LIMIT_1:
		jnc	ALF_CHANGE_LIMIT_7
		sjmp	ALF_CHANGE_LIMIT_5

ALF_CHANGE_LIMIT_2:
		mov	DPTR, #6078h	; Макс.	скорость обогащения смеси, 1/сек.
		clr	A
		movc	A, @A+DPTR
		xch		A, B
		subb	A, B
		jnc	ALF_CHANGE_LIMIT_3
		clr	A

ALF_CHANGE_LIMIT_3:
		cjne	A, ALF_1, ALF_CHANGE_LIMIT_4

ALF_CHANGE_LIMIT_4:
		jc	ALF_CHANGE_LIMIT_7

ALF_CHANGE_LIMIT_5:
		mov	DPTR, #0F833h
		movx	@DPTR, A
		mov	ALF_1, A

ALF_CHANGE_LIMIT_6:
		ret

ALF_CHANGE_LIMIT_7:
		mov	DPTR, #0F833h
		mov	A, ALF_1
		movx	@DPTR, A
		ret
ENDM
