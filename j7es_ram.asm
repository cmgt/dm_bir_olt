; Segment type:	Internal processor memory & SFR
		;.segment RAM
		DSEG
		
RAM_68		equ		68h
RAM_69		equ		69h
RAM_4A		equ		4Ah

RAM_0 equ 0				; DATA XREF: Timer1Proc_1ms+Dr
					; Timer1Proc_1ms:code_82Aw ...
					; ����殮��� �⪫�祭��	��⠭��, �
RAM_1 equ 1				; DATA XREF: OnlineInit:code_26E1w
					; OnlineInit-A8C3r ...
RAM_2 equ 2				; DATA XREF: code_BC94+5Ew code_BE1Er	...
RAM_3 equ 3				; DATA XREF: OnlineInit-937Dr
					; code_B4E3+D5r ...
RAM_4 equ 4				; DATA XREF: code_ABCB+Fw
					; code_ABCB+23r ...
MayBeCylinderNum equ 5			; DATA XREF: DPKV_PROC+18r
					; DPKV_PROC+25w ...
DPKVDoubleIntervalL equ	6		; DATA XREF: DPKV_PROC+30w
					; DPKV_PROC+3Ar ...
DPKVDoubleIntervalH equ	7		; DATA XREF: DPKV_PROC+36w
					; DPKV_PROC+3Fr ...
RAM_8 equ 8				; DATA XREF: IE0_0+4Bw	IE0_0:code_982r ...
RAM_9 equ 9				; DATA XREF: IE0_0+4Ew	IE0_0:code_982w ...
RAM_A equ 0Ah				; DATA XREF: IE0_0+46r	IE0_0+4Br ...
RAM_B equ 0Bh				; DATA XREF: IE0_0+49r	IE0_0+4Er ...


RAM_E equ 0Eh				; DATA XREF: IE0_0+4D0w IE0_0+521r ...
RAM_F equ 0Fh				; DATA XREF: IE0_0+4D2w IE0_0+525r ...
RAM_10 equ 10h				; DATA XREF: DPKV_PROC+27Bw
					; DPKV_PROC+2BCr ...
RAM_11 equ 11h				; DATA XREF: DPKV_PROC+27Ew
					; DPKV_PROC+2BFr ...
RAM_12 equ 12h				; DATA XREF: DPKV_PROC+281w
					; DPKV_PROC:code_441r ...
RAM_13 equ 13h				; DATA XREF: DPKV_PROC+284w
					; DPKV_PROC+32Er ...
RAM_14 equ 14h				; DATA XREF: DPKV_PROC:code_3A1w
					; DPKV_PROC:code_488r ...
RAM_15 equ 15h				; DATA XREF: DPKV_PROC+28Bw
					; DPKV_PROC+372r ...
RAM_16 equ 16h				; DATA XREF: DPKV_PROC+28Ew
					; DPKV_PROC:code_4F4r ...
RAM_17 equ 17h				; DATA XREF: DPKV_PROC+291w
					; DPKV_PROC+3E1r ...
RAM_18 equ 18h				; DATA XREF: DPKV_PROC:code_1DAr
					; DPKV_PROC+144r ...
RAM_19 equ 19h				; DATA XREF: DPKV_PROC+C3r
					; DPKV_PROC+146r ...


RAM_1C equ 1Ch				; DATA XREF: OnlineInit-B9A3r
RAM_1D equ 1Dh				; DATA XREF: OnlineInit-B9A1r


Hardware equ 20h			; DATA XREF: DPKV_PROC+184r
					; DPKV_PROC+2E7r ...
					; Bit00="���稪 ���業��樨 ��᫮த�"
					; Bit01="���ࡥ�"
					; Bit02="������ �����樨"
					; Bit03="���稪 ��⮭�樨"
					; Bit04="���稪 ⥬������� ������"
					; Bit05="���稪 䠧"
					; Bit06="�ਧ��� ����ﭭ��� ����祭�� ⮯����"
					; Bit07="�ਧ��� ࠧ�襭�� �����樨 ��⠢�� ��"
