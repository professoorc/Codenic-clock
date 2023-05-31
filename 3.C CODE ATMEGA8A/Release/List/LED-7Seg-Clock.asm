
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _positionNumber=R5
	.DEF _h=R4
	.DEF _m=R7
	.DEF _s=R6
	.DEF _left=R9
	.DEF _right=R8
	.DEF _timedisabeHomeTemp=R11
	.DEF _runnigState=R10
	.DEF _menuPosition=R13
	.DEF _clickState=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP _ext_int1_isr
	RJMP _timer2_comp_isr
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x4

_0x3:
	.DB  0x1,0x1,0x1,0x1,0x1
_0x4:
	.DB  0x63
_0x5:
	.DB  0x3C

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x05
	.DW  _portEnable
	.DW  _0x3*2

	.DW  0x01
	.DW  _brightnessSet
	.DW  _0x4*2

	.DW  0x01
	.DW  _tempSecondBip
	.DW  _0x5*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <i2c.h>
;#include <ds1307.h>
;#include <stdio.h>
;
;#define alarmTime 9 // means 4.5 second
;#define exitMenuTime 32000 //means about  second
;#define dateShowOffTime 8000 //means about 7 second
;#define dateShowOnTime 5 //means about 1 second
;#define fastEditBrightnessTimeon 5 //means about 1 second
;#define buzzerPin PORTD.1
;#define sevenSegmentPins PORTB
;#define clickPin !PIND.0
;#define fastEditBrightnessMultiple 5 //means 5 percent change
;#define blinkWhenChangeNumberTimeOn 4
;#define blinkWhenChangeNumberTimeOff 1
;
;eeprom unsigned char alMinute,alHour,brightnessMem,alarmSet,muteState1;
;
;enum commandType
;{
;    HOME ,
;    BRIGHTNESSHOME ,
;    SHOWDATE ,
;    MENU ,
;    SETTIME ,
;    SETDATE ,
;    SETALARM ,
;    EXIT,
;    BRIGHTNESS,
;    ALARM,
;    MUTE,
;    SUM,
;    MINUS ,
;    ON ,
;    OFF,
;    CLOCK ,
;    ONE ,
;    BIP ,
;    EVER
;};
;
;unsigned char positionNumber=1,segmentPinState[4],h=0,m=0,s=0,left=0,right=0,timedisabeHomeTemp=0,runnigState=HOME,menuP ...
;unsigned char counterBlinkNumber=0,blinkNumberChageState=0,portEnable[5]={1,1,1,1,1},brightnessSet=99,muteState=0,ym=0,m ...

	.DSEG
