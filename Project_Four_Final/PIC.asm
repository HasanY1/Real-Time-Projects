; LCD Display Configuration
PROCESSOR 16F877A
INCLUDE "P16F877A.INC"
__CONFIG 0x3731

; Equates
SymbolCounter EQU 0x25
savedSymbol EQU 0x26
symbol EQU 0x27
Counter EQU 0x28                    ; Counter variable initialized to 0
Counter1 EQU 0x29                   ; Counter variable initialized to 0
CounterTemp EQU 0x2A                   ; Counter variable initialized to 0
tenThousandsFirst EQU 0x2B          ; Flag to indicate if two seconds have elapsed without RB0 interrupt
ThousandsFirst EQU 0x2C          ; Flag to indicate if two seconds have elapsed without RB0 interrupt
HundredsFirst EQU 0x2D
TensFirst EQU 0x2F
OnesFirst EQU 0x30
tenThousandsFirstNum EQU 0x31       ; Variable to store the counter value when the flag is set
ThousandsFirstNum EQU 0x32       ; Variable to store the counter value when the flag is set
HundredsFirstNum EQU 0x33
TensFirstNum EQU 0x34
OnesFirstNum EQU 0x35
FirstNumL EQU 0x36
FirstNumH EQU 0x37
SecondNumL EQU 0x38
SecondNumH EQU 0x39
Sum EQU 0x3A
OnesSum EQU 0x3B                   ; Variable for the ones digit of the sum
TensSum EQU 0x3C                   ; Variable for the tens digit of the sum
HundredsSum EQU 0x3D               ; Variable for the hundreds digit of the sum
ThousandsSum EQU 0x3E              ; Variable for the thousands digit of the sum
tenThousandsSum EQU 0x3F           ; Variable for the ten thousands digit of the sum
SumTemp EQU 0x41
Quotient EQU 0x42
Quotient1 EQU 0x43
Carry EQU 0x44
OnesSumT EQU 0x45                   ; Variable for the ones digit of the sum
TensSumT EQU 0x46                   ; Variable for the tens digit of the sum
HundredsSumT EQU 0x47               ; Variable for the hundreds digit of the sum
ThousandsSumT EQU 0x48              ; Variable for the thousands digit of the sum
tenThousandsSumT EQU 0x49           ; Variable for the ten thousands digit of the sum
counter1 EQU 0x4A
counter2 EQU 0x4B
counter3 EQU 0x4C
tenThousandsSecondNum EQU 0x4D
ThousandsSecondNum EQU 0x4E
HundredsSecondNum EQU 0x4F
TensSecondNum EQU 0x50
OnesSecondNum EQU 0x51
TensSecond EQU 0x52
OnesSecond EQU 0x53
tenThousandsSecond EQU 0x54
ThousandsSecond EQU 0x55
HundredsSecond EQU 0x56
IDX16 EQU 0x57
IDX16_H EQU 0x58
TEMPYY EQU 0x59
RemainderL EQU 0x5A
RemainderH EQU 0x5B
TenNum EQU 0x5C
ZeroNum EQU 0x5D
DivTenThousands EQU 0x5E
DivThousands EQU 0x5F
DivHundreds EQU 0x60
DivTens EQU 0x61
DivOnes EQU 0x62
QuotientF EQU 0x63
QuotientF1 EQU 0x64
RemainderF EQU 0x65
RemainderF1 EQU 0x66
RemOnes	EQU 0x67
RemTens EQU 0x68
RemHundreds EQU 0x69
RemThousands EQU 0x6A
RemTenThousands EQU 0x6B
Counter2 EQU 0x6C
SingleDoubleFlag EQU 0x6D
YNCounter EQU 0x6E
; The instructions should start from here
ORG 0x00
GOTO init
ORG 0x04
GOTO ISR

; The initialization routine for our program
init:
CLRF YNCounter
CLRF SingleDoubleFlag
CLRF Counter2
CLRF DivTenThousands 
CLRF DivThousands 
CLRF DivHundreds 
CLRF DivTens 
CLRF DivOnes
CLRF Quotient
CLRF Quotient1
CLRF QuotientF
CLRF QuotientF1
MOVLW 0x0A
MOVWF TenNum
CLRF ZeroNum
CLRF RemainderL
CLRF RemainderH 
CLRF IDX16 
CLRF IDX16_H 
CLRF TEMPYY 
CLRF FirstNumL
CLRF FirstNumH
CLRF SecondNumL
CLRF SecondNumH
CLRF counter1
CLRF counter2
CLRF counter3
CLRF Carry
CLRF symbol
CLRF Sum
CLRF savedSymbol
CLRF SymbolCounter
    MOVLW 100                          ; Load the value 1 into the W register
    MOVWF Counter1                   ; Move the value from W register to Counter1
MOVLW 200                        ; Load the value 1 into the W register
    MOVWF Counter2
CLRF Counter
CLRF ThousandsFirst
CLRF ThousandsFirstNum
CLRF tenThousandsFirst
CLRF tenThousandsFirstNum
CLRF HundredsFirst
CLRF HundredsFirstNum
CLRF TensFirst
CLRF TensFirstNum
CLRF OnesFirst
CLRF OnesFirstNum
CLRF tenThousandsSecond
CLRF tenThousandsSecondNum
CLRF ThousandsSecond
CLRF ThousandsSecondNum
CLRF HundredsSecond
CLRF HundredsSecondNum
CLRF TensSecond
CLRF TensSecondNum
CLRF OnesSecond
CLRF OnesSecondNum
CLRF CounterTemp
    BSF TRISB, TRISB0                                   
    CALL xms                      
    CALL xms
    CALL inid                      
    BCF Select, RS
    MOVLW 0x80
    CALL send
    BSF Select, RS
CALL PrintRes
    
    BSF INTCON, GIE                  ; Enable global interrupts
    BSF INTCON, INTE          

    GOTO start

ISR:
    BCF INTCON, INTE                 ; Disable external interrupt
    BCF INTCON, INTF                 ; Clear interrupt flag
    BTFSS tenThousandsFirst, 0       ; Check if tenThousandsFirst is equal to 1
    GOTO not_equal                  ; Branch if not equal (skip next instruction)
    ; Code to execute if tenThousandsFirst is equal to 1
    GOTO equal_end                   ; Skip the code below

not_equal:
    ; Code after the conditional branch
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVF Counter, W                ; Move the value of Counter to W register
    MOVWF CounterTemp              ; Move the value from W register to CounterTemp
    MOVLW 0xC0
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data
    MOVF CounterTemp, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
    MOVLW 0x06
    XORWF CounterTemp, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
equal_end:
    BTFSS ThousandsFirst, 0       ; Check if ThousandsFirst is equal to 1
    GOTO not_equal1                  ; Branch if not equal (skip next instruction)
    ; Code to execute if tenThousandsFirst is equal to 1
    GOTO equal_end1                   ; Skip the code below
    
    
    
more_than_six:
    MOVLW 0x05
    XORWF CounterTemp, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr

   
  
 

 
 
 
 

not_equal1:
    ; Code after the conditional branch
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVF Counter, W                ; Move the value of Counter to W register
    MOVWF CounterTemp              ; Move the value from W register to CounterTemp
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVLW 0xC1
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data
    MOVF CounterTemp, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
    MOVLW 0x06
    XORWF tenThousandsFirstNum, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if the result is greater than or equal to 7
    GOTO more_than_six               ; Branch if tenThousandsFirst is more than 6
    MOVLW 0x09
    XORWF Counter, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr

equal_end1:
    BTFSS HundredsFirst, 0       ; Check if hundreds is equal to 1
    GOTO not_equal2                  ; Branch if not equal (skip next instruction)
    GOTO equal_end2                   ; Skip the code below
    
    
    
not_equal2:
    MOVF Counter, W                ; Move the value of Counter to W register
    MOVWF CounterTemp              ; Move the value from W register to CounterTemp
    BCF Select, RS
    MOVLW 0xC2
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data
    MOVF CounterTemp, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
    BSF INTCON, INTE                 ; Enable external interrupt
   MOVLW 0x06
   XORWF tenThousandsFirstNum, W                 ; Compare tenThousandsFirstNum with 0x06
   BTFSS STATUS, Z                               ; Check if result is zero (tenThousandsFirstNum == 0x06)
   GOTO NOT_EQUAL                                ; Jump to NOT_EQUAL if not equal
   MOVLW 0x05
   XORWF ThousandsFirstNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL                                ; Jump to NOT_EQUAL if not equal
 
 
    MOVLW 0x05
    XORWF CounterTemp, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
