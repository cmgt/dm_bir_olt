;================================  Функции обработки ДАД
CALC_COARSE_DAD_VALUE:				; CODE XREF: RESET_0+84Fp
		mov	DPTR, #0F80Ch
		movx	A, @DPTR
		mov	B, #4		; B-Register
		mul	AB
		mov	R2, A
		mov	R3, B		; B-Register
		jmp	CALC_DAD_1
		
CALC_DAD_VALUE:
		mov	C, LowLevelError.6 ; 6 bit	АЦП ДМРВ/ДАД меньше минимума (обрыв ДМРВ /ДАД)
		orl	C, HiLevelError.6 ; 6 bit	АЦП ДМРВ/ДАД больше максимума (ошибка ДМРВ/ДАД)
		jnc	CALC_DAD_START

		mov	A, THR_CODE
		mov	DPTR, #THR_MAP_ADDR
		movc	A, @A+DPTR
		mov	R3, A
		mov	R2, RPM
		mov	DPTR, #DAD_EMUL_ADDR
		lcall	Get3DCell
		mov	B, #64h
		mul	AB
		mov	R0, A
		mov	R1, B
		jmp	CALC_DAD_1
		
CALC_DAD_START:
		mov	A, RAM_33
		jnz	CALC_DAD_AVR
		ret
		
CALC_DAD_AVR:
		mov	B, #40h	
		mul	AB
		mov	MD0, RAM_34	
		mov	MD1, RAM_35	
		mov	MD2, RAM_7F	
		mov	MD3, #0		
		mov	MD4, A		
		mov	MD5, B		
		FILL_NOP 6
		mov	R2, MD0
		mov	R3, MD1
		mov	A, MD2
		mov	A, MD3
		mov	A, MD4
		mov	A, MD5
		mov	DPTR, #DAD_OFFSET_ADDR	; Смещение ДАД
		clr	A
		movc	A, @A+DPTR
		mov	R0, A
		mov	A, #1
		movc	A, @A+DPTR
		mov	R1, A
		mov	A, R0
		add	A, R2
		mov	R2, A
		mov	A, R1
		addc	A, R3
		mov	R3, A
		mov	DPTR, #DAD_SLOPE_ADDR	; Наклон ДАД
		clr	A
		movc	A, @A+DPTR
		mov	R0, A
		mov	A, #1
		movc	A, @A+DPTR
		mov	R1, A
		mov	MD0, R2		; Multiplication/Division Register 0
		mov	MD4, R0		; Multiplication/Division Register 4
		mov	MD1, R3		; Multiplication/Division Register 1
		mov	MD5, R1		; Multiplication/Division Register 5
		FILL_NOP 4
		mov	A, MD0		; Multiplication/Division Register 0
		mov	R0, MD1		; Multiplication/Division Register 1
		mov	R1, MD2		; Multiplication/Division Register 2
		mov	A, MD3          ; Multiplication/Division Register 3
		jz	CALC_DAD_1
		mov	R0, #0FFh
		mov	R1, #0FFh
		
CALC_DAD_1:
		
		mov	DAD_VALUE_LO, R0
		mov	DAD_VALUE_HI, R1
		
		;mov		DPTR, #0F876h
		;mov		A, R0
		;movx	@DPTR, A
		;inc		DPTR
		;mov		A, R1
		;movx	@DPTR, A
;==========================  Вычисление температуры заряда
		GET_THR
		mov	R3, A		
		mov	DPTR, #FCHARGE_ADDR
		mov	R2, RPM
		call	Get3DCell
		mov	B, A		; B-Register
		mov	DPTR, #FCHARGE_TWAT		; ТОЖ
		movx	A, @DPTR
		mov	R0, A
		mov	DPTR, #TAIR_VALUE					; ТВ
		movx	A, @DPTR
		clr	C
		subb	A, R0
		jnc	CALC_DAD_2
		mov	R1, A
		clr	A
		clr	C
		subb	A, R1
		mul	AB
		clr	A
		clr	C
		subb	A, B
		jmp	CALC_DAD_3
		
CALC_DAD_2:
		mul	AB
		mov	A, B
		
