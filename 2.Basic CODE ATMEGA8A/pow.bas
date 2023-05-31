$regfile = "m8def.dat"
$crystal = 8000000

'##############

Config Portb = Output
Config Portc.2 = Output  'COM1  C5
Config Portc.3 = Output  'COM2  C4
Config Portc.1 = Output  'COM1  C5
Config Portc.0 = Output  'COM2  C4

Config PortD.1 = Output  'BUZZER

'Config Portc.3 = Output
Config PortD.3 = Input
Config PortD.0 = Input
PortD.0 = 1
'##################
dim x as byte
Dim B1 As Byte
Dim B2 As Word
Dim D As Byte
Dim Y As Byte
Dim A As Byte
Dim Z As Byte
dim i as word
A = 0
Dim Seco As Byte , Mine As Byte , Hour As Byte
dim Mine1 As Byte
dim Mine2 As Byte
dim Hour1 As Byte
dim Hour2 As Byte
dim ww as Word
'##################
dim mal as Byte
dim hal as Byte
dim Mineal As Byte
dim Houral As Byte
'##################

Config Int0 = Rising

Enable Int0
On Int0 Armin
Enable Interrupts
'#########################
$lib "ds1307clock.lib"
'configure the scl and sda pins
Config Sda = PortC.4
Config Scl = PortC.5
'address of ds1307
Const Ds1307w = &HD0                                        ' Addresses of Ds1307 clock
Const Ds1307r = &HD1

';#######################
I2cstart                                                    ' Generate start code
I2cwbyte Ds1307w                                            ' send write address
I2cwbyte 0                                                  ' start address in 1307
I2cstart                                                    ' Generate start code
I2cwbyte Ds1307r                                            ' send read address
I2crbyte Seco , Nack
I2cstop

Seco.7 = 0
I2cstart                                                    'bit7 rah andazi ds hatamn bayad bahad
I2cwbyte Ds1307w
I2cwbyte &H00
I2cwbyte Seco
I2cstop


I2cstart                                                    ' led cheshmak 1HZ
I2cwbyte Ds1307w
I2cwbyte &H07
I2cwbyte &H10
I2cstop


'(

I2cstart                                                    ' daghighe
I2cwbyte Ds1307w
I2cwbyte &H01
I2cwbyte &H48
I2cstop


I2cstart                                                    ' saat
I2cwbyte Ds1307w
I2cwbyte &H02
I2cwbyte &H17
I2cstop
')
Wait 1
'-----------------------
Declare Sub buzz
Declare Sub segg
'#######################

A1:
        I2cstart                                            ' Generate start code
        I2cwbyte Ds1307w                                    ' send address
        I2cwbyte 0                                          ' start address in 1307
        I2cstart                                            ' Generate start code
        I2cwbyte Ds1307r                                    ' send address
        I2crbyte Seco , Ack                                 'sec
        I2crbyte Mine , Ack                                 ' MINUTES
        I2crbyte Hour , Nack                                ' Hours
        I2cstop

        Seco = Makedec(seco) : Mine = Makedec(mine) : Hour = Makedec(hour)
'
if hal=hour and mal=mine and seco<=30 and a<2 then
if hour<>0 and mine<>0  then
call buzz
endif
endif

'--------------
call segg
'--------------

If PinD.0 = 0 Then
do
waitms 1
incr ww
'-----------
if ww>=1400 then
call buzz
ww=0
do
loop until pind.0=1
a=0
goto alset
endif
'-----------
loop until pind.0=1
a=Hour
ww=0
Goto A2
End If

Goto A1

'##############################################################################

A2:
for i=0 to 500
Y = Hour Mod 10
Portb = Lookup(Y , Table1)
Portc.1 = 1
Waitms 1
Portc.1 = 0

D = Hour/10
Portb = Lookup(D , Table1)
Portc.0 = 1
Waitms 1
Portc.0 = 0
'------

Hour=a
'--------------
if Hour>23 then
Hour=0
a=0
endif
'--------------
next