NOT_EQUAL

    MOVLW 0x09
    XORWF Counter, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr

 ;;;;;;;;;;;;;;;;
 
 
 
 equal_end2:
    BTFSS TensFirst, 0       ; Check if hundreds is equal to 1
    GOTO not_equal3                  ; Branch if not equal (skip next instruction)
    ; Code to execute if hundreds is equal to 1
    GOTO equal_end3                   ; Skip the code below
 
 
 not_equal3:
    MOVF Counter, W                ; Move the value of Counter to W register
    MOVWF CounterTemp              ; Move the value from W register to CounterTemp
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVLW 0xC3
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data
    MOVF CounterTemp, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display

   MOVLW 0x06
   XORWF tenThousandsFirstNum, W                 ; Compare tenThousandsFirstNum with 0x06
   BTFSS STATUS, Z                               ; Check if result is zero (tenThousandsFirstNum == 0x06)
   GOTO NOT_EQUAL1                                ; Jump to NOT_EQUAL if not equal

   MOVLW 0x05
   XORWF ThousandsFirstNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL1                               ; Jump to NOT_EQUAL if not equal
 
   MOVLW 0x05
   XORWF ThousandsFirstNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL1                               ; Jump to NOT_EQUAL if not equal
 
    MOVLW 0x03
    XORWF CounterTemp, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
    
    NOT_EQUAL1
    MOVLW 0x09
    XORWF Counter, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
    
 equal_end3:
    BTFSS OnesFirst, 0       ; Check if hundreds is equal to 1
    GOTO not_equal4                  ; Branch if not equal (skip next instruction)
    ; Code to execute if hundreds is equal to 1
    GOTO equal_end4                   ; Skip the code below





 not_equal4:
    MOVF Counter, W                ; Move the value of Counter to W register
    MOVWF CounterTemp              ; Move the value from W register to CounterTemp
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVLW 0xC4
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data
    MOVF CounterTemp, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
   MOVLW 0x06
   XORWF tenThousandsFirstNum, W                 ; Compare tenThousandsFirstNum with 0x06
   BTFSS STATUS, Z                               ; Check if result is zero (tenThousandsFirstNum == 0x06)
   GOTO NOT_EQUAL2                                ; Jump to NOT_EQUAL if not equal

   MOVLW 0x05
   XORWF ThousandsFirstNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL2                               ; Jump to NOT_EQUAL if not equal
 
   MOVLW 0x05
   XORWF HundredsFirstNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL2                               ; Jump to NOT_EQUAL if not equal
   MOVLW 0x03
   XORWF TensFirstNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL2  
    MOVLW 0x05
    XORWF CounterTemp, W                 ; Compare Counter value with 0x06
    BTFSS STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO NOT_EQUAL2                               ; Jump to NOT_EQUAL if not equal
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
    NOT_EQUAL2
    MOVLW 0x09
    XORWF Counter, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
    

equal_end4: 
    BTFSS symbol, 0       ; Check if hundreds is equal to 1
    GOTO not_equal5                  ; Branch if not equal (skip next instruction)
    ; Code to execute if hundreds is equal to 1
    GOTO equal_end5                   ; Skip the code below


not_equal5:
MOVLW 0x00
XORWF SymbolCounter, W        
BTFSS STATUS, Z                
GOTO counter_not_zero
BCF Select, RS
MOVLW 0xC5
CALL send                      ; Send command to set cursor position
BSF Select, RS                 ; Set RS bit for data
MOVLW '+'
CALL send   
MOVLW '+'
MOVWF savedSymbol 
INCF SymbolCounter, F          ; Increment the counter value

GOTO end_isr
 

counter_not_zero:
 MOVLW 0x01
    XORWF SymbolCounter, W                 ; Compare Counter value with 0x06
    BTFSS STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO counter_is_two          ; Jump to counter_is_two if counter is 2                      ; Send command to set cursor position
        BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVLW 0xC5
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data  
    MOVLW '/'
    CALL send   
   MOVLW '/'
   MOVWF savedSymbol   
   INCF SymbolCounter, F                  ; Increment the counter value 
    GOTO end_isr
    
    
counter_is_two:
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVLW 0xC5
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data 
        MOVLW '%'
    CALL send    
    MOVLW '%'
    MOVWF savedSymbol
    CLRF SymbolCounter
    GOTO end_isr

;;;;;;;;;;Second Number;;;;;;;;;;;;;;;    
;;;;;;;;;;;;tenthousands;;;;;;;;;;;;;;



equal_end5:
    BTFSS tenThousandsSecond, 0       ; Check if tenThousandsFirst is equal to 1
    GOTO not_equal6                  ; Branch if not equal (skip next instruction)
    ; Code to execute if tenThousandsFirst is equal to 1
    GOTO equal_end6                   ; Skip the code below

not_equal6:
    ; Code after the conditional branch
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVF Counter, W                ; Move the value of Counter to W register
    MOVWF CounterTemp              ; Move the value from W register to CounterTemp
    MOVLW 0xC6
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data
    MOVF CounterTemp, W                  ; Load counter value into W register
        CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
    MOVLW 0x06
    XORWF CounterTemp, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr

    equal_end6:
    BTFSS ThousandsSecond, 0       ; Check if ThousandsFirst is equal to 1
    GOTO not_equal7                  ; Branch if not equal (skip next instruction)
    ; Code to execute if tenThousandsFirst is equal to 1
    GOTO equal_end7                   ; Skip the code below
 
 not_equal7:
     ; Code after the conditional branch
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVF Counter, W                ; Move the value of Counter to W register
    MOVWF CounterTemp              ; Move the value from W register to CounterTemp
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVLW 0xC7
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data
    MOVF CounterTemp, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
    MOVLW 0x06
    XORWF tenThousandsSecondNum, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if the result is greater than or equal to 7
    GOTO more_than_six1               ; Branch if tenThousandsFirst is more than 6
    MOVLW 0x09
    XORWF Counter, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
    
    
more_than_six1:
    ; Code to execute if tenThousandsFirst is more than 6
    MOVLW 0x05
    XORWF CounterTemp, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr    
    
    
equal_end7:
    BTFSS HundredsSecond, 0       ; Check if ThousandsFirst is equal to 1
    GOTO not_equal8                  ; Branch if not equal (skip next instruction)
    ; Code to execute if tenThousandsFirst is equal to 1
    GOTO equal_end8      

    
not_equal8:
    MOVF Counter, W                ; Move the value of Counter to W register
    MOVWF CounterTemp              ; Move the value from W register to CounterTemp
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVLW 0xC8
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data
    MOVF CounterTemp, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
   MOVLW 0x06
   XORWF tenThousandsSecondNum, W                 ; Compare tenThousandsFirstNum with 0x06
   BTFSS STATUS, Z                               ; Check if result is zero (tenThousandsFirstNum == 0x06)
   GOTO NOT_EQUAL3                                ; Jump to NOT_EQUAL if not equal

   MOVLW 0x05
   XORWF ThousandsSecondNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL3                                ; Jump to NOT_EQUAL if not equal
 
 
    MOVLW 0x05
    XORWF CounterTemp, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
NOT_EQUAL3

    MOVLW 0x09
    XORWF Counter, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
    
 equal_end8:
    BTFSS TensSecond, 0       ; Check if ThousandsFirst is equal to 1
    GOTO not_equal9                  ; Branch if not equal (skip next instruction)
    ; Code to execute if tenThousandsFirst is equal to 1
    GOTO equal_end9 
 
 
 
 
 
 
 not_equal9:
    MOVF Counter, W                ; Move the value of Counter to W register
    MOVWF CounterTemp              ; Move the value from W register to CounterTemp
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVLW 0xC9
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data
    MOVF CounterTemp, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
   MOVLW 0x06
   XORWF tenThousandsSecondNum, W                 ; Compare tenThousandsFirstNum with 0x06
   BTFSS STATUS, Z                               ; Check if result is zero (tenThousandsFirstNum == 0x06)
   GOTO NOT_EQUAL4                                ; Jump to NOT_EQUAL if not equal

   MOVLW 0x05
   XORWF ThousandsSecondNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL4                               ; Jump to NOT_EQUAL if not equal
 
   MOVLW 0x05
   XORWF HundredsSecondNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL4                               ; Jump to NOT_EQUAL if not equal
 
    MOVLW 0x03
    XORWF CounterTemp, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
    
    NOT_EQUAL4
    MOVLW 0x09
    XORWF Counter, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
 
equal_end9: 
    BTFSS OnesSecond, 0       ; Check if ThousandsFirst is equal to 1
    GOTO not_equal10                  ; Branch if not equal (skip next instruction)
    ; Code to execute if tenThousandsFirst is equal to 1
    GOTO equal_end10 
 

 
 not_equal10: 
    MOVF Counter, W                ; Move the value of Counter to W register
    MOVWF CounterTemp              ; Move the value from W register to CounterTemp
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)

    MOVLW 0xCA
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data
    MOVF CounterTemp, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
   MOVLW 0x06
   XORWF tenThousandsSecondNum, W                 ; Compare tenThousandsFirstNum with 0x06
   BTFSS STATUS, Z                               ; Check if result is zero (tenThousandsFirstNum == 0x06)
   GOTO NOT_EQUAL5                                ; Jump to NOT_EQUAL if not equal

   MOVLW 0x05
   XORWF ThousandsSecondNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL5                               ; Jump to NOT_EQUAL if not equal
   MOVLW 0x05
   XORWF HundredsSecondNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL5                               ; Jump to NOT_EQUAL if not equal
   MOVLW 0x03
   XORWF TensSecondNum, W                    ; Compare ThousandsFirstNum with 0x01
   BTFSS STATUS, Z                               ; Check if result is zero (ThousandsFirstNum == 0x01)
   GOTO NOT_EQUAL5  
    MOVLW 0x05
    XORWF CounterTemp, W                 ; Compare Counter value with 0x06
    BTFSS STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO NOT_EQUAL2                               ; Jump to NOT_EQUAL if not equal
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
    NOT_EQUAL5
    MOVLW 0x09
    XORWF Counter, W                 ; Compare Counter value with 0x06
    BTFSC STATUS, Z                  ; Branch if not zero (counter != 6)
    GOTO reset_counter               ; Jump to reset_counter if counter == 6
    INCF Counter, F                  ; Increment the counter value
    GOTO end_isr
 
