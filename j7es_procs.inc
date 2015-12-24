;====================================== Определение мощностного режима
DEFINE_POW_MODE:
		mov	DPTR, #LAMBDA_THR_LINE_ADDR	; Граница зоны экономичного режима X - Обороты,	об/мин F - Положение дросселя, %
		mov	A, RPM_RT_32	; Режимная точка по оборотам, квантованная на 32
		movc	A, @A+DPTR
		mov	R1, THR_CODE	; Положение дросселя
		clr	C
		subb	A, R1
		mov	RAM_2B.2, C	; 0 - Признак выключения двигателя
					; 1 - Признак ХХ
					; 2 - Мощностное обогащение
					; 3 - Блокировка топливоподачи
					; 4 - Признак зоны регулирования по ДК
					; 5 - Признак попадания	в зону детонации
					; 6 - Признак разрешения продувки адсорбера
					; 7 - Признак сохранения результатов обучения по датчику кислорода
		ret			
		
		
;================================== Расчет ALF для режима под нагрузкой
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

;================================== Расчет УОЗ
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
		mov		UOZXX_1, A	; УОЗ на ХХ
		ret
		
		
CALC_EMERGENCY_ALF_UOZ:
		mov	DPTR, #5FFFh	; Состав смеси аварийном режиме,
		clr	A
		movc	A, @A+DPTR
		mov	ALF_1, A
		
		mov	A, DEV_FLAGS	; Флаги	управления исполнительными механизмами
		anl	A, #4
		jnz	CE_EXIT
		
		mov	DPTR, #7877h	; УОЗ при аварии ДМРВ X	- Обороты коленвала, об/мин Y -	Цикловое наполнение,$0Aмг/цикл F - УОЗ,	гр.п.к.в.
		mov     R2, RPM_RT
		mov     R3, GBC_RT
		call	Get3DCell
		mov	B, A		; B-Register		
		mov	DPTR, #0F802h	; Коррекция УОЗ	по Тв
		movx	A, @DPTR
		xch	A, B		; B-Register
		clr	C
		subb	A, B		; B-Register
		mov	UOZXX_1, A	; УОЗ на ХХ
CE_EXIT:
		ret

		
;=================================== Инициализация флагов
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
		mov		Options.0, C	;работать без ДМРВ (ДАД или дроссель)
		mov		DPTR, #PART_FLAGS_ADDR
		clr		A
		movc	A, @A+DPTR
		mov		C, ACC.1
		mov		Options.5, C	;попарно-параллельный режим для катушек Январь 7.2 (2111)
		ret

;===================================== Инициализация после RESET
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
					; P3.2 - OltPin	   (выход)
		mov	A, IP0		; Interrupt Priority Register 0
					; 7 - OWDS;
					; 6 - WDTS запуск по watchdog timer
		jb	ACC.6, OnlineInitExit ;	Accumulator
		orl	P6, #1		; Выбор	вторых 64кБ флешь ПЗУ
		orl	IP1, #10000000b	; Interrupt Priority Register 1
		mov	P3, #111001b	; Port 3 (PDIR=0)
					; #111001
					; P3.0 - KLINE RxD (вход)
					; P3.1 - KLINE TxD (выход)
					; P3.2 - OltPin	   (выход)
					; P3.3 - Компаратор ключей катушек зажигания (вход) (работает с	Р9.6)
					; Р3.4 - Счетчик импульсов с фильтра ДД	(вход)
					; Р3.5 - Датчик	скорости (вход)
					; Р3.6 - Запись	во внешнее ОЗУ WR(выход)
					; Р3.7 - Чтение	внешнего ОЗУ RD(выход)
		orl	IP1, #10000000b	; Interrupt Priority Register 1
		mov	P6, #11010000b	; Port 6 (PDIR=0)
					; #11010000
					; P6.0 - А15 - адресная	нога флешь ПЗУ (выбор вторых 64	кБ) (выход)
					; Р6.1 - микра управления шаговым двигателем пин Phase 1 (выход)
					; Р6.2 - микра управления шаговым двигателем пин Phase 2 (выход)
					; Р6.3 - пин WE# = Write enable	флешь ПЗУ (выход)
					; P6.4 - пин 57	разъема	ЭБУ (Вход Кодирование вариантов	(опцион)) (вход)
					; P6.5 - микра управления шаговым двигателем пины I10,I11,I20,I21 (выход)
					; Р6.6 - микра управления шаговым двигателем пин Err2 (вход)
					; Р6.7 - микра управления шаговым двигателем пин Err1 (вход)

code_E71E:				; CODE XREF: OnlineInit+37j
		mov	DPTR, #0