Hour=a
'--------------
if Hour>23 then
Hour=0
a=0
endif
'--------------
If PinD.0 = 0 Then
do
PortD.1=1
waitms 100
waitms 1
loop until pind.0=1
'-------
Hour1=Hour/10
Hour2=Hour mod 10
Hour=Hour1*16
Hour=Hour+Hour2

I2cstart                                                    ' daghighe
I2cwbyte Ds1307w
I2cwbyte &H02
I2cwbyte Hour
I2cstop
'-------
a=Mine
PortD.1=0
Goto A3
End If

waitms 50

Goto A2
'###############################################################################
a3:
for i=0 to 500
Y = Mine Mod 10
Portb = Lookup(Y , Table1)
Portc.3 = 1
Waitms 1
Portc.3 = 0


D = Mine / 10
Portb = Lookup(D , Table1)
Portc.2 = 1
Waitms 1
Portc.2 = 0
'------

mine=a
'--------------
if mine>59 then
mine=0
a=0
endif
'--------------
next

mine=a
'--------------
if mine>59 then
mine=0
a=0
endif
'--------------
If PinD.0 = 0 Then
do
PortD.1=1
waitms 100
waitms 1
loop until pind.0=1
'-------
mine1=mine/10
mine2=mine mod 10
mine=mine1*16
mine=mine+mine2

I2cstart                                                    ' daghighe
I2cwbyte Ds1307w
I2cwbyte &H01
I2cwbyte mine
I2cstop
'-------
a=0
PortD.1=0
Goto A1
End If

waitms 50
goto a3
'###############################################################################
alset:


for i=0 to 500
Y =  hal Mod 10
Portb = Lookup(Y , Table1)
Portc.1 = 1
Waitms 1
Portc.1 = 0

D = hal/10
Portb = Lookup(D , Table1)
Portc.0 = 1
Waitms 1
Portc.0 = 0
'------

hal=a
'--------------
if hal>23 then
hal=0
a=0
endif
'--------------
next

hal=a
'--------------
if hal>23 then
hal=0
a=0
endif
'--------------
If PinD.0 = 0 Then
PortD.1=1
do
waitms 1
loop until pind.0=1
'-------
Houral=hal
'-------
PortD.1=0
a=0
Goto alset2
End If

waitms 50






goto alset
'###############################################################################
alset2:

for i=0 to 500
Y = mal Mod 10
Portb = Lookup(Y , Table1)
Portc.3 = 1
Waitms 1
Portc.3 = 0


D = mal / 10
Portb = Lookup(D , Table1)
Portc.2 = 1
Waitms 1
Portc.2 = 0
'------

mal=a
'--------------
if mal>59 then
mal=0
a=0
endif
'--------------
next

mal=a
'--------------
if mal>59 then
mal=0
a=0
endif
'--------------
If PinD.0 = 0 Then
PortD.1=1
do
waitms 1
loop until pind.0=1
'-------
mineal=mal
'-------
a=0
PortD.1=0
Goto A1
End If

waitms 50





goto alset2
'###############################################################################
Table1:
Data &B00111111, &B00000110, &B01011011, &B01001111, &B01100110, &B01101101, &B01111101, &B00000111, &B01111111, &B01101111
'###############################################################################
Sub buzz

PortD.1=1
for x=0 to 180
call segg
next

PortD.1=0

for x=0 to 80
call segg
next


end sub
'############################
Sub segg
'---------------
Y = Mine Mod 10
Portb = Lookup(Y , Table1)
Portc.3 = 1
Waitms 1
Portc.3 = 0


D = Mine / 10
Portb = Lookup(D , Table1)
Portc.2 = 1
Waitms 1
Portc.2 = 0


Y = Hour Mod 10
Portb = Lookup(Y , Table1)
Portc.1 = 1
Waitms 1
Portc.1 = 0

D = Hour/10
Portb = Lookup(D , Table1)
Portc.0 = 1
Waitms 1
Portc.0 = 0


end sub
'#################################
Armin:

   If PinD.3 = 0 Then
      A = A + 1
   Else
      A = A - 1
   End If

   If A > 99 Then
   A = 00
   End If

    PortD.1=1

   Waitms 2
   PortD.1=0
Return