equal_end10:
    MOVLW 0
    XORWF SingleDoubleFlag,W
    BTFSC STATUS,Z
    GOTO SingleDoubleCounter
    GOTO checkYN

 checkYN:
 MOVLW 1
 XORWF YNCounter ,W
 BTFSC STATUS,Z
 GOTO not_equal5
 GOTO end_isr
 
 
reset_counter:
    CLRF Counter                     ; Reset the counter value to zero
    GOTO end_isr
        
SingleDoubleCounter:
MOVLW 2
XORWF YNCounter,W
BTFSS STATUS,Z
    INCF YNCounter, F
    GOTO end_isr
    
    
end_isr:
    ; Clear Timer1 interrupt flag
    BCF PIR1, TMR1IF

    ; Reset Timer1 registers for next iteration
    MOVLW 0xE1                       ; Set the high byte of the initial value (0x0BB8)
    MOVWF TMR1H
    MOVLW 0xF4                       ; Set the low byte of the initial value (0x0BB8)
    MOVWF TMR1L

    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    BSF INTCON, INTE                 ; Enable external interrupt
    ; Reset Counter1 for next iteration
CALL CountersInit
    retfie


INCLUDE "LCDIS_PORTA.INC"            ; Include the LCD display library

; The main code for our program
start:
CALL CountersInit
CALL TC1

    BSF INTCON, INTE                 ; Enable external interrupt
    CLRF Counter                     ; Initialize the counter value to zero

program_loop:
    BSF PIE1, TMR1IE
    BCF Select, RS
    ; Set cursor to the second line, first position (address 0x40)
    MOVLW 0xC0
    CALL send                        ; Send command to set cursor position
    BSF Select, RS                   ; Set RS bit for data
    MOVLW '0'
    CALL send 
    INCF Counter, F                ; Move the value of Counter to W register
Wait5Seconds:

CALL TimerCon

    ; Loop until 5 seconds have passed
    LOOP:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOP

    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5Seconds                 ; Loop until Counter1 is zero

    CALL DisableTimer
    MOVF CounterTemp, W                  ; Load counter value into W register
    MOVWF tenThousandsFirstNum        ; Store the counter value in tenThousandsFirstNum
    MOVLW 1                          ; Set tenThousandsFirst flag to 1
    MOVWF tenThousandsFirst
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    MOVLW 100                          ; Load the value 1 into the W register
    MOVWF Counter1
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt
    MOVLW '0'
    CALL send 
    INCF Counter, F  
Wait5Seconds1:
   
CALL TimerCon
    ; Loop until 5 seconds have passed
    LOOP1:

        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOP1
    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5Seconds1                 ; Loop until Counter1 is zero
    CALL DisableTimer
    MOVF CounterTemp, W                  ; Load counter value into W register
    MOVWF ThousandsFirstNum        ; Store the counter value in tenThousandsFirstNum
    MOVLW 1                          ; Set tenThousandsFirst flag to 1
    MOVWF ThousandsFirst
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    MOVLW 100                          ; Load the value 1 into the W register
    MOVWF Counter1                   ; Move the value from W register to Counter1
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt
    MOVLW '0'
    CALL send 
    INCF Counter, F  
Wait5Seconds2:
CALL TimerCon
    LOOP2:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOP2
    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5Seconds2                 ; Loop until Counter1 is zero
    CALL DisableTimer
    MOVF CounterTemp, W                  ; Load counter value into W register
    MOVWF HundredsFirstNum        ; Store the counter value in tenThousandsFirstNum
    MOVLW 1                          ; Set tenThousandsFirst flag to 1
    MOVWF HundredsFirst
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    MOVLW 100                          ; Load the value 1 into the W register
    MOVWF Counter1                   ; Move the value from W register to Counter1

    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON

    BSF INTCON, INTE                 ; Enable external interrupt
      MOVLW '0'
    CALL send 
    INCF Counter, F  
Wait5Seconds3:
CALL TimerCon

    ; Loop until 5 seconds have passed
    LOOP3:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOP3

    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5Seconds3                 ; Loop until Counter1 is zero
    ; Timer1 interrupt occurred, reset the Timer1 interrupt flag
    CALL DisableTimer
    MOVF CounterTemp, W                  ; Load counter value into W register
    MOVWF TensFirstNum        ; Store the counter value in tenThousandsFirstNum
    MOVLW 1                          ; Set tenThousandsFirst flag to 1
    MOVWF TensFirst
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    MOVLW 100                         ; Load the value 1 into the W register
    MOVWF Counter1                   ; Move the value from W register to Counter1
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ones;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt
      MOVLW '0'
    CALL send 
    INCF Counter, F  
Wait5Seconds4:
CALL TimerCon

    LOOP4:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOP4

    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5Seconds4                 ; Loop until Counter1 is zero

    ; Timer1 interrupt occurred, reset the Timer1 interrupt flag
    CALL DisableTimer
    MOVF CounterTemp, W                  ; Load counter value into W register
    MOVWF OnesFirstNum        ; Store the counter value in tenThousandsFirstNum
    MOVLW 1                          ; Set tenThousandsFirst flag to 1
    MOVWF OnesFirst
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    MOVLW 100                          ; Load the value 1 into the W register
    MOVWF Counter1                   ; Move the value from W register to Counter1
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt
    MOVLW '+'
    MOVWF savedSymbol
      MOVLW '+'
    CALL send 
    INCF SymbolCounter, F
  
Wait5Seconds5:
CALL TimerCon
    ; Loop until 5 seconds have passed
    LOOP5:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOP5
    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5Seconds5                 ; Loop until Counter1 is zero
CALL DisableTimer
    MOVLW 1                          ; Set tenThousandsFirst flag to 1
    MOVWF symbol
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    MOVLW 100                          ; Load the value 1 into the W register
    MOVWF Counter1                   ; Move the value from W register to Counter1
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;secondtensthounsands;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt
      MOVLW '0'
    CALL send 
    INCF Counter, F  
Wait5Seconds6:
CALL TimerCon

    ; Loop until 5 seconds have passed
    LOOP6:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOP6
    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5Seconds6                 ; Loop until Counter1 is zero
    ; Timer1 interrupt occurred, reset the Timer1 interrupt flag
CALL DisableTimer
    MOVF CounterTemp, W                  ; Load counter value into W register
    MOVWF tenThousandsSecondNum        ; Store the counter value in tenThousandsFirstNum
    MOVLW 1                          ; Set tenThousandsFirst flag to 1
    MOVWF tenThousandsSecond
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    MOVLW 100                        ; Load the value 1 into the W register
    MOVWF Counter1                   ; Move the value from W register to Counter1
;;;;;;;;;;;;;;;second thousands;;;;;;;;;;;;;;;
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt
      MOVLW '0'
    CALL send 
    INCF Counter, F  
Wait5Seconds7:
CALL TimerCon
    ; Loop until 5 seconds have passed
    LOOP7:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOP7
    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5Seconds7                 ; Loop until Counter1 is zero
    ; Timer1 interrupt occurred, reset the Timer1 interrupt flag
    CALL DisableTimer
    MOVF CounterTemp, W                  ; Load counter value into W register
    MOVWF ThousandsSecondNum        ; Store the counter value in tenThousandsFirstNum
    MOVLW 1                          ; Set tenThousandsFirst flag to 1
    MOVWF ThousandsSecond
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    MOVLW 100                         ; Load the value 1 into the W register
    MOVWF Counter1                   ; Move the value from W register to Counter1
    
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt
      MOVLW '0'
    CALL send 
    INCF Counter, F  
Wait5Seconds8:
CALL TimerCon
    ; Loop until 5 seconds have passed
    LOOP8:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOP8
    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5Seconds8                 ; Loop until Counter1 is zero
CALL DisableTimer

    ; Reset Timer1 registers for next iteration
    MOVF CounterTemp, W                  ; Load counter value into W register
    MOVWF HundredsSecondNum        ; Store the counter value in tenThousandsFirstNum
    MOVLW 1                          ; Set tenThousandsFirst flag to 1
    MOVWF HundredsSecond
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    MOVLW 100                          ; Load the value 1 into the W register
    MOVWF Counter1                   ; Move the value from W register to Counter1
     ;;;;;;;;;;;;;;;second Tens;;;;;;;;;;;;;;;
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt
      MOVLW '0'
    CALL send 
    INCF Counter, F  
