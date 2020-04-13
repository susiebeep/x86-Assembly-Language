TITLE Program 3 - Integer Accumulator     (program3_hibberts.asm)

; Author: Susan Hibbert
; Last Modified: 4th February 2020
; OSU email address: hibberts@oregonstate.edu
; Course number/section: CS_271_C400_W2020
; Project Number: 3              Due Date: 9th February 2020
; Description: This program is an integer accumulator program. It is comprised of the following steps:
; 1. Display the program title and programmer's name
; 2.	a) Get the user's name
;		b) Greet the user
; 3. Display instructions to the user
; 4. Repeatedly prompt the user to enter a valid number
;		a) Validate the user input to be in [-88, -55] or [-40, -1] (inclusive).
;		b) Count and accumulate the valid user numbers until a non-negative number is entered (detect
;		this using the SIGN flag).
;		c) Notify the user of any invalid numbers (negative, but not in the ranges specified)
; 5) Calculate the (rounded integer) average of the valid numbers.
; 6) Display:
;		a) the number of valid numbers entered
;		b) the sum of negative numbers entered
;		c) the maximum (closest to 0) valid number entered
;		d) the minimum (farthest from 0) valid number entered
;		e) the average valid number, rounded to the nearest integer
;		f) a parting message (including the user’s name)

INCLUDE Irvine32.inc
; The four value limits defined as constants

RANGE1_UPPER = -55	; first range's upper limit
RANGE1_LOWER = -88	; first range's lower limit
RANGE2_UPPER = -1	; second range's upper limit
RANGE2_LOWER = -40	; second range's lower limit


.data

blank		BYTE		" ", 0
intro1		BYTE		"*** Welcome to Program 3 - Integer Accumulator by Susan Hibbert ***", 13, 10, 0
askName		BYTE		"What is your name?", 13, 10, 0
userName	BYTE		33 DUP(0) ; stores the string to be entered by the user, initialized with the null-terminated character 0
hello		BYTE		"Hello, ", 0
bye			BYTE		"Goodbye, ", 0
endMsg		BYTE		"*** So long, and thanks for all the fish! ***", 13, 10, 0
prompt1		BYTE		"Please enter numbers between -88 and -55 or between -40 and -1 (inclusive)", 13, 10, 0
prompt2		BYTE		"When you are finished, enter a non-negative number to see your results ", 13, 10, 0
prompt3		BYTE		"Enter a number: ", 0
validNo		DWORD		?	; number to be entered by the user in [-88, -55] or [-40, -1] (inclusive)
wrongNo		BYTE		"Invalid Number! Although it's a negative number, it isn't in range. Please try again! ", 13, 10, 0
count		DWORD		0 ; used to keep track of the number of valid numbers entered by the user
sum			DWORD		0 ; used to accumulate the sum of the valid numbers entered by the user
avNo		DWORD		0 ; used to store the quotient of the average number calculation
remdr		DWORD		0 ; used to store the remainder of average number calculation
min			DWORD		0 ; used to store the minimum valid number entered by the user
max			DWORD		0 ; used to store the maximum valid number entered by the user
noValNo		BYTE		"Eh, this is awkward. You didn't *actually* enter any negative numbers... ", 13, 10, 0
totalNo1	BYTE		"You entered ", 0
totalNo2	BYTE		" valid numbers", 13, 10, 0
maxNo		BYTE		"The maximum valid number is ", 0
minNo		BYTE		"The minimum valid number is ", 0
sumNo		BYTE		"The sum of your valid numbers is ", 0
rndAvNo		BYTE		"The rounded average number is ", 0

.code
main PROC

; INTRODUCTION
; Please note that I re-used and adapted this section of code from previous code I wrote in program 2
; 1. Display the program title and programmer's name
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf

; 2a. Get the user's name
	mov		edx, OFFSET askName
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32				; although the array userName is 33 bytes long, the last byte is for the null-terminating character 0
	call	ReadString

; Insert white space in code for readability
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf

; 2b. Greet user
	mov		edx, OFFSET hello
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

; Insert white space in code for readability
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf


; DISPLAY INSTRUCTIONS
; 3. Display Instructions for the user
;	Ask the user to enter numbers in [-88, -55] or [-40, -1] (inclusive)
;	then ask them to enter a non-negative number when they are finished
;	to see their results
	mov		edx, OFFSET prompt1
	call	WriteString
	mov		edx, OFFSET prompt2
	call	WriteString 

; Insert white space in code for readability
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf


; GET USER DATA
; 4. Repeatedly prompt the user to enter a number
getNo:
	mov		edx, OFFSET prompt3
	call	WriteString 
	call	ReadInt
	mov		validNo, eax