CALC_DAD_3:
		add	A, R0
		mov	R0, A		; Добавление 10% от разницы с предыдущей Тз
		mov	B, #26
		mov	DPTR, #TCHARGE	; Тз
		movx	A, @DPTR
		clr	C
		subb	A, R0
		jnc	CALC_DAD_4
		mov	R1, A
		clr	A
		clr	C
		subb	A, R1
		mul	AB
		clr	A
		clr	C
		subb	A, B		; B-Register
		jmp	CALC_DAD_5

CALC_DAD_4:				; CODE XREF: code:B0ECj
		mul	AB
		mov	A, B		; B-Register
		
CALC_DAD_5:
		add	A, R0
		movx	@DPTR, A
		mov	R0, A
		FILL_TWAT_ARGS
		mov	DPTR, #FCHARGE_FCORR_ADDR	; Корректирующая функция для Тз
		call	code_AEBD
		mov	B, A		; B-Register
		mov	A, R0
		mul	AB
		jnb	ACC.7, CALC_DAD_6 ; Accumulator
		inc	B		; B-Register
		
CALC_DAD_6:
		mov	A, B		; B-Register
		mov	DPTR, #TCHARGE_FIN	; Тз после всех	коррекций
		movx	@DPTR, A
		add	A, #233
		mov	B, A
		clr	A
		addc	A, #0
		mov	MD0, DAD_VALUE_LO ; Умножение на 293
		mov	MD4, #25h 
		mov	MD1, DAD_VALUE_HI 
		mov	MD5, #1
		FILL_NOP 4
		mov	R0, MD0
		mov	R1, MD1
		mov	R2, MD2
		mov	R3, MD3
		nop
		mov	MD0, R0
		mov	MD1, R1
		mov	MD2, R2
		mov	MD3, R3
		mov	MD4, B
		mov	MD5, A
		FILL_NOP 6
		mov	R0, MD0
		mov	R1, MD1
		mov	A, MD2
		mov	A, MD3
		mov	A, MD4
		mov	A, MD5
		mov	DPTR, #CYL_VOLUME_ADDR
		clr	A
		movc	A, @A+DPTR
		mov	B, A		; B-Register
		mov	A, #1
		movc	A, @A+DPTR
		mov	MD0, R0
		mov	MD4, B
		mov	MD1, R1
		mov	MD5, A
		FILL_NOP 4
		mov	A, MD0
		mov	A, MD1
		mov	R0, MD2
		mov	R1, MD3
		mov	DPTR, #FCHARGE_GBC_VALUE_ADDR
		mov	A, R0
		movx	@DPTR, A
		inc	DPL
		mov	A, R1
		movx	@DPTR, A
;==========================  Вычисление квантованного значения
		mov	MD0, DAD_VALUE_LO
		mov	MD4, #3
		mov	MD1, DAD_VALUE_HI
		mov	MD5, #0
		FILL_NOP 4
		mov	R0, MD0
		mov	R1, MD1
		mov	R2, MD2
		mov	R3, MD3
		nop
		mov	MD0, R0
		mov	MD1, R1
		mov	MD2, R2
		mov	MD3, R3
		mov	MD4, #5
		mov	MD5, #0
		FILL_NOP 6
		mov	R0, MD0
		mov	R1, MD1
		mov	A, MD2
		mov	A, MD3
		mov	A, MD4
		mov	A, MD5
		mov	DPTR, #DAD_MIN_ADDR	; Минимум для квантования давления
		clr	A
		movc	A, @A+DPTR
		mov	R2, A
		inc		DPL
		movc	A, @A+DPTR
		mov	R3, A
		call	SUB_R0R1_R2R3
		clr	A
		jc	CALC_DAD_7
		mov	DPTR, #DAD_RANGE_ADDR	; Диапазон квантования давления
		clr	A
		movc	A, @A+DPTR
		mov	B, A		; B-Register
		call	DIV_R0R1_8
		call	MUL_R0R1_B
		mov	A, R1
		jnz	CALC_DAD_8
		mov	A, R0
		cjne	A, #0F0h, CALC_DAD_9 ; 'Ё'

CALC_DAD_9:
		jc	CALC_DAD_7

CALC_DAD_8:
		mov	A, #0F0h ; 'Ё'

CALC_DAD_7:
		mov	DPTR, #PRESSURE	; Текущее значение давления (ДАД)
		movx	@DPTR, A
		ret
		

;===================== Коррекция ТОЖ для модели Т заряда
FCHARGE_TOG_CORRECTION:
		FILL_TWAT_ARGS
		mov	DPTR, #FCHARGE_TWAT_CONVERT_ADDR
		call	code_AEBD
		mov	DPTR, #FCHARGE_TWAT
		movx	@DPTR, A
		ret
		
		
;================ Ускорительный насос по давлению
; CALC_DAD_ADD_FUEL:
		; mov	DPTR, #0F981h	; Давление в пред. цикле для расчета доп. топлива
		; movx	A, @DPTR
		; mov	R2, A
		; inc	DPTR
		; movx	A, @DPTR
		; mov	R3, A
		; clr	C
		; mov	A, DAD_VALUE_LO
		; subb	A, R2
		; mov	R2, A
		; mov	A, DAD_VALUE_HI
		; subb	A, R3
		; mov	R3, A
		; jnc	CALC_DAD_ADD_FUEL_2
		; clr	C
		; mov	A, #0FFh
		; subb	A, R2
		; mov	R2, A
		; mov	A, #0FFh
		; subb	A, R3
		; mov	R3, A
		; mov	DPTR, #0F981h	; Давление в пред. цикле для расчета доп. топлива
		; mov	A, DAD_VALUE_LO
		; movx	@DPTR, A
		; inc	DPTR
		; mov	A, DAD_VALUE_HI
		; movx	@DPTR, A
		; mov	DPTR, #5F53h	; Порог	нечувствительности по скачку давления (падение)
		; movx	A, @DPTR
		; mov	R0, A
		; inc	DPTR
		; movx	A, @DPTR
		; mov	R1, A
		; clr	C
		; mov	A, R2
		; subb	A, R0
		; mov	A, R3
		; subb	A, R1
		; jnc	CALC_DAD_ADD_FUEL_1
		; mov	DPTR, #0F983h	; Дополнительное топливо по давлению
		; movx	A, @DPTR
		; mov	R0, A
		; inc	DPL		; Data Pointer,	Low Byte
		; movx	A, @DPTR
		; mov	R1, A
		; mov	DPTR, #5EF6h	; Коэффициент уменьшения GTC 1 (падение)
		; movc	A, @A+DPTR
		; mov	B, A		; B-Register
		; call	MUL_R0R1_B
		; mov	DPTR, #0F983h	; Дополнительное топливо по давлению
		; mov	A, R0
		; movx	@DPTR, A
		; inc	DPL		; Data Pointer,	Low Byte
		; mov	A, R1
		; movx	@DPTR, A
		; ret
; ; ---------------------------------------------------------------------------

; CALC_DAD_ADD_FUEL_1:
		; clr	A
		; mov	DPTR, #0F983h	; Дополнительное топливо по давлению
		; movx	@DPTR, A
		; inc	DPL		; Data Pointer,	Low Byte
		; movx	@DPTR, A
		; ret
; ; ---------------------------------------------------------------------------