Wait5Seconds9:
CALL TimerCon
    ; Loop until 5 seconds have passed
    LOOP9:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOP9
    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5Seconds9                 ; Loop until Counter1 is zero
    ; Timer1 interrupt occurred, reset the Timer1 interrupt flag
    BCF PIR1, TMR1IF
    BCF PIE1, TMR1IE                 ; Disable Timer1 interrupt
    MOVLW 0x00                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    ; Reset Timer1 registers for next iteration
    MOVF CounterTemp, W                  ; Load counter value into W register
    MOVWF TensSecondNum        ; Store the counter value in tenThousandsFirstNum
    MOVLW 1                          ; Set tenThousandsFirst flag to 1
    MOVWF TensSecond
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    MOVLW 100                        ; Load the value 1 into the W register
    MOVWF Counter1                   ; Move the value from W register to Counter1
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt
      MOVLW '0'
    CALL send 
    INCF Counter, F  
Wait5Seconds10:
CALL TimerCon
    ; Loop until 5 seconds have passed
    LOOP10:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOP10
    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5Seconds10                 ; Loop until Counter1 is zero
    BCF PIR1, TMR1IF
    BCF PIE1, TMR1IE                 ; Disable Timer1 interrupt
    MOVLW 0x00                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    MOVF CounterTemp, W                  ; Load counter value into W register
    MOVWF OnesSecondNum        ; Store the counter value in tenThousandsFirstNum
    MOVLW 1                          ; Set tenThousandsFirst flag to 1
    MOVWF OnesSecond
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    MOVLW 100                         ; Load the value 1 into the W register
    MOVWF Counter1                   ; Move the value from W register to Counter1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;s   
SingleDoubleOP: 
MOVLW '+'
XORWF savedSymbol, W        ; Compare savedSymbol with '+'
BTFSS STATUS, Z             ; Branch if not zero (savedSymbol != '+')
GOTO division               ; Go to the division routine
;adddition
    CLRF OnesSum                    ; Clear the sum of ones digit
    MOVF OnesFirstNum,W
    ADDWF OnesSum
    MOVF OnesSecondNum,W
    ADDWF OnesSum                   ; Store the sum of ones digit
    MOVF OnesSum,W
    MOVWF OnesSumT
   MOVLW 9
   SUBWF OnesSumT
   BTFSC STATUS, Z
   GOTO OnesSumEquals9
   BTFSC  STATUS, C 
   GOTO OnesSumGreaterThan9
   GOTO OnesSumLessThan9


   OnesSumEquals9:
MOVLW 0       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison

OnesSumGreaterThan9:
MOVLW 0x0A       ; Load the immediate value 10 into the W register
SUBWF OnesSum, F
MOVLW 1       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison

OnesSumLessThan9:
MOVLW 0       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison

EndComparison:
    

    CLRF TensSum                    ; Clear the sum of tens digit
MOVF TensFirstNum, W         ; Move TensFirstNum to W register
ADDWF TensSum      ; Add TensSecondNum to TensFirstNum and store the result in TensSecondNum
MOVF Carry, W               ; Move the value of Carry to W register
ADDWF TensSum      ; Add the Carry value to the sum of TensFirstNum and TensSecondNum and store the result in TensSecondNum
MOVF TensSecondNum, W 
ADDWF TensSum              ; Move the result to TensSum
MOVF  TensSum,W 
MOVWF TensSumT ; Add the value of C1 to HundredsSum and store the result in HundredsSum
   MOVLW 9
   SUBWF TensSumT
   BTFSC STATUS, Z
   GOTO TensSumEquals9
   BTFSC  STATUS, C   
   GOTO TensSumGreaterThan9
   GOTO TensSumLessThan9



   TensSumEquals9:
MOVLW 0       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison1

TensSumGreaterThan9:
MOVLW 0x0A       ; Load the immediate value 10 into the W register
SUBWF TensSum,F ; Subtract 10 from OnesSum and store the result in W register
MOVLW 1       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison1

TensSumLessThan9:
MOVLW 0       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison1

EndComparison1:
    CLRF HundredsSum                ; Clear the sum of hundreds digit
MOVF HundredsFirstNum, W         ; Move TensFirstNum to W register
ADDWF HundredsSum      ; Add TensSecondNum to TensFirstNum and store the result in TensSecondNum
MOVF Carry, W               ; Move the value of Carry to W register
ADDWF HundredsSum      ; Add the Carry value to the sum of TensFirstNum and TensSecondNum and store the result in TensSecondNum
MOVF HundredsSecondNum, W
ADDWF HundredsSum               ; Move the result to TensSum
MOVF HundredsSum,W
MOVWF HundredsSumT  ; Add the value of C1 to HundredsSum and store the result in HundredsSum
   MOVLW 9
   SUBWF HundredsSumT
   BTFSC STATUS, Z
   GOTO HundredsSumEquals9
   BTFSC  STATUS, C   
   GOTO HundredsSumGreaterThan9
   GOTO HundredsSumLessThan9


   HundredsSumEquals9:
MOVLW 0       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison2

HundredsSumGreaterThan9:
MOVLW 0x0A       ; Load the immediate value 10 into the W register
SUBWF HundredsSum,F ; Subtract 10 from OnesSum and store the result in W register
MOVLW 1       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison2

HundredsSumLessThan9:
MOVLW 0       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison2

EndComparison2:
    CLRF ThousandsSum               ; Clear the sum of thousands digit
MOVF ThousandsFirstNum, W         ; Move TensFirstNum to W register
ADDWF ThousandsSum      ; Add TensSecondNum to TensFirstNum and store the result in TensSecondNum
MOVF Carry, W               ; Move the value of Carry to W register
ADDWF ThousandsSum      ; Add the Carry value to the sum of TensFirstNum and TensSecondNum and store the result in TensSecondNum
MOVF ThousandsSecondNum, W   
ADDWF ThousandsSum               ; Move the result to TensSum
MOVF ThousandsSum,W
MOVWF ThousandsSumT  ; Add the value of C1 to HundredsSum and store the result in HundredsSum
   MOVLW 9
   SUBWF ThousandsSumT
   BTFSC STATUS, Z
   GOTO ThousandsSumEquals9
   BTFSC  STATUS, C   ;
   GOTO ThousandsSumGreaterThan9
   GOTO ThousandsSumLessThan9
   ThousandsSumEquals9:
MOVLW 0       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison3

ThousandsSumGreaterThan9:
MOVLW 0x0A       ; Load the immediate value 10 into the W register
SUBWF ThousandsSum,F ; Subtract 10 from OnesSum and store the result in W register
MOVLW 1       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison3

ThousandsSumLessThan9:
MOVLW 0       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison3

EndComparison3:
    CLRF tenThousandsSum            ; Clear the sum of ten thousands digit
MOVF tenThousandsFirstNum, W         ; Move TensFirstNum to W register
ADDWF tenThousandsSum      ; Add TensSecondNum to TensFirstNum and store the result in TensSecondNum
MOVF Carry, W               ; Move the value of Carry to W register
ADDWF tenThousandsSum      ; Add the Carry value to the sum of TensFirstNum and TensSecondNum and store the result in TensSecondNum
MOVF tenThousandsSecondNum, W      
ADDWF tenThousandsSum               ; Move the result to TensSum
MOVF tenThousandsSum,W
MOVWF tenThousandsSumT  ; Add the value of C1 to HundredsSum and store the result in HundredsSum
   MOVLW 9
   SUBWF tenThousandsSumT
   BTFSC STATUS, Z
   GOTO tenThousandsSumEquals9
   BTFSC  STATUS, C   ;
   GOTO tenThousandsSumSumGreaterThan9
   GOTO tenThousandsSumSumLessThan9
   tenThousandsSumEquals9:
MOVLW 0       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison4

tenThousandsSumSumGreaterThan9:
MOVLW 0x0A       ; Load the immediate value 10 into the W register
SUBWF tenThousandsSum,F ; Subtract 10 from OnesSum and store the result in W register
MOVLW 1       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison4
tenThousandsSumSumLessThan9:
MOVLW 0       ; Move the value 1 to W register
MOVWF Carry   ; Store the value in the Carry variable
  GOTO EndComparison4
EndComparison4:
    CALL xms                         ; Delay for initialization
    CALL xms
    CALL inid                        ; Initialize the LCD display
    BCF Select, RS
    ; Send the ASCII code for 'h' to display the character
    ; Set cursor to the first line, first position (address 0x00)
    MOVLW 0x80
    CALL send                        ; Send command to set cursor position
    BSF Select, RS
    ; Send the ASCII code for 'E' to display the character
    MOVLW 'R'
    CALL send
    ; Send the ASCII code for 'n' to display the character
    MOVLW 'e'
    CALL send
    ; Send the ASCII code for 't' to display the character
    MOVLW 's'
    CALL send
    ; Send the ASCII code for 'e' to display the character
    MOVLW 'u'
    CALL send
    MOVLW 'l'
    CALL send
    ; Send the ASCII code for ' ' to display the character
    MOVLW 't'
    CALL send   