; 4a. Validate the user input to be in [-88, -55] or [-40, -1] (inclusive)
	jns		average					; if user entered 0 or above (ie. an unsigned number) the sign flag will be clear - in this case terminate user input and calculate the average of the numbers
	cmp		validNo, RANGE1_LOWER	; compare user's input to -88
	jl		error					; display error message if they have entered a value less than -88
	cmp		validNo, RANGE1_UPPER	; compare user's input to -55
	ja		midRange1				; if user entered a number greater than -55, check if it is in [-40, -1]
	cmp		validNo, RANGE2_LOWER	; compare user's input to -40
	jb		midRange2				; if user entered a number less than -40, check if it is in [-88, -55]	
	jmp		saveNo					; if the number makes it to this line, it is valid and can be saved

; 4c. Notify the user of any invalid numbers
error:
	mov		edx, OFFSET wrongNo		; tell user they entered an invalid number
	call	WriteString
	jmp		getNo					; re-prompt user for a valid number

; jump here if input is greater than -55
midRange1:
	cmp		validNo, RANGE2_LOWER	; compare user's input to -40
	jb		error					; user entered number between -41 and -54, re-prompt for valid number
	jmp		saveNo					; otherwise, save valid number

; jump here if input is less than -40
midRange2:
	cmp		validNo, RANGE1_UPPER	; compare user's input to -55
	ja		error					; user entered number between -41 and -54, re-prompt for valid number
	jmp		saveNo					; otherwise, save valid number

; 4b. Count and accumulate the valid, negative user numbers
saveNo:
	mov		eax, sum
	add		eax, validNo
	mov		sum, eax
	inc		count					; add 1 to count of valid numbers
	cmp		count, 1				; if this is the first valid number entered, set it to both min and max value
	je		count1
	jmp		setMinMax				; set min and max values	

; if this is the first valid number entered, set it to min and max values	
count1:
	mov		eax, validNo
	mov		min, eax
	mov		max, eax
	jmp		getNo					; ask user for more valid numbers

setMinMax:
	mov		eax, validNo
	cmp		eax, max				; if number entered is greater than current max value (i.e. closer to 0), set it to new max value
	jg		newMax
	cmp		eax, min				; if number entered is less than current min value (i.e. further from 0), set it to new min value
	jl		newMin
	jmp		getNo					; if min and max values do not need to be updated, ask user for more valid numbers

newMax:								; update max value
	mov		eax, validNo
	mov		max, eax
	jmp		getNo

newMin:								; update min value
	mov		eax, validNo
	mov		min, eax
	jmp		getNo	


; CALCULATE AVERAGE
; 5. Calculate the (rounded integer) average of the valid numbers.
average:
	cmp		count, 0				
	je		noNum					; if no negative numbers were entered, display a message to the user
	mov		edx, 00000000			; clear dividend prior to division
	mov		eax, sum
	cdq
	mov		ebx, count
	idiv	ebx						; calculate average of valid numbers
	mov		avNo, eax				; quotient of average calculation
	mov		remdr, edx				; remainder of average calculation


	; round the average number to the nearest integer by comparing count/2 with remainder of average calculation
	mov		edx, 00000000			; clear dividend prior to division
	mov		eax, count
	cdq
	mov		ebx, 2
	div		ebx						; divide count by 2
	add		eax, edx				; round the count/2 calculation to nearest integer by adding on the remainder of the count/2 calculation - either 0 or 1
	neg		eax						; make count/2 negative as the remainder will be a negative number since we are working with signed values
	cmp		remdr, eax				; determine whether to round average number up or down by comparing remainder with count/2 value (in eax)
	jl		round					; round number down if remainder is less than half the count (NB both numbers will be negative)
	jmp		results

; if user did not eneter any negative numbers
noNum:
; Insert white space in code for readability
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf

	mov		edx, OFFSET noValNo
	call	WriteString
	jmp		finish

round:
	dec		avNo					; round number down to nearest integer (NB we are working with negative numbers)
	jmp		results


; DISPLAY RESULTS
results:	
; Insert white space in code for readability
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf

; 6a. Display how many valid numbers they entered
	mov		edx, OFFSET totalNo1
	call	WriteString
	mov		eax, count
	call	WriteDec
	mov		edx, OFFSET totalNo2
	call	WriteString

; 6b. Display the sum of the valid numbers
	mov		edx, OFFSET sumNo
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf

; 6c. Display the max value entered 
	mov		edx, OFFSET maxNo
	call	WriteString
	mov		eax, max
	call	WriteInt
	call	CrLf

; 6d. Display the min value entered 
	mov		edx, OFFSET minNo
	call	WriteString
	mov		eax, min
	call	WriteInt
	call	CrLf

; 6e. Display the rounded average number
	mov		edx, OFFSET rndAvNo
	call	WriteString
	mov		eax, avNo
	call	WriteInt
	call	CrLf

; FAREWELL
finish:	
; Insert white space in code for readability
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf

; 6f. Say goodbye to the user
	mov		edx, OFFSET bye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf
	mov		edx, OFFSET endMsg
	call	WriteString
	call	CrLf
	
	exit	; exit to operating system

main ENDP

END main