Options	equ 21h				; DATA XREF: IE0_0+15F5r IE0_0+173Dr ...
					; Bit10="��⥭樮���� ॣ㫨஢�� CO"
					; Bit11="������� ��� ���ᥫ�"
					; Bit12="�ᨭ�஭��� ⮯��������� �� ����୮� ��᪥"
					; Bit13="����ﭭ�� �࠭���� �訡��"
					; Bit14="���稪 ᪮��� ��⮬�����"
					; Bit15="����襭�� �����६������ ����᪠"
					; Bit16="�ᨭ�஭��� �����饭�� �� �᪮७��"
					; Bit17="��� � 䠧�஢����� ०���"
SystemErrorVar equ 22h			; DATA XREF: DPKV_PROC+187w
					; DPKV_PROC:code_2B5w ...
					; ���⥬�� �訡��
					; Bit00="0335 - �訡�� ����"
					; Bit01="1610 - �������筮 �६��� � 横�� 1��"
					; Bit02="1603 - �訡�� EEPROM"
					; Bit03="0135 - �訡�� ���ॢ�⥫� ��"
					; Bit04="0340 - �訡�� ���稪� 䠧"
					; Bit05="1612 - �訡�� ��� ������"
					; Bit06="0603 - �訡�� ���"
					; Bit07="0601 - �訡�� ���"
LowLevelError equ 23h			; DATA XREF: IE0_0+DDDw IE0_0+DEAw ...
					; ������ �஢��	ᨣ�����
					; Bit10="0562 - ������ �஢��� ���⮢��� ����殮���"
					; Bit11="1171 - ������ �஢��� ᨣ���� RCO"
					; Bit12="0112 - ������ �஢��� ᨣ���� ���"
					; Bit13="0117 - ������ �஢��� ᨣ���� ����"
					; Bit14="0131 - ������ �஢��� ᨣ���� � ��"
					; Bit15="0122 - ������ �஢��� ᨣ���� ����"
					; Bit16="0102 - ������ �஢��� ᨣ���� ����"
					; Bit17="0327 - ������ �஢��� �㬠 �����⥫�"
HiLevelError equ 24h			; DATA XREF: IE0_0+DECw IE0_0+E23r ...
					; ��᮪�� �஢�� ᨣ����
					; Bit20="0563 - ��᮪�� �஢��� ���⮢��� ����殮���"
					; Bit21="1172 - ��᮪�� �஢��� ᨣ���� RCO"
					; Bit22="0113 - ��᮪�� �஢��� ᨣ���� ���"
					; Bit23="0118 - ��᮪�� �஢��� ᨣ���� ����"
					; Bit24="0132 - ��᮪�� �஢��� ᨣ���� � ��"
					; Bit25="0123 - ��᮪�� �஢��� ᨣ���� ����"
					; Bit26="0103 - ��᮪�� �஢��� ᨣ���� ����"
					; Bit27="0328 - ��᮪�� �஢��� �㬠 �����⥫�"
InOutError equ 25h			; DATA XREF: DPKV_PROC+B5w
					; DPKV_PROC:code_23Bw ...
					; �訡�� �室���/��室��� 楯��
					; Bit30="0325 - ���� ���稪� ��⮭�樨"
					; Bit31="1600 - ��� �裡 � �����������஬"
					; Bit32="3999 - �� �ᯮ������"
					; Bit33="0134 - ��� ��⨢���� ���稪� ��᫮த�"
					; Bit34="0172 - ��� �⪫��� ���稪� ��᫮த� �� ���������"
					; Bit35="0171 - ��� �⪫��� ���稪� ��᫮த� �� �����饭��"
					; Bit36="0501 - �訡�� ���稪� ᪮��� ��⮬�����"
					; Bit37="0505 - �訡�� ॣ���� 宫��⮣� 室�"
RAM_26 equ 26h				; DATA XREF: DPKV_PROC:code_111w
					; DPKV_PROC+15r ...