BCF Select, RS

    ; Send the ASCII code for 'h' to display the character
    ; Set cursor to the first line, first position (address 0x00)
    MOVLW 0xC0
    CALL send                        ; Send command to set cursor position
    BSF Select, RS
    MOVLW '='
    CALL send
    MOVF Carry, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send  
    MOVF tenThousandsSum, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
    MOVF ThousandsSum, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send  
    MOVF HundredsSum, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send  
    MOVF TensSum, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send
    MOVF OnesSum, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send
GOTO SingleDouble



division:
CLRF RemainderL
CLRF RemainderH 
CLRF IDX16 
CLRF IDX16_H 
CLRF TEMPYY 
CLRF FirstNumL
CLRF FirstNumH
CLRF SecondNumL
CLRF SecondNumH
MOVLW '/'
XORWF savedSymbol, W        ; Compare savedSymbol with '/'
BTFSS STATUS, Z             ; Branch if not zero (savedSymbol != '/')
goto MOD

converting:
MOVF tenThousandsFirstNum,W
MOVWF counter1

MOVLW 0
    XORWF tenThousandsFirstNum, W
    BTFSC STATUS,Z
    GOTO ENFTT 

OuterLoopFTT:
MOVLW 0
    XORWF counter1, W
    BTFSC STATUS,Z
    GOTO ENFTT 
    movlw 0x64
    movwf counter2

InnerLoopF1TT:

    movlw 0x64
    movwf counter3

InnerLoopF2TT:
  incf   FirstNumL                      ;  Increment the Lower Byte
  btfsc  STATUS, Z              ;  If the Zero Flag is Set
   incf  FirstNumH                  ;   Increment the Upper Byte

    ; Decrement counter3
    decfSZ counter3
    goto InnerLoopF2TT ; Repeat the third loop if counter3 is not zero

    ; Decrement counter2
    decfSZ counter2,F
    goto InnerLoopF1TT ; Repeat the second loop if counter2 is not zero

    ; Decrement counter1
    decFSZ counter1,F
    goto OuterLoopFTT ; Repeat the outermost loop if counter1 is not zero

    


;; ten thousands second num

ENFTT:
CALL ClearLoopCounters
MOVF tenThousandsSecondNum,W
MOVWF counter1

MOVLW 0
    XORWF tenThousandsSecondNum, W
    BTFSC STATUS,Z
    GOTO ENSTT 

OuterLoopSTT:
MOVLW 0
    XORWF counter1, W
    BTFSC STATUS,Z
    GOTO ENSTT 
    movlw 0x64
    movwf counter2

InnerLoopS1TT:

    movlw 0x64
    movwf counter3

InnerLoopS2TT:
  incf   SecondNumL                      ;  Increment the Lower Byte
  btfsc  STATUS, Z              ;  If the Zero Flag is Set
   incf  SecondNumH                  ;   Increment the Upper Byte

    ; Decrement counter3
    decfSZ counter3
    goto InnerLoopS2TT ; Repeat the third loop if counter3 is not zero

    ; Decrement counter2
    decfSZ counter2,F
    goto InnerLoopS1TT ; Repeat the second loop if counter2 is not zero

    ; Decrement counter1
    decFSZ counter1,F
    goto OuterLoopSTT ; Repeat the outermost loop if counter1 is not zero

    

    
; tenthousands lopp both numbers end here
ENSTT:   
CALL ClearLoopCounters
    movlw 0x00
    XORWF ThousandsFirstNum, W
    BTFSC STATUS,Z
    GOTO ENFTH
    MOVF ThousandsFirstNum,W
    MOVWF counter1

OuterLoopFTH:

MOVLW 0
    XORWF counter1, W
    BTFSC STATUS,Z
    GOTO ENFTH 
    movlw 0x0A
    movwf counter2

InnerLoopF1TH:

    movlw 0x64
    movwf counter3

InnerLoopF2TH:
  incf   FirstNumL                     ;  Increment the Lower Byte
  btfsc  STATUS, Z              ;  If the Zero Flag is Set
   incf  FirstNumH                  ;   Increment the Upper Byte

    ; Decrement counter3
    decfsz counter3, F
    goto InnerLoopF2TH ; Repeat the third loop if counter3 is not zero

    ; Decrement counter2
    decfsz counter2, F
    goto InnerLoopF1TH ; Repeat the second loop if counter2 is not zero

    ; Decrement counter1
    decfsz counter1, F
    goto OuterLoopFTH ; Repeat the outermost loop if counter1 is not zero

ENFTH:

CALL ClearLoopCounters
    movlw 0x00
    XORWF ThousandsSecondNum, W
    BTFSC STATUS,Z
    GOTO ENSTH
    MOVF ThousandsSecondNum,W
    MOVWF counter1

OuterLoopSTH:
	MOVLW 0
    XORWF counter1, W
    BTFSC STATUS,Z
    GOTO ENSTH 
    movlw 0x0A
    movwf counter2

InnerLoopS1TH:

    movlw 0x64
    movwf counter3

InnerLoopS2TH:
  incf   SecondNumL                      ;  Increment the Lower Byte
  btfsc  STATUS, Z              ;  If the Zero Flag is Set
   incf  SecondNumH                  ;   Increment the Upper Byte

    ; Decrement counter3
    decfsz counter3, F
    goto InnerLoopS2TH ; Repeat the third loop if counter3 is not zero

    ; Decrement counter2
    decfsz counter2, F
    goto InnerLoopS1TH 

    ; Decrement counter1
    decfsz counter1, F
    goto OuterLoopSTH 

;;;;; thousnads both ends ere;;;;
ENSTH:
CALL ClearLoopCounters
    movlw 0x00
    XORWF HundredsFirstNum, W
    BTFSC STATUS,Z
    GOTO ENFH
    MOVF HundredsFirstNum,W
    MOVWF counter1

OuterLoopFH:
	MOVLW 0
    XORWF counter1, W
    BTFSC STATUS,Z
    GOTO ENFH 
    movlw 0x64
    movwf counter2

InnerLoopFH:
  incf   FirstNumL                      ;  Increment the Lower Byte
  btfsc  STATUS, Z              ;  If the Zero Flag is Set
   incf  FirstNumH                  ;   Increment the Upper Byte
   
    decfsz counter2, F
    goto InnerLoopFH ; Repeat the inner loop if counter2 is not zero

    ; Decrement counter1
    decfsz counter1, F
    goto OuterLoopFH ; Repeat the outer loop if counter1 is not zero

ENFH:



CALL ClearLoopCounters
    movlw 0x00
    XORWF HundredsSecondNum, W
    BTFSC STATUS,Z
    GOTO ENSH
    MOVF HundredsSecondNum,W
    MOVWF counter1

OuterLoopSH:
	MOVLW 0
    XORWF counter1, W
    BTFSC STATUS,Z
    GOTO ENSH 
    movlw 0x64
    movwf counter2

InnerLoopSH:
  incf   SecondNumL                      ;  Increment the Lower Byte
  btfsc  STATUS, Z              ;  If the Zero Flag is Set
   incf  SecondNumH                  ;   Increment the Upper Byte
   
    decfsz counter2, F
    goto InnerLoopSH ; Repeat the inner loop if counter2 is not zero

    ; Decrement counter1
    decfsz counter1, F
    goto OuterLoopSH ; Repeat the outer loop if counter1 is not zero
 
ENSH:

CALL ClearLoopCounters
    movlw 0x00
    XORWF TensFirstNum, W
    BTFSC STATUS,Z
    GOTO ENFTE
    MOVF TensFirstNum,W
	MOVWF counter1
OuterLoopFT:
	MOVLW 0
    XORWF counter1, W
    BTFSC STATUS,Z
    GOTO ENFTE 
    movlw 0x0A
    movwf counter2

InnerLoopFT:
  incf   FirstNumL                      ;  Increment the Lower Byte
  btfsc  STATUS, Z              ;  If the Zero Flag is Set
   incf  FirstNumH                  ;   Increment the Upper Byte
   
    decfsz counter2, F
    goto InnerLoopFT ; Repeat the inner loop if counter2 is not zero

    ; Decrement counter1
    decfsz counter1, F
    goto OuterLoopFT ; Repeat the outer loop if counter1 is not zero
ENFTE:
    
    

CALL ClearLoopCounters
    movlw 0x00
    XORWF TensSecondNum, W
    BTFSC STATUS,Z
    GOTO ENSTE
    MOVF TensSecondNum,W
	MOVWF counter1
OuterLoopST:
	MOVLW 0
    XORWF counter1, W
    BTFSC STATUS,Z
    GOTO ENSTE 
    movlw 0x0A
    movwf counter2

InnerLoopST:
  incf   SecondNumL                      ;  Increment the Lower Byte
  btfsc  STATUS, Z              ;  If the Zero Flag is Set
   incf  SecondNumH                  ;   Increment the Upper Byte
   
    decfsz counter2, F
    goto InnerLoopST ; Repeat the inner loop if counter2 is not zero

    ; Decrement counter1
    decfsz counter1, F
    goto OuterLoopST ; Repeat the outer loop if counter1 is not zero
ENSTE:
CALL ClearLoopCounters
    movlw 0x00
    XORWF OnesFirstNum, W
    BTFSC STATUS,Z
    GOTO ENFO
    MOVF OnesFirstNum,W
    MOVWF counter1
