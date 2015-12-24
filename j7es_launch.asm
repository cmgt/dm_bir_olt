LAUNCH_INIT MACRO
		mov		DPTR, #605Ch
		clr		A
		movc	A, @A+DPTR
		mov		DPTR, #FUEL_CUTOFF_RPM				; Обороты блокировки впрыска
		movx	@DPTR, A
		mov		DPTR, #FUEL_LAUNCH_CUTOFF_RPM		; Обороты блокировки впрыска на	лаунче
		movx	@DPTR, A
		mov		RAM_68, #0FFh		
		mov		RAM_69, #0FFh	; дельта текущих оборотов и оборотов блокировки впрыска
		mov		RAM_4A, #0	; счетчик 20мс интервалов времени для лаунч
ENDM

LAUNCH_TF1 MACRO
		mov		A, RAM_4A		; Счетчик 20 мс интервалов после входа в режим лаунч (начало движения)
		jz		LAUNCH_TF1_EXIT
		inc		A
		jz		LAUNCH_TF1_EXIT
		mov		RAM_4A, A		; Счетчик 20 мс интервалов после входа в режим лаунч (начало движения)
LAUNCH_TF1_EXIT:
ENDM

LAUNCH_START_TEST MACRO
		jnb		Options.4, LAUNCH_DISABLE 
		jb		InOutError.6, LAUNCH_DISABLE
		mov		DPTR, #0F8AEh		;Текущая скорость
		movx	A, @DPTR
		mov		B, A		; B-Register
		mov		DPTR, #LAUNCH_SPEED_ADDR	; Скорость входа в режим Launch, км/ч, км/час
		clr		A
		movc	A, @A+DPTR
		cjne	A, B, LAUNCH_ENABLED_TEST

LAUNCH_ENABLED_TEST:
		jc		LAUNCH_ENABLED
		clr		A
		mov		RAM_4A,	A			; Счетчик 20 мс интервалов после входа в режим лаунч (начало движения)
		jmp		LAUNCH_DISABLE_RPM_SET
		
LAUNCH_DISABLE:
		clr		A
		mov		RAM_4A,	A			; Счетчик 20 мс интервалов после входа в режим лаунч (начало движения)
		mov		DPTR, #FUEL_CUTOFF_RPM		;Обороты блокировки впрыска, об./мин
		movx	A, @DPTR
		jmp		LAUNCH_2

LAUNCH_ENABLED:
		mov		A, RAM_4A			; Счетчик 20 мс интервалов после входа в режим лаунч (начало движения)
		jnz		LAUNCH_RPM_SET
		inc		RAM_4A				; Счетчик 20 мс интервалов после входа в режим лаунч (начало движения)
		
LAUNCH_RPM_SET:
		rr		A
		rr		A
		rr		A
		anl		A, #1Fh

LAUNCH_DISABLE_RPM_SET:
		mov		DPTR, #FUEL_LAUNCH_CUTOFF_RPM_ADDR	; Обороты блокировки впрыска на	лаунче X - Время с начала движения F - Обороты,	об/мин
		movc	A, @A+DPTR
		mov		B, A
		mov		DPTR, #FUEL_CUTOFF_RPM		;Обороты блокировки впрыска, об./мин
		movx	A, @DPTR
		cjne	A, B, LAUNCH_1

LAUNCH_1:
		jc		LAUNCH_2
		mov		A, B

LAUNCH_2:
		mov		DPTR, #FUEL_LAUNCH_CUTOFF_RPM		;Обороты блокировки впрыска на	лаунче
		movx	@DPTR, A
ENDM

; LAUNCH_DPKV_EXEC MACRO
		; mov		DPTR, #FUEL_LAUNCH_CUTOFF_RPM		;Обороты блокировки впрыска на	лаунче
		; movx	A, @DPTR
		; mov		B, #5		    ;Подсчет пороговой дельты оборотов
		; mul		AB
		; mov		A, RAM_69				; дельта текущих оборотов и оборотов блокировки впрыска
		; clr		C
		; subb	A, B
		; mov		RAM_2D.7, C
		; jc		LAUNCH_DPKV_1
		; mov		RAM_68,	B
		; sjmp	LAUNCH_DPKV_2

; LAUNCH_DPKV_1:
		; dec		RAM_68
		; mov		A, RAM_68
		; clr		C
		; subb	A, RAM_69
		; jnc		LAUNCH_DPKV_2
		; mov		RAM_68,	RAM_69
; LAUNCH_DPKV_2:
; ENDM

LAUNCH_DPKV_EXEC MACRO
		inc		RAM_68
		mov		A, RAM_68
		setb	C
		subb	A, RAM_69
		jc		LAUNCH_DPKV_1
		mov		RAM_68, #0

LAUNCH_DPKV_1:
		mov	A, RAM_69
		clr	C
		subb	A, #3
		jc	LAUNCH_DPKV_2
		mov	RAM_68,	#1
LAUNCH_DPKV_2:
ENDM

LAUNCH_SPARK_1 MACRO
		mov	A, RAM_68
		jz	no_spark_1
ENDM

LAUNCH_SPARK_2 MACRO
		mov	A, RAM_68
		jz	no_spark_2
ENDM

LAUNCH_SPARK_3 MACRO
		mov	A, RAM_68
		jz	no_spark_3
ENDM

LAUNCH_SPARK_4 MACRO
		mov	A, RAM_68
		jz	no_spark_4
ENDM