;int ys=0,ms=0,ds=0,counterSecondTime=0;
;
;void brightness(unsigned char timeBR);
;void portConfig();
;void stopIntrupts();
;void startIntrupts();
;void startTimers();
;void stopTimers() ;
;void backToHome(unsigned char timeStop);
;void startCounterTimer();
;void stopCounterTimer();
;void fastEditBrightness(unsigned char addOrMinus);
;void blinkNumberChangeTimer();
;void digitalWritePortC (unsigned char portNumber);
;void buzzer(unsigned int timeBuzz,unsigned int timeSleep);
;
;void dotBlink(unsigned char state){
; 0000 003E void dotBlink(unsigned char state){

	.CSEG
_dotBlink:
; .FSTART _dotBlink
; 0000 003F     switch (state)
	RCALL SUBOPT_0x0
;	state -> Y+0
; 0000 0040     {
; 0000 0041     case OFF:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x9
; 0000 0042         rtc_write(0x07,0x00);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x140
; 0000 0043         break;
; 0000 0044     case ON:
_0x9:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x8
; 0000 0045         rtc_write(0x07,0x10);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(16)
_0x140:
	RCALL _rtc_write
; 0000 0046         break;
; 0000 0047     }}
_0x8:
	RJMP _0x20A0009
; .FEND
;int m2s(int ym,int mm,int dm,int *ys,int *ms,int *ds)
; 0000 0049 {
_m2s:
; .FSTART _m2s
; 0000 004A unsigned long int ys1,ym1;
; 0000 004B int ym2,ys2,mm1,ms1,k,ms0;
; 0000 004C ym1=ym+2000;
	RCALL SUBOPT_0x1
	SBIW R28,14
	RCALL __SAVELOCR6
;	ym -> Y+30
;	mm -> Y+28
;	dm -> Y+26
;	*ys -> Y+24
;	*ms -> Y+22
;	*ds -> Y+20
;	ys1 -> Y+16
;	ym1 -> Y+12
;	ym2 -> R16,R17
;	ys2 -> R18,R19
;	mm1 -> R20,R21
;	ms1 -> Y+10
;	k -> Y+8
;	ms0 -> Y+6
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 004D k=ym1%4;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ANDI R30,LOW(0x3)
	ANDI R31,HIGH(0x3)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 004E ym1--;
	RCALL SUBOPT_0x5
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	RCALL SUBOPT_0x4
; 0000 004F ym1=ym1*365;
	RCALL SUBOPT_0x5
	__GETD2N 0x16D
	RCALL __MULD12U
	RCALL SUBOPT_0x4
; 0000 0050 if(mm==1){mm1=0;}
	RCALL SUBOPT_0x6
	SBIW R26,1
	BRNE _0xB
	__GETWRN 20,21,0
; 0000 0051 if(mm==2){mm1=31;}
_0xB:
	RCALL SUBOPT_0x6
	SBIW R26,2
	BRNE _0xC
	__GETWRN 20,21,31
; 0000 0052 if(mm==3){mm1=59;}
_0xC:
	RCALL SUBOPT_0x6
	SBIW R26,3
	BRNE _0xD
	__GETWRN 20,21,59
; 0000 0053 if(mm==4){mm1=90;}
_0xD:
	RCALL SUBOPT_0x6
	SBIW R26,4
	BRNE _0xE
	__GETWRN 20,21,90
; 0000 0054 if(mm==5){mm1=120;}
_0xE:
	RCALL SUBOPT_0x6
	SBIW R26,5
	BRNE _0xF
	__GETWRN 20,21,120
; 0000 0055 if(mm==6){mm1=151;}
_0xF:
	RCALL SUBOPT_0x6
	SBIW R26,6
	BRNE _0x10
	__GETWRN 20,21,151
; 0000 0056 if(mm==7){mm1=181;}
_0x10:
	RCALL SUBOPT_0x6
	SBIW R26,7
	BRNE _0x11
	__GETWRN 20,21,181
; 0000 0057 if(mm==8){mm1=212;}
_0x11:
	RCALL SUBOPT_0x6
	SBIW R26,8
	BRNE _0x12
	__GETWRN 20,21,212
; 0000 0058 if(mm==9){mm1=243;}
_0x12:
	RCALL SUBOPT_0x6
	SBIW R26,9
	BRNE _0x13
	__GETWRN 20,21,243
; 0000 0059 if(mm==10){mm1=273;}
_0x13:
	RCALL SUBOPT_0x6
	SBIW R26,10
	BRNE _0x14
	__GETWRN 20,21,273
; 0000 005A if(mm==11){mm1=304;}
_0x14:
	RCALL SUBOPT_0x6
	SBIW R26,11
	BRNE _0x15
	__GETWRN 20,21,304
; 0000 005B if(mm==12){mm1=334;}
_0x15:
	RCALL SUBOPT_0x6
	SBIW R26,12
	BRNE _0x16
	__GETWRN 20,21,334
; 0000 005C if(k==0){mm1++;}
_0x16:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x17
	__ADDWRN 20,21,1
; 0000 005D ym1=ym1+mm1;
_0x17:
	MOVW R30,R20
	RCALL SUBOPT_0x7
; 0000 005E ym1=ym1+dm;
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	RCALL SUBOPT_0x7
; 0000 005F ym2=ym+2000;
	RCALL SUBOPT_0x2
	MOVW R16,R30
; 0000 0060 ym2--;
	__SUBWRN 16,17,1
; 0000 0061 ym2=ym2/4;
	MOVW R26,R16
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL __DIVW21
	MOVW R16,R30
; 0000 0062 ym1=ym1+ym2;
	RCALL SUBOPT_0x7
; 0000 0063 ym1=ym1-226899;
	RCALL SUBOPT_0x5
	__SUBD1N 226899
	RCALL SUBOPT_0x4
; 0000 0064 ys2=ym2-155;
	MOVW R30,R16
	SUBI R30,LOW(155)
	SBCI R31,HIGH(155)
	MOVW R18,R30
; 0000 0065 ys1=ym1-ys2;
	__GETD2S 12
	RCALL SUBOPT_0x3
	RCALL __SUBD21
	__PUTD2S 16
; 0000 0066 *ys=ys1/365;
	RCALL SUBOPT_0x8
	RCALL __DIVD21U
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 0067 *ys=*ys-1299;
	RCALL SUBOPT_0x9
	RCALL __GETW1P
	SUBI R30,LOW(1299)
	SBCI R31,HIGH(1299)
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 0068 ms1=ys1%365;
	RCALL SUBOPT_0x8
	RCALL __MODD21U
	RCALL SUBOPT_0xB
; 0000 0069 ms0=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0xC
; 0000 006A if(ms1>31){ms0++;ms1=ms1-31;}
	RCALL SUBOPT_0xD
	BRLT _0x18
	RCALL SUBOPT_0xE
; 0000 006B if(ms1>31){ms0++;ms1=ms1-31;}
_0x18:
	RCALL SUBOPT_0xD
	BRLT _0x19
	RCALL SUBOPT_0xE
; 0000 006C if(ms1>31){ms0++;ms1=ms1-31;}
_0x19:
	RCALL SUBOPT_0xD
	BRLT _0x1A
	RCALL SUBOPT_0xE
; 0000 006D if(ms1>31){ms0++;ms1=ms1-31;}
_0x1A:
	RCALL SUBOPT_0xD
	BRLT _0x1B
	RCALL SUBOPT_0xE
; 0000 006E if(ms1>31){ms0++;ms1=ms1-31;}
_0x1B:
	RCALL SUBOPT_0xD
	BRLT _0x1C
	RCALL SUBOPT_0xE
; 0000 006F if(ms1>31){ms0++;ms1=ms1-31;}
_0x1C:
	RCALL SUBOPT_0xD
	BRLT _0x1D
	RCALL SUBOPT_0xE
; 0000 0070 if(ms1>30){ms0++;ms1=ms1-30;}
_0x1D:
	RCALL SUBOPT_0xF
	BRLT _0x1E
	RCALL SUBOPT_0x10
; 0000 0071 if(ms1>30){ms0++;ms1=ms1-30;}
_0x1E:
	RCALL SUBOPT_0xF
	BRLT _0x1F
	RCALL SUBOPT_0x10
; 0000 0072 if(ms1>30){ms0++;ms1=ms1-30;}
_0x1F:
	RCALL SUBOPT_0xF
	BRLT _0x20
	RCALL SUBOPT_0x10
; 0000 0073 if(ms1>30){ms0++;ms1=ms1-30;}
_0x20:
	RCALL SUBOPT_0xF
	BRLT _0x21
	RCALL SUBOPT_0x10
; 0000 0074 if(ms1>30){ms0++;ms1=ms1-30;}
_0x21:
	RCALL SUBOPT_0xF
	BRLT _0x22
	RCALL SUBOPT_0x10
; 0000 0075 *ds=ms1;
_0x22:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL SUBOPT_0xA
; 0000 0076 *ms=ms0;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	RCALL SUBOPT_0xA
; 0000 0077 return *ys;
	RCALL SUBOPT_0x9
; 0000 0078 return *ms;
; 0000 0079 return *ds;
_0x20A000C:
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,32
	RET
; 0000 007A }
; .FEND
;void buzzer(unsigned int timeBuzz,unsigned int timeSleep){
; 0000 007B void buzzer(unsigned int timeBuzz,unsigned int timeSleep){
_buzzer:
; .FSTART _buzzer
; 0000 007C if(muteState1){buzzerPin=1;
	RCALL SUBOPT_0x1
;	timeBuzz -> Y+2
;	timeSleep -> Y+0
	LDI  R26,LOW(_muteState1)
	LDI  R27,HIGH(_muteState1)
	RCALL __EEPROMRDB
	CPI  R30,0
	BREQ _0x23
	SBI  0x12,1
; 0000 007D delay_ms(timeBuzz);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL _delay_ms
; 0000 007E buzzerPin=0;
	CBI  0x12,1
; 0000 007F if(timeSleep>0)delay_ms(timeSleep);
	RCALL SUBOPT_0x11
	RCALL __CPW02
	BRSH _0x28
	RCALL SUBOPT_0x11
	RCALL _delay_ms
; 0000 0080 }}
_0x28:
_0x23:
	RJMP _0x20A0001
; .FEND
;void changePositionNumber(unsigned char position){
; 0000 0081 void changePositionNumber(unsigned char position){
_changePositionNumber:
; .FSTART _changePositionNumber
; 0000 0082 PORTC=PORTC&0xf0;
	ST   -Y,R26
;	position -> Y+0
	IN   R30,0x15
	ANDI R30,LOW(0xF0)
	OUT  0x15,R30
; 0000 0083  switch (position) {
	RCALL SUBOPT_0x12
; 0000 0084     case 1 :
	BRNE _0x2C
; 0000 0085     digitalWritePortC(1);
	LDI  R26,LOW(1)
	RJMP _0x141
; 0000 0086     break;
; 0000 0087     case 2 :
_0x2C:
	RCALL SUBOPT_0x13
	BRNE _0x2D
; 0000 0088     digitalWritePortC(2);
	LDI  R26,LOW(2)
	RJMP _0x141
; 0000 0089     break;
; 0000 008A     case 3 :
_0x2D:
	RCALL SUBOPT_0x14
	BRNE _0x2E
; 0000 008B     digitalWritePortC(3);
	LDI  R26,LOW(3)
	RJMP _0x141
; 0000 008C     break;
; 0000 008D     case 4 :
_0x2E:
	RCALL SUBOPT_0x15
	BRNE _0x2B
; 0000 008E     digitalWritePortC(4);
	LDI  R26,LOW(4)
_0x141:
	RCALL _digitalWritePortC
; 0000 008F     break;
; 0000 0090     };
_0x2B:
; 0000 0091 }
	RJMP _0x20A0009
; .FEND
;void digitalWritePortC (unsigned char portNumber){
; 0000 0092 void digitalWritePortC (unsigned char portNumber){
_digitalWritePortC:
; .FSTART _digitalWritePortC
; 0000 0093      switch (portNumber) {
	RCALL SUBOPT_0x0
;	portNumber -> Y+0
; 0000 0094     case 1 :
	RCALL SUBOPT_0x16
	BRNE _0x33
; 0000 0095     if(portEnable[1])PORTC.0=1;
	__GETB1MN _portEnable,1
	CPI  R30,0
	BREQ _0x34
	SBI  0x15,0
; 0000 0096     break;
_0x34:
	RJMP _0x32
; 0000 0097     case 2 :
_0x33:
	RCALL SUBOPT_0x13
	BRNE _0x37
; 0000 0098     if(portEnable[2])PORTC.1=1;
	__GETB1MN _portEnable,2
	CPI  R30,0
	BREQ _0x38
	SBI  0x15,1
; 0000 0099     break;
_0x38:
	RJMP _0x32
; 0000 009A     case 3 :
_0x37:
	RCALL SUBOPT_0x14
	BRNE _0x3B
; 0000 009B     if(portEnable[3])PORTC.2=1;
	__GETB1MN _portEnable,3
	CPI  R30,0
	BREQ _0x3C
	SBI  0x15,2
; 0000 009C     break;
_0x3C:
	RJMP _0x32
; 0000 009D     case 4 :
_0x3B:
	RCALL SUBOPT_0x15
	BRNE _0x32
; 0000 009E     if(portEnable[4])PORTC.3=1;
	__GETB1MN _portEnable,4
	CPI  R30,0
	BREQ _0x40
	SBI  0x15,3
; 0000 009F     break;
_0x40:
; 0000 00A0     };
_0x32:
; 0000 00A1 }
	RJMP _0x20A0009
; .FEND
;unsigned char digitalWritePort ( unsigned char input){
; 0000 00A2 unsigned char digitalWritePort ( unsigned char input){
_digitalWritePort:
; .FSTART _digitalWritePort
; 0000 00A3  switch (input) {
	RCALL SUBOPT_0x0
;	input -> Y+0
; 0000 00A4     case 1:
	RCALL SUBOPT_0x16
	BRNE _0x46
; 0000 00A5     return 6 ;
	LDI  R30,LOW(6)
	RJMP _0x20A0009
; 0000 00A6     case 2:
_0x46:
	RCALL SUBOPT_0x13
	BRNE _0x47
; 0000 00A7     return 91 ;
	LDI  R30,LOW(91)
	RJMP _0x20A0009
; 0000 00A8     case 3:
_0x47:
	RCALL SUBOPT_0x14
	BRNE _0x48
; 0000 00A9     return 79 ;
	LDI  R30,LOW(79)
	RJMP _0x20A0009
; 0000 00AA     case 4:
_0x48:
	RCALL SUBOPT_0x15
	BRNE _0x49
; 0000 00AB     return 102 ;
	LDI  R30,LOW(102)
	RJMP _0x20A0009
; 0000 00AC     case 5:
_0x49:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4A
; 0000 00AD     return 109 ;
	LDI  R30,LOW(109)
	RJMP _0x20A0009
; 0000 00AE     case 6:
_0x4A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x4B
; 0000 00AF     return 125 ;
	LDI  R30,LOW(125)
	RJMP _0x20A0009
; 0000 00B0     case 7:
_0x4B:
	RCALL SUBOPT_0x17
	BRNE _0x4C
; 0000 00B1     return 7 ;
	LDI  R30,LOW(7)
	RJMP _0x20A0009
; 0000 00B2     case 8:
_0x4C:
	RCALL SUBOPT_0x18
	BRNE _0x4D
; 0000 00B3     return 127 ;
	LDI  R30,LOW(127)
	RJMP _0x20A0009
; 0000 00B4     case 9:
_0x4D:
	RCALL SUBOPT_0x19
	BRNE _0x4E
; 0000 00B5     return 111 ;
	LDI  R30,LOW(111)
	RJMP _0x20A0009
; 0000 00B6     case 0:
_0x4E:
	SBIW R30,0
	BRNE _0x4F
; 0000 00B7     return 63 ;
	LDI  R30,LOW(63)
	RJMP _0x20A0009
; 0000 00B8     case 'e':
_0x4F:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x50
; 0000 00B9     return 121 ;
	LDI  R30,LOW(121)
	RJMP _0x20A0009
; 0000 00BA     case 'r':
_0x50:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x51
; 0000 00BB     return 112 ;
	LDI  R30,LOW(112)
	RJMP _0x20A0009
; 0000 00BC     case 'b':
_0x51:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x52
; 0000 00BD     return 124 ;
	LDI  R30,LOW(124)
	RJMP _0x20A0009
; 0000 00BE     case 'p':
_0x52:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x53
; 0000 00BF     return 115 ;
	LDI  R30,LOW(115)
	RJMP _0x20A0009
; 0000 00C0     case 'o':
_0x53:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x54
; 0000 00C1     return 92 ;
	LDI  R30,LOW(92)
	RJMP _0x20A0009
; 0000 00C2     case 'f':
_0x54:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x55
; 0000 00C3     return 113 ;
	LDI  R30,LOW(113)
	RJMP _0x20A0009
; 0000 00C4     case 'l':
_0x55:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x56
; 0000 00C5     return 56 ;
	LDI  R30,LOW(56)
	RJMP _0x20A0009
; 0000 00C6     case 'c':
_0x56:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x57
; 0000 00C7     return 88 ;
	LDI  R30,LOW(88)
	RJMP _0x20A0009
; 0000 00C8     case 't':
_0x57:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x58
; 0000 00C9     return 120 ;
	LDI  R30,LOW(120)
	RJMP _0x20A0009
; 0000 00CA     case 'x':
_0x58:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x59
; 0000 00CB     return 118 ;
	LDI  R30,LOW(118)
	RJMP _0x20A0009
; 0000 00CC     case 'a':
_0x59:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x5A
; 0000 00CD     return 119 ;
	LDI  R30,LOW(119)
	RJMP _0x20A0009
; 0000 00CE     case 'i':
_0x5A:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x5B
; 0000 00CF     return 48 ;
	LDI  R30,LOW(48)
	RJMP _0x20A0009
; 0000 00D0     case 'h':
_0x5B:
	CPI  R30,LOW(0x68)
	LDI  R26,HIGH(0x68)
	CPC  R31,R26
	BRNE _0x5C
; 0000 00D1     return 116 ;
	LDI  R30,LOW(116)
	RJMP _0x20A0009
; 0000 00D2     case 'v':
_0x5C:
	CPI  R30,LOW(0x76)
	LDI  R26,HIGH(0x76)
	CPC  R31,R26
	BRNE _0x5D
; 0000 00D3     return 62 ;
	LDI  R30,LOW(62)
	RJMP _0x20A0009
; 0000 00D4     case '.':
_0x5D:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0x5E
; 0000 00D5     return 0 ;
	LDI  R30,LOW(0)
	RJMP _0x20A0009
; 0000 00D6     case 'd':
_0x5E:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x5F
; 0000 00D7     return 94 ;
	LDI  R30,LOW(94)
	RJMP _0x20A0009
; 0000 00D8     case 'n':
_0x5F:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x45
; 0000 00D9     return 84 ;
	LDI  R30,LOW(84)
	RJMP _0x20A0009
; 0000 00DA     };
_0x45:
; 0000 00DB }
	RJMP _0x20A0009
; .FEND
;void showString(unsigned char counterSegment,unsigned char input,unsigned char numberSegment)
; 0000 00DD {
_showString:
; .FSTART _showString
; 0000 00DE     counterSegment--;
	ST   -Y,R26
;	counterSegment -> Y+2
;	input -> Y+1
;	numberSegment -> Y+0
	LDD  R30,Y+2
	SUBI R30,LOW(1)
	STD  Y+2,R30
; 0000 00DF     if(counterSegment){
	CPI  R30,0
	BREQ _0x61
; 0000 00E0     switch (numberSegment) {
	RCALL SUBOPT_0x12
; 0000 00E1     case 1 :
	BRNE _0x65
; 0000 00E2       segmentPinState[numberSegment-1]= digitalWritePort(input/10);
	RCALL SUBOPT_0x1A
	SBIW R30,1
	RCALL SUBOPT_0x1B
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1C
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00E3       segmentPinState[numberSegment]= digitalWritePort(input%10);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1D
	POP  R26
	POP  R27
	RJMP _0x142
; 0000 00E4     break;
; 0000 00E5     case 2 :
_0x65:
	RCALL SUBOPT_0x13
	BRNE _0x64
; 0000 00E6       segmentPinState[numberSegment]= digitalWritePort(input/10);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1C
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00E7       segmentPinState[numberSegment+1]= digitalWritePort(input%10);
	RCALL SUBOPT_0x1A
	__ADDW1MN _segmentPinState,1
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1D
	POP  R26
	POP  R27
_0x142:
	ST   X,R30
; 0000 00E8     break;
; 0000 00E9     }; }else{
_0x64:
	RJMP _0x67
_0x61:
; 0000 00EA       segmentPinState[numberSegment-1]= digitalWritePort(input);
	RCALL SUBOPT_0x1A
	SBIW R30,1
	RCALL SUBOPT_0x1B
	PUSH R31
	PUSH R30
	LDD  R26,Y+1
	RCALL _digitalWritePort
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00EB     }
_0x67:
; 0000 00EC }
	RJMP _0x20A0003
; .FEND
;void blinkNumber(){
; 0000 00ED void blinkNumber(){
_blinkNumber:
; .FSTART _blinkNumber
; 0000 00EE     switch (positionNumber) {
	MOV  R30,R5
	LDI  R31,0
; 0000 00EF     case 1 :
	RCALL SUBOPT_0x16
	BRNE _0x6B
; 0000 00F0      sevenSegmentPins=segmentPinState[0];
	LDS  R30,_segmentPinState
	RCALL SUBOPT_0x1E
; 0000 00F1      changePositionNumber(positionNumber);
; 0000 00F2     positionNumber=2;
	LDI  R30,LOW(2)
	RJMP _0x143
; 0000 00F3     break;
; 0000 00F4     case 2 :
_0x6B:
	RCALL SUBOPT_0x13
	BRNE _0x6C
; 0000 00F5      sevenSegmentPins=segmentPinState[1];
	__GETB1MN _segmentPinState,1
	RCALL SUBOPT_0x1E
; 0000 00F6      changePositionNumber(positionNumber);
; 0000 00F7      positionNumber=3;
	LDI  R30,LOW(3)
	RJMP _0x143
; 0000 00F8     break;
; 0000 00F9     case 3 :
_0x6C:
	RCALL SUBOPT_0x14
	BRNE _0x6D
; 0000 00FA      sevenSegmentPins=segmentPinState[2];
	__GETB1MN _segmentPinState,2
	RCALL SUBOPT_0x1E
; 0000 00FB      changePositionNumber(positionNumber);
; 0000 00FC      positionNumber=4;
	LDI  R30,LOW(4)
	RJMP _0x143
; 0000 00FD     break;
; 0000 00FE     case 4 :
_0x6D:
	RCALL SUBOPT_0x15
	BRNE _0x6A
; 0000 00FF      sevenSegmentPins=segmentPinState[3];
	__GETB1MN _segmentPinState,3
	RCALL SUBOPT_0x1E
; 0000 0100      changePositionNumber(positionNumber);
; 0000 0101      positionNumber=1;
	LDI  R30,LOW(1)
_0x143:
	MOV  R5,R30
; 0000 0102     break;
; 0000 0103     };
_0x6A:
; 0000 0104     counterSecondTime++;
	LDI  R26,LOW(_counterSecondTime)
	LDI  R27,HIGH(_counterSecondTime)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0105 }
	RET
; .FEND
;void resetClickState(){
; 0000 0106 void resetClickState(){
_resetClickState:
; .FSTART _resetClickState
; 0000 0107     clickState=0;
	CLR  R12
; 0000 0108 }
	RET
; .FEND
;void setClickState(){
; 0000 0109 void setClickState(){
_setClickState:
; .FSTART _setClickState
; 0000 010A     clickState=1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 010B }
	RET
; .FEND
;void resetVolume(){
; 0000 010C void resetVolume(){
_resetVolume:
; .FSTART _resetVolume
; 0000 010D         right=0;left=0;
	CLR  R8
	CLR  R9
; 0000 010E }
	RET
; .FEND
;void resetCounterSecondTime(){
; 0000 010F void resetCounterSecondTime(){
_resetCounterSecondTime:
; .FSTART _resetCounterSecondTime
; 0000 0110     counterSecondTime=0;
	LDI  R30,LOW(0)
	STS  _counterSecondTime,R30
	STS  _counterSecondTime+1,R30
; 0000 0111 }
	RET
; .FEND
;void volumeCheck(){
; 0000 0112 void volumeCheck(){
_volumeCheck:
; .FSTART _volumeCheck
; 0000 0113             if(clickPin){
	SBIC 0x10,0
	RJMP _0x6F
; 0000 0114             while(clickPin);
_0x70:
	SBIS 0x10,0
	RJMP _0x70
; 0000 0115             buzzer(100,0);
	RCALL SUBOPT_0x1F
; 0000 0116             setClickState();
	RCALL _setClickState
; 0000 0117             resetCounterSecondTime();
	RCALL _resetCounterSecondTime
; 0000 0118             if(runnigState==HOME){
	TST  R10
	BRNE _0x73
; 0000 0119                 dotBlink(OFF);
	RCALL SUBOPT_0x20
; 0000 011A                 runnigState=MENU;
	LDI  R30,LOW(3)
	MOV  R10,R30
; 0000 011B                 resetClickState();
	RCALL _resetClickState
; 0000 011C             }}
_0x73:
; 0000 011D             switch (runnigState)
_0x6F:
	MOV  R30,R10
	LDI  R31,0
; 0000 011E             {
; 0000 011F             case MENU :
	RCALL SUBOPT_0x14
	BRNE _0x77
; 0000 0120                 if(counterSecondTime>exitMenuTime){
	RCALL SUBOPT_0x21
	CPI  R26,LOW(0x7D01)
	LDI  R30,HIGH(0x7D01)
	CPC  R27,R30
	BRLT _0x78
; 0000 0121                     resetCounterSecondTime();
	RCALL _resetCounterSecondTime
; 0000 0122                     runnigState=HOME;
	CLR  R10
; 0000 0123                     buzzer(100,0);}
	RCALL SUBOPT_0x1F
; 0000 0124                 break;
_0x78:
	RJMP _0x76
; 0000 0125                 case HOME :
_0x77:
	SBIW R30,0
	BRNE _0x76
; 0000 0126                 if(counterSecondTime>dateShowOffTime){
	RCALL SUBOPT_0x21
	CPI  R26,LOW(0x1F41)
	LDI  R30,HIGH(0x1F41)
	CPC  R27,R30
	BRLT _0x7A
; 0000 0127                     runnigState=SHOWDATE;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 0128                     backToHome(dateShowOnTime);
	LDI  R26,LOW(5)
	RCALL _backToHome
; 0000 0129                     resetCounterSecondTime();
	RCALL _resetCounterSecondTime
; 0000 012A                 }
; 0000 012B                if(right==2|left==2){
_0x7A:
	MOV  R26,R8
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x22
	MOV  R26,R9
	LDI  R30,LOW(2)
	RCALL __EQB12
	OR   R30,R0
	BREQ _0x7B
; 0000 012C                 runnigState=BRIGHTNESSHOME;}
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 012D                 break;
_0x7B:
; 0000 012E             }
_0x76:
; 0000 012F }
	RET
; .FEND
;void fastEditBrightness(unsigned char addOrMinus){
; 0000 0130 void fastEditBrightness(unsigned char addOrMinus){
_fastEditBrightness:
; .FSTART _fastEditBrightness
; 0000 0131             unsigned char counterFor=0;
; 0000 0132             for(counterFor=0;counterFor<fastEditBrightnessMultiple;counterFor++){
	ST   -Y,R26
	ST   -Y,R17
;	addOrMinus -> Y+1
;	counterFor -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x7D:
	CPI  R17,5
	BRSH _0x7E
; 0000 0133                 switch (addOrMinus)
	LDD  R30,Y+1
	LDI  R31,0
; 0000 0134                 {
; 0000 0135                      case SUM:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x82
; 0000 0136                      if(brightnessSet<99)brightnessSet++;
	RCALL SUBOPT_0x23
	CPI  R26,LOW(0x63)
	BRSH _0x83
	RCALL SUBOPT_0x24
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x25
; 0000 0137                     break;
_0x83:
	RJMP _0x81
; 0000 0138                     case MINUS:
_0x82:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x81
; 0000 0139                      if(brightnessSet>1)brightnessSet--;
	RCALL SUBOPT_0x23
	CPI  R26,LOW(0x2)
	BRLO _0x85
	RCALL SUBOPT_0x24
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x25
; 0000 013A                     break;
_0x85:
; 0000 013B                 }
_0x81:
; 0000 013C             }
	SUBI R17,-1
	RJMP _0x7D
_0x7E:
; 0000 013D                brightness(brightnessSet);
	RCALL SUBOPT_0x23
	RCALL _brightness
; 0000 013E                backToHome(fastEditBrightnessTimeon);
	LDI  R26,LOW(5)
	RCALL _backToHome
; 0000 013F                showString(2,brightnessSet,2);
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x27
; 0000 0140                showString(1,'b',1);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
; 0000 0141                showString(1,'r',2);
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
; 0000 0142 }
	LDD  R17,Y+0
	RJMP _0x20A0004
; .FEND
;void backToHome(unsigned char timeStop){
; 0000 0143 void backToHome(unsigned char timeStop){
_backToHome:
; .FSTART _backToHome
; 0000 0144  timedisabeHomeTemp = timeStop;
	ST   -Y,R26
;	timeStop -> Y+0
	LDD  R11,Y+0
; 0000 0145  startCounterTimer();
	RCALL _startCounterTimer
; 0000 0146  disabeHomeTempState=1;
	LDI  R30,LOW(1)
	STS  _disabeHomeTempState,R30
; 0000 0147 }
	RJMP _0x20A0009
; .FEND
;void checkTimeDisabeHomeTemp(){
; 0000 0148 void checkTimeDisabeHomeTemp(){
_checkTimeDisabeHomeTemp:
; .FSTART _checkTimeDisabeHomeTemp
; 0000 0149   if(disabeHomeTempState){
	LDS  R30,_disabeHomeTempState
	CPI  R30,0
	BREQ _0x86
; 0000 014A     if(timedisabeHomeTemp>0){
	LDI  R30,LOW(0)
	CP   R30,R11
	BRSH _0x87
; 0000 014B      timedisabeHomeTemp-- ;
	DEC  R11
; 0000 014C      }else{
	RJMP _0x88
_0x87:
; 0000 014D      stopCounterTimer();
	RCALL _stopCounterTimer
; 0000 014E      runnigState=HOME;
	CLR  R10
; 0000 014F      disabeHomeTempState=0;
	LDI  R30,LOW(0)
	STS  _disabeHomeTempState,R30
; 0000 0150      }
_0x88:
; 0000 0151   }
; 0000 0152 }
_0x86:
	RET
; .FEND
;unsigned char checkVolumeRight(){
; 0000 0153 unsigned char checkVolumeRight(){
_checkVolumeRight:
; .FSTART _checkVolumeRight
; 0000 0154     if(left==2){
	LDI  R30,LOW(2)
	CP   R30,R9
	BREQ _0x20A000B
; 0000 0155         buzzer(3,0);
; 0000 0156         resetVolume();
; 0000 0157         return 1;
; 0000 0158     }else{return 0;}}
	RJMP _0x20A000A
; .FEND
;unsigned char checkVolumeLeft(){
; 0000 0159 unsigned char checkVolumeLeft(){
_checkVolumeLeft:
; .FSTART _checkVolumeLeft
; 0000 015A     if(right==2){
	LDI  R30,LOW(2)
	CP   R30,R8
	BRNE _0x8B
; 0000 015B         buzzer(3,0);
_0x20A000B:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x2C
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _buzzer
; 0000 015C         resetVolume();
	RCALL _resetVolume
; 0000 015D         return 1;
	LDI  R30,LOW(1)
	RET
; 0000 015E     }else{return 0;}}
_0x8B:
_0x20A000A:
	LDI  R30,LOW(0)
	RET
	RET
; .FEND
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0160 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0x2D
; 0000 0161     switch (left) {
	MOV  R30,R9
	RCALL SUBOPT_0x2E
; 0000 0162     case 0 :
	BRNE _0x90
; 0000 0163     right=1;
	LDI  R30,LOW(1)
	RJMP _0x144
; 0000 0164     break;
; 0000 0165     case 1 :
_0x90:
	RCALL SUBOPT_0x16
	BRNE _0x8F
; 0000 0166     right=2;
	LDI  R30,LOW(2)
_0x144:
	MOV  R8,R30
; 0000 0167     break;
; 0000 0168     };
_0x8F:
; 0000 0169     resetCounterSecondTime();
	RCALL _resetCounterSecondTime
; 0000 016A }
	RJMP _0x146
; .FEND
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 016C {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x2D
; 0000 016D     switch (right) {
	MOV  R30,R8
	RCALL SUBOPT_0x2E
; 0000 016E     case 0 :
	BRNE _0x95
; 0000 016F     left=1;
	LDI  R30,LOW(1)
	RJMP _0x145
; 0000 0170     break;
; 0000 0171     case 1 :
_0x95:
	RCALL SUBOPT_0x16
	BRNE _0x94
; 0000 0172     left=2;
	LDI  R30,LOW(2)
_0x145:
	MOV  R9,R30
; 0000 0173     break;
; 0000 0174     };
_0x94:
; 0000 0175     resetCounterSecondTime();
	RCALL _resetCounterSecondTime
; 0000 0176 }
	RJMP _0x146
; .FEND
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0178 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	RCALL SUBOPT_0x2D
; 0000 0179 checkTimeDisabeHomeTemp();
	RCALL _checkTimeDisabeHomeTemp
; 0000 017A blinkNumberChangeTimer();
	RCALL _blinkNumberChangeTimer
; 0000 017B TCNT1H=0x9E58 >> 8;
	LDI  R30,LOW(158)
	OUT  0x2D,R30
; 0000 017C TCNT1L=0x9E58 & 0xff;
	LDI  R30,LOW(88)
	OUT  0x2C,R30
; 0000 017D }
	RJMP _0x146
; .FEND
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 017F {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	RCALL SUBOPT_0x2D
; 0000 0180     blinkNumber();
	RCALL _blinkNumber
; 0000 0181 }
	RJMP _0x146
; .FEND
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
; 0000 0183 {
_timer2_comp_isr:
; .FSTART _timer2_comp_isr
	RCALL SUBOPT_0x2D
; 0000 0184     changePositionNumber(0);
	LDI  R26,LOW(0)
	RCALL _changePositionNumber
; 0000 0185 }
_0x146:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;void brightness(unsigned char timeBR){
; 0000 0186 void brightness(unsigned char timeBR){
_brightness:
; .FSTART _brightness
; 0000 0187     unsigned char temp=0;
; 0000 0188     OCR2=0;
	ST   -Y,R26
	ST   -Y,R17
;	timeBR -> Y+1
;	temp -> R17
	LDI  R17,0
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 0189     timeBR=(timeBR*255)/100  ;
	LDD  R26,Y+1
	LDI  R30,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	STD  Y+1,R30
; 0000 018A     for(temp=0;temp<timeBR;temp++){
	LDI  R17,LOW(0)
_0x98:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0x99
; 0000 018B         if(OCR2<255){
	IN   R30,0x23
	CPI  R30,LOW(0xFF)
	BRSH _0x9A
; 0000 018C          OCR2= OCR2+1;
	IN   R30,0x23
	SUBI R30,-LOW(1)
	OUT  0x23,R30
; 0000 018D         }}
_0x9A:
	SUBI R17,-1
	RJMP _0x98
_0x99:
; 0000 018E }
	LDD  R17,Y+0
	RJMP _0x20A0004
; .FEND
;void blinkNumberChangeTimer(){
; 0000 018F void blinkNumberChangeTimer(){
_blinkNumberChangeTimer:
; .FSTART _blinkNumberChangeTimer
; 0000 0190     if(blinkNumberChageState){
	LDS  R30,_blinkNumberChageState
	CPI  R30,0
	BREQ _0x9B
; 0000 0191     if(counterBlinkNumber<blinkWhenChangeNumberTimeOff){
	LDS  R26,_counterBlinkNumber
	CPI  R26,LOW(0x1)
	BRSH _0x9C
; 0000 0192     counterBlinkNumber++;
	RCALL SUBOPT_0x2F
; 0000 0193     switch (seqNumber)
; 0000 0194     {
; 0000 0195     case 1:
	BRNE _0xA0
; 0000 0196         portEnable[1]=0; portEnable[2]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _portEnable,1
	__PUTB1MN _portEnable,2
; 0000 0197         break;
	RJMP _0x9F
; 0000 0198     case 2 :
_0xA0:
	RCALL SUBOPT_0x13
	BRNE _0x9F
; 0000 0199         portEnable[3]=0; portEnable[4]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _portEnable,3
	__PUTB1MN _portEnable,4
; 0000 019A     break;
; 0000 019B     }
_0x9F:
; 0000 019C     } else{if(counterBlinkNumber<blinkWhenChangeNumberTimeOn){
	RJMP _0xA2
_0x9C:
	LDS  R26,_counterBlinkNumber
	CPI  R26,LOW(0x4)
	BRSH _0xA3
; 0000 019D         counterBlinkNumber++;
	RCALL SUBOPT_0x2F
; 0000 019E     switch (seqNumber)
; 0000 019F     {
; 0000 01A0     case 1:
	BRNE _0xA7
; 0000 01A1         portEnable[1]=1; portEnable[2]=1;
	RCALL SUBOPT_0x30
; 0000 01A2         break;
	RJMP _0xA6
; 0000 01A3     case 2 :
_0xA7:
	RCALL SUBOPT_0x13
	BRNE _0xA6
; 0000 01A4         portEnable[3]=1; portEnable[4]=1;
	RCALL SUBOPT_0x31
; 0000 01A5     break;
; 0000 01A6     }
_0xA6:
; 0000 01A7     }else{counterBlinkNumber=0;}}}
	RJMP _0xA9
_0xA3:
	LDI  R30,LOW(0)
	STS  _counterBlinkNumber,R30
_0xA9:
_0xA2:
; 0000 01A8 }
_0x9B:
	RET
; .FEND
;void blinkEditNumber(unsigned char seqNu){
; 0000 01A9 void blinkEditNumber(unsigned char seqNu){
_blinkEditNumber:
; .FSTART _blinkEditNumber
; 0000 01AA     if(blinkNumberChageState){
	ST   -Y,R26
;	seqNu -> Y+0
	LDS  R30,_blinkNumberChageState
	CPI  R30,0
	BREQ _0xAA
; 0000 01AB         stopCounterTimer();
	RCALL _stopCounterTimer
; 0000 01AC         blinkNumberChageState=0;
	LDI  R30,LOW(0)
	STS  _blinkNumberChageState,R30
; 0000 01AD         portEnable[1]=1; portEnable[2]=1;
	RCALL SUBOPT_0x30
; 0000 01AE         portEnable[3]=1; portEnable[4]=1;
	RCALL SUBOPT_0x31
; 0000 01AF     }
; 0000 01B0     if(seqNu>0){
_0xAA:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRLO _0xAB
; 0000 01B1     seqNumber = seqNu ;
	LD   R30,Y
	STS  _seqNumber,R30
; 0000 01B2     startCounterTimer();
	RCALL _startCounterTimer
; 0000 01B3     blinkNumberChageState=1;
	LDI  R30,LOW(1)
	STS  _blinkNumberChageState,R30
; 0000 01B4         }
; 0000 01B5     }
_0xAB:
	RJMP _0x20A0009
; .FEND
;void showClock(){
; 0000 01B6 void showClock(){
_showClock:
; .FSTART _showClock
; 0000 01B7     rtc_get_time(&h,&m,&s);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x2C
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL SUBOPT_0x2C
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	RCALL _rtc_get_time
; 0000 01B8     if(m==0){
	TST  R7
	BRNE _0xAC
; 0000 01B9     if(tempSecondBip>s){
	LDS  R26,_tempSecondBip
	CP   R6,R26
	BRSH _0xAD
; 0000 01BA         if(h<22 & h>7){
	MOV  R26,R4
	LDI  R30,LOW(22)
	RCALL __LTB12U
	MOV  R0,R30
	LDI  R30,LOW(7)
	RCALL __GTB12U
	AND  R30,R0
	BREQ _0xAE
; 0000 01BB             buzzer(500,500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x2C
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _buzzer
; 0000 01BC             buzzer(500,0);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x2C
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _buzzer
; 0000 01BD         }}
_0xAE:
; 0000 01BE         tempSecondBip=s;}
_0xAD:
	STS  _tempSecondBip,R6
; 0000 01BF     if(alarmSet==1|alarmSet==2){
_0xAC:
	RCALL SUBOPT_0x32
	MOV  R1,R30
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x22
	MOV  R30,R1
	LDI  R26,LOW(2)
	RCALL __EQB12
	OR   R30,R0
	BREQ _0xAF
; 0000 01C0         if(alHour==h & alMinute==m ){
	LDI  R26,LOW(_alHour)
	LDI  R27,HIGH(_alHour)
	RCALL __EEPROMRDB
	MOV  R26,R30
	MOV  R30,R4
	RCALL SUBOPT_0x22
	LDI  R26,LOW(_alMinute)
	LDI  R27,HIGH(_alMinute)
	RCALL __EEPROMRDB
	MOV  R26,R30
	MOV  R30,R7
	RCALL SUBOPT_0x33
	BREQ _0xB0
; 0000 01C1         runnigState=ALARM;
	LDI  R30,LOW(9)
	MOV  R10,R30
; 0000 01C2         if(alarmSet==1)alarmSet=0;
	RCALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0xB1
	RCALL SUBOPT_0x34
; 0000 01C3         }}
_0xB1:
_0xB0:
; 0000 01C4     showString(2,h,1);
_0xAF:
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x35
; 0000 01C5     showString(2,m,2);
	ST   -Y,R7
	RCALL SUBOPT_0x2B
; 0000 01C6     dotBlink(ON);
	LDI  R26,LOW(13)
	RCALL _dotBlink
; 0000 01C7 }
	RET
; .FEND
;void showDate(){
; 0000 01C8 void showDate(){
_showDate:
; .FSTART _showDate
; 0000 01C9     dotBlink(OFF);
	RCALL SUBOPT_0x20
; 0000 01CA     rtc_get_date(&w,&dm,&mm,&ym);
	LDI  R30,LOW(_w)
	LDI  R31,HIGH(_w)
	RCALL SUBOPT_0x2C
	LDI  R30,LOW(_dm)
	LDI  R31,HIGH(_dm)
	RCALL SUBOPT_0x2C
	LDI  R30,LOW(_mm)
	LDI  R31,HIGH(_mm)
	RCALL SUBOPT_0x2C
	LDI  R26,LOW(_ym)
	LDI  R27,HIGH(_ym)
	RCALL _rtc_get_date
; 0000 01CB     m2s(ym,mm,dm,&ys,&ms,&ds);
	RCALL SUBOPT_0x36
	LDI  R31,0
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x37
	LDI  R31,0
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x38
	LDI  R31,0
	RCALL SUBOPT_0x2C
	LDI  R30,LOW(_ys)
	LDI  R31,HIGH(_ys)
	RCALL SUBOPT_0x2C
	LDI  R30,LOW(_ms)
	LDI  R31,HIGH(_ms)
	RCALL SUBOPT_0x2C
	LDI  R26,LOW(_ds)
	LDI  R27,HIGH(_ds)
	RCALL _m2s
; 0000 01CC     showString(2,ms,1);
	RCALL SUBOPT_0x26
	LDS  R30,_ms
	RCALL SUBOPT_0x39
; 0000 01CD     showString(2,ds,2);
	LDS  R30,_ds
	RCALL SUBOPT_0x3A
; 0000 01CE }
	RET
; .FEND
;void playAlarm(){
; 0000 01CF void playAlarm(){
_playAlarm:
; .FSTART _playAlarm
; 0000 01D0     unsigned char counterFor=0;
; 0000 01D1     dotBlink(OFF);
	ST   -Y,R17
;	counterFor -> R17
	LDI  R17,0
	RCALL SUBOPT_0x20
; 0000 01D2     showString(2,alHour,1);
	RCALL SUBOPT_0x26
	LDI  R26,LOW(_alHour)
	LDI  R27,HIGH(_alHour)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x39
; 0000 01D3     showString(2,alMinute,2);
	LDI  R26,LOW(_alMinute)
	LDI  R27,HIGH(_alMinute)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x3A
; 0000 01D4     for(counterFor=0;counterFor<alarmTime;counterFor++){
	LDI  R17,LOW(0)
_0xB3:
	CPI  R17,9
	BRSH _0xB4
; 0000 01D5     buzzer(300,200);}
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x2C
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _buzzer
	SUBI R17,-1
	RJMP _0xB3
_0xB4:
; 0000 01D6     runnigState=HOME;
	CLR  R10
; 0000 01D7 }
	LD   R17,Y+
	RET
; .FEND
;void exitMenu(){
; 0000 01D8 void exitMenu(){
_exitMenu:
; .FSTART _exitMenu
; 0000 01D9         runnigState=HOME;
	CLR  R10
; 0000 01DA         menuPosition = SETTIME;
	LDI  R30,LOW(4)
	MOV  R13,R30
; 0000 01DB         resetClickState();
	RCALL _resetClickState
; 0000 01DC         blinkEditNumber(0);
	LDI  R26,LOW(0)
	RCALL _blinkEditNumber
; 0000 01DD }
	RET
; .FEND
;void showStringReady(unsigned char stringName){
; 0000 01DE void showStringReady(unsigned char stringName){
_showStringReady:
; .FSTART _showStringReady
; 0000 01DF     switch (stringName)
	RCALL SUBOPT_0x0
;	stringName -> Y+0
; 0000 01E0     {
; 0000 01E1     case CLOCK:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xB8
; 0000 01E2        showString(1,'c',1);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(99)
	RCALL SUBOPT_0x3B
; 0000 01E3        showString(1,'l',2);
	LDI  R30,LOW(108)
	RCALL SUBOPT_0x3A
; 0000 01E4        showString(1,'o',3);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x3C
; 0000 01E5        showString(1,'c',4);
	LDI  R30,LOW(99)
	RCALL SUBOPT_0x3D
; 0000 01E6         break;
	RJMP _0xB7
; 0000 01E7     case EXIT:
_0xB8:
	RCALL SUBOPT_0x17
	BRNE _0xB9
; 0000 01E8        showString(1,'e',1);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(101)
	RCALL SUBOPT_0x3B
; 0000 01E9        showString(1,'x',2);
	LDI  R30,LOW(120)
	RCALL SUBOPT_0x3A
; 0000 01EA        showString(1,'i',3);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x3E
; 0000 01EB        showString(1,'t',4);
	LDI  R30,LOW(116)
	RCALL SUBOPT_0x3D
; 0000 01EC         break;
	RJMP _0xB7
; 0000 01ED     case ALARM:
_0xB9:
	RCALL SUBOPT_0x19
	BRNE _0xBA
; 0000 01EE        showString(1,'a',1);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(97)
	RCALL SUBOPT_0x3B
; 0000 01EF        showString(1,'l',2);
	LDI  R30,LOW(108)
	RCALL SUBOPT_0x3A
; 0000 01F0        showString(1,'a',3);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(97)
	RCALL SUBOPT_0x3F
; 0000 01F1        showString(1,'r',4);
	RCALL SUBOPT_0x2A
	LDI  R26,LOW(4)
	RCALL _showString
; 0000 01F2         break;
	RJMP _0xB7
; 0000 01F3     case BRIGHTNESS:
_0xBA:
	RCALL SUBOPT_0x18
	BRNE _0xBB
; 0000 01F4        showString(1,'b',1);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
; 0000 01F5        showString(1,'r',2);
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
; 0000 01F6        showString(1,'i',3);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x3E
; 0000 01F7        showString(1,9,4);
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x3D
; 0000 01F8         break;
	RJMP _0xB7
; 0000 01F9     case ONE:
_0xBB:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xBC
; 0000 01FA        showString(1,'.',1);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x40
; 0000 01FB        showString(1,'o',2);
	LDI  R30,LOW(111)
	RCALL SUBOPT_0x3A
; 0000 01FC        showString(1,'n',3);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(110)
	RCALL SUBOPT_0x3F
; 0000 01FD        showString(1,'e',4);
	LDI  R30,LOW(101)
	RCALL SUBOPT_0x3D
; 0000 01FE         break;
	RJMP _0xB7
; 0000 01FF     case ON:
_0xBC:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xBD
; 0000 0200        showString(1,'.',1);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x40
; 0000 0201        showString(1,'.',2);
	LDI  R30,LOW(46)
	RCALL SUBOPT_0x3A
; 0000 0202        showString(1,'o',3);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x3C
; 0000 0203        showString(1,'n',4);
	LDI  R30,LOW(110)
	RCALL SUBOPT_0x3D
; 0000 0204         break;
	RJMP _0xB7
; 0000 0205     case OFF:
_0xBD:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xBE
; 0000 0206        showString(1,'.',1);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x40
; 0000 0207        showString(1,'o',2);
	LDI  R30,LOW(111)
	RCALL SUBOPT_0x3A
; 0000 0208        showString(1,'f',3);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(102)
	RCALL SUBOPT_0x3F
; 0000 0209        showString(1,'f',4);
	LDI  R30,LOW(102)
	RCALL SUBOPT_0x3D
; 0000 020A         break;
	RJMP _0xB7
; 0000 020B     case BIP:
_0xBE:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xBF
; 0000 020C        showString(1,'.',1);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x40
; 0000 020D        showString(1,'b',2);
	LDI  R30,LOW(98)
	RCALL SUBOPT_0x3A
; 0000 020E        showString(1,'i',3);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x3E
; 0000 020F        showString(1,'p',4);
	LDI  R30,LOW(112)
	RCALL SUBOPT_0x3D
; 0000 0210         break;
	RJMP _0xB7
; 0000 0211     case SHOWDATE:
_0xBF:
	RCALL SUBOPT_0x13
	BRNE _0xC0
; 0000 0212        showString(1,'d',1);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(100)
	RCALL SUBOPT_0x3B
; 0000 0213        showString(1,'a',2);
	LDI  R30,LOW(97)
	RCALL SUBOPT_0x3A
; 0000 0214        showString(1,'t',3);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(116)
	RCALL SUBOPT_0x3F
; 0000 0215        showString(1,'e',4);
	LDI  R30,LOW(101)
	RCALL SUBOPT_0x3D
; 0000 0216         break;
	RJMP _0xB7
; 0000 0217      case EVER:
_0xC0:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xC2
; 0000 0218        showString(1,'e',1);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(101)
	RCALL SUBOPT_0x3B
; 0000 0219        showString(1,'v',2);
	LDI  R30,LOW(118)
	RCALL SUBOPT_0x3A
; 0000 021A        showString(1,'e',3);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(101)
	RCALL SUBOPT_0x3F
; 0000 021B        showString(1,'r',4);
	RCALL SUBOPT_0x2A
	LDI  R26,LOW(4)
	RCALL _showString
; 0000 021C         break;
; 0000 021D     default:
_0xC2:
; 0000 021E         break;
; 0000 021F     }
_0xB7:
; 0000 0220 }
_0x20A0009:
	ADIW R28,1
	RET
; .FEND
;void setBrightnessMenu(){
; 0000 0221 void setBrightnessMenu(){
_setBrightnessMenu:
; .FSTART _setBrightnessMenu
; 0000 0222     resetClickState();
	RCALL SUBOPT_0x41
; 0000 0223     blinkEditNumber(2);
; 0000 0224         while (clickState==0 & runnigState==MENU)
_0xC3:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	BREQ _0xC5
; 0000 0225     {
; 0000 0226         volumeCheck();
	RCALL SUBOPT_0x44
; 0000 0227         if(checkVolumeRight()){if(brightnessSet<99)brightnessSet++;}
	BREQ _0xC6
	RCALL SUBOPT_0x23
	CPI  R26,LOW(0x63)
	BRSH _0xC7
	RCALL SUBOPT_0x24
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x25
_0xC7:
; 0000 0228         if(checkVolumeLeft()){if(brightnessSet>1)brightnessSet--;}
_0xC6:
	RCALL SUBOPT_0x45
	BREQ _0xC8
	RCALL SUBOPT_0x23
	CPI  R26,LOW(0x2)
	BRLO _0xC9
	RCALL SUBOPT_0x24
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x25
_0xC9:
; 0000 0229         showString(2,brightnessSet,2);
_0xC8:
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x27
; 0000 022A     }
	RJMP _0xC3
_0xC5:
; 0000 022B     brightness(brightnessSet);
	RCALL SUBOPT_0x23
	RCALL _brightness
; 0000 022C     brightnessMem=brightnessSet;
	RCALL SUBOPT_0x24
	LDI  R26,LOW(_brightnessMem)
	LDI  R27,HIGH(_brightnessMem)
	RJMP _0x20A0007
; 0000 022D     exitMenu();
; 0000 022E }
; .FEND
;void setTimeMenu(){
; 0000 022F void setTimeMenu(){
_setTimeMenu:
; .FSTART _setTimeMenu
; 0000 0230     unsigned char hour=h,minute=m;
; 0000 0231         resetClickState();
	RCALL __SAVELOCR2
;	hour -> R17
;	minute -> R16
	MOV  R17,R4
	MOV  R16,R7
	RCALL _resetClickState
; 0000 0232         showString(2,h,1);
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x35
; 0000 0233         showString(2,m,2);
	ST   -Y,R7
	RCALL SUBOPT_0x2B
; 0000 0234         blinkEditNumber(1);
	LDI  R26,LOW(1)
	RCALL _blinkEditNumber
; 0000 0235     while (clickState==0 & runnigState==MENU)
_0xCA:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	BREQ _0xCC
; 0000 0236     {
; 0000 0237         volumeCheck();
	RCALL SUBOPT_0x44
; 0000 0238         if(checkVolumeRight()){if(hour<24)hour++;}
	BREQ _0xCD
	CPI  R17,24
	BRSH _0xCE
	SUBI R17,-1
_0xCE:
; 0000 0239         if(checkVolumeLeft()){if(hour>0)hour--;}
_0xCD:
	RCALL SUBOPT_0x45
	BREQ _0xCF
	CPI  R17,1
	BRLO _0xD0
	SUBI R17,1
_0xD0:
; 0000 023A         showString(2,hour,1);
_0xCF:
	RCALL SUBOPT_0x26
	ST   -Y,R17
	LDI  R26,LOW(1)
	RCALL _showString
; 0000 023B     }
	RJMP _0xCA
_0xCC:
; 0000 023C     resetClickState();
	RCALL SUBOPT_0x41
; 0000 023D     blinkEditNumber(2);
; 0000 023E     while (clickState==0 & runnigState==MENU)
_0xD1:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	BREQ _0xD3
; 0000 023F     {
; 0000 0240         volumeCheck();
	RCALL SUBOPT_0x44
; 0000 0241         if(checkVolumeRight()){if(minute<59)minute++;}
	BREQ _0xD4
	CPI  R16,59
	BRSH _0xD5
	SUBI R16,-1
_0xD5:
; 0000 0242         if(checkVolumeLeft()){if(minute>0)minute--;}
_0xD4:
	RCALL SUBOPT_0x45
	BREQ _0xD6
	CPI  R16,1
	BRLO _0xD7
	SUBI R16,1
_0xD7:
; 0000 0243         showString(2,minute,2);
_0xD6:
	RCALL SUBOPT_0x26
	ST   -Y,R16
	RCALL SUBOPT_0x2B
; 0000 0244     }
	RJMP _0xD1
_0xD3:
; 0000 0245     rtc_set_time(hour,minute,0);
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(0)
	RCALL _rtc_set_time
; 0000 0246     exitMenu();
	RJMP _0x20A0008
; 0000 0247 }
; .FEND
;void setDateMenu(){
; 0000 0248 void setDateMenu(){
_setDateMenu:
; .FSTART _setDateMenu
; 0000 0249          resetClickState();
	RCALL _resetClickState
; 0000 024A          showString(1,4,1);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x3B
; 0000 024B          showString(1,'e',2);
	LDI  R30,LOW(101)
	RCALL SUBOPT_0x3A
; 0000 024C          showString(2,ym,2);
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x3A
; 0000 024D         while (clickState==0 & runnigState==MENU)
_0xD8:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	BREQ _0xDA
; 0000 024E     {
; 0000 024F         volumeCheck();
	RCALL SUBOPT_0x44
; 0000 0250         if(checkVolumeRight()){if(ym<99)ym++;}
	BREQ _0xDB
	LDS  R26,_ym
	CPI  R26,LOW(0x63)
	BRSH _0xDC
	RCALL SUBOPT_0x36
	SUBI R30,-LOW(1)
	STS  _ym,R30
_0xDC:
; 0000 0251         if(checkVolumeLeft()){if(ym>0)ym--;}
_0xDB:
	RCALL SUBOPT_0x45
	BREQ _0xDD
	LDS  R26,_ym
	CPI  R26,LOW(0x1)
	BRLO _0xDE
	RCALL SUBOPT_0x36
	SUBI R30,LOW(1)
	STS  _ym,R30
_0xDE:
; 0000 0252         showString(2,ym,2);
_0xDD:
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x3A
; 0000 0253     }
	RJMP _0xD8
_0xDA:
; 0000 0254          resetClickState();
	RCALL _resetClickState
; 0000 0255          showString(1,'n',1);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(110)
	RCALL SUBOPT_0x3B
; 0000 0256          showString(1,'n',2);
	LDI  R30,LOW(110)
	RCALL SUBOPT_0x3A
; 0000 0257          showString(2,mm,2);
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x3A
; 0000 0258         while (clickState==0 & runnigState==MENU)
_0xDF:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	BREQ _0xE1
; 0000 0259     {
; 0000 025A         volumeCheck();
	RCALL SUBOPT_0x44
; 0000 025B         if(checkVolumeRight()){if(mm<59)mm++;}
	BREQ _0xE2
	LDS  R26,_mm
	CPI  R26,LOW(0x3B)
	BRSH _0xE3
	RCALL SUBOPT_0x37
	SUBI R30,-LOW(1)
	STS  _mm,R30
_0xE3:
; 0000 025C         if(checkVolumeLeft()){if(mm>0)mm--;}
_0xE2:
	RCALL SUBOPT_0x45
	BREQ _0xE4
	LDS  R26,_mm
	CPI  R26,LOW(0x1)
	BRLO _0xE5
	RCALL SUBOPT_0x37
	SUBI R30,LOW(1)
	STS  _mm,R30
_0xE5:
; 0000 025D         showString(2,mm,2);
_0xE4:
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x3A
; 0000 025E     }
	RJMP _0xDF
_0xE1:
; 0000 025F         resetClickState();
	RCALL _resetClickState
; 0000 0260          showString(1,'d',1);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(100)
	RCALL SUBOPT_0x3B
; 0000 0261          showString(1,'a',2);
	LDI  R30,LOW(97)
	RCALL SUBOPT_0x3A
; 0000 0262          showString(2,dm,2);
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x3A
; 0000 0263         while (clickState==0 & runnigState==MENU)
_0xE6:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	BREQ _0xE8
; 0000 0264     {
; 0000 0265         volumeCheck();
	RCALL SUBOPT_0x44
; 0000 0266         if(checkVolumeRight()){if(dm<59)dm++;}
	BREQ _0xE9
	LDS  R26,_dm
	CPI  R26,LOW(0x3B)
	BRSH _0xEA
	RCALL SUBOPT_0x38
	SUBI R30,-LOW(1)
	STS  _dm,R30
_0xEA:
; 0000 0267         if(checkVolumeLeft()){if(dm>0)dm--;}
_0xE9:
	RCALL SUBOPT_0x45
	BREQ _0xEB
	LDS  R26,_dm
	CPI  R26,LOW(0x1)
	BRLO _0xEC
	RCALL SUBOPT_0x38
	SUBI R30,LOW(1)
	STS  _dm,R30
_0xEC:
; 0000 0268         showString(2,dm,2);
_0xEB:
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x3A
; 0000 0269     }
	RJMP _0xE6
_0xE8:
; 0000 026A     rtc_set_date(7,dm,mm,ym);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL SUBOPT_0x38
	ST   -Y,R30
	RCALL SUBOPT_0x37
	ST   -Y,R30
	LDS  R26,_ym
	RCALL _rtc_set_date
; 0000 026B     exitMenu();
	RJMP _0x20A0006
; 0000 026C }
; .FEND
;void setAlarmMenu(){
; 0000 026D void setAlarmMenu(){
_setAlarmMenu:
; .FSTART _setAlarmMenu
; 0000 026E    unsigned char alHour1=0,alMinute1=0;
; 0000 026F    alHour1=h;alMinute1=m;
	RCALL __SAVELOCR2
;	alHour1 -> R17
;	alMinute1 -> R16
	LDI  R17,0
	LDI  R16,0
	MOV  R17,R4
	MOV  R16,R7
; 0000 0270     resetClickState();
	RCALL _resetClickState
; 0000 0271     alarmSet=0;
	RCALL SUBOPT_0x34
; 0000 0272     while (clickState==0 & runnigState==MENU)
_0xED:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	BREQ _0xEF
; 0000 0273     {   switch (alarmSet)
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x2E
; 0000 0274          {
; 0000 0275         case 0:
	BRNE _0xF3
; 0000 0276         showStringReady(OFF);
	RCALL SUBOPT_0x46
; 0000 0277         if(checkVolumeRight()){alarmSet=1;}
	BREQ _0xF4
	RCALL SUBOPT_0x47
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 0278         if(checkVolumeLeft()){alarmSet=2;}
_0xF4:
	RCALL SUBOPT_0x45
	BREQ _0xF5
	RCALL SUBOPT_0x47
	LDI  R30,LOW(2)
	RCALL __EEPROMWRB
; 0000 0279         break;
_0xF5:
	RJMP _0xF2
; 0000 027A         case 1:
_0xF3:
	RCALL SUBOPT_0x16
	BRNE _0xF6
; 0000 027B         showStringReady(ONE);
	LDI  R26,LOW(16)
	RCALL SUBOPT_0x48
; 0000 027C         if(checkVolumeRight()){alarmSet=2;}
	BREQ _0xF7
	RCALL SUBOPT_0x47
	LDI  R30,LOW(2)
	RCALL __EEPROMWRB
; 0000 027D         if(checkVolumeLeft()){alarmSet=0;}
_0xF7:
	RCALL SUBOPT_0x45
	BREQ _0xF8
	RCALL SUBOPT_0x34
; 0000 027E         break;
_0xF8:
	RJMP _0xF2
; 0000 027F         case 2:
_0xF6:
	RCALL SUBOPT_0x13
	BRNE _0xF2
; 0000 0280         showStringReady(EVER);
	LDI  R26,LOW(18)
	RCALL SUBOPT_0x48
; 0000 0281         if(checkVolumeRight()){alarmSet=0;}
	BREQ _0xFA
	RCALL SUBOPT_0x34
; 0000 0282         if(checkVolumeLeft()){alarmSet=1;}
_0xFA:
	RCALL SUBOPT_0x45
	BREQ _0xFB
	RCALL SUBOPT_0x47
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 0283         break;
_0xFB:
; 0000 0284         }
_0xF2:
; 0000 0285         volumeCheck();
	RCALL _volumeCheck
; 0000 0286     }
	RJMP _0xED
_0xEF:
; 0000 0287     if(alarmSet){
	RCALL SUBOPT_0x32
	CPI  R30,0
	BREQ _0xFC
; 0000 0288         resetClickState();
	RCALL _resetClickState
; 0000 0289         showString(2,h,1);
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x35
; 0000 028A         showString(2,m,2);
	ST   -Y,R7
	RCALL SUBOPT_0x2B
; 0000 028B         blinkEditNumber(1);
	LDI  R26,LOW(1)
	RCALL _blinkEditNumber
; 0000 028C     while (clickState==0 & runnigState==MENU)
_0xFD:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	BREQ _0xFF
; 0000 028D     {
; 0000 028E         volumeCheck();
	RCALL SUBOPT_0x44
; 0000 028F         if(checkVolumeRight()){if(alHour1<24)alHour1++;}
	BREQ _0x100
	CPI  R17,24
	BRSH _0x101
	SUBI R17,-1
_0x101:
; 0000 0290         if(checkVolumeLeft()){if(alHour1>0)alHour1--;}
_0x100:
	RCALL SUBOPT_0x45
	BREQ _0x102
	CPI  R17,1
	BRLO _0x103
	SUBI R17,1
_0x103:
; 0000 0291         showString(2,alHour1,1);
_0x102:
	RCALL SUBOPT_0x26
	ST   -Y,R17
	LDI  R26,LOW(1)
	RCALL _showString
; 0000 0292     }
	RJMP _0xFD
_0xFF:
; 0000 0293     resetClickState();
	RCALL SUBOPT_0x41
; 0000 0294     blinkEditNumber(2);
; 0000 0295     while (clickState==0 & runnigState==MENU)
_0x104:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	BREQ _0x106
; 0000 0296     {
; 0000 0297         volumeCheck();
	RCALL SUBOPT_0x44
; 0000 0298         if(checkVolumeRight()){if(alMinute1<59)alMinute1++;}
	BREQ _0x107
	CPI  R16,59
	BRSH _0x108
	SUBI R16,-1
_0x108:
; 0000 0299         if(checkVolumeLeft()){if(alMinute1>0)alMinute1--;}
_0x107:
	RCALL SUBOPT_0x45
	BREQ _0x109
	CPI  R16,1
	BRLO _0x10A
	SUBI R16,1
_0x10A:
; 0000 029A         showString(2,alMinute1,2);
_0x109:
	RCALL SUBOPT_0x26
	ST   -Y,R16
	RCALL SUBOPT_0x2B
; 0000 029B     }
	RJMP _0x104
_0x106:
; 0000 029C     alHour=alHour1;alMinute=alMinute1;
	MOV  R30,R17
	LDI  R26,LOW(_alHour)
	LDI  R27,HIGH(_alHour)
	RCALL __EEPROMWRB
	MOV  R30,R16
	LDI  R26,LOW(_alMinute)
	LDI  R27,HIGH(_alMinute)
	RCALL __EEPROMWRB
; 0000 029D     }
; 0000 029E     exitMenu();
_0xFC:
_0x20A0008:
	RCALL _exitMenu
; 0000 029F }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void setMuteMenu(){
; 0000 02A0 void setMuteMenu(){
_setMuteMenu:
; .FSTART _setMuteMenu
; 0000 02A1     resetClickState();
	RCALL _resetClickState
; 0000 02A2     while (clickState==0 & runnigState==MENU)
_0x10B:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	BREQ _0x10D
; 0000 02A3     {   switch (muteState)
	LDS  R30,_muteState
	RCALL SUBOPT_0x2E
; 0000 02A4          {
; 0000 02A5         case 0:
	BRNE _0x111
; 0000 02A6         showStringReady(OFF);
	RCALL SUBOPT_0x46
; 0000 02A7         if(checkVolumeRight()){muteState=1;}
	BREQ _0x112
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x49
; 0000 02A8         if(checkVolumeLeft()){muteState=1;}
_0x112:
	RCALL SUBOPT_0x45
	BREQ _0x113
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x49
; 0000 02A9         break;
_0x113:
	RJMP _0x110
; 0000 02AA         case 1:
_0x111:
	RCALL SUBOPT_0x16
	BRNE _0x110
; 0000 02AB         showStringReady(ON);
	LDI  R26,LOW(13)
	RCALL SUBOPT_0x48
; 0000 02AC         if(checkVolumeRight()){muteState=0;}
	BREQ _0x115
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x49
; 0000 02AD         if(checkVolumeLeft()){muteState=0;}
_0x115:
	RCALL SUBOPT_0x45
	BREQ _0x116
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x49
; 0000 02AE         break;
_0x116:
; 0000 02AF         }
_0x110:
; 0000 02B0         volumeCheck();
	RCALL _volumeCheck
; 0000 02B1     }
	RJMP _0x10B
_0x10D:
; 0000 02B2     muteState1=muteState;
	LDS  R30,_muteState
	LDI  R26,LOW(_muteState1)
	LDI  R27,HIGH(_muteState1)
_0x20A0007:
	RCALL __EEPROMWRB
; 0000 02B3      exitMenu();
_0x20A0006:
	RCALL _exitMenu
; 0000 02B4 }
	RET
; .FEND
;void fastEditBrightnessMenu(){
; 0000 02B5 void fastEditBrightnessMenu(){
_fastEditBrightnessMenu:
; .FSTART _fastEditBrightnessMenu
; 0000 02B6             dotBlink(OFF);
	RCALL SUBOPT_0x20
; 0000 02B7             if(checkVolumeRight()){fastEditBrightness(SUM);}
	RCALL SUBOPT_0x4A
	BREQ _0x117
	LDI  R26,LOW(11)
	RCALL _fastEditBrightness
; 0000 02B8             if(checkVolumeLeft()){fastEditBrightness(MINUS);}
_0x117:
	RCALL SUBOPT_0x45
	BREQ _0x118
	LDI  R26,LOW(12)
	RCALL _fastEditBrightness
; 0000 02B9 }
_0x118:
	RET
; .FEND
;void showMenu(){
; 0000 02BA void showMenu(){
_showMenu:
; .FSTART _showMenu
; 0000 02BB     dotBlink(OFF);
	RCALL SUBOPT_0x20
; 0000 02BC     switch (menuPosition)
	MOV  R30,R13
	LDI  R31,0
; 0000 02BD     {
; 0000 02BE     case SETTIME:
	RCALL SUBOPT_0x15
	BRNE _0x11C
; 0000 02BF         showStringReady(CLOCK);
	LDI  R26,LOW(15)
	RCALL SUBOPT_0x4B
; 0000 02C0         if(clickState)setTimeMenu();
	BREQ _0x11D
	RCALL _setTimeMenu
; 0000 02C1         if(checkVolumeRight())menuPosition=SETDATE;
_0x11D:
	RCALL SUBOPT_0x4A
	BREQ _0x11E
	LDI  R30,LOW(5)
	MOV  R13,R30
; 0000 02C2         if(checkVolumeLeft())menuPosition=EXIT;
_0x11E:
	RCALL SUBOPT_0x45
	BREQ _0x11F
	LDI  R30,LOW(7)
	MOV  R13,R30
; 0000 02C3         break;
_0x11F:
	RJMP _0x11B
; 0000 02C4     case SETDATE:
_0x11C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x120
; 0000 02C5         showStringReady(SHOWDATE);
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x4B
; 0000 02C6         if(clickState)setDateMenu();
	BREQ _0x121
	RCALL _setDateMenu
; 0000 02C7         if(checkVolumeRight())menuPosition=SETALARM;
_0x121:
	RCALL SUBOPT_0x4A
	BREQ _0x122
	LDI  R30,LOW(6)
	MOV  R13,R30
; 0000 02C8         if(checkVolumeLeft())menuPosition=SETTIME;
_0x122:
	RCALL SUBOPT_0x45
	BREQ _0x123
	LDI  R30,LOW(4)
	MOV  R13,R30
; 0000 02C9         break;
_0x123:
	RJMP _0x11B
; 0000 02CA     case SETALARM:
_0x120:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x124
; 0000 02CB         showStringReady(ALARM);
	LDI  R26,LOW(9)
	RCALL SUBOPT_0x4B
; 0000 02CC         if(clickState)setAlarmMenu();
	BREQ _0x125
	RCALL _setAlarmMenu
; 0000 02CD         if(checkVolumeRight())menuPosition=BRIGHTNESS;
_0x125:
	RCALL SUBOPT_0x4A
	BREQ _0x126
	LDI  R30,LOW(8)
	MOV  R13,R30
; 0000 02CE         if(checkVolumeLeft())menuPosition=SETDATE;
_0x126:
	RCALL SUBOPT_0x45
	BREQ _0x127
	LDI  R30,LOW(5)
	MOV  R13,R30
; 0000 02CF         break;
_0x127:
	RJMP _0x11B
; 0000 02D0     case BRIGHTNESS:
_0x124:
	RCALL SUBOPT_0x18
	BRNE _0x128
; 0000 02D1         showStringReady(BRIGHTNESS);
	LDI  R26,LOW(8)
	RCALL SUBOPT_0x4B
; 0000 02D2         if(clickState)setBrightnessMenu();
	BREQ _0x129
	RCALL _setBrightnessMenu
; 0000 02D3         if(checkVolumeRight())menuPosition=MUTE;
_0x129:
	RCALL SUBOPT_0x4A
	BREQ _0x12A
	LDI  R30,LOW(10)
	MOV  R13,R30
; 0000 02D4         if(checkVolumeLeft())menuPosition=SETALARM;
_0x12A:
	RCALL SUBOPT_0x45
	BREQ _0x12B
	LDI  R30,LOW(6)
	MOV  R13,R30
; 0000 02D5         break;
_0x12B:
	RJMP _0x11B
; 0000 02D6         case MUTE:
_0x128:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x12C
; 0000 02D7         showStringReady(BIP);
	LDI  R26,LOW(17)
	RCALL SUBOPT_0x4B
; 0000 02D8         if(clickState)setMuteMenu();
	BREQ _0x12D
	RCALL _setMuteMenu
; 0000 02D9         if(checkVolumeRight())menuPosition=EXIT;
_0x12D:
	RCALL SUBOPT_0x4A
	BREQ _0x12E
	LDI  R30,LOW(7)
	MOV  R13,R30
; 0000 02DA         if(checkVolumeLeft())menuPosition=BRIGHTNESS;
_0x12E:
	RCALL SUBOPT_0x45
	BREQ _0x12F
	LDI  R30,LOW(8)
	MOV  R13,R30
; 0000 02DB         break;
_0x12F:
	RJMP _0x11B
; 0000 02DC     case EXIT:
_0x12C:
	RCALL SUBOPT_0x17
	BRNE _0x11B
; 0000 02DD         showStringReady(EXIT);
	LDI  R26,LOW(7)
	RCALL SUBOPT_0x4B
; 0000 02DE         if(clickState)exitMenu();
	BREQ _0x131
	RCALL _exitMenu
; 0000 02DF         if(checkVolumeRight())menuPosition=SETTIME;
_0x131:
	RCALL SUBOPT_0x4A
	BREQ _0x132
	LDI  R30,LOW(4)
	MOV  R13,R30
; 0000 02E0         if(checkVolumeLeft())menuPosition=MUTE;
_0x132:
	RCALL SUBOPT_0x45
	BREQ _0x133
	LDI  R30,LOW(10)
	MOV  R13,R30
; 0000 02E1         break;
_0x133:
; 0000 02E2     }
_0x11B:
; 0000 02E3 }
	RET
; .FEND
;
;void main(void)
; 0000 02E6 {
_main:
; .FSTART _main
; 0000 02E7 portConfig();
	RCALL _portConfig
; 0000 02E8 startTimers();
	RCALL _startTimers
; 0000 02E9 startIntrupts();
	RCALL _startIntrupts
; 0000 02EA #asm("sei")
	sei
; 0000 02EB i2c_init();
	RCALL _i2c_init
; 0000 02EC rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 02ED brightness(brightnessMem);
	LDI  R26,LOW(_brightnessMem)
	LDI  R27,HIGH(_brightnessMem)
	RCALL __EEPROMRDB
	MOV  R26,R30
	RCALL _brightness
; 0000 02EE brightnessSet=brightnessMem;
	LDI  R26,LOW(_brightnessMem)
	LDI  R27,HIGH(_brightnessMem)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x25
; 0000 02EF 
; 0000 02F0 while (1)
_0x134:
; 0000 02F1       {
; 0000 02F2             volumeCheck();
	RCALL _volumeCheck
; 0000 02F3             switch (runnigState)
	MOV  R30,R10
	RCALL SUBOPT_0x2E
; 0000 02F4             {
; 0000 02F5             case HOME:
	BRNE _0x13A
; 0000 02F6             showClock();
	RCALL _showClock
; 0000 02F7             break;
	RJMP _0x139
; 0000 02F8             case MENU:
_0x13A:
	RCALL SUBOPT_0x14
	BRNE _0x13B
; 0000 02F9             showMenu();
	RCALL _showMenu
; 0000 02FA             break;
	RJMP _0x139
; 0000 02FB             case ALARM:
_0x13B:
	RCALL SUBOPT_0x19
	BRNE _0x13C
; 0000 02FC             playAlarm();
	RCALL _playAlarm
; 0000 02FD             break;
	RJMP _0x139
; 0000 02FE             case BRIGHTNESSHOME :
_0x13C:
	RCALL SUBOPT_0x16
	BRNE _0x13D
; 0000 02FF             fastEditBrightnessMenu();
	RCALL _fastEditBrightnessMenu
; 0000 0300             break;
	RJMP _0x139
; 0000 0301             case SHOWDATE:
_0x13D:
	RCALL SUBOPT_0x13
	BRNE _0x139
; 0000 0302             showDate();
	RCALL _showDate
; 0000 0303             break;
; 0000 0304             }
_0x139:
; 0000 0305       }
	RJMP _0x134
; 0000 0306 }
_0x13F:
	RJMP _0x13F
; .FEND
;
;void stopTimers(){
; 0000 0308 void stopTimers(){
; 0000 0309 ASSR=0<<AS2;
; 0000 030A TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
; 0000 030B TCNT2=0x00;
; 0000 030C TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
; 0000 030D }
;void startTimers(){
; 0000 030E void startTimers(){
_startTimers:
; .FSTART _startTimers
; 0000 030F ASSR=0<<AS2;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 0310 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (1<<CS21) | (1<<CS20);
	LDI  R30,LOW(3)
	OUT  0x25,R30
; 0000 0311 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0312 OCR2=0xff;
	LDI  R30,LOW(255)
	OUT  0x23,R30
; 0000 0313 TIMSK=(1<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(196)
	OUT  0x39,R30
; 0000 0314 }
	RET
; .FEND
;void startCounterTimer(){
; 0000 0315 void startCounterTimer(){
_startCounterTimer:
; .FSTART _startCounterTimer
; 0000 0316 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0317 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 0318 TCNT1H=0x9E;
	LDI  R30,LOW(158)
	OUT  0x2D,R30
; 0000 0319 TCNT1L=0x58;
	LDI  R30,LOW(88)
	RJMP _0x20A0005
; 0000 031A ICR1H=0x00;
; 0000 031B ICR1L=0x00;
; 0000 031C OCR1AH=0x00;
; 0000 031D OCR1AL=0x00;
; 0000 031E OCR1BH=0x00;
; 0000 031F OCR1BL=0x00;
; 0000 0320 }
; .FEND
;void stopCounterTimer(){
; 0000 0321 void stopCounterTimer(){
_stopCounterTimer:
; .FSTART _stopCounterTimer
; 0000 0322 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0323 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0324 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0325 TCNT1L=0x00;
_0x20A0005:
	OUT  0x2C,R30
; 0000 0326 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0327 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0328 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0329 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 032A OCR1BH=0x00;
	OUT  0x29,R30
; 0000 032B OCR1BL=0x00;
	OUT  0x28,R30
; 0000 032C }
	RET
; .FEND
;void startIntrupts(){
; 0000 032D void startIntrupts(){
_startIntrupts:
; .FSTART _startIntrupts
; 0000 032E GICR|=(1<<INT1) | (1<<INT0);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 032F MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0330 GIFR=(1<<INTF1) | (1<<INTF0);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0331 }
	RET
; .FEND
;void stopIntrupts(){
; 0000 0332 void stopIntrupts(){
; 0000 0333  GICR|=(0<<INT1) | (0<<INT0);
; 0000 0334 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
; 0000 0335 GIFR=(0<<INTF1) | (0<<INTF0);
; 0000 0336 }
;void portConfig(){
; 0000 0337 void portConfig(){
_portConfig:
; .FSTART _portConfig
; 0000 0338 DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(127)
	OUT  0x17,R30
; 0000 0339 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 033A DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 033B PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 033C DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 033D PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(13)
	OUT  0x12,R30
; 0000 033E }
	RET
; .FEND

	.CSEG
_rtc_write:
; .FSTART _rtc_write
	RCALL SUBOPT_0x4C
	LDD  R26,Y+1
	RCALL _i2c_write
	LD   R26,Y
	RCALL SUBOPT_0x4D
_0x20A0004:
	ADIW R28,2
	RET
; .FEND
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	RCALL SUBOPT_0x4E
	LDI  R26,LOW(7)
	RCALL _i2c_write
	LDD  R26,Y+2
	RJMP _0x20A0002
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x4E
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,6
	RET
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	RCALL SUBOPT_0x4C
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x55
_0x20A0002:
	RCALL _i2c_write
	RCALL _i2c_stop
_0x20A0003:
	ADIW R28,3
	RET
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x4E
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x4F
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x51
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
	RCALL SUBOPT_0x11
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,8
	RET
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	RCALL SUBOPT_0x4C
	LDI  R26,LOW(3)
	RCALL _i2c_write
	LDD  R26,Y+3
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x4D
_0x20A0001:
	ADIW R28,4
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.CSEG

	.CSEG

	.ESEG
_alMinute:
	.BYTE 0x1
_alHour:
	.BYTE 0x1
_brightnessMem:
	.BYTE 0x1
_alarmSet:
	.BYTE 0x1
_muteState1:
	.BYTE 0x1

	.DSEG
_segmentPinState:
	.BYTE 0x4
_disabeHomeTempState:
	.BYTE 0x1
_seqNumber:
	.BYTE 0x1
_counterBlinkNumber:
	.BYTE 0x1
_blinkNumberChageState:
	.BYTE 0x1
_portEnable:
	.BYTE 0x5
_brightnessSet:
	.BYTE 0x1
_muteState:
	.BYTE 0x1
_ym:
	.BYTE 0x1
_mm:
	.BYTE 0x1
_dm:
	.BYTE 0x1
_w:
	.BYTE 0x1
_tempSecondBip:
	.BYTE 0x1
_ys:
	.BYTE 0x2
_ms:
	.BYTE 0x2
_ds:
	.BYTE 0x2
_counterSecondTime:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDD  R30,Y+30
	LDD  R31,Y+30+1
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	RCALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x4:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
	__GETD2S 12
	RCALL SUBOPT_0x3
	RCALL __ADDD12
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	__GETD2S 16
	__GETD1N 0x16D
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xD:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xE:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	RCALL SUBOPT_0xC
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,31
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x10:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	RCALL SUBOPT_0xC
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,30
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LD   R30,Y
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x13:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x14:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x16:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	SUBI R30,LOW(-_segmentPinState)
	SBCI R31,HIGH(-_segmentPinState)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOV  R26,R30
	RJMP _digitalWritePort

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+1
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOV  R26,R30
	RJMP _digitalWritePort

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
	OUT  0x18,R30
	MOV  R26,R5
	RJMP _changePositionNumber

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _buzzer

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(14)
	RJMP _dotBlink

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDS  R26,_counterSecondTime
	LDS  R27,_counterSecondTime+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x22:
	RCALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDS  R26,_brightnessSet
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x24:
	LDS  R30,_brightnessSet
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	STS  _brightnessSet,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x24
	ST   -Y,R30
	LDI  R26,LOW(2)
	RJMP _showString

;OPTIMIZER ADDED SUBROUTINE, CALLED 48 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(98)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _showString
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(114)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x2B:
	LDI  R26,LOW(2)
	RJMP _showString

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2C:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x2D:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	LDS  R30,_counterBlinkNumber
	SUBI R30,-LOW(1)
	STS  _counterBlinkNumber,R30
	LDS  R30,_seqNumber
	LDI  R31,0
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(1)
	__PUTB1MN _portEnable,1
	__PUTB1MN _portEnable,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(1)
	__PUTB1MN _portEnable,3
	__PUTB1MN _portEnable,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x32:
	LDI  R26,LOW(_alarmSet)
	LDI  R27,HIGH(_alarmSet)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x33:
	RCALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	LDI  R26,LOW(_alarmSet)
	LDI  R27,HIGH(_alarmSet)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x35:
	ST   -Y,R4
	LDI  R26,LOW(1)
	RCALL _showString
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x36:
	LDS  R30,_ym
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	LDS  R30,_mm
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	LDS  R30,_dm
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _showString
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3A:
	ST   -Y,R30
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x3B:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _showString
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3C:
	LDI  R30,LOW(111)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _showString
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3D:
	ST   -Y,R30
	LDI  R26,LOW(4)
	RJMP _showString

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(105)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _showString
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3F:
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _showString
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	LDI  R30,LOW(46)
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	RCALL _resetClickState
	LDI  R26,LOW(2)
	RJMP _blinkEditNumber

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x42:
	MOV  R26,R12
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x43:
	MOV  R26,R10
	LDI  R30,LOW(3)
	RJMP SUBOPT_0x33

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x44:
	RCALL _volumeCheck
	RCALL _checkVolumeRight
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x45:
	RCALL _checkVolumeLeft
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	LDI  R26,LOW(14)
	RCALL _showStringReady
	RCALL _checkVolumeRight
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	LDI  R26,LOW(_alarmSet)
	LDI  R27,HIGH(_alarmSet)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x48:
	RCALL _showStringReady
	RCALL _checkVolumeRight
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	STS  _muteState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4A:
	RCALL _checkVolumeRight
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	RCALL _showStringReady
	TST  R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4C:
	ST   -Y,R26
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	RCALL _i2c_write
	RJMP _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4E:
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4F:
	RCALL _i2c_start
	LDI  R26,LOW(209)
	RCALL _i2c_write
	LDI  R26,LOW(1)
	RJMP _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	MOV  R26,R30
	RJMP _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x51:
	ST   X,R30
	LDI  R26,LOW(1)
	RCALL _i2c_read
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	RCALL _i2c_read
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	RCALL _i2c_write
	LD   R26,Y
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	RCALL _i2c_write
	LDD  R26,Y+1
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL _bin2bcd
	MOV  R26,R30
	RET


	.CSEG
	.equ __sda_bit=4
	.equ __scl_bit=5
	.equ __i2c_port=0x15 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
	RET

__GTB12U:
	CP   R30,R26
	LDI  R30,1
	BRLO __GTB12U1
	CLR  R30
__GTB12U1:
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
