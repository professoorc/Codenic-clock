
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
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
	.DEF _brightnessPercent=R5
	.DEF _positionNumber=R4
	.DEF _i=R7
	.DEF _h=R6
	.DEF _m=R9
	.DEF _s=R8
	.DEF _left=R11
	.DEF _right=R10
	.DEF _clock=R13
	.DEF _timeStopClock=R12

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
	.DB  0x1,0x63,0x0,0x32
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x1

_0x3:
	.DB  0x2
_0x4:
	.DB  0x1,0x1,0x1,0x1,0x1
_0x5:
	.DB  0x63

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _menuPosition
	.DW  _0x3*2

	.DW  0x05
	.DW  _portEnable
	.DW  _0x4*2

	.DW  0x01
	.DW  _brightnessSet
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
;eeprom unsigned char alMinute,alHour,brightnessMem,alarmSet;
;enum commandType
;{
;	HOME ,
;	MENU ,
;    SETTIME ,
;    SETALARM ,
;    EXIT,
;    BRIGHTNESS,
;    ALARM,
;    MUTE
;};
;
;unsigned char brightnessPercent=99,positionNumber=1,n[4],temp[2],i=50,h=0,m=0,s=0,left=0,right=0,clock=1,timeStopClock=0 ...

	.DSEG