RAM_27 equ 27h				; DATA XREF: DPKV_PROC:code_100w
					; DPKV_PROCr ...
					; 0
					; 1
					; 2
					; 3 - (⥪�騩 �� 56) ����� ������ 58-59 ��쥢
RAM_28 equ 28h				; DATA XREF: DPKV_PROC+1E6w
					; DPKV_PROC+24Bw ...
					; 0
					; 1 - ����祭 ���⨫��� �嫠������
					; 2
					; 3
					; 4 - 䫠� �ᯮ�짮����� ᮯ����� (MD) � ��ࠡ��稪� ���뢠���
					; 5 - �⪫�祭 ����஫�	��⮭�樨 (������ > ������ �⪫. �����. ��⮭.)
RAM_29 equ 29h				; DATA XREF: Timer1Proc_1ms+30w
					; IE0_0+DBEr ...
					; 0 - 䫠� ����᪠ �������� 横�� ���᫥��� (20 ��)
					; 1 - �������� ����᪠
					; 2
					; 3
					; 4 - ����祭� ��⠭��
					;
RAM_2A equ 2Ah				; DATA XREF: DPKV_PROC+263w
					; DPKV_PROC:code_438r ...
					; 0
					; 1 - ⥪�騥 ������ ����� ����⮢ ��砫� ��室� �� ०��� ��᪠
					; 2
					; 3
					; 4 - �� ��諨 �� ०��� ��᪠ (������	�� �ॢ�ᨫ� ������ ������� ��室�)
					; 5
					; 6 - �����⥫�	����饭
					; 7
RAM_2B equ 2Bh				; DATA XREF: IE0_0+218r IE0_0+41Fr ...
					; 0 - �ਧ��� �몫�祭�� �����⥫�
					; 1 - �ਧ��� ��
					; 2 - ��魮�⭮� �����饭��
					; 3 - �����஢�� ⮯���������
					; 4 - �ਧ��� ���� ॣ㫨஢���� �� ��
					; 5 - �ਧ��� ���������	� ���� ��⮭�樨
					; 6 - �ਧ��� ࠧ�襭�� �த㢪� ���ࡥ�
					; 7 - �ਧ��� ��࠭���� १���⮢ ���祭�� �� ���稪� ��᫮த�
RAM_2C equ 2Ch				; DATA XREF: IE0_0+1116r IE0_0+112Dr ...
					; 0
					; 1 - �ਧ��� �� � ��諮� 横��
					; 2 - ����襭�� �����஢�� ��室� �� ��
					; 3 - �ਧ��� ���������	� ���� ��⮭�樨 � ��諮� 横��
					; 4 - �ਧ��� ������ �த㢪� ���ࡥ� � ��諮� 横��
					; 5 - �ਧ��� �����㦥��� ��⮭�樨
					; 6 - �ਧ��� ��諮�� ���ﭨ� ���稪� ��᫮த�
					; 7 - �ਧ��� ⥪�饣� ���ﭨ� ���稪� ��᫮த�
RAM_2D equ 2Dh				; DATA XREF: Timer1Proc_1ms:code_573r
					; Timer1Proc_1ms+68w ...
					; 0 - �᫨ ��⠭�����, Baund Rate 10400; �᫨ ���, � -	900
					; 1
					; 2
					; 3
					; 4
					; 5 - �ਧ��� �������� ��⮬�����
					; 6 - ०�� �����樮��஢����
					; 7 - 䫠� ࠧ�襭�� ���������	����⮢ ��� ����
RAM_2E equ 2Eh				; DATA XREF: OnlineInit-BDCFw
					; OnlineInit-A453r ...
RAM_2F equ 2Fh				; DATA XREF: Timer1Proc_1ms+74r
					; Timer1Proc_1ms+7Ar ...
					; �����	ࠡ��� � ��᫥����⥫�� ����䥩ᮬ
					; 0
					; 1
					; 2
					; 3
					; 4 - ���� ����� ��� ��।��
					; 5 - ��⠭������ ���� �裡 (StartCommunication)
					; 6 - ��⠭������ ���� �������⨪� (DiagnosticSession)
					; 7 - 4	�����	��������� �����
RAM_30 equ 30h				; DATA XREF: DPKV_PROC+1CCr
					; DPKV_PROC+1D6w ...
					; �㬬�	��� ���� ��� 䨫��� (����訩 ����)
RAM_31 equ 31h				; DATA XREF: DPKV_PROC+1CFr
					; DPKV_PROC+1D8w ...
					; �㬬�	��� ���� ��� 䨫��� (���訩 ����)
RAM_32 equ 32h				; DATA XREF: DPKV_PROC+1D2r
					; DPKV_PROC+1DAw ...
					; ���-�� ���祭�� ��� 䨫��� ����
RAM_33 equ 33h				; DATA XREF: DPKV_PROC+1D2w IE0_0+D86r ...
					; ���-�� ���祭�� ��� 䨫��� ����
RAM_34 equ 34h				; DATA XREF: DPKV_PROC+1CCw IE0_0+D92r ...
					; �㬬�	��� ���� ��� 䨫��� (����訩 ����)
RAM_35 equ 35h				; DATA XREF: DPKV_PROC+1CFw IE0_0+D98r ...
					; �㬬�	��� ���� ��� 䨫��� (���訩 ����)
RAM_36 equ 36h				; DATA XREF: DPKV_PROC+1FBr
					; DPKV_PROC+24Ew
RAM_37 equ 37h				; DATA XREF: DPKV_PROC+200r
					; DPKV_PROC+250w
RAM_38 equ 38h				; DATA XREF: DPKV_PROC+1FDw
					; DPKV_PROC+219r ...
RAM_39 equ 39h				; DATA XREF: DPKV_PROC+202w
					; DPKV_PROC+21Cr ...
RAM_3A equ 3Ah				; DATA XREF: code_B4E3+3w
					; code_B4E3+A0w ...
RAM_3B equ 3Bh				; DATA XREF: code_B4E3+4Aw
					; code_B4E3+54r ...
RAM_3C equ 3Ch				; DATA XREF: DPKV_PROC+1C6r
					; DPKV_PROC+1EAw ...
RAM_3D equ 3Dh				; DATA XREF: DPKV_PROC+1DFr
					; DPKV_PROC+1EDw ...
RAM_3E equ 3Eh				; DATA XREF: DPKV_PROC+1EAr
					; OnlineInit-BF36w ...
RAM_3F equ 3Fh				; DATA XREF: DPKV_PROC+1EDr
					; OnlineInit-BF2Dw ...
RAM_40 equ 40h				; DATA XREF: DPKV_PROC+16Ew
					; DPKV_PROC+170w ...
RAM_41 equ 41h				; DATA XREF: DPKV_PROC+1E3w
					; IE0_0:code_2081r
RAM_42 equ 42h				; DATA XREF: ICMP0_ICMP7_0+2Cw
RAM_43 equ 43h				; DATA XREF: DPKV_PROC+25Ew
					; DPKV_PROC+269r ...
RAM_44 equ 44h				; DATA XREF: OnlineInit-9474w
					; ICMP0_ICMP7_0+16r ...
RAM_45 equ 45h				; DATA XREF: OnlineInit-9472w
					; ICMP0_ICMP7_0+1Cr ...
MainCicleDelay_RAM_46 equ 46h		; DATA XREF: Timer1Proc_1ms+2Aw
					; Timer1Proc_1ms+2Dw ...
					; ���稪 �६��� �� ����᪠ �������� 横�� ���᫥��� (20��)
					; dec 1	� ��ࠡ��稪� �1


TWAT equ 49h				; DATA XREF: IE0_0+DAr
					; OnlineInit:code_2A01w ...
RAM_4B equ 4Bh				; DATA XREF: OnlineInit-BC25w
					; OnlineInit-BC1Cw ...