code_E721:				; CODE XREF: OnlineInit+2Cj
		clr	A		; Копирование ПЗУ во внешнюю ОЗУ (для инжинерника)
		movc	A, @A+DPTR
		movx	@DPTR, A
		mov	A, DPL		; Data Pointer,	Low Byte
		jnz	code_E72C
		setb	IEN0.6		; Interrupt Enable Register 0
		setb	IEN1.6		; Interrupt Enable Register 1

code_E72C:				; CODE XREF: OnlineInit+23j
		inc	DPTR
		mov	A, DPH		; Data Pointer,	High Byte
		cjne	A, #0F4h, code_E721 ; 'Ї' ; Копирование ПЗУ во внешнюю ОЗУ (для инжинерника)
		mov	A, P6		; Port 6 (PDIR=0)
					; #11010000
					; P6.0 - А15 - адресная	нога флешь ПЗУ (выбор вторых 64	кБ) (выход)
					; Р6.1 - микра управления шаговым двигателем пин Phase 1 (выход)
					; Р6.2 - микра управления шаговым двигателем пин Phase 2 (выход)
					; Р6.3 - пин WE# = Write enable	флешь ПЗУ (выход)
					; P6.4 - пин 57	разъема	ЭБУ (Вход Кодирование вариантов	(опцион)) (вход)
					; P6.5 - микра управления шаговым двигателем пины I10,I11,I20,I21 (выход)
					; Р6.6 - микра управления шаговым двигателем пин Err2 (вход)
					; Р6.7 - микра управления шаговым двигателем пин Err1 (вход)
		jnb	ACC.0, code_E73C ; Accumulator
		anl	P6, #11111110b	; Port 6 (PDIR=0)
					; #11010000
					; P6.0 - А15 - адресная	нога флешь ПЗУ (выбор вторых 64	кБ) (выход)
					; Р6.1 - микра управления шаговым двигателем пин Phase 1 (выход)
					; Р6.2 - микра управления шаговым двигателем пин Phase 2 (выход)
					; Р6.3 - пин WE# = Write enable	флешь ПЗУ (выход)
					; P6.4 - пин 57	разъема	ЭБУ (Вход Кодирование вариантов	(опцион)) (вход)
					; P6.5 - микра управления шаговым двигателем пины I10,I11,I20,I21 (выход)
					; Р6.6 - микра управления шаговым двигателем пин Err2 (вход)
					; Р6.7 - микра управления шаговым двигателем пин Err1 (вход)
		sjmp	code_E71E
; ---------------------------------------------------------------------------

code_E73C:				; CODE XREF: OnlineInit+31j
		orl	P6, #1		; Port 6 (PDIR=0)
					; #11010000
					; P6.0 - А15 - адресная	нога флешь ПЗУ (выбор вторых 64	кБ) (выход)
					; Р6.1 - микра управления шаговым двигателем пин Phase 1 (выход)
					; Р6.2 - микра управления шаговым двигателем пин Phase 2 (выход)
					; Р6.3 - пин WE# = Write enable	флешь ПЗУ (выход)
					; P6.4 - пин 57	разъема	ЭБУ (Вход Кодирование вариантов	(опцион)) (вход)
					; P6.5 - микра управления шаговым двигателем пины I10,I11,I20,I21 (выход)
					; Р6.6 - микра управления шаговым двигателем пин Err2 (вход)
					; Р6.7 - микра управления шаговым двигателем пин Err1 (вход)
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
		

;===================================== Конфигурирование портов выходного драйвера TLE6240
INIT_TLE6240:
		mov		DPTR, #PART_FLAGS_ADDR
		clr		A
		movc	A, @A+DPTR
		jnb		ACC.2, NOT_KALINA 			;проводка Калина (реле вентилятора и БН)
		
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
		mov	A, #0F0h ; 'Ё'
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
		
;==========================    Доп. функции лампы CE   ===================
CE_FUNC:
		mov	DPTR, #CE_FUNC_STATE
		movx	A, @DPTR
		mov		B, A
		mov	DPTR, #CE_RPM1_ADDR   ;Дельта индикации отсечки лампой CE
		clr	A
		movc	A, @A+DPTR
		jb	ACC.7, CE_TWAT_TEST ; Accumulator
		mov	R0, A
		mov	DPTR, #CE_RPM2_ADDR    ;Дельта гашения CE
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
		mov	DPTR, #CE_TWAT_ERROR_ADDR  ; Значение перегретого двигателя
		clr	A
		movc	A, @A+DPTR
		clr	C
		subb	A, TWAT	; Текущее значение ДТОЖ	(температура двигателя)
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