LoopFO:
	MOVLW 0
    XORWF counter1, W
    BTFSC STATUS,Z
    GOTO ENFTT 
  incf   FirstNumL                      ;  Increment the Lower Byte
  btfsc  STATUS, Z              ;  If the Zero Flag is Set
   incf  FirstNumH                  ;   Increment the Upper Byte
   
    decfsz counter1, F
    goto LoopFO ; Repeat the loop if counter is not zero
ENFO:
CALL ClearLoopCounters
    movlw 0x00
    XORWF OnesSecondNum, W
    BTFSC STATUS,Z
    GOTO ENSO
    MOVF OnesSecondNum,W
    MOVWF counter1
LoopSO:
	MOVLW 0
    XORWF counter1, W
    BTFSC STATUS,Z
    GOTO ENFTT 
  incf   SecondNumL                      ;  Increment the Lower Byte
  btfsc  STATUS, Z              ;  If the Zero Flag is Set
   incf  SecondNumH                  ;   Increment the Upper Byte
   
    decfsz counter1, F
    goto LoopSO ; Repeat the loop if counter is not zero
ENSO:

DIVV16
	MOVF SecondNumL,F
	BTFSS  STATUS,Z
	GOTO  ZERO_TEST_SKIPPED
	MOVF SecondNumH,F
	BTFSS STATUS,Z
	GOTO  ZERO_TEST_SKIPPED
    CALL xms                      
    CALL xms
    CALL inid                      
    BCF Select, RS
    MOVLW 0x80
    CALL send
    BSF Select, RS
CALL PrintErr
    CALL xms                         ; Delay for initialization
    CALL xms
GOTO init
ZERO_TEST_SKIPPED
	MOVLW   1
	MOVWF   IDX16
	CLRF    IDX16_H
	CLRF    Quotient
	CLRF    Quotient1
SHIFT_IT16
	BTFSC   SecondNumH,7
	GOTO 	DIVU16LOOP
	BCF     STATUS,C
  	RLF     IDX16,F
  	RLF     IDX16_H,F
  	BCF     STATUS,C
  	RLF     SecondNumL,F
  	RLF     SecondNumH,F
  	GOTO    SHIFT_IT16
DIVU16LOOP


	MOVF    SecondNumH,W
	MOVWF   TEMPYY
	MOVF    SecondNumL,W
	SUBWF   FirstNumL
	BTFSS   STATUS,C
	INCF    TEMPYY,F
	MOVF    TEMPYY,W
	SUBWF   FirstNumH


	BTFSC   STATUS,C
	GOTO    COUNTX
	MOVF    SecondNumL,W
	ADDWF   FirstNumL
	BTFSC   STATUS,C
	INCF    FirstNumH,F
	MOVF    SecondNumH,W
	ADDWF   FirstNumH
	GOTO    FINALX
COUNTX
	MOVF    IDX16,W
	ADDWF   Quotient
	BTFSC   STATUS,C
	INCF    Quotient1,F
	MOVF    IDX16_H,W
	ADDWF   Quotient1
FINALX

	BCF     STATUS,C
	RRF     SecondNumH,F
	RRF     SecondNumL,F
	BCF     STATUS,C
	RRF     IDX16_H,F
	RRF     IDX16,F
	BTFSS   STATUS,C
	GOTO    DIVU16LOOP

END_DIV:
MOVF FirstNumH, W
MOVWF RemainderH
MOVF FirstNumL,W
MOVWF RemainderL
MOVLW 0x0A
MOVWF TenNum
CLRF TEMPYY 

MOVLW '/'
XORWF savedSymbol, W        ; Compare savedSymbol with '/'
BTFSS STATUS, Z             ; Branch if not zero (savedSymbol != '/')
goto convertingAndDivisionDone

;;;;;;;;;;;;;;;;;;;;;;;;;getting digits ones;;;;;
DIVV161
ZERO_TEST_SKIPPED1
CLRF QuotientF
CLRF QuotientF1
CLRF TEMPYY
	MOVLW   1
	MOVWF   IDX16
	CLRF    IDX16_H

SHIFT_IT161
	BTFSC   ZeroNum,7
	GOTO 	DIVU16LOOP1
	BCF     STATUS,C
  	RLF     IDX16,F
  	RLF     IDX16_H,F
  	BCF     STATUS,C
  	RLF     TenNum,F
  	RLF     ZeroNum,F
  	GOTO    SHIFT_IT161
DIVU16LOOP1


	MOVF    ZeroNum,W
	MOVWF   TEMPYY
	MOVF    TenNum,W
	SUBWF   Quotient
	BTFSS   STATUS,C
	INCF    TEMPYY,F
	MOVF    TEMPYY,W
	SUBWF   Quotient1


	BTFSC   STATUS,C
	GOTO    COUNTX1
	MOVF    TenNum,W
	ADDWF   Quotient
	BTFSC   STATUS,C
	INCF    Quotient1,F
	MOVF    ZeroNum,W
	ADDWF   Quotient1
	GOTO    FINALX1
COUNTX1
	MOVF    IDX16,W
	ADDWF   QuotientF
	BTFSC   STATUS,C
	INCF    QuotientF1,F
	MOVF    IDX16_H,W
	ADDWF   QuotientF1
FINALX1

	BCF     STATUS,C
	RRF     ZeroNum,F
	RRF     TenNum,F
	BCF     STATUS,C
	RRF     IDX16_H,F
	RRF     IDX16,F
	BTFSS   STATUS,C
	GOTO    DIVU16LOOP1

END_DIV1:
MOVF Quotient,W
MOVWF DivOnes
MOVF QuotientF,W
MOVWF Quotient
MOVF QuotientF1,W
MOVWF Quotient1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;div tens digit


DIVV162
MOVLW 0x0A
MOVWF TenNum
CLRF QuotientF
CLRF QuotientF1
CLRF TEMPYY
	MOVLW   1
	MOVWF   IDX16
	CLRF    IDX16_H

SHIFT_IT162:
	BTFSC   ZeroNum,7
	GOTO 	DIVU16LOOP2
	BCF     STATUS,C
  	RLF     IDX16,F
  	RLF     IDX16_H,F
  	BCF     STATUS,C
  	RLF     TenNum,F
  	RLF     ZeroNum,F
  	GOTO    SHIFT_IT162
DIVU16LOOP2:


	MOVF    ZeroNum,W
	MOVWF   TEMPYY
	MOVF    TenNum,W
	SUBWF   Quotient
	BTFSS   STATUS,C
	INCF    TEMPYY,F
	MOVF    TEMPYY,W
	SUBWF   Quotient1


	BTFSC   STATUS,C
	GOTO    COUNTX2
	MOVF    TenNum,W
	ADDWF   Quotient
	BTFSC   STATUS,C
	INCF    Quotient1,F
	MOVF    ZeroNum,W
	ADDWF   Quotient1
	GOTO    FINALX2
COUNTX2:
	MOVF    IDX16,W
	ADDWF   QuotientF
	BTFSC   STATUS,C
	INCF    QuotientF1,F
	MOVF    IDX16_H,W
	ADDWF   QuotientF1
FINALX2:

	BCF     STATUS,C
	RRF     ZeroNum,F
	RRF     TenNum,F
	BCF     STATUS,C
	RRF     IDX16_H,F
	RRF     IDX16,F
	BTFSS   STATUS,C
	GOTO    DIVU16LOOP2

END_DIV2:
MOVF Quotient,W
MOVWF DivTens
MOVF QuotientF,W
MOVWF Quotient
MOVF QuotientF1,W
MOVWF Quotient1
;;;;;;;;;;;;;;;;;;hundreds
DIVV163
MOVLW 0x0A
MOVWF TenNum
ZERO_TEST_SKIPPED3
CLRF QuotientF
CLRF QuotientF1
CLRF TEMPYY
	MOVLW   1
	MOVWF   IDX16
	CLRF    IDX16_H

SHIFT_IT163:
	BTFSC   ZeroNum,7
	GOTO 	DIVU16LOOP3
	BCF     STATUS,C
  	RLF     IDX16,F
  	RLF     IDX16_H,F
  	BCF     STATUS,C
  	RLF     TenNum,F
  	RLF     ZeroNum,F
  	GOTO    SHIFT_IT163
DIVU16LOOP3:


	MOVF    ZeroNum,W
	MOVWF   TEMPYY
	MOVF    TenNum,W
	SUBWF   Quotient
	BTFSS   STATUS,C
	INCF    TEMPYY,F
	MOVF    TEMPYY,W
	SUBWF   Quotient1


	BTFSC   STATUS,C
	GOTO    COUNTX3
	MOVF    TenNum,W
	ADDWF   Quotient
	BTFSC   STATUS,C
	INCF    Quotient1,F
	MOVF    ZeroNum,W
	ADDWF   Quotient1
	GOTO    FINALX3
COUNTX3:
	MOVF    IDX16,W
	ADDWF   QuotientF
	BTFSC   STATUS,C
	INCF    QuotientF1,F
	MOVF    IDX16_H,W
	ADDWF   QuotientF1