COEFF_RCO equ 4Ch			; DATA XREF: DPKV_PROC+294r
					; OnlineInit-BA5Dw
					; �����樥�� ���४樨	RCO
Faza equ 4Dh				; DATA XREF: code_EB06:code_EB14r
					; code_EB06+24w
					; ���� ����᪠
TWAT_RT	equ 4Eh				; DATA XREF: IE0_0+F24r IE0_0+F31r ...
RAM_50 equ 50h				; DATA XREF: IE0_0+17E5r IE0_0+1A1Ar ...
SerialCount equ	51h			; DATA XREF: Timer1Proc_1ms+4Bw
					; Timer1Proc_1ms+4Dr ...
					; ���-�� ���� ��� ��।��
THR_CODE equ 52h			; DATA XREF: IE0_0+F13r IE0_0+14E4r ...
					; ��������� ���ᥫ�
RPM_XX equ 53h				; DATA XREF: OnlineInit-BA04w
					; OnlineInit:code_2E3Cw ...
					; ������� ��饭�� �����⥫� �� 宫��⮬ 室�
					; RPM /	10
RPM_1 equ 54h				; DATA XREF: IE0_0+160Ar
					; OnlineInit-BA02w ...
RPM equ	55h				; DATA XREF: OnlineInit-BA00w
					; OnlineInit-B899r ...
					; ������� ��饭�� �����⥫�
					; RPM /	40
RAM_56 equ 56h				; DATA XREF: Timer1Proc_1ms+2E3w

RPM_RT equ 57h				; DATA XREF: IE0_0+F1Ar IE0_0+1296r ...
					; ����⮢���� ������
RPM_RT_32 equ 58h			; DATA XREF: OnlineInit-BA9Ar
					; OnlineInit-BA90r ...
					; �������� �窠 �� ����⠬, ����⮢����� �� 32
RPM_RT_16 equ 59h			; DATA XREF: OnlineInit-B83Aw
					; OnlineInit-B7CCr ...
					; �������� �窠 �� ����⠬, ����⮢����� �� 16
RAM_5A equ 5Ah				; DATA XREF: OnlineInit-BF54w
					; OnlineInit-BA1Er ...
SysError equ 5Bh			; DATA XREF: OnlineInit:code_5582w
					; OnlineInit-9174w ...
					; ���⥬�� �訡��
					; Bit00="0335 - �訡�� ����"
					; Bit01="1610 - �������筮 �६��� � 横�� 1��"
					; Bit02="1603 - �訡�� EEPROM"
					; Bit03="0135 - �訡�� ���ॢ�⥫� ��"
					; Bit04="0340 - �訡�� ���稪� 䠧"
					; Bit05="1612 - �訡�� ��� ������"
					; Bit06="0603 - �訡�� ���"
					; Bit07="0601 - �訡�� ���"
GBC_RT equ 5Ch				; DATA XREF: IE0_0:code_1CB6w
					; IE0_0+1484r ...
GBC_RT_32 equ 5Dh			; DATA XREF: IE0_0+1482w IE0_0+1726r ...
GBC_RT_240 equ 5Eh			; DATA XREF: IE0_0+148Dw
					; OnlineInit-9006r
RPM_GBC_3D_RT equ 5Fh			; DATA XREF: IE0_0+1498w
					; OnlineInit-A4C0r ...
ALF_1 equ 60h				; DATA XREF: OnlineInit-BB9Aw
					; OnlineInit:code_457Bw ...
ALF_2 equ 61h				; DATA XREF: IE0_0:code_1E66r
					; OnlineInit-C377r ...
UOZXX_1	equ 62h				; DATA XREF: OnlineInit-A37Ew
					; OnlineInit-A1F8w ...
					; ��� �� ��
UOZXX_2	equ 63h				; DATA XREF: OnlineInit-9F54w
					; OnlineInit-9EDFr ...
					; ��� �� ��
UFRXX equ 64h				; DATA XREF: Timer1Proc_1ms:code_71Fr
					; OnlineInit-BAE9w ...
					; �����⠭��� (��������) ��������� ���
CRRXX equ 65h				; DATA XREF: Timer1Proc_1ms+1E1r
					; Timer1Proc_1ms+257w ...
					; ����饥 ��������� ���
RAM_66 equ 66h				; DATA XREF: Timer1Proc_1ms+1F6r
					; Timer1Proc_1ms:code_743w ...
RAM_67 equ 67h				; DATA XREF: Timer1Proc_1ms:code_718r
					; Timer1Proc_1ms+1DBw ...
					; �������� ࠧ���� ���
UGB equ	6Ah				; DATA XREF: OnlineInit-9A55r
					; OnlineInit:code_4D72r ...
					; ���室 ������ �१ ���
RAM_6B equ 6Bh				; DATA XREF: OnlineInit:code_4A82r
					; OnlineInit:code_4AA5r ...
RAM_6C equ 6Ch				; DATA XREF: OnlineInit-9B01w
					; OnlineInit-9A69w ...
DELTA_RPM_XX equ 6Dh			; DATA XREF: OnlineInit:code_47CCw
					; OnlineInit-9F28r ...
					; �⪫������ ⥪��� ����⮢ �� �� ��������
RAM_6E equ 6Eh				; DATA XREF: OnlineInit-BDD9w
					; OnlineInit-96D7r ...
COEFF equ 6Fh				; DATA XREF: IE0_0+175Fr IE0_0+1767r ...
					; �����樥�� ���४樨	�६���	����᪠
RAM_70 equ 70h				; DATA XREF: Lambda_Reg+12w
					; Lambda_Reg:code_A580w ...
RAM_71 equ 71h				; DATA XREF: IE0_0+1A6w code_B4E3+6Cr	...
ADC_DD equ 72h				; DATA XREF: DPKV_PROC:code_3BCr
					; OnlineInit-BA5Fw
					; ���, ��
RAM_73 equ 73h				; DATA XREF: SerialRead_Write:code_D504w
					; SerialRead_Write+6Fr
RAM_74 equ 74h				; DATA XREF: DPKV_PROC+2AAw IE0_0+1Ar
RAM_75 equ 75h				; DATA XREF: DPKV_PROC+2ADw IE0_0+1Cr
RAM_76 equ 76h				; DATA XREF: Timer1Proc_1ms+2CAw
					; Timer1Proc_1ms+2CCw ...
					; ��� �ࠢ����� �������� ���ࡥ�
RAM_77 equ 77h				; DATA XREF: Timer1Proc_1ms+2D1r
					; OnlineInit-BDCBw ...
					; ��� �ࠢ����� �������� ���ࡥ�
SerialCurrentByte equ 78h		; DATA XREF: CT1Fw Timer1Proc_1ms+35w	...
RAM_79 equ 79h				; DATA XREF: Timer1Proc_1ms+C7w
					; OnlineInit-A459r ...
DEV_FLAGS equ 7Ah			; DATA XREF: Timer1Proc_1ms+C9w
					; OnlineInit:code_37E9r ...
					; �����	�ࠢ����� �ᯮ���⥫�묨 ��堭������
RAM_7B equ 7Bh				; DATA XREF: Timer1Proc_1ms+CBw
					; OnlineInit-AE03r ...
RAM_7C equ 7Ch				; DATA XREF: Timer1Proc_1ms+CDw
					; Timer1Proc_1ms+11Ar ...
RAM_7D equ 7Dh				; DATA XREF: Timer1Proc_1ms+CFw
					; OnlineInit:code_4539r ...
SerialBuffIndex	equ 7Eh			; DATA XREF: InitSerialReadBuffer+1w
					; code_C6BD+9w	...
RAM_7F equ 7Fh				; DATA XREF: Timer1Proc_1ms:code_820w
					; OnlineInit-907Ar ...
; end of 'RAM'                          ; ���-�� �����ᮢ � ��� (�� ����� 10)

; ===========================================================================