;unsigned char counterBlinkNumber=0,blinkNumberChageState=0,portEnable[5]={1,1,1,1,1},brightnessSet=99;
;int z=0;
;
;void brightness(unsigned char timeBR);
;void portConfig();
;void stopIntrupts();
;void startIntrupts();
;void startTimers();
;void stopTimers() ;
;void stopClock(unsigned char timeStop);
;void startCounterTimer();
;void stopCounterTimer();
;void showBrightness();
;void brightnessCheck();
;void blinkNumberChangeTimer();
;void digitalWritePortC (unsigned char portNumber);
;
;void buzzer(unsigned int timeBuzz){
; 0000 0025 void buzzer(unsigned int timeBuzz){

	.CSEG
_buzzer:
; .FSTART _buzzer
; 0000 0026 //PORTD.1=1;
; 0000 0027 delay_ms(timeBuzz);
	ST   -Y,R27
	ST   -Y,R26
;	timeBuzz -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _delay_ms
; 0000 0028 PORTD.1=0;
	CBI  0x12,1
; 0000 0029 }
	RJMP _0x20A0008
; .FEND
;
;void changePositionNumber(unsigned char position){
; 0000 002B void changePositionNumber(unsigned char position){
_changePositionNumber:
; .FSTART _changePositionNumber
; 0000 002C PORTC=PORTC&0xf0;
	ST   -Y,R26
;	position -> Y+0
	IN   R30,0x15
	ANDI R30,LOW(0xF0)
	OUT  0x15,R30
; 0000 002D  switch (position) {
	RCALL SUBOPT_0x0
; 0000 002E     case 1 :
	BRNE _0xB
; 0000 002F     digitalWritePortC(1);
	LDI  R26,LOW(1)
	RJMP _0xD8
; 0000 0030     break;
; 0000 0031     case 2 :
_0xB:
	RCALL SUBOPT_0x1
	BRNE _0xC
; 0000 0032     digitalWritePortC(2);
	LDI  R26,LOW(2)
	RJMP _0xD8
; 0000 0033     break;
; 0000 0034     case 3 :
_0xC:
	RCALL SUBOPT_0x2
	BRNE _0xD
; 0000 0035     digitalWritePortC(3);
	LDI  R26,LOW(3)
	RJMP _0xD8
; 0000 0036     break;
; 0000 0037     case 4 :
_0xD:
	RCALL SUBOPT_0x3
	BRNE _0xA
; 0000 0038     digitalWritePortC(4);
	LDI  R26,LOW(4)
_0xD8:
	RCALL _digitalWritePortC
; 0000 0039     break;
; 0000 003A     };
_0xA:
; 0000 003B }
	RJMP _0x20A0007
; .FEND
;
;void digitalWritePortC (unsigned char portNumber){
; 0000 003D void digitalWritePortC (unsigned char portNumber){
_digitalWritePortC:
; .FSTART _digitalWritePortC
; 0000 003E      switch (portNumber) {
	ST   -Y,R26
;	portNumber -> Y+0
	RCALL SUBOPT_0x0
; 0000 003F     case 1 :
	BRNE _0x12
; 0000 0040     if(portEnable[1])PORTC.0=1;
	__GETB1MN _portEnable,1
	CPI  R30,0
	BREQ _0x13
	SBI  0x15,0
; 0000 0041     break;
_0x13:
	RJMP _0x11
; 0000 0042     case 2 :
_0x12:
	RCALL SUBOPT_0x1
	BRNE _0x16
; 0000 0043     if(portEnable[2])PORTC.1=1;
	__GETB1MN _portEnable,2
	CPI  R30,0
	BREQ _0x17
	SBI  0x15,1
; 0000 0044     break;
_0x17:
	RJMP _0x11
; 0000 0045     case 3 :
_0x16:
	RCALL SUBOPT_0x2
	BRNE _0x1A
; 0000 0046     if(portEnable[3])PORTC.2=1;
	__GETB1MN _portEnable,3
	CPI  R30,0
	BREQ _0x1B
	SBI  0x15,2
; 0000 0047     break;
_0x1B:
	RJMP _0x11
; 0000 0048     case 4 :
_0x1A:
	RCALL SUBOPT_0x3
	BRNE _0x11
; 0000 0049     if(portEnable[4])PORTC.3=1;
	__GETB1MN _portEnable,4
	CPI  R30,0
	BREQ _0x1F
	SBI  0x15,3
; 0000 004A     break;
_0x1F:
; 0000 004B     };
_0x11:
; 0000 004C }
	RJMP _0x20A0007
; .FEND
;
;unsigned char digitalWritePort ( unsigned char input){
; 0000 004E unsigned char digitalWritePort ( unsigned char input){
_digitalWritePort:
; .FSTART _digitalWritePort
; 0000 004F  switch (input) {
	ST   -Y,R26
;	input -> Y+0
	RCALL SUBOPT_0x0
; 0000 0050     case 1:
	BRNE _0x25
; 0000 0051     return 6 ;
	LDI  R30,LOW(6)
	RJMP _0x20A0007
; 0000 0052     case 2:
_0x25:
	RCALL SUBOPT_0x1
	BRNE _0x26
; 0000 0053     return 91 ;
	LDI  R30,LOW(91)
	RJMP _0x20A0007
; 0000 0054     case 3:
_0x26:
	RCALL SUBOPT_0x2
	BRNE _0x27
; 0000 0055     return 79 ;
	LDI  R30,LOW(79)
	RJMP _0x20A0007
; 0000 0056     case 4:
_0x27:
	RCALL SUBOPT_0x3
	BRNE _0x28
; 0000 0057     return 102 ;
	LDI  R30,LOW(102)
	RJMP _0x20A0007
; 0000 0058     case 5:
_0x28:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x29
; 0000 0059     return 109 ;
	LDI  R30,LOW(109)
	RJMP _0x20A0007
; 0000 005A     case 6:
_0x29:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2A
; 0000 005B     return 125 ;
	LDI  R30,LOW(125)
	RJMP _0x20A0007
; 0000 005C     case 7:
_0x2A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2B
; 0000 005D     return 7 ;
	LDI  R30,LOW(7)
	RJMP _0x20A0007
; 0000 005E     case 8:
_0x2B:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2C
; 0000 005F     return 127 ;
	LDI  R30,LOW(127)
	RJMP _0x20A0007
; 0000 0060     case 9:
_0x2C:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x2D
; 0000 0061     return 111 ;
	LDI  R30,LOW(111)
	RJMP _0x20A0007
; 0000 0062     case 0:
_0x2D:
	SBIW R30,0
	BRNE _0x2E
; 0000 0063     return 63 ;
	LDI  R30,LOW(63)
	RJMP _0x20A0007
; 0000 0064     case 'e':
_0x2E:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x2F
; 0000 0065     return 121 ;
	LDI  R30,LOW(121)
	RJMP _0x20A0007
; 0000 0066     case 'r':
_0x2F:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x30
; 0000 0067     return 112 ;
	LDI  R30,LOW(112)
	RJMP _0x20A0007
; 0000 0068     case 'b':
_0x30:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x31
; 0000 0069     return 124 ;
	LDI  R30,LOW(124)
	RJMP _0x20A0007
; 0000 006A     case 'p':
_0x31:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x32
; 0000 006B     return 115 ;
	LDI  R30,LOW(115)
	RJMP _0x20A0007
; 0000 006C     case 'o':
_0x32:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x33
; 0000 006D     return 92 ;
	LDI  R30,LOW(92)
	RJMP _0x20A0007
; 0000 006E     case 'f':
_0x33:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x34
; 0000 006F     return 113 ;
	LDI  R30,LOW(113)
	RJMP _0x20A0007
; 0000 0070     case 'l':
_0x34:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x35
; 0000 0071     return 56 ;
	LDI  R30,LOW(56)
	RJMP _0x20A0007
; 0000 0072     case 'c':
_0x35:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x36
; 0000 0073     return 88 ;
	LDI  R30,LOW(88)
	RJMP _0x20A0007
; 0000 0074     case 't':
_0x36:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x37
; 0000 0075     return 120 ;
	LDI  R30,LOW(120)
	RJMP _0x20A0007
; 0000 0076     case 'x':
_0x37:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x38
; 0000 0077     return 118 ;
	LDI  R30,LOW(118)
	RJMP _0x20A0007
; 0000 0078     case 'a':
_0x38:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x39
; 0000 0079     return 119 ;
	LDI  R30,LOW(119)
	RJMP _0x20A0007
; 0000 007A     case 'i':
_0x39:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x3A
; 0000 007B     return 48 ;
	LDI  R30,LOW(48)
	RJMP _0x20A0007
; 0000 007C     case 'n':
_0x3A:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x3B
; 0000 007D     return 116 ;
	LDI  R30,LOW(116)
	RJMP _0x20A0007
; 0000 007E     case 'v':
_0x3B:
	CPI  R30,LOW(0x76)
	LDI  R26,HIGH(0x76)
	CPC  R31,R26
	BRNE _0x3C
; 0000 007F     return 62 ;
	LDI  R30,LOW(62)
	RJMP _0x20A0007
; 0000 0080     case '.':
_0x3C:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0x24
; 0000 0081     return 0 ;
	LDI  R30,LOW(0)
	RJMP _0x20A0007
; 0000 0082     };
_0x24:
; 0000 0083 }
	RJMP _0x20A0007
; .FEND
;
;void showTwoNumber(unsigned char input,unsigned char nu)
; 0000 0086 {
_showTwoNumber:
; .FSTART _showTwoNumber
; 0000 0087     switch (nu) {
	ST   -Y,R26
;	input -> Y+1
;	nu -> Y+0
	RCALL SUBOPT_0x0
; 0000 0088     case 1 :
	BRNE _0x41
; 0000 0089     n[nu-1]= digitalWritePort(input/10);
	RCALL SUBOPT_0x4
	SBIW R30,1
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x6
	POP  R26
	POP  R27
	ST   X,R30
; 0000 008A     n[nu]= digitalWritePort(input%10);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x7
	POP  R26
	POP  R27
	RJMP _0xD9
; 0000 008B     break;
; 0000 008C     case 2 :
_0x41:
	RCALL SUBOPT_0x1
	BRNE _0x40
; 0000 008D     n[nu]= digitalWritePort(input/10);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x6
	POP  R26
	POP  R27
	ST   X,R30
; 0000 008E     n[nu+1]= digitalWritePort(input%10);
	RCALL SUBOPT_0x4
	__ADDW1MN _n,1
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x7
	POP  R26
	POP  R27
_0xD9:
	ST   X,R30
; 0000 008F     break;
; 0000 0090     };
_0x40:
; 0000 0091 }
	RJMP _0x20A0008
; .FEND
;
;void showOneNumber(unsigned char input,char nu)
; 0000 0094 {
_showOneNumber:
; .FSTART _showOneNumber
; 0000 0095   n[nu-1]= digitalWritePort(input);
	ST   -Y,R26
;	input -> Y+1
;	nu -> Y+0
	RCALL SUBOPT_0x4
	SBIW R30,1
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	LDD  R26,Y+1
	RCALL _digitalWritePort
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0096 }
	RJMP _0x20A0008
; .FEND
;
;void blinkNumber(){
; 0000 0098 void blinkNumber(){
_blinkNumber:
; .FSTART _blinkNumber
; 0000 0099     switch (positionNumber) {
	MOV  R30,R4
	RCALL SUBOPT_0x8
; 0000 009A     case 1 :
	BRNE _0x46
; 0000 009B     PORTB=n[0];
	LDS  R30,_n
	RCALL SUBOPT_0x9
; 0000 009C     changePositionNumber(positionNumber);
; 0000 009D     positionNumber=2;
	LDI  R30,LOW(2)
	RJMP _0xDA
; 0000 009E     break;
; 0000 009F     case 2 :
_0x46:
	RCALL SUBOPT_0x1
	BRNE _0x47
; 0000 00A0     PORTB=n[1];
	__GETB1MN _n,1
	RCALL SUBOPT_0x9
; 0000 00A1     changePositionNumber(positionNumber);
; 0000 00A2     positionNumber=3;
	LDI  R30,LOW(3)
	RJMP _0xDA
; 0000 00A3     break;
; 0000 00A4     case 3 :
_0x47:
	RCALL SUBOPT_0x2
	BRNE _0x48
; 0000 00A5     PORTB=n[2];
	__GETB1MN _n,2
	RCALL SUBOPT_0x9
; 0000 00A6     changePositionNumber(positionNumber);
; 0000 00A7     positionNumber=4;
	LDI  R30,LOW(4)
	RJMP _0xDA
; 0000 00A8     break;
; 0000 00A9     case 4 :
_0x48:
	RCALL SUBOPT_0x3
	BRNE _0x45
; 0000 00AA     PORTB=n[3];
	__GETB1MN _n,3
	RCALL SUBOPT_0x9
; 0000 00AB     changePositionNumber(positionNumber);
; 0000 00AC     positionNumber=1;
	LDI  R30,LOW(1)
_0xDA:
	MOV  R4,R30
; 0000 00AD     break;
; 0000 00AE     };
_0x45:
; 0000 00AF }
	RET
; .FEND
;
;void clickCheck(){
; 0000 00B1 void clickCheck(){
_clickCheck:
; .FSTART _clickCheck
; 0000 00B2             if(!PIND.0){
	SBIC 0x10,0
	RJMP _0x4A
; 0000 00B3             while(!PIND.0);
_0x4B:
	SBIS 0x10,0
	RJMP _0x4B
; 0000 00B4             buzzer(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _buzzer
; 0000 00B5             click=1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xA
; 0000 00B6             if(runnigState==HOME){
	LDS  R30,_runnigState
	CPI  R30,0
	BRNE _0x4E
; 0000 00B7                 runnigState=MENU;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xB
; 0000 00B8                 click=0;
	RCALL SUBOPT_0xC
; 0000 00B9             }
; 0000 00BA              }
_0x4E:
; 0000 00BB }
_0x4A:
	RET
; .FEND
;
;void brightnessCheck(){
; 0000 00BD void brightnessCheck(){
_brightnessCheck:
; .FSTART _brightnessCheck
; 0000 00BE                if(right==2){
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x4F
; 0000 00BF                buzzer(3);
	RCALL SUBOPT_0xD
; 0000 00C0                if(brightnessSet>1)brightnessSet--;
	CPI  R26,LOW(0x2)
	BRLO _0x50
	RCALL SUBOPT_0xE
; 0000 00C1                if(brightnessSet>1)brightnessSet--;
_0x50:
	RCALL SUBOPT_0xF
	BRLO _0x51
	RCALL SUBOPT_0xE
; 0000 00C2                if(brightnessSet>1)brightnessSet--;
_0x51:
	RCALL SUBOPT_0xF
	BRLO _0x52
	RCALL SUBOPT_0xE
; 0000 00C3                if(brightnessSet>1)brightnessSet--;
_0x52:
	RCALL SUBOPT_0xF
	BRLO _0x53
	RCALL SUBOPT_0xE
; 0000 00C4                if(brightnessSet>1)brightnessSet--;
_0x53:
	RCALL SUBOPT_0xF
	BRLO _0x54
	RCALL SUBOPT_0xE
; 0000 00C5                brightness(brightnessSet);
_0x54:
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
; 0000 00C6                showBrightness();
; 0000 00C7                left=0;right=0;
; 0000 00C8               }
; 0000 00C9               if(left==2){
_0x4F:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x55
; 0000 00CA                buzzer(3);
	RCALL SUBOPT_0xD
; 0000 00CB                if(brightnessSet<99)brightnessSet++;
	CPI  R26,LOW(0x63)
	BRSH _0x56
	RCALL SUBOPT_0x12
; 0000 00CC                if(brightnessSet<99)brightnessSet++;
_0x56:
	RCALL SUBOPT_0x13
	BRSH _0x57
	RCALL SUBOPT_0x12
; 0000 00CD                if(brightnessSet<99)brightnessSet++;
_0x57:
	RCALL SUBOPT_0x13
	BRSH _0x58
	RCALL SUBOPT_0x12
; 0000 00CE                if(brightnessSet<99)brightnessSet++;
_0x58:
	RCALL SUBOPT_0x13
	BRSH _0x59
	RCALL SUBOPT_0x12
; 0000 00CF                if(brightnessSet<99)brightnessSet++;
_0x59:
	RCALL SUBOPT_0x13
	BRSH _0x5A
	RCALL SUBOPT_0x12
; 0000 00D0                brightness(brightnessSet);
_0x5A:
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
; 0000 00D1                showBrightness();
; 0000 00D2                left=0;right=0;
; 0000 00D3               }
; 0000 00D4 }
_0x55:
	RET
; .FEND
;
;void showBrightness(){
; 0000 00D6 void showBrightness(){
_showBrightness:
; .FSTART _showBrightness
; 0000 00D7                stopClock(5);
	LDI  R26,LOW(5)
	RCALL _stopClock
; 0000 00D8                showTwoNumber(brightnessSet,2);
	RCALL SUBOPT_0x14
; 0000 00D9                showOneNumber('b',1);
	RCALL SUBOPT_0x15
; 0000 00DA                showOneNumber('r',2);
	RJMP _0x20A0006
; 0000 00DB }
; .FEND
;void stopClock(unsigned char timeStop){
; 0000 00DC void stopClock(unsigned char timeStop){
_stopClock:
; .FSTART _stopClock
; 0000 00DD  clock=0;
	ST   -Y,R26
;	timeStop -> Y+0
	CLR  R13
; 0000 00DE  timeStopClock = timeStop;
	LDD  R12,Y+0
; 0000 00DF  startCounterTimer();
	RCALL _startCounterTimer
; 0000 00E0  stopClockState=1;
	LDI  R30,LOW(1)
	STS  _stopClockState,R30
; 0000 00E1 }
	RJMP _0x20A0007
; .FEND
;
;void checkTimeForClock(){
; 0000 00E3 void checkTimeForClock(){
_checkTimeForClock:
; .FSTART _checkTimeForClock
; 0000 00E4 if(stopClockState){
	LDS  R30,_stopClockState
	CPI  R30,0
	BREQ _0x5B
; 0000 00E5   if(timeStopClock>0){
	LDI  R30,LOW(0)
	CP   R30,R12
	BRSH _0x5C
; 0000 00E6    timeStopClock-- ;
	DEC  R12
; 0000 00E7    }else{
	RJMP _0x5D
_0x5C:
; 0000 00E8    clock=1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 00E9    stopCounterTimer();
	RCALL _stopCounterTimer
; 0000 00EA    stopClockState=0;
	LDI  R30,LOW(0)
	STS  _stopClockState,R30
; 0000 00EB    }
_0x5D:
; 0000 00EC }
; 0000 00ED }
_0x5B:
	RET
; .FEND
;unsigned char right1(){
; 0000 00EE unsigned char right1(){
_right1:
; .FSTART _right1
; 0000 00EF     if(left==2){
	LDI  R30,LOW(2)
	CP   R30,R11
	BREQ _0x20A000A
; 0000 00F0         right=0;left=0;
; 0000 00F1         return 1;
; 0000 00F2     }else{
; 0000 00F3         return 0;
	RJMP _0x20A0009
; 0000 00F4     }
; 0000 00F5 }
; .FEND
;unsigned char left1(){
; 0000 00F6 unsigned char left1(){
_left1:
; .FSTART _left1
; 0000 00F7     if(right==2){
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x60
; 0000 00F8         right=0;left=0;
_0x20A000A:
	CLR  R10
	CLR  R11
; 0000 00F9         return 1;
	LDI  R30,LOW(1)
	RET
; 0000 00FA     }else{
_0x60:
; 0000 00FB         return 0;
_0x20A0009:
	LDI  R30,LOW(0)
	RET
; 0000 00FC     }
; 0000 00FD }
	RET
; .FEND
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 00FF {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0x16
; 0000 0100     switch (left) {
	MOV  R30,R11
	RCALL SUBOPT_0x17
; 0000 0101     case 0 :
	BRNE _0x65
; 0000 0102     right=1;
	LDI  R30,LOW(1)
	RJMP _0xDB
; 0000 0103     break;
; 0000 0104     case 1 :
_0x65:
	RCALL SUBOPT_0x18
	BRNE _0x64
; 0000 0105     right=2;
	LDI  R30,LOW(2)
_0xDB:
	MOV  R10,R30
; 0000 0106     break;
; 0000 0107     };
_0x64:
; 0000 0108 }
	RJMP _0xDE
; .FEND
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 010B {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x16
; 0000 010C     switch (right) {
	MOV  R30,R10
	RCALL SUBOPT_0x17
; 0000 010D     case 0 :
	BRNE _0x6A
; 0000 010E     left=1;
	LDI  R30,LOW(1)
	RJMP _0xDC
; 0000 010F     break;
; 0000 0110     case 1 :
_0x6A:
	RCALL SUBOPT_0x18
	BRNE _0x69
; 0000 0111     left=2;
	LDI  R30,LOW(2)
_0xDC:
	MOV  R11,R30
; 0000 0112     break;
; 0000 0113     };
_0x69:
; 0000 0114 }
_0xDE:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0117 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	RCALL SUBOPT_0x19
; 0000 0118 checkTimeForClock();
	RCALL _checkTimeForClock
; 0000 0119 blinkNumberChangeTimer();
	RCALL _blinkNumberChangeTimer
; 0000 011A TCNT1H=0x9E58 >> 8;
	LDI  R30,LOW(158)
	OUT  0x2D,R30
; 0000 011B TCNT1L=0x9E58 & 0xff;
	LDI  R30,LOW(88)
	OUT  0x2C,R30
; 0000 011C }
	RJMP _0xDD
; .FEND
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 011F {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	RCALL SUBOPT_0x19
; 0000 0120     blinkNumber();
	RCALL _blinkNumber
; 0000 0121 }
	RJMP _0xDD
; .FEND
;
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
; 0000 0124 {
_timer2_comp_isr:
; .FSTART _timer2_comp_isr
	RCALL SUBOPT_0x19
; 0000 0125     changePositionNumber(0);
	LDI  R26,LOW(0)
	RCALL _changePositionNumber
; 0000 0126 }
_0xDD:
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
;
;void brightness(unsigned char timeBR){
; 0000 0128 void brightness(unsigned char timeBR){
_brightness:
; .FSTART _brightness
; 0000 0129     unsigned char temp=0;
; 0000 012A     OCR2=0;
	ST   -Y,R26
	ST   -Y,R17
;	timeBR -> Y+1
;	temp -> R17
	LDI  R17,0
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 012B     timeBR=(timeBR*255)/100  ;
	LDD  R26,Y+1
	LDI  R30,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	STD  Y+1,R30
; 0000 012C     for(temp=0;temp<timeBR;temp++){
	LDI  R17,LOW(0)
_0x6D:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0x6E
; 0000 012D         if(OCR2<255){
	IN   R30,0x23
	CPI  R30,LOW(0xFF)
	BRSH _0x6F
; 0000 012E          OCR2= OCR2+1;
	IN   R30,0x23
	SUBI R30,-LOW(1)
	OUT  0x23,R30
; 0000 012F         }}
_0x6F:
	SUBI R17,-1
	RJMP _0x6D
_0x6E:
; 0000 0130 }
	LDD  R17,Y+0
_0x20A0008:
	ADIW R28,2
	RET
; .FEND
;
;void blinkNumberChangeTimer(){
; 0000 0132 void blinkNumberChangeTimer(){
_blinkNumberChangeTimer:
; .FSTART _blinkNumberChangeTimer
; 0000 0133     if(blinkNumberChageState){
	LDS  R30,_blinkNumberChageState
	CPI  R30,0
	BREQ _0x70
; 0000 0134     if(counterBlinkNumber<1){
	LDS  R26,_counterBlinkNumber
	CPI  R26,LOW(0x1)
	BRSH _0x71
; 0000 0135     counterBlinkNumber++;
	RCALL SUBOPT_0x1A
; 0000 0136     switch (seqNumber)
; 0000 0137     {
; 0000 0138     case 1:
	BRNE _0x75
; 0000 0139         portEnable[1]=0; portEnable[2]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _portEnable,1
	__PUTB1MN _portEnable,2
; 0000 013A         break;
	RJMP _0x74
; 0000 013B     case 2 :
_0x75:
	RCALL SUBOPT_0x1
	BRNE _0x74
; 0000 013C         portEnable[3]=0; portEnable[4]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _portEnable,3
	__PUTB1MN _portEnable,4
; 0000 013D     break;
; 0000 013E     }
_0x74:
; 0000 013F     } else{if(counterBlinkNumber<4){
	RJMP _0x77
_0x71:
	LDS  R26,_counterBlinkNumber
	CPI  R26,LOW(0x4)
	BRSH _0x78
; 0000 0140         counterBlinkNumber++;
	RCALL SUBOPT_0x1A
; 0000 0141     switch (seqNumber)
; 0000 0142     {
; 0000 0143     case 1:
	BRNE _0x7C
; 0000 0144         portEnable[1]=1; portEnable[2]=1;
	RCALL SUBOPT_0x1B
; 0000 0145         break;
	RJMP _0x7B
; 0000 0146     case 2 :
_0x7C:
	RCALL SUBOPT_0x1
	BRNE _0x7B
; 0000 0147         portEnable[3]=1; portEnable[4]=1;
	RCALL SUBOPT_0x1C
; 0000 0148     break;
; 0000 0149     }
_0x7B:
; 0000 014A     }else{counterBlinkNumber=0;}}}
	RJMP _0x7E
_0x78:
	LDI  R30,LOW(0)
	STS  _counterBlinkNumber,R30
_0x7E:
_0x77:
; 0000 014B }
_0x70:
	RET
; .FEND
;
;void blinkEditNumber(unsigned char seqNu){
; 0000 014D void blinkEditNumber(unsigned char seqNu){
_blinkEditNumber:
; .FSTART _blinkEditNumber
; 0000 014E     if(blinkNumberChageState){
	ST   -Y,R26
;	seqNu -> Y+0
	LDS  R30,_blinkNumberChageState
	CPI  R30,0
	BREQ _0x7F
; 0000 014F         stopCounterTimer();
	RCALL _stopCounterTimer
; 0000 0150         blinkNumberChageState=0;
	LDI  R30,LOW(0)
	STS  _blinkNumberChageState,R30
; 0000 0151         portEnable[1]=1; portEnable[2]=1;
	RCALL SUBOPT_0x1B
; 0000 0152         portEnable[3]=1; portEnable[4]=1;
	RCALL SUBOPT_0x1C
; 0000 0153     }
; 0000 0154     if(seqNu>0){
_0x7F:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRLO _0x80
; 0000 0155     seqNumber = seqNu ;
	LD   R30,Y
	STS  _seqNumber,R30
; 0000 0156     startCounterTimer();
	RCALL _startCounterTimer
; 0000 0157     blinkNumberChageState=1;
	LDI  R30,LOW(1)
	STS  _blinkNumberChageState,R30
; 0000 0158         }
; 0000 0159     }
_0x80:
_0x20A0007:
	ADIW R28,1
	RET
; .FEND
;
;void showClock(){
; 0000 015B void showClock(){
_showClock:
; .FSTART _showClock
; 0000 015C     rtc_get_time(&h,&m,&s);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	RCALL _rtc_get_time
; 0000 015D     if(alarmSet==1|alarmSet==2){
	RCALL SUBOPT_0x1D
	MOV  R1,R30
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x1E
	MOV  R30,R1
	LDI  R26,LOW(2)
	RCALL __EQB12
	OR   R30,R0
	BREQ _0x81
; 0000 015E         if(alHour==h & alMinute==m ){
	LDI  R26,LOW(_alHour)
	LDI  R27,HIGH(_alHour)
	RCALL __EEPROMRDB
	MOV  R26,R30
	MOV  R30,R6
	RCALL SUBOPT_0x1E
	LDI  R26,LOW(_alMinute)
	LDI  R27,HIGH(_alMinute)
	RCALL __EEPROMRDB
	MOV  R26,R30
	MOV  R30,R9
	RCALL SUBOPT_0x1F
	BREQ _0x82
; 0000 015F         runnigState=ALARM;
	LDI  R30,LOW(6)
	RCALL SUBOPT_0xB
; 0000 0160         if(alarmSet==1)alarmSet=0;
	RCALL SUBOPT_0x1D
	CPI  R30,LOW(0x1)
	BRNE _0x83
	RCALL SUBOPT_0x20
; 0000 0161         }}
_0x83:
_0x82:
; 0000 0162   if(clock){
_0x81:
	TST  R13
	BREQ _0x84
; 0000 0163     showTwoNumber(h,1);
	RCALL SUBOPT_0x21
; 0000 0164     showTwoNumber(m,2);
; 0000 0165     }
; 0000 0166 }
_0x84:
	RET
; .FEND
;void playAlarm(){
; 0000 0167 void playAlarm(){
_playAlarm:
; .FSTART _playAlarm
; 0000 0168     showTwoNumber(alHour,1);
	LDI  R26,LOW(_alHour)
	LDI  R27,HIGH(_alHour)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x22
	RCALL _showTwoNumber
; 0000 0169     showTwoNumber(alMinute,2);
	LDI  R26,LOW(_alMinute)
	LDI  R27,HIGH(_alMinute)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x23
	RCALL _showTwoNumber
; 0000 016A     runnigState = HOME;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xB
; 0000 016B     stopClock(100);
	LDI  R26,LOW(100)
	RCALL _stopClock
; 0000 016C     buzzer(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _buzzer
; 0000 016D }
	RET
; .FEND
;void exitMenu(){
; 0000 016E void exitMenu(){
_exitMenu:
; .FSTART _exitMenu
; 0000 016F         runnigState=HOME;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xB
; 0000 0170         menuPosition = SETTIME;
	RCALL SUBOPT_0x24
; 0000 0171         click=0;
	RCALL SUBOPT_0xC
; 0000 0172       blinkEditNumber(0);
	LDI  R26,LOW(0)
	RCALL _blinkEditNumber
; 0000 0173 }
	RET
; .FEND
;void showStringClock(){
; 0000 0174 void showStringClock(){
_showStringClock:
; .FSTART _showStringClock
; 0000 0175        showOneNumber('c',1);
	LDI  R30,LOW(99)
	RCALL SUBOPT_0x22
	RCALL _showOneNumber
; 0000 0176        showOneNumber('l',2);
	LDI  R30,LOW(108)
	RCALL SUBOPT_0x23
	RCALL _showOneNumber
; 0000 0177        showOneNumber('o',3);
	LDI  R30,LOW(111)
	RCALL SUBOPT_0x25
; 0000 0178        showOneNumber('c',4);
	LDI  R30,LOW(99)
	RJMP _0x20A0004
; 0000 0179 }
; .FEND
;void showStringExit(){
; 0000 017A void showStringExit(){
_showStringExit:
; .FSTART _showStringExit
; 0000 017B        showOneNumber('e',1);
	LDI  R30,LOW(101)
	RCALL SUBOPT_0x22
	RCALL _showOneNumber
; 0000 017C        showOneNumber('x',2);
	LDI  R30,LOW(120)
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x26
; 0000 017D        showOneNumber('i',3);
; 0000 017E        showOneNumber('t',4);
	LDI  R30,LOW(116)
	RJMP _0x20A0004
; 0000 017F }
; .FEND
;void showStringAlarm(){
; 0000 0180 void showStringAlarm(){
_showStringAlarm:
; .FSTART _showStringAlarm
; 0000 0181        showOneNumber('a',1);
	LDI  R30,LOW(97)
	RCALL SUBOPT_0x22
	RCALL _showOneNumber
; 0000 0182        showOneNumber('l',2);
	LDI  R30,LOW(108)
	RCALL SUBOPT_0x23
	RCALL _showOneNumber
; 0000 0183        showOneNumber('a',3);
	LDI  R30,LOW(97)
	RJMP _0x20A0005
; 0000 0184        showOneNumber('r',4);
; 0000 0185 }
; .FEND
;void showStringBrightness(){
; 0000 0186 void showStringBrightness(){
_showStringBrightness:
; .FSTART _showStringBrightness
; 0000 0187        showOneNumber('b',1);
	RCALL SUBOPT_0x15
; 0000 0188        showOneNumber('r',2);
	RCALL SUBOPT_0x26
; 0000 0189        showOneNumber('i',3);
; 0000 018A        showOneNumber(9,4);
	LDI  R30,LOW(9)
	RJMP _0x20A0004
; 0000 018B }
; .FEND
;void showStringOne(){
; 0000 018C void showStringOne(){
_showStringOne:
; .FSTART _showStringOne
; 0000 018D     showOneNumber('o',2);
	LDI  R30,LOW(111)
	RCALL SUBOPT_0x23
	RCALL _showOneNumber
; 0000 018E     showOneNumber('n',3);
	LDI  R30,LOW(110)
	RCALL SUBOPT_0x25
; 0000 018F     showOneNumber('e',4);
	LDI  R30,LOW(101)
	RJMP _0x20A0004
; 0000 0190 }
; .FEND
;void showStringOff(){
; 0000 0191 void showStringOff(){
_showStringOff:
; .FSTART _showStringOff
; 0000 0192     showOneNumber('.',1);
	LDI  R30,LOW(46)
	RCALL SUBOPT_0x22
	RCALL _showOneNumber
; 0000 0193     showOneNumber('o',2);
	LDI  R30,LOW(111)
	RCALL SUBOPT_0x23
	RCALL _showOneNumber
; 0000 0194     showOneNumber('f',3);
	LDI  R30,LOW(102)
	RCALL SUBOPT_0x25
; 0000 0195     showOneNumber('f',4);
	LDI  R30,LOW(102)
	RJMP _0x20A0004
; 0000 0196 }
; .FEND
;void showStringBip(){
; 0000 0197 void showStringBip(){
_showStringBip:
; .FSTART _showStringBip
; 0000 0198     showOneNumber('.',1);
	LDI  R30,LOW(46)
	RCALL SUBOPT_0x22
	RCALL _showOneNumber
; 0000 0199     showOneNumber('b',2);
	LDI  R30,LOW(98)
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x26
; 0000 019A     showOneNumber('i',3);
; 0000 019B     showOneNumber('p',4);
	LDI  R30,LOW(112)
	RJMP _0x20A0004
; 0000 019C }
; .FEND
;void showStringEvery(){
; 0000 019D void showStringEvery(){
_showStringEvery:
; .FSTART _showStringEvery
; 0000 019E     showOneNumber('e',1);
	LDI  R30,LOW(101)
	RCALL SUBOPT_0x22
	RCALL _showOneNumber
; 0000 019F     showOneNumber('v',2);
	LDI  R30,LOW(118)
	RCALL SUBOPT_0x23
	RCALL _showOneNumber
; 0000 01A0     showOneNumber('e',3);
	LDI  R30,LOW(101)
_0x20A0005:
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _showOneNumber
; 0000 01A1     showOneNumber('r',4);
	LDI  R30,LOW(114)
_0x20A0004:
	ST   -Y,R30
	LDI  R26,LOW(4)
_0x20A0006:
	RCALL _showOneNumber
; 0000 01A2 }
	RET
; .FEND
;void setBrightnessMenu(){
; 0000 01A3 void setBrightnessMenu(){
_setBrightnessMenu:
; .FSTART _setBrightnessMenu
; 0000 01A4     click=0;
	RCALL SUBOPT_0xC
; 0000 01A5     blinkEditNumber(2);
	LDI  R26,LOW(2)
	RCALL _blinkEditNumber
; 0000 01A6         while (click==0 & runnigState==MENU)
_0x85:
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
	BREQ _0x87
; 0000 01A7     {
; 0000 01A8         clickCheck();
	RCALL SUBOPT_0x29
; 0000 01A9         if(right1()){if(brightnessSet<99)brightnessSet++;}
	BREQ _0x88
	RCALL SUBOPT_0x13
	BRSH _0x89
	RCALL SUBOPT_0x12
_0x89:
; 0000 01AA         if(left1()){if(brightnessSet>1)brightnessSet--;}
_0x88:
	RCALL SUBOPT_0x2A
	BREQ _0x8A
	RCALL SUBOPT_0xF
	BRLO _0x8B
	RCALL SUBOPT_0xE
_0x8B:
; 0000 01AB         showTwoNumber(brightnessSet,2);
_0x8A:
	RCALL SUBOPT_0x14
; 0000 01AC     }
	RJMP _0x85
_0x87:
; 0000 01AD     brightness(brightnessSet);
	RCALL SUBOPT_0x10
	RCALL _brightness
; 0000 01AE     brightnessMem=brightnessSet;
	LDS  R30,_brightnessSet
	LDI  R26,LOW(_brightnessMem)
	LDI  R27,HIGH(_brightnessMem)
	RCALL __EEPROMWRB
; 0000 01AF     exitMenu();
	RCALL _exitMenu
; 0000 01B0 }
	RET
; .FEND
;void setTimeMenu(){
; 0000 01B1 void setTimeMenu(){
_setTimeMenu:
; .FSTART _setTimeMenu
; 0000 01B2     unsigned char hour=h,minute=m;
; 0000 01B3         click=0;
	RCALL __SAVELOCR2
;	hour -> R17
;	minute -> R16
	MOV  R17,R6
	MOV  R16,R9
	RCALL SUBOPT_0xC
; 0000 01B4         showTwoNumber(h,1);
	RCALL SUBOPT_0x21
; 0000 01B5         showTwoNumber(m,2);
; 0000 01B6         blinkEditNumber(1);
	LDI  R26,LOW(1)
	RCALL _blinkEditNumber
; 0000 01B7     while (click==0 & runnigState==MENU)
_0x8C:
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
	BREQ _0x8E
; 0000 01B8     {
; 0000 01B9         clickCheck();
	RCALL SUBOPT_0x29
; 0000 01BA         if(right1()){if(hour<24)hour++;}
	BREQ _0x8F
	CPI  R17,24
	BRSH _0x90
	SUBI R17,-1
_0x90:
; 0000 01BB         if(left1()){if(hour>0)hour--;}
_0x8F:
	RCALL SUBOPT_0x2A
	BREQ _0x91
	CPI  R17,1
	BRLO _0x92
	SUBI R17,1
_0x92:
; 0000 01BC         showTwoNumber(hour,1);
_0x91:
	ST   -Y,R17
	LDI  R26,LOW(1)
	RCALL _showTwoNumber
; 0000 01BD     }
	RJMP _0x8C
_0x8E:
; 0000 01BE     click=0;
	RCALL SUBOPT_0xC
; 0000 01BF     blinkEditNumber(2);
	LDI  R26,LOW(2)
	RCALL _blinkEditNumber
; 0000 01C0     while (click==0 & runnigState==MENU)
_0x93:
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
	BREQ _0x95
; 0000 01C1     {
; 0000 01C2         clickCheck();
	RCALL SUBOPT_0x29
; 0000 01C3         if(right1()){if(minute<59)minute++;}
	BREQ _0x96
	CPI  R16,59
	BRSH _0x97
	SUBI R16,-1
_0x97:
; 0000 01C4         if(left1()){if(minute>0)minute--;}
_0x96:
	RCALL SUBOPT_0x2A
	BREQ _0x98
	CPI  R16,1
	BRLO _0x99
	SUBI R16,1
_0x99:
; 0000 01C5         showTwoNumber(minute,2);
_0x98:
	ST   -Y,R16
	LDI  R26,LOW(2)
	RCALL _showTwoNumber
; 0000 01C6     }
	RJMP _0x93
_0x95:
; 0000 01C7     rtc_set_time(hour,minute,0);
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(0)
	RCALL _rtc_set_time
; 0000 01C8     exitMenu();
	RJMP _0x20A0003
; 0000 01C9 }
; .FEND
;void setAlarmMenu(){
; 0000 01CA void setAlarmMenu(){
_setAlarmMenu:
; .FSTART _setAlarmMenu
; 0000 01CB    unsigned char alHour1=0,alMinute1=0;
; 0000 01CC    alHour1=h;alMinute1=m;
	RCALL __SAVELOCR2
;	alHour1 -> R17
;	alMinute1 -> R16
	LDI  R17,0
	LDI  R16,0
	MOV  R17,R6
	MOV  R16,R9
; 0000 01CD     click=0;
	RCALL SUBOPT_0xC
; 0000 01CE     alarmSet=0;
	RCALL SUBOPT_0x20
; 0000 01CF     while (click==0 & runnigState==MENU)
_0x9A:
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
	BREQ _0x9C
; 0000 01D0     {   switch (alarmSet)
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x17
; 0000 01D1          {
; 0000 01D2         case 0:
	BRNE _0xA0
; 0000 01D3         showStringOff();
	RCALL _showStringOff
; 0000 01D4         if(right1()){alarmSet=1;}
	RCALL SUBOPT_0x2B
	BREQ _0xA1
	RCALL SUBOPT_0x2C
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 01D5         if(left1()){alarmSet=2;}
_0xA1:
	RCALL SUBOPT_0x2A
	BREQ _0xA2
	RCALL SUBOPT_0x2C
	LDI  R30,LOW(2)
	RCALL __EEPROMWRB
; 0000 01D6         break;
_0xA2:
	RJMP _0x9F
; 0000 01D7         case 1:
_0xA0:
	RCALL SUBOPT_0x18
	BRNE _0xA3
; 0000 01D8         showStringOne();
	RCALL _showStringOne
; 0000 01D9         if(right1()){alarmSet=2;}
	RCALL SUBOPT_0x2B
	BREQ _0xA4
	RCALL SUBOPT_0x2C
	LDI  R30,LOW(2)
	RCALL __EEPROMWRB
; 0000 01DA         if(left1()){alarmSet=0;}
_0xA4:
	RCALL SUBOPT_0x2A
	BREQ _0xA5
	RCALL SUBOPT_0x20
; 0000 01DB         break;
_0xA5:
	RJMP _0x9F
; 0000 01DC         case 2:
_0xA3:
	RCALL SUBOPT_0x1
	BRNE _0x9F
; 0000 01DD         showStringEvery();
	RCALL _showStringEvery
; 0000 01DE         if(right1()){alarmSet=0;}
	RCALL SUBOPT_0x2B
	BREQ _0xA7
	RCALL SUBOPT_0x20
; 0000 01DF         if(left1()){alarmSet=1;}
_0xA7:
	RCALL SUBOPT_0x2A
	BREQ _0xA8
	RCALL SUBOPT_0x2C
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 01E0         break;
_0xA8:
; 0000 01E1         }
_0x9F:
; 0000 01E2         clickCheck();
	RCALL _clickCheck
; 0000 01E3     }
	RJMP _0x9A
_0x9C:
; 0000 01E4         click=0;
	RCALL SUBOPT_0xC
; 0000 01E5         showTwoNumber(h,1);
	RCALL SUBOPT_0x21
; 0000 01E6         showTwoNumber(m,2);
; 0000 01E7         blinkEditNumber(1);
	LDI  R26,LOW(1)
	RCALL _blinkEditNumber
; 0000 01E8     while (click==0 & runnigState==MENU)
_0xA9:
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
	BREQ _0xAB
; 0000 01E9     {
; 0000 01EA         clickCheck();
	RCALL SUBOPT_0x29
; 0000 01EB         if(right1()){if(alHour1<24)alHour1++;}
	BREQ _0xAC
	CPI  R17,24
	BRSH _0xAD
	SUBI R17,-1
_0xAD:
; 0000 01EC         if(left1()){if(alHour1>0)alHour1--;}
_0xAC:
	RCALL SUBOPT_0x2A
	BREQ _0xAE
	CPI  R17,1
	BRLO _0xAF
	SUBI R17,1
_0xAF:
; 0000 01ED         showTwoNumber(alHour1,1);
_0xAE:
	ST   -Y,R17
	LDI  R26,LOW(1)
	RCALL _showTwoNumber
; 0000 01EE     }
	RJMP _0xA9
_0xAB:
; 0000 01EF     click=0;
	RCALL SUBOPT_0xC
; 0000 01F0     blinkEditNumber(2);
	LDI  R26,LOW(2)
	RCALL _blinkEditNumber
; 0000 01F1     while (click==0 & runnigState==MENU)
_0xB0:
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
	BREQ _0xB2
; 0000 01F2     {
; 0000 01F3         clickCheck();
	RCALL SUBOPT_0x29
; 0000 01F4         if(right1()){if(alMinute1<59)alMinute1++;}
	BREQ _0xB3
	CPI  R16,59
	BRSH _0xB4
	SUBI R16,-1
_0xB4:
; 0000 01F5         if(left1()){if(alMinute1>0)alMinute1--;}
_0xB3:
	RCALL SUBOPT_0x2A
	BREQ _0xB5
	CPI  R16,1
	BRLO _0xB6
	SUBI R16,1
_0xB6:
; 0000 01F6         showTwoNumber(alMinute1,2);
_0xB5:
	ST   -Y,R16
	LDI  R26,LOW(2)
	RCALL _showTwoNumber
; 0000 01F7     }
	RJMP _0xB0
_0xB2:
; 0000 01F8     alHour=alHour1;alMinute=alMinute1;
	MOV  R30,R17
	LDI  R26,LOW(_alHour)
	LDI  R27,HIGH(_alHour)
	RCALL __EEPROMWRB
	MOV  R30,R16
	LDI  R26,LOW(_alMinute)
	LDI  R27,HIGH(_alMinute)
	RCALL __EEPROMWRB
; 0000 01F9     exitMenu();
_0x20A0003:
	RCALL _exitMenu
; 0000 01FA }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void setMuteMenu(){
; 0000 01FB void setMuteMenu(){
_setMuteMenu:
; .FSTART _setMuteMenu
; 0000 01FC 
; 0000 01FD }
	RET
; .FEND
;void showMenu(){
; 0000 01FE void showMenu(){
_showMenu:
; .FSTART _showMenu
; 0000 01FF     switch (menuPosition)
	LDS  R30,_menuPosition
	LDI  R31,0
; 0000 0200     {
; 0000 0201     case SETTIME:
	RCALL SUBOPT_0x1
	BRNE _0xBA
; 0000 0202         showStringClock();
	RCALL _showStringClock
; 0000 0203         if(click)setTimeMenu();
	RCALL SUBOPT_0x2D
	BREQ _0xBB
	RCALL _setTimeMenu
; 0000 0204         if(right1())menuPosition=SETALARM;
_0xBB:
	RCALL SUBOPT_0x2B
	BREQ _0xBC
	RCALL SUBOPT_0x2E
; 0000 0205         if(left1())menuPosition=EXIT;
_0xBC:
	RCALL SUBOPT_0x2A
	BREQ _0xBD
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2F
; 0000 0206         break;
_0xBD:
	RJMP _0xB9
; 0000 0207     case SETALARM:
_0xBA:
	RCALL SUBOPT_0x2
	BRNE _0xBE
; 0000 0208         showStringAlarm();
	RCALL _showStringAlarm
; 0000 0209         if(click)setAlarmMenu();
	RCALL SUBOPT_0x2D
	BREQ _0xBF
	RCALL _setAlarmMenu
; 0000 020A         if(right1())menuPosition=BRIGHTNESS;
_0xBF:
	RCALL SUBOPT_0x2B
	BREQ _0xC0
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x2F
; 0000 020B         if(left1())menuPosition=SETTIME;
_0xC0:
	RCALL SUBOPT_0x2A
	BREQ _0xC1
	RCALL SUBOPT_0x24
; 0000 020C         break;
_0xC1:
	RJMP _0xB9
; 0000 020D     case BRIGHTNESS:
_0xBE:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xC2
; 0000 020E         showStringBrightness();
	RCALL _showStringBrightness
; 0000 020F         if(click)setBrightnessMenu();
	RCALL SUBOPT_0x2D
	BREQ _0xC3
	RCALL _setBrightnessMenu
; 0000 0210         if(right1())menuPosition=MUTE;
_0xC3:
	RCALL SUBOPT_0x2B
	BREQ _0xC4
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x2F
; 0000 0211         if(left1())menuPosition=SETALARM;
_0xC4:
	RCALL SUBOPT_0x2A
	BREQ _0xC5
	RCALL SUBOPT_0x2E
; 0000 0212         break;
_0xC5:
	RJMP _0xB9
; 0000 0213         case MUTE:
_0xC2:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xC6
; 0000 0214         showStringBip();
	RCALL _showStringBip
; 0000 0215         if(click)setMuteMenu();
	RCALL SUBOPT_0x2D
	BREQ _0xC7
	RCALL _setMuteMenu
; 0000 0216         if(right1())menuPosition=EXIT;
_0xC7:
	RCALL SUBOPT_0x2B
	BREQ _0xC8
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2F
; 0000 0217         if(left1())menuPosition=BRIGHTNESS;
_0xC8:
	RCALL SUBOPT_0x2A
	BREQ _0xC9
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x2F
; 0000 0218         break;
_0xC9:
	RJMP _0xB9
; 0000 0219     case EXIT:
_0xC6:
	RCALL SUBOPT_0x3
	BRNE _0xB9
; 0000 021A         showStringExit();
	RCALL _showStringExit
; 0000 021B         if(click)exitMenu();
	RCALL SUBOPT_0x2D
	BREQ _0xCB
	RCALL _exitMenu
; 0000 021C         if(right1())menuPosition=SETTIME;
_0xCB:
	RCALL SUBOPT_0x2B
	BREQ _0xCC
	RCALL SUBOPT_0x24
; 0000 021D         if(left1())menuPosition=SETALARM;
_0xCC:
	RCALL SUBOPT_0x2A
	BREQ _0xCD
	RCALL SUBOPT_0x2E
; 0000 021E         break;
_0xCD:
; 0000 021F     }
_0xB9:
; 0000 0220 }
	RET
; .FEND
;void main(void)
; 0000 0222 {
_main:
; .FSTART _main
; 0000 0223 
; 0000 0224 portConfig();
	RCALL _portConfig
; 0000 0225 startTimers();
	RCALL _startTimers
; 0000 0226 startIntrupts();
	RCALL _startIntrupts
; 0000 0227 
; 0000 0228 #asm("sei")
	sei
; 0000 0229 
; 0000 022A i2c_init();
	RCALL _i2c_init
; 0000 022B rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 022C brightness(brightnessMem);
	LDI  R26,LOW(_brightnessMem)
	LDI  R27,HIGH(_brightnessMem)
	RCALL __EEPROMRDB
	MOV  R26,R30
	RCALL _brightness
; 0000 022D buzzer(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _buzzer
; 0000 022E brightnessSet=brightnessMem;
	LDI  R26,LOW(_brightnessMem)
	LDI  R27,HIGH(_brightnessMem)
	RCALL __EEPROMRDB
	STS  _brightnessSet,R30
; 0000 022F 
; 0000 0230 while (1)
_0xCE:
; 0000 0231       {
; 0000 0232             clickCheck();
	RCALL _clickCheck
; 0000 0233             switch (runnigState)
	LDS  R30,_runnigState
	RCALL SUBOPT_0x17
; 0000 0234             {
; 0000 0235             case HOME:
	BRNE _0xD4
; 0000 0236             brightnessCheck();
	RCALL _brightnessCheck
; 0000 0237             showClock();
	RCALL _showClock
; 0000 0238             break;
	RJMP _0xD3
; 0000 0239             case MENU:
_0xD4:
	RCALL SUBOPT_0x18
	BRNE _0xD5
; 0000 023A             showMenu();
	RCALL _showMenu
; 0000 023B             break;
	RJMP _0xD3
; 0000 023C             case ALARM:
_0xD5:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xD3
; 0000 023D             playAlarm();
	RCALL _playAlarm
; 0000 023E             break;
; 0000 023F             }
_0xD3:
; 0000 0240       }
	RJMP _0xCE
; 0000 0241 }
_0xD7:
	RJMP _0xD7
; .FEND
;
;
;
;
;void stopTimers(){
; 0000 0246 void stopTimers(){
; 0000 0247 ASSR=0<<AS2;
; 0000 0248 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
; 0000 0249 TCNT2=0x00;
; 0000 024A TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
; 0000 024B }
;
;void startTimers(){
; 0000 024D void startTimers(){
_startTimers:
; .FSTART _startTimers
; 0000 024E ASSR=0<<AS2;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 024F TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (1<<CS21) | (1<<CS20);
	LDI  R30,LOW(3)
	OUT  0x25,R30
; 0000 0250 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0251 OCR2=0xff;
	LDI  R30,LOW(255)
	OUT  0x23,R30
; 0000 0252 TIMSK=(1<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(196)
	OUT  0x39,R30
; 0000 0253 }
	RET
; .FEND
;
;void startCounterTimer(){
; 0000 0255 void startCounterTimer(){
_startCounterTimer:
; .FSTART _startCounterTimer
; 0000 0256 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0257 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 0258 TCNT1H=0x9E;
	LDI  R30,LOW(158)
	OUT  0x2D,R30
; 0000 0259 TCNT1L=0x58;
	LDI  R30,LOW(88)
	RJMP _0x20A0002
; 0000 025A ICR1H=0x00;
; 0000 025B ICR1L=0x00;
; 0000 025C OCR1AH=0x00;
; 0000 025D OCR1AL=0x00;
; 0000 025E OCR1BH=0x00;
; 0000 025F OCR1BL=0x00;
; 0000 0260 }
; .FEND
;
;void stopCounterTimer(){
; 0000 0262 void stopCounterTimer(){
_stopCounterTimer:
; .FSTART _stopCounterTimer
; 0000 0263 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0264 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0265 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0266 TCNT1L=0x00;
_0x20A0002:
	OUT  0x2C,R30
; 0000 0267 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0268 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0269 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 026A OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 026B OCR1BH=0x00;
	OUT  0x29,R30
; 0000 026C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 026D }
	RET
; .FEND
;
;void startIntrupts(){
; 0000 026F void startIntrupts(){
_startIntrupts:
; .FSTART _startIntrupts
; 0000 0270 GICR|=(1<<INT1) | (1<<INT0);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 0271 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0272 GIFR=(1<<INTF1) | (1<<INTF0);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0273 }
	RET
; .FEND
;
;void stopIntrupts(){
; 0000 0275 void stopIntrupts(){
; 0000 0276  GICR|=(0<<INT1) | (0<<INT0);
; 0000 0277 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
; 0000 0278 GIFR=(0<<INTF1) | (0<<INTF0);
; 0000 0279 }
;
;void portConfig(){
; 0000 027B void portConfig(){
_portConfig:
; .FSTART _portConfig
; 0000 027C DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(127)
	OUT  0x17,R30
; 0000 027D PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 027E DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 027F PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0280 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 0281 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(13)
	OUT  0x12,R30
; 0000 0282 }
	RET
; .FEND

	.CSEG
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
	RCALL SUBOPT_0x30
	LDI  R26,LOW(7)
	RCALL _i2c_write
	LDD  R26,Y+2
	RJMP _0x20A0001
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	ST   -Y,R27
	ST   -Y,R26
	RCALL SUBOPT_0x30
	LDI  R26,LOW(0)
	RCALL _i2c_write
	RCALL _i2c_stop
	RCALL _i2c_start
	LDI  R26,LOW(209)
	RCALL _i2c_write
	RCALL SUBOPT_0x31
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RCALL SUBOPT_0x31
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	RCALL _i2c_read
	MOV  R26,R30
	RCALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,6
	RET
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	RCALL SUBOPT_0x30
	LDI  R26,LOW(0)
	RCALL _i2c_write
	LD   R26,Y
	RCALL _bin2bcd
	MOV  R26,R30
	RCALL _i2c_write
	LDD  R26,Y+1
	RCALL _bin2bcd
	MOV  R26,R30
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL _bin2bcd
	MOV  R26,R30
_0x20A0001:
	RCALL _i2c_write
	RCALL _i2c_stop
	ADIW R28,3
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

	.DSEG
_n:
	.BYTE 0x4
_runnigState:
	.BYTE 0x1
_menuPosition:
	.BYTE 0x1
_click:
	.BYTE 0x1
_stopClockState:
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

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x1:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	SUBI R30,LOW(-_n)
	SBCI R31,HIGH(-_n)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOV  R26,R30
	RJMP _digitalWritePort

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDD  R26,Y+1
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOV  R26,R30
	RJMP _digitalWritePort

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	OUT  0x18,R30
	MOV  R26,R4
	RJMP _changePositionNumber

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	STS  _click,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	STS  _runnigState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _buzzer
	LDS  R26,_brightnessSet
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xE:
	LDS  R30,_brightnessSet
	SUBI R30,LOW(1)
	STS  _brightnessSet,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	LDS  R26,_brightnessSet
	CPI  R26,LOW(0x2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDS  R26,_brightnessSet
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	RCALL _brightness
	RCALL _showBrightness
	CLR  R11
	CLR  R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x12:
	LDS  R30,_brightnessSet
	SUBI R30,-LOW(1)
	STS  _brightnessSet,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x10
	CPI  R26,LOW(0x63)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDS  R30,_brightnessSet
	ST   -Y,R30
	LDI  R26,LOW(2)
	RJMP _showTwoNumber

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(98)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _showOneNumber
	LDI  R30,LOW(114)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x19:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDS  R30,_counterBlinkNumber
	SUBI R30,-LOW(1)
	STS  _counterBlinkNumber,R30
	LDS  R30,_seqNumber
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(1)
	__PUTB1MN _portEnable,1
	__PUTB1MN _portEnable,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(1)
	__PUTB1MN _portEnable,3
	__PUTB1MN _portEnable,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(_alarmSet)
	LDI  R27,HIGH(_alarmSet)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	RCALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	RCALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(_alarmSet)
	LDI  R27,HIGH(_alarmSet)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x21:
	ST   -Y,R6
	LDI  R26,LOW(1)
	RCALL _showTwoNumber
	ST   -Y,R9
	LDI  R26,LOW(2)
	RJMP _showTwoNumber

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	ST   -Y,R30
	LDI  R26,LOW(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(2)
	STS  _menuPosition,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x25:
	ST   -Y,R30
	LDI  R26,LOW(3)
	RJMP _showOneNumber

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	RCALL _showOneNumber
	LDI  R30,LOW(105)
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x27:
	LDS  R26,_click
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x28:
	LDS  R26,_runnigState
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	RCALL _clickCheck
	RCALL _right1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2A:
	RCALL _left1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	RCALL _right1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(_alarmSet)
	LDI  R27,HIGH(_alarmSet)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2D:
	LDS  R30,_click
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(3)
	STS  _menuPosition,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	STS  _menuPosition,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x30:
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	LDI  R26,LOW(1)
	RCALL _i2c_read
	MOV  R26,R30
	RJMP _bcd2bin


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
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
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

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

;END OF CODE MARKER
__END_OF_CODE:
