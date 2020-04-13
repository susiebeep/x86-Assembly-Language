TITLE Program 6 - Designing low-level I/0 procedures    (project6_hibberts.asm)

; Author: Susan Hibbert
; Last Modified: 15th March 2020
; OSU email address: hibberts@oregonstate.edu
; Course number/section: CS_271_C400_W2020
; Project Number: 6               Due Date: 15th March 2020
; Description: The program asks the user for 10 signed decimal integers and performs input validation on
;			   the user's input. If the user enters non-digits other than '+' or '-' to indicate sign, or
;			   if the number is too large for a 32-bit register, an error message will be displayed and
;			   the user will be re-prompted to enter a signed integer. After the user enters all 10 signed
;			   integers, the program displays the signed integers to the user and calculates their sum and
;			   their average value.

INCLUDE Irvine32.inc



ARRAYSIZE1 = 10							; size of array for numeric values declared as a constant
ARRAYSIZE2 = 30							; size of array for digit strings declared as a constant

 
; getString macro
; Description: Displays a prompt passed as a parameter, gets user's input, then stores the input in a variable passed as a parameter
; Receives: Addresses of prompt and inputVar
; Returns: Digit string entered by user in inputVar, number of characters entered by user in eax
; Pre-conditions: Offset of prompt, offset of inputVar, maximum size of user input in ecx
; Post-conditions: Digit string entered by user is stored in inputVar, number of characters entered by user is stored in eax
; Registers changed: edx, ecx, eax

getString	MACRO	prompt, inputVar
	push	edx							; save registers used by macro
	push	ecx
	displayString	 prompt				; display prompt to user using displayString macro
	mov		edx, inputVar
	mov		ecx, 12						; maximum number of characters user can enter
	call	ReadString					; user's input is saved in inputVar variable
	pop		ecx							; restore registers
	pop		edx
ENDM



; displayString macro
; Description: Displays the string passed as parameter
; Receives: Address of text
; Returns: None, string is displayed on screen
; Pre-conditions: Offset of text
; Post-conditions: None, string is displayed on screen
; Registers changed: edx

displayString	MACRO	text
	push	edx							; save register used by macro
	mov		edx, text
	call	WriteString					; display string
	pop		edx							; restore register
ENDM



.data

blank		BYTE		" ", 13, 10, 0
blank1		BYTE		"  ", 0
intro1		BYTE		"*** Welcome to Program 6 - Designing Low-Level I/O Procedures by Susan Hibbert ***", 13, 10, 0
intro2		BYTE		"Please enter 10 signed decimal integers (positive or negative numbers).", 13, 10, 0
intro3		BYTE		"Each number needs to be small enough to fit inside a 32-bit register.", 13, 10, 0
intro4		BYTE		"After you have entered all 10 numbers I will display a list of the integers, their sum, and their average value.", 13, 10, 0
prompt1		BYTE		"Please enter a signed integer: ", 0
errorMsg	BYTE		"You did not enter a signed number or your number was too big to fit in a 32-bit register. Try again!", 13, 10, 0
msg1		BYTE		"You entered the following numbers:", 13, 10, 0
msg2		BYTE		"The sum of these numbers is:", 13, 10, 0
msg3		BYTE		"The rounded average is:", 13, 10, 0
bye1		BYTE		"***Goodbye***", 13, 10, 0
signArr		SDWORD		ARRAYSIZE1	DUP(?)	; unintialized array to hold user's digit string
strArr		DWORD		ARRAYSIZE2	DUP(?)			; unintialized array to hold user's numeric values
temp1		SDWORD		0					; temporarily stores input by user
temp2		DWORD		0					; temporarily stores output before being displayed to user
temp3		DWORD		0					; temporarily stores output before being displayed to user
charCount1	DWORD		11	DUP(0)			; stores number of characters in each digit string used in writeVal procedure
charCount2	DWORD		11	DUP(0)			; stores number of characters in each digit string used in sumArr procedure
charCount3	DWORD		11	DUP(0)			; stores number of characters in each digit string used in avArr procedure
index		DWORD		0					; acts as a boolean to check whether examining first digit in digit string (0 = true, 1 = false)
sumInt		SDWORD		1	DUP(0)			; holds sum of numeric values in array
sumStr		DWORD		1	DUP(0)			; hold sum of numeric values in array, converted to digit string
averageInt	SDWORD		1	DUP(0)			; holds average of numeric values in array
averageStr	DWORD		1	DUP(0)			; holds average of numeric values in array, converted to digit string



.code
main PROC
	push	OFFSET blank
	push	OFFSET intro1				
	push	OFFSET intro2
	push	OFFSET intro3
	push	OFFSET intro4
	call	intro						; introduce program and programmer and display instructions to the user
	

	push	OFFSET blank		
	call	whiteSpace					; insert white space for readability


	push	OFFSET index
	push	OFFSET errorMsg
	push	OFFSET prompt1
	push	OFFSET temp1
	push	ARRAYSIZE1
	push	OFFSET signArr
	call	readVal						; call readVal proc to get user's string of digits, convert to numeric values and store them in signArr, while carrying out input validation

	push	OFFSET temp2
	push	OFFSET blank
	push	OFFSET blank1
	push	OFFSET charCount2
	push	OFFSET temp3
	push	ARRAYSIZE1
	push	OFFSET sumStr
	push	OFFSET sumInt
	push	OFFSET signArr
	push	OFFSET msg2
	call	sumArr						; call sumArr procedure to calculate the sum of the numeric values in signArr; calls writeVal to convert numeric value of sum in sumInt to 
										; digit string and store in sumStr, then displays sumStr to user

	push	OFFSET blank		
	call	whiteSpace					; insert white space for readability


	push	OFFSET temp2
	push	OFFSET blank
	push	OFFSET blank1
	push	OFFSET charCount3
	push	OFFSET temp3
	push	ARRAYSIZE1
	push	sumInt
	push	OFFSET averageStr
	push	OFFSET averageInt
	push	OFFSET msg3
	call	avArr						; call avArr procedure to calculate the average of the numeric values in signArr; calls writeVal to convert numeric value of averageInt to 
										; digit string and store in averageStr, then display averageStr to user

	push	OFFSET blank		
	call	whiteSpace					; insert white space for readability


	push	OFFSET temp3
	push	OFFSET blank
	push	OFFSET blank1
	push	OFFSET charCount1
	push	OFFSET temp2
	push	ARRAYSIZE1
	push	OFFSET signArr
	push	OFFSET strArr
	push	OFFSET msg1
	call	writeVal					; call writeVal procedure to convert numeric values to digit strings, then display digit strings to user


	push	OFFSET blank		
	call	whiteSpace					; insert white space for readability

	
	push	OFFSET blank		
	call	whiteSpace					


	push	OFFSET bye1			
	call	farewell					; display goodbye message to user


	exit	; exit to operating system
main ENDP



; intro
; Description: Procedure to introduce the program and the programmer and provide brief instructions to the user,
;			   using displayString macro
; Receives: Addresses of blank, intro1, intro2, intro3 and intro4 on the system stack
; Returns: None, displays message on screen
; Pre-conditions: Addresses of intro1, intro2, intro3 and intro4 on the system stack
; Post-conditions: None, displays message on screen
; Registers changed: edx

intro PROC	
	push	edx							; save register used by procedure
	push	ebp
	mov		ebp, esp
	displayString	[ebp + 24]			; Display the program title and programmer's name
	displayString	[ebp + 28]			; Insert blank space in code for readability
	displayString	[ebp + 20]			; Display instructions to user
	displayString	[ebp + 16]			
	displayString	[ebp + 12]			
	pop		ebp
	pop		edx							; restore register used by procedure
	ret		20							; clean up variables on the stack	
intro ENDP



; whiteSpace
; Description: Procedure to display white space in program for readability, using displayString macro
; Receives: Address of blank on the system stack
; Returns: None, displays white space on screen
; Pre-conditions: Address of blank on the system stack
; Post-conditions: None, displays white space on screen
; Registers changed: edx

whiteSpace PROC
	push	edx							; save register used by procedure
	push	ebp
	mov		ebp, esp
	displayString	 [ebp + 12]			; insert white space in program for readability
	pop		ebp
	pop		edx							; restore register used by procedure
	ret		4							; clean up variable on the stack
whiteSpace ENDP



; readVal
; Description: Invokes getString macro to get user's string of digits, then converts the digit string
;			   to numeric while validating the user's input
; Receives: Addresses of signArr, temp1, index, prompt1 and errorMsg, and value of ARRAYSIZE on system stack
; Returns: signArr filled with 10 signed numeric integer values
; Pre-conditions: Addresses of signArr, temp1, index, prompt1 and errorMsg, and value of ARRAYSIZE on system stack
; Post-conditions: SignArr filled with 10 signed numeric integer values
; Registers changed: eax, ebx, ecx, edx, esi, edi

readVal PROC
	push	eax							; save registers that will be used in procedure
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp + 32]				; address of signArr
	mov		ecx, [ebp + 36]				; set loop counter to size of signArr		
	mov		edi, 0						; acts as a boolean, used to indicate sign of numeric value: 0 = positive number, 1 = negative number
	mov		[ebp - 12], edi				; will hold the power of ten value used in calculations
	
getNum:
	mov		[ebp - 4], ecx
	push	ecx							; save outer loop counter
	mov		edi, 0
	mov		[ebp + 52], edi				; reset the array index to 0
	getString	[ebp + 44], [ebp + 40]	; pass instruction prompt and temporary storage variable to macro
	mov		ecx, eax					; set inner loop to the number of chars entered by the user
	cmp		eax, 0						; check if user just pressed enter key, display error message if so
	je		error
	mov		esi, [ebp + 40]				; put address of temp into source index esi
	cld									; clear the direction flag so direction is forward and esi is incremented

loadChar:								
	lodsb								; load char from temp into al	
	mov		[ebp - 8], edi				; save boolean value indicating whether number is positive/negative
	mov		edi, 0
	cmp		[ebp + 52], edi				; when checking first byte (i.e. when index = 0), check if user entered a '+' or '-' sign or leading zero
	je		firstTerm
	mov		edi, [ebp - 8]				; restore boolean value
	movzx	eax, al						; zero extend al into eax
	jmp		inputVal
	
firstTerm:
	mov		edi, 1
	add		[ebp + 52], edi				; set index variable to 1 (i.e. false) as first digit has been examined
	mov		edi, [ebp - 8]
	movzx	eax, al						; zero extend al into eax
	cmp		eax, 43						; check if user entered a '+' sign
	je		subFromCount				; subtract 1 from the char count if user entered '+' sign
	cmp		eax, 48						; check if user entered leading zero
	je		zeroNum						; subtract 1 from the char count if user entered leading zero
	cmp		eax, 45						; check if user entered a '-' sign
	je		negNo						; if user entered '-' sign, change boolean variable to 1 to indicate the number is negative and subtract 1 from char count
	jmp		powerTen1					; otherwise, work out the powers of ten of the number

jumpHere1:
	loop	getNum						; the jump to getNum was too far from storeNum so needed to add this intermediate jump location
	jmp		quit

continue:
	jo		error						; display error message if signed integer overflow occured i.e. overflow flag set
	loop	loadChar					; move onto next digit in temp variable
	
	pop		ecx
	mov		ecx, [ebp - 4]				; restore outer loop counter
	cmp		edi, 0
	je		storeNum
	neg		edx							; if edi is 1, the number is negative so negate it
	jo		error						; display error message if signed integer overflow occured i.e. overflow flag set
	jmp		storeNum

negNo:
	mov		edi, 1						; move 1 to edi to indicate number is negative

zeroNum:
	cmp		ecx, 1						; check if user only entered a single 0
	jne		subFromCount
	mov		[ebp - 12], ecx				; if user only entered one digit, set power of ten variable to 1
	mov		edx, 0						; initialize edx to 0 which stores the final result
	jmp		inputVal


subFromCount:
	dec		ecx							; subtract 1 from char count to account for sign or leading zero

powerTen1:
	mov		[ebp - 12], ecx				; save ecx
	mov		[ebp - 16], eax				; save eax
	mov		[ebp - 20], ebx				; save edx
	mov		eax, 1						
	mov		ebx, 10
	dec		ecx
	cmp		ecx, 0
	jne		powerTen2
	mov		[ebp - 12], eax				; if user only entered one digit, set power of ten variable to 1
	jmp		start

powerTen2:								; work out how many powers of 10 are in the number
	imul	ebx
	loop	powerTen2

start:	
	mov		ecx, [ebp - 12]				; restore ecx
	mov		ebx, [ebp - 20]				; restore ebx
	jo		error						; check power of ten number and display error message if signed integer overflow occured in calculation i.e. overflow flag set
	mov		[ebp - 12], eax				; store powers of 10 value
	mov		eax, [ebp - 16]				; restore eax
	mov		edx, 0						; initialize edx to 0 which stores the final result
	cmp		eax, 43						; check if user entered a '+' sign
	je		loadChar					; move onto next char if user entered '+' sign
	cmp		eax, 45						; check if user entered a '-' sign
	je		loadChar					; move onto next char if user entered  '-' sign
	cmp		eax, 48						; check if user entered leading zero
	je		loadChar					; move onto next char if user entered 
	jmp		inputVal					; otherwise continue with input validation


inputVal:
	cmp		eax, 48
	jb		error						; display error message if user entered something other than 0 - 9 (less than ASCII for 0)
	cmp		eax, 57
	ja		error						; display error message if user entered something other than 0 - 9 (more than ASCII for 9)
	mov		[ebp - 24], ecx				; save ecx
	mov		[ebp - 28], edx				; save edx prior to multiplication
	mov		ecx, [ebp - 12]
	mul		ecx							; multiply value in eax by its respective power of 10 to account for the 10's position, 100's position etc in digit string
	mov		ecx, [ebp - 24]				; restore ecx
	mov		edx, [ebp - 28]				; restore edx
	jmp		numConvert

numConvert:	
	mov		[ebp - 24], edx				; save edx
	mov		edx, [ebp - 12]
	imul	edx, 48
	sub		eax, edx					; subtract 48, 480, 4800 etc to get the numeric value
	mov		edx, [ebp - 24]				; restore edx
	add		edx, eax					; add to previous value
	mov		[ebp - 20], eax				; save eax
	mov		[ebp - 24], edx				; save edx
	mov		[ebp - 28], ecx				; save ecx
	mov		eax, [ebp - 12]
	mov		ecx, 10
	mov		edx, 0
	div		ecx							; divide by 10 to get new power of ten before looping
	mov		[ebp - 12], eax	
	mov		eax, [ebp - 20]				; restore eax
	mov		edx, [ebp - 24]				; restore edx
	mov		ecx, [ebp - 28]				; restore ecx
	jmp		continue

storeNum:
	jo		error						; display error message if signed integer overflow occured i.e. overflow flag set
	mov		[ebx], edx					; store signed integer in array
	add		ebx, 4						; move onto next position in array
	jmp		jumpHere1					; loop until signArr is filled with 10 signed integers


error:
	displayString	[ebp + 48]			; display error message when invalid input entered
	pop		ecx
	mov		ecx, [ebp - 4]				; restore outer loop counter
	jmp		getNum						; reprompt user for valid input

quit:
	pop		ebp							; restore all used registers
	pop		edi
	pop		esi
	pop		edx
	pop		ecx	
	pop		ebx
	pop		eax
	ret		24							; clean up variables on the stack
readVal ENDP



; writeVal
; Description: Converts a numeric value to a string of digits, then invokes the displayString macro to
;			   produce the output
; Receives: Addresses of blank, blank1, signArr, strArr, msg1, temp2, temp3 and charCount1, and value of ARRAYSIZE on system stack
; Returns: strArr filled with digit strings and displayed to user
; Pre-conditions: strArr filled with digit strings and displayed to user
; Post-conditions: Addresses of blank, blank1, signArr, strArr, msg1, temp2, temp3 and charCount1, and value of ARRAYSIZE on system stack
; Registers changed: eax, ebx, ecx, edx, edi, esi and displayed to user

writeVal PROC
	push	eax							; save registers that will be used in procedure
	push	ebx
	push	ecx
	push	edx
	push	edi
	push	esi
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp + 36]				; address of strArr moved to target
	mov		esi, [ebp + 40]				; address of signArr moved to source  
	mov		ecx, [ebp + 44]				; set loop counter to size of signArr	
	mov		ebx, [ebp + 52]				; address of charCount array to store number of characters in each digit string, stored locally on stack
	mov		[ebp - 16], ebx				
	mov		ebx, 0						
	mov		[ebp - 20], ebx				; acts as a boolean variable to indicate if number is positive or negative (1 = negative, 0 = positive)
	mov		ebx, 10						; acts as the divisor
	cld									; clear the direction flag so the direction is forward and esi is incremented
	
setUp:
	mov		[ebp - 4], ecx				; save outer loop counter locally on stack
	mov		ecx, [ebp - 16]				; address of charCount array to store number of characters in each digit string
	mov		eax, SDWORD PTR [esi]
	sub		eax, 0						; the sign flag will be set if the result of this expression is negative, thus meaning the number is negative
	jns		convertStr					; if sign flag is not set the number is positive
	neg		eax							; otherwise get the absolute value of the negative number
	mov		[ebp - 12], ebx				; save ebx
	mov		ebx, 1
	mov		[ebp - 20], ebx				; change boolean value to 1 to indicate number is negative
	mov		ebx, [ebp - 12]				; restore ebx

convertStr:	
	cdq
	idiv	ebx							; divide numeric value by 10
	add		edx, 48						; add 48 to the remainder to get its ASCII value
	mov		[ebp - 8], eax				; save quotient of division in local stack variable 
	mov		eax, edx					; store char value in eax prior to calling stosd
	stosb								; store byte from al in strArr
	mov		[ebp - 12], ebx				; save ebx
	mov		ebx, 1
	add		[ecx], ebx					; add 1 to character count
	mov		ebx, [ebp - 12]				; restore ebx
	mov		eax, [ebp - 8]				; restore value of eax
	cmp		eax, 0						; check if finished converting current numeric value
	je		checkSign					; if finished, check sign of the current numeric value then move onto next numeric value in array
	jmp		convertStr					; otherwise convert rest of number to its ASCII value		

checkSign:
	mov		[ebp - 12], ebx				; save ebx
	mov		ebx, [ebp - 20]
	cmp		ebx, 1						; check if number is negative
	je		convertNegNo
	mov		ebx, [ebp - 12]				; restore ebx
	jmp		nextNum

convertNegNo:
	mov		eax, 45
	stosb								; append the ASCII char for negative sign to indicate number is negative
	mov		ebx, 1
	add		[ecx], ebx					; add 1 to character count
	mov		ebx, [ebp - 12]				; restore ebx 	
	mov		eax, 0						; move 0 back to eax prior to appending the null terminator to end of digit string
	mov		[ebp - 20], eax				; reset the boolean back to 0 ahead of converting next numeric value
	
nextNum:
	stosb								; append null terminator to end of digit string
	add		esi, 4						; move onto next numeric value
	add		ecx, 4						; move onto next storage position in charCount
	mov		[ebp - 16], ecx				; store address of current position in charCount
	mov		ecx, [ebp - 4]				; restore outer loop counter
	loop	setUp

	displayString	[ebp + 60]			; insert white space in the code for readability
	displayString	[ebp + 32]			; display message to user about what will be displayed on screen

	mov		ecx, [ebp + 44]				; set loop counter to number of elements in strArr
	mov		edi, [ebp + 36]				; point to start of strArr
	mov		ebx, [ebp + 52]				; point to start of charCount
	mov		eax, 0

start:	
	push	ecx							; save outer loop
	mov		[ebp - 4], ecx
	mov		ecx, [ebx]					; set inner loop to be character count for the digit string

stackSetUp:
	mov		al, BYTE PTR [edi]			; due to little-endian storage, we need to reverse the digit string
	movsx	eax, al						; so it displays correctly on screen - to do this we need to
	push	eax							; push each char in the digit string onto the stack and pop them
	inc		edi							; back into the digit string in LIFO order
	loop	stackSetUp

	dec		edi
	mov		ecx, [ebx]					; set inner loop to be character count for the digit string

displayStr:
	pop		[ebp + 64]					; pop digit strings into temp3 variable - digit strings will be displayed in order
	mov		al, [ebp + 64]
	mov		[edi], al
	mov		[ebp + 48], edi
	displayString	[ebp + 48]			; display digit string
	loop	displayStr

	displayString	[ebp + 56]			; insert spaces between the numbers
	add		edi, 2						; point to the address of next digit string in strArr
	add		ebx, 4						; point to next charCount value

	pop		ecx							; restore outer loop
	mov		ecx, [ebp - 4]
	loop	start						; continue to display all the digit strings

	pop		ebp
	pop		esi							; restore all used registers
	pop		edi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret		36							; clean up variables on the stack
writeVal ENDP