FINALX3:

	BCF     STATUS,C
	RRF     ZeroNum,F
	RRF     TenNum,F
	BCF     STATUS,C
	RRF     IDX16_H,F
	RRF     IDX16,F
	BTFSS   STATUS,C
	GOTO    DIVU16LOOP3

END_DIV3:
MOVF Quotient,W
MOVWF DivHundreds
MOVF QuotientF,W
MOVWF Quotient
MOVF QuotientF1,W
MOVWF Quotient1
;;;;;;;;;;;;;;;;;;thousands
DIVV164
MOVLW 0x0A
MOVWF TenNum
CLRF QuotientF
CLRF QuotientF1
CLRF TEMPYY
	MOVLW   1
	MOVWF   IDX16
	CLRF    IDX16_H

SHIFT_IT164:
	BTFSC   ZeroNum,7
	GOTO 	DIVU16LOOP4
	BCF     STATUS,C
  	RLF     IDX16,F
  	RLF     IDX16_H,F
  	BCF     STATUS,C
  	RLF     TenNum,F
  	RLF     ZeroNum,F
  	GOTO    SHIFT_IT164
DIVU16LOOP4:


	MOVF    ZeroNum,W
	MOVWF   TEMPYY
	MOVF    TenNum,W
	SUBWF   Quotient
	BTFSS   STATUS,C
	INCF    TEMPYY,F
	MOVF    TEMPYY,W
	SUBWF   Quotient1


	BTFSC   STATUS,C
	GOTO    COUNTX4
	MOVF    TenNum,W
	ADDWF   Quotient
	BTFSC   STATUS,C
	INCF    Quotient1,F
	MOVF    ZeroNum,W
	ADDWF   Quotient1
	GOTO    FINALX4
COUNTX4:
	MOVF    IDX16,W
	ADDWF   QuotientF
	BTFSC   STATUS,C
	INCF    QuotientF1,F
	MOVF    IDX16_H,W
	ADDWF   QuotientF1
FINALX4:

	BCF     STATUS,C
	RRF     ZeroNum,F
	RRF     TenNum,F
	BCF     STATUS,C
	RRF     IDX16_H,F
	RRF     IDX16,F
	BTFSS   STATUS,C
	GOTO    DIVU16LOOP4

END_DIV4:
MOVF Quotient,W
MOVWF DivThousands
MOVF QuotientF,W
MOVWF Quotient
MOVF QuotientF1,W
MOVWF Quotient1

MOVF QuotientF,W
MOVWF DivTenThousands
MOVF QuotientF,W
MOVWF Quotient
MOVF QuotientF1,W
MOVWF Quotient1

goto convertingAndDivisionDone

printDivision:

    CALL xms                         ; Delay for initialization
    CALL xms
    CALL inid                        ; Initialize the LCD display
    BCF Select, RS

    ; Send the ASCII code for 'h' to display the character
    ; Set cursor to the first line, first position (address 0x00)
    MOVLW 0x80
    CALL send                        ; Send command to set cursor position
    BSF Select, RS
CALL PrintOp 

	BCF Select, RS

    ; Send the ASCII code for 'h' to display the character
    ; Set cursor to the first line, first position (address 0x00)
    MOVLW 0xC0
    CALL send                        ; Send command to set cursor position
    BSF Select, RS
    MOVLW '='
    CALL send
    MOVF DivTenThousands, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send  
    MOVF DivThousands, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
    MOVF DivHundreds, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send  
    MOVF DivTens, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send  
    MOVF DivOnes, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send

    MOVLW ' '
    CALL send
    MOVLW 'R'
    CALL send
    MOVLW ':'
    CALL send
    MOVF RemTenThousands, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send  
    MOVF RemThousands, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send                        ; Send the ASCII character to the LCD display
    MOVF RemHundreds, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send  
    MOVF RemTens, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send  
    MOVF RemOnes, W                  ; Load counter value into W register
    CALL numToASCII                  ; Convert the counter value to ASCII
    CALL send
GOTO SingleDouble


MOD:
goto converting

convertingAndDivisionDone:
MOVLW 0x0A
MOVWF TenNum
CLRF IDX16 
CLRF IDX16_H 
CLRF TEMPYY 
;;;;;;;;;;;;;;;;;;;;;;;;;getting digits ones;;;;;
MOD161
	CLRF RemainderF
	CLRF RemainderF1
	CLRF TEMPYY
	MOVLW   1
	MOVWF   IDX16
	CLRF    IDX16_H

SHIFT_IT16MOD1
	BTFSC   ZeroNum,7
	GOTO 	DIVU16LOOPMOD1
	BCF     STATUS,C
  RLF     IDX16,F
  RLF     IDX16_H,F
  BCF     STATUS,C
  RLF     TenNum,F
  RLF     ZeroNum,F
  GOTO    SHIFT_IT16MOD1
DIVU16LOOPMOD1


	MOVF    ZeroNum,W
	MOVWF   TEMPYY
	MOVF    TenNum,W
	SUBWF   RemainderL
	BTFSS   STATUS,C
	INCF    TEMPYY,F
	MOVF    TEMPYY,W
	SUBWF   RemainderH


	BTFSC   STATUS,C
	GOTO    COUNTXMOD1
	MOVF    TenNum,W
	ADDWF   RemainderL
	BTFSC   STATUS,C
	INCF    RemainderH,F
	MOVF    ZeroNum,W
	ADDWF   RemainderH
	GOTO    FINALXMOD1
COUNTXMOD1
	MOVF    IDX16,W
	ADDWF   RemainderF
	BTFSC   STATUS,C
	INCF    RemainderF1,F
	MOVF    IDX16_H,W
	ADDWF   RemainderF1
FINALXMOD1

	BCF     STATUS,C
	RRF     ZeroNum,F
	RRF     TenNum,F
	BCF     STATUS,C
	RRF     IDX16_H,F
	RRF     IDX16,F
	BTFSS   STATUS,C
	GOTO    DIVU16LOOPMOD1

END_DIVMOD1:
	MOVF RemainderL,W
	MOVWF RemOnes
	MOVF RemainderF,W
	MOVWF RemainderL
	MOVF RemainderF1,W
	MOVWF RemainderH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;div tens digit


MOD162
	MOVLW 0x0A
	MOVWF TenNum
ZERO_TEST_SKIPPEDMOD2
	CLRF RemainderF
	CLRF RemainderF1
	CLRF TEMPYY
	MOVLW   1
	MOVWF   IDX16
	CLRF    IDX16_H

SHIFT_IT16MOD2:
	BTFSC   ZeroNum,7
	GOTO 	DIVU16LOOPMOD2
	BCF     STATUS,C
  RLF     IDX16,F
  RLF     IDX16_H,F
  BCF     STATUS,C
  RLF     TenNum,F
  RLF     ZeroNum,F
  GOTO    SHIFT_IT16MOD2
DIVU16LOOPMOD2:


	MOVF    ZeroNum,W
	MOVWF   TEMPYY
	MOVF    TenNum,W
	SUBWF   RemainderL
	BTFSS   STATUS,C
	INCF    TEMPYY,F
	MOVF    TEMPYY,W
	SUBWF   RemainderH


	BTFSC   STATUS,C
	GOTO    COUNTXMOD2
	MOVF    TenNum,W
	ADDWF   RemainderL
	BTFSC   STATUS,C
	INCF    RemainderH,F
	MOVF    ZeroNum,W
	ADDWF   RemainderH
	GOTO    FINALXMOD2
COUNTXMOD2:
	MOVF    IDX16,W
	ADDWF   RemainderF
	BTFSC   STATUS,C
	INCF    RemainderF1,F
	MOVF    IDX16_H,W
	ADDWF   RemainderF1
FINALXMOD2:

	BCF     STATUS,C
	RRF     ZeroNum,F
	RRF     TenNum,F
	BCF     STATUS,C
	RRF     IDX16_H,F
	RRF     IDX16,F
	BTFSS   STATUS,C
	GOTO    DIVU16LOOPMOD2

END_DIVMOD2:
	MOVF RemainderL,W
	MOVWF RemTens
	MOVF RemainderF,W
	MOVWF RemainderL
	MOVF RemainderF1,W
	MOVWF RemainderH
;;;;;;;;;;;;;;;;;;hundreds
MOD163
	MOVLW 0x0A
	MOVWF TenNum
ZERO_TEST_SKIPPEDMOD3
	CLRF RemainderF
	CLRF RemainderF1
	CLRF TEMPYY
	MOVLW   1
	MOVWF   IDX16
	CLRF    IDX16_H

SHIFT_IT16MOD3:
	BTFSC   ZeroNum,7
	GOTO 	DIVU16LOOPMOD3
	BCF     STATUS,C
  RLF     IDX16,F
  RLF     IDX16_H,F
  BCF     STATUS,C
  RLF     TenNum,F
  RLF     ZeroNum,F
  GOTO    SHIFT_IT16MOD3
DIVU16LOOPMOD3:


	MOVF    ZeroNum,W
	MOVWF   TEMPYY
	MOVF    TenNum,W
	SUBWF   RemainderL
	BTFSS   STATUS,C
	INCF    TEMPYY,F
	MOVF    TEMPYY,W
	SUBWF   RemainderH


	BTFSC   STATUS,C
	GOTO    COUNTXMOD3
	MOVF    TenNum,W
	ADDWF   RemainderL
	BTFSC   STATUS,C
	INCF    RemainderH,F
	MOVF    ZeroNum,W
	ADDWF   RemainderH
	GOTO    FINALXMOD3
COUNTXMOD3:
	MOVF    IDX16,W
	ADDWF   RemainderF
	BTFSC   STATUS,C
	INCF    RemainderF1,F
	MOVF    IDX16_H,W
	ADDWF   RemainderF1
FINALXMOD3:

	BCF     STATUS,C
	RRF     ZeroNum,F
	RRF     TenNum,F
	BCF     STATUS,C
	RRF     IDX16_H,F
	RRF     IDX16,F
	BTFSS   STATUS,C
	GOTO    DIVU16LOOPMOD3

END_DIVMOD3:
	MOVF RemainderL,W
	MOVWF RemHundreds
	MOVF RemainderF,W
	MOVWF RemainderL
	MOVF RemainderF1,W
	MOVWF RemainderH
;;;;;;;;;;;;;;;;;;thousands
MOD164
	MOVLW 0x0A
	MOVWF TenNum
ZERO_TEST_SKIPPEDMOD4
	CLRF RemainderF
	CLRF RemainderF1
	CLRF TEMPYY
	MOVLW   1
	MOVWF   IDX16
	CLRF    IDX16_H

SHIFT_IT16MOD4:
	BTFSC   ZeroNum,7
	GOTO 	DIVU16LOOPMOD4
	BCF     STATUS,C
  RLF     IDX16,F
  RLF     IDX16_H,F
  BCF     STATUS,C
  RLF     TenNum,F
  RLF     ZeroNum,F
  GOTO    SHIFT_IT16MOD4
DIVU16LOOPMOD4:


	MOVF    ZeroNum,W
	MOVWF   TEMPYY
	MOVF    TenNum,W
	SUBWF   RemainderL
	BTFSS   STATUS,C
	INCF    TEMPYY,F
	MOVF    TEMPYY,W
	SUBWF   RemainderH


	BTFSC   STATUS,C
	GOTO    COUNTXMOD4
	MOVF    TenNum,W
	ADDWF   RemainderL
	BTFSC   STATUS,C
	INCF    RemainderH,F
	MOVF    ZeroNum,W
	ADDWF   RemainderH
	GOTO    FINALXMOD4
COUNTXMOD4:
	MOVF    IDX16,W
	ADDWF   RemainderF
	BTFSC   STATUS,C
	INCF    RemainderF1,F
	MOVF    IDX16_H,W
	ADDWF   RemainderF1
FINALXMOD4:

	BCF     STATUS,C
	RRF     ZeroNum,F
	RRF     TenNum,F
	BCF     STATUS,C
	RRF     IDX16_H,F
	RRF     IDX16,F
	BTFSS   STATUS,C
	GOTO    DIVU16LOOPMOD4

END_DIVMOD4:
	MOVF RemainderL,W
	MOVWF RemThousands
	MOVF RemainderF,W
	MOVWF RemainderL
	MOVF RemainderF1,W
	MOVWF RemainderH

	MOVF RemainderF,W
	MOVWF RemTenThousands
	MOVF RemainderF,W
	MOVWF RemainderL
	MOVF RemainderF1,W
	MOVWF RemainderH


  MOVLW '%'
  XORWF savedSymbol, W        ; Compare savedSymbol with '%'
  BTFSS STATUS, Z             ; Branch if not zero (savedSymbol != '%')
  goto printDivision  

  CALL xms                         ; Delay for initialization
  CALL xms
  CALL inid                        ; Initialize the LCD display
  BCF Select, RS

  MOVLW 0x80
  CALL send                        ; Send command to set cursor position
  BSF Select, RS

 CALL PrintOp  

	BCF Select, RS

  MOVLW 0xC0
  CALL send                        ; Send command to set cursor position
  BSF Select, RS
  MOVLW '='
  CALL send
  MOVF RemTenThousands, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send  
  MOVF RemThousands, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send                        ; Send the ASCII character to the LCD display
  MOVF RemHundreds, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send  
  MOVF RemTens, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send  
  MOVF RemOnes, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send

  
 
  
SingleDouble:
MOVLW 1
MOVWF SingleDoubleFlag    
CLRF YNCounter
    BSF PIE1, TMR1IE
    
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON

    BSF INTCON, INTE                 ; Enable external interrupt
Wait5SecondsYN:
CALL TimerCon

    ; Loop until 5 seconds have passed
    LOOPYN:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOPYN

    DECFSZ Counter2, 1                ; Decrement Counter1
    GOTO Wait5SecondsYN                ; Loop until Counter1 is zero

    ; Timer1 interrupt occurred, reset the Timer1 interrupt flag
    BCF PIR1, TMR1IF
    BCF PIE1, TMR1IE                 ; Disable Timer1 interrupt
    MOVLW 0x00                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
CALL CountersInit
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt
    CLRF SingleDoubleFlag
 CALL xms                         ; Delay for initialization
  CALL xms
  CALL inid                        ; Initialize the LCD display
  
  BCF Select, RS

  MOVLW 0x80
  CALL send                        ; Send command to set cursor position
  BSF Select, RS

  MOVLW 'K'
  CALL send

  MOVLW 'e'
  CALL send
    
  MOVLW 'e'
  CALL send
    
  MOVLW 'p'
  CALL send
    
  MOVLW '?'
  CALL send

  MOVLW '['
  CALL send   
  MOVLW '1'
  CALL send

  MOVLW ':'
  CALL send
  MOVLW 'Y'
  CALL send

  MOVLW ','
  CALL send     
  
    MOVLW ' '
  CALL send

  MOVLW '2'
  CALL send   
    MOVLW ':'
  CALL send

  MOVLW 'N'
  CALL send  
  MOVLW ']'
  CALL send  
    BSF PIE1, TMR1IE

    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON

    BSF INTCON, INTE                 ; Enable external interrupt
Wait5SecondsYN1:
CALL TimerCon

    ; Loop until 5 seconds have passed
    LOOPYN1:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOPYN1

    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5SecondsYN1                ; Loop until Counter1 is zero

    ; Timer1 interrupt occurred, reset the Timer1 interrupt flag
    BCF PIR1, TMR1IF
    BCF PIE1, TMR1IE                 ; Disable Timer1 interrupt
    MOVLW 0x00                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
      CALL CountersInit
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt  
    MOVLW 1
 MOVWF SingleDoubleFlag
MOVLW 1
XORWF YNCounter,W
BTFSS STATUS,Z
GOTO YN2
 CALL xms                         ; Delay for initialization
  CALL xms
  CALL inid                        ; Initialize the LCD display
    BCF Select, RS
    MOVLW 0x80
    CALL send                        ; Send command to set cursor position
    BSF Select, RS
  CALL PrintRes
  BCF Select, RS
  MOVLW 0xC0
  CALL send                        ; Send command to set cursor position
  BSF Select, RS
  MOVF tenThousandsFirstNum, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send  
  MOVF ThousandsFirstNum, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send                        ; Send the ASCII character to the LCD display
  MOVF HundredsFirstNum, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send  
  MOVF TensFirstNum, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send  
  MOVF OnesFirstNum, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send

;;;;
  MOVF savedSymbol, W                  ; Load counter value into W register
  CALL send
  
   MOVF tenThousandsSecondNum, W                  ; Load counter value into W register
  CALL numToASCII     
CALL send
  MOVF ThousandsSecondNum, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send                        ; Send the ASCII character to the LCD display
  MOVF HundredsSecondNum, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send  
  MOVF TensSecondNum, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send  
  MOVF OnesSecondNum, W                  ; Load counter value into W register
  CALL numToASCII                  ; Convert the counter value to ASCII
  CALL send
  
    BSF PIE1, TMR1IE

    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON

    BSF INTCON, INTE                 ; Enable external interrupt
Wait5SecondsYN2:
CALL TimerCon

    ; Loop until 5 seconds have passed
    LOOPYN2:
        BTFSS PIR1, TMR1IF            ; Check Timer1 interrupt flag
        GOTO LOOPYN2

    DECFSZ Counter1, 1                ; Decrement Counter1
    GOTO Wait5SecondsYN2                ; Loop until Counter1 is zero

    ; Timer1 interrupt occurred, reset the Timer1 interrupt flag
    BCF PIR1, TMR1IF
    BCF PIE1, TMR1IE                 ; Disable Timer1 interrupt
    MOVLW 0x00                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF PIE1, TMR1IE                 ; Enable Timer1 interrupt
    CLRF Counter                     ; Reset the counter value to zero
    CLRF CounterTemp                     ; Reset the counter value to zero
    CALL CountersInit
    MOVLW 0x01                       ; Set TMR1ON and TMR1CS bits (Timer1 enabled, use internal clock)
    MOVWF T1CON
    BSF INTCON, INTE                 ; Enable external interrupt  
    ; Send the ASCII code for 'E' to display the character

GOTO SingleDoubleOP

YN2:
    BCF INTCON, INTE                 ; Enable external interrupt
GOTO init
	
  end 