; CALC_DAD_ADD_FUEL_2:
		; mov	DPTR, #0F981h	; Давление в пред. цикле для расчета доп. топлива
		; mov	A, DAD_VALUE_LO
		; movx	@DPTR, A
		; inc	DPTR
		; mov	A, DAD_VALUE_HI
		; movx	@DPTR, A
		; mov	DPTR, #5EF8h	; Порог	нечувствительности по скачку давления (возрастание)
		; movx	A, @DPTR
		; mov	R0, A
		; inc	DPTR
		; movx	A, @DPTR
		; mov	R1, A
		; clr	C
		; mov	A, R2
		; subb	A, R0
		; mov	A, R3
		; subb	A, R1
		; jc	CALC_DAD_ADD_FUEL_3
		; mov	A, R3
		; mov	R1, A
		; mov	A, R2
		; mov	R0, A
		; mov	DPTR, #84BAh	; Экстраполирующий коэффициент пересчета давления
		; mov	A, TWAT_RT
		; movc	A, @A+DPTR
		; mov	B, A		; B-Register
		; call	MUL_R0R1_B
		; mov	A, RPM_RT
		; mov	DPTR, #84E1h	; Коэффициент топлива по оборотам
		; movc	A, @A+DPTR
		; mov	B, A		; B-Register
		; call	MUL_R0R1_B
		; mov	DPTR, #0F9A0h
		; movx	A, @DPTR
		; add	A, #4
		; swap	A
		; rl	A
		; anl	A, #1Fh
		; mov	DPTR, #8501h	; Коэффициент топлива по давлению
		; movc	A, @A+DPTR
		; mov	B, A		; B-Register
		; call	MUL_R0R1_B
		; mov	DPTR, #0F983h	; Дополнительное топливо по давлению
		; movx	A, @DPTR
		; mov	R2, A
		; inc	DPL		; Data Pointer,	Low Byte
		; movx	A, @DPTR
		; mov	R3, A
		; clr	C
		; mov	A, R0
		; subb	A, R2
		; mov	A, R1
		; subb	A, R3
		; jc	CALC_DAD_ADD_FUEL_4
		; sjmp	CALC_DAD_ADD_FUEL_6
; ; ---------------------------------------------------------------------------

; CALC_DAD_ADD_FUEL_3:
		; mov	A, RAM_41 ; Текущий такт
		; jnz	CALC_DAD_ADD_FUEL_7
		; mov	DPTR, #5EF6h	; Коэффициент уменьшения GTC 1 (падение)
		; sjmp	CALC_DAD_ADD_FUEL_5
; ; ---------------------------------------------------------------------------

; CALC_DAD_ADD_FUEL_4:
		; mov	DPTR, #5EF7h	; Коэффициент уменьшения GTC 2 (стационарность)

; CALC_DAD_ADD_FUEL_5:
		; clr	A
		; movc	A, @A+DPTR
		; mov	B, A		; B-Register
		; mov	DPTR, #0F983h	; Дополнительное топливо по давлению
		; movx	A, @DPTR
		; mov	R0, A
		; inc	DPL		; Data Pointer,	Low Byte
		; movx	A, @DPTR
		; mov	R1, A
		; call	MUL_R0R1_B

; CALC_DAD_ADD_FUEL_6:
		; mov	DPTR, #0F983h	; Дополнительное топливо по давлению
		; mov	A, R0
		; movx	@DPTR, A
		; inc	DPL		; Data Pointer,	Low Byte
		; mov	A, R1
		; movx	@DPTR, A

; CALC_DAD_ADD_FUEL_7:
		; ret
; End of function CALC_DAD_ADD_FUEL

;===================== Диагностика ДАД
DAD_DIAG:
		jb	RAM_2A.3, DAD_DIAG_NO_ERROR
		mov	DPTR, #0F80Ch
		movx	A, @DPTR
		mov	R0, A
		mov	DPTR, #DAD_ADC_MIN
		clr	A
		movc	A, @A+DPTR
		clr	C
		subb	A, R0
		jc	DAD_DIAG_TEST_MAX
		mov	DPTR, #DAD_ADC_ERR_COUNT
		movx	A, @DPTR
		jz	DAD_DIAG_ERR_LOW
		dec	A
		movx	@DPTR, A
		ret

DAD_DIAG_ERR_LOW:
		setb	LowLevelError.6
		clr	HiLevelError.6
		ret

DAD_DIAG_TEST_MAX:
		mov	DPTR, #5EF1h
		clr	A
		movc	A, @A+DPTR
		clr	C
		subb	A, R0
		jnc	DAD_DIAG_NO_ERROR
		mov	DPTR, #DAD_ADC_ERR_COUNT
		movx	A, @DPTR
		jz	DAD_DIAG_ERR_HI
		dec	A
		movx	@DPTR, A
		ret

DAD_DIAG_ERR_HI:
		clr	LowLevelError.6
		setb	HiLevelError.6
		ret

DAD_DIAG_NO_ERROR:
		mov	DPTR, #DAD_ADC_ERR_COUNT
		mov	A, #20
		movx	@DPTR, A
		clr	LowLevelError.6
		clr	HiLevelError.6
		ret