; sumArr
; Description: Calculates sum of numeric values in array and calls writeVal to convert numeric value of sum
;			   to a digit string which is displayed on screen to the user
; Receives: Addresses of msg2, signArr, sumInt, sumStr, temp2, temp3, charCount2, blank and blank1 and value of ARRAYSIZE
; Returns: Sum of numeric values returned as an integer in eax which gets saved in sumInt and converted to a digit string 
;		   by writeVal and stored in sumStr
; Pre-conditions: Addresses of msg2, signArr, sumInt, sumStr, temp2, temp3, charCount2, blank and blank1 and value of ARRAYSIZE
; Post-conditions: Sum of numeric values in eax, which is then saved in address of sumInt variable. After calling writeVal, sum
;				   of numeric values as a digit string is stored in sumStr
; Registers changed: eax, ebx, ecx, esi

sumArr PROC
	push	eax							; save registers that will be used in procedure
	push	ebx
	push	ecx
	push	esi
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 28]				; address of signArr
	mov		ecx, [ebp + 40]				; set loop counter to size of array
	mov		eax, 0						; holds sum

sumCalc:
	add		eax, [esi]
	add		esi, 4
	loop	sumCalc

	mov		ebx, [ebp + 32]			
	mov		[ebx], eax					; move sum of numeric values to address of sumInt variable

	push	[ebp + 60]					; address of temp2
	push	[ebp + 56]					; address of blank
	push	[ebp + 52]					; address of blank1
	push	[ebp + 48]					; address of charCount2
	push	[ebp + 44]					; address of temp3
	push	1							; size of sumInt array
	push	[ebp + 32]					; address of sumInt
	push	[ebp + 36]					; address of sumStr
	push	[ebp + 24]					; address of msg2
	call	WriteVal

	pop		ebp							; restore all used registers
	pop		esi
	pop		ecx
	pop		ebx
	pop		eax
	ret		36							; clean up variables on the stack
sumArr ENDP



; avArr
; Description: Calculates average of numeric values in array, rounded down to nearest integer, and calls writeVal
;			   to convert numeric value of average to a digit string which is displayed on screen to the user
; Receives: Addresses of msg3, averageInt, averageStr, temp2, temp3, charCount3, blank and blank1 and value of sumInt and ARRAYSIZE
; Returns: Average of numeric values, rounded down to nearest integer, returned in eax which gets saved in averageInt and converted 
;		   to a digit string by writeVal and stored in averageStr
; Pre-conditions: Addresses of msg3, averageInt, averageStr, temp2, temp3, charCount3, blank and blank1 and value of sumInt and ARRAYSIZE
; Post-conditions: Average of the numeric values in eax which is then saved in address of averageInt. After calling writeVal, average
;				   of numeric values as a digit string is stored in averageStr
; Registers changed: eax, ebx, ecx, edx

avArr PROC
	push	eax							; save registers that will be used in procedure
	push	ebx
	push	ecx
	push	edx
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp + 36]				; value of sumInt
	mov		ecx, [ebp + 40]				; size of array

	cdq									; sign extend before division
	idiv	ecx							; calculate average = sum / number of integers

	mov		ebx, [ebp + 28]
	mov		[ebx], eax					; store average in averageInt variable (rounded down)

	push	[ebp + 60]					; address of temp2
	push	[ebp + 56]					; address of blank
	push	[ebp + 52]					; address of blank1
	push	[ebp + 48]					; address of charCount3
	push	[ebp + 44]					; address of temp3
	push	1							; size of averageInt array
	push	[ebp + 28]					; address of averageInt
	push	[ebp + 32]					; address of averageStr
	push	[ebp + 24]					; address of msg3
	call	WriteVal

	pop		ebp							; restore all used registers
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret		40							; clean up variables on the stack
avArr ENDP



; farewell
; Description: Procedure to display a goodbye message to the user, using displayString macro
; Receives: Address of bye1 on the system stack
; Returns: None, message displayed on screen
; Pre-conditions: Address of bye1 on the system stack
; Post-conditions: None, message displayed on screen
; Registers changed: none

farewell PROC
	push	ebp							; save register used by procedure
	mov		ebp, esp
	displayString	 [ebp + 8]			; Display parting message to user	
	pop		ebp							; restore register used by procedure
	ret		4							; clean up variable on the stack
farewell ENDP



END main
