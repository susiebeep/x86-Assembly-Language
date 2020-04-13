TITLE Program 4 - Composite Number Generator     (program4_hibberts.asm)

; Author: Susan Hibbert
; Last Modified: 11th February 2020
; OSU email address: hibberts@oregonstate.edu
; Course number/section: CS_271_C400_W2020
; Project Number: 4         Due Date: 16th February 2020
; Description: 
; This program calculates and displays composite numbers. After displaying the program name and the
; name of the programmer, the user is asked to enter the number of composites they would like to be
; displayed, in the range of 1 to 400 (inclusive).  
; The user enters a number, n, and the program verifies that it is in range.  If n is out of range, 
; the user is re-prompted until they enter a value in the specified range. The program then calculates
; and displays all of the composite numbers up to and including the nth composite.  The results are
; displayed 10 composite numbers per line, separated by 3 spaces each. 


INCLUDE Irvine32.inc

UPPER_LIMIT = 400		; maximum number of composites that can be displayed
LOWER_LIMIT = 1			; minimum number of composites that can be displayed
	
.data

blank		BYTE		" ", 0
spaces		BYTE		"   ", 0	; separates each composite number by 3 spaces
intro1		BYTE		"*** Welcome to Program 4 - Composite Number Generator by Susan Hibbert ***", 13, 10, 0
prompt1		BYTE		"How many composite numbers would you like to see?", 13, 10, 0
prompt2		BYTE		"Please enter a number between 1 and 400 (inclusive):", 13, 10, 0
prompt3		BYTE		"Enter the number of composites to display: ", 0
numComp		DWORD		?	; number of composites to be entered by the user [1 .. 400]
compNo		DWORD		4	; used to store the composite numbers, starting with the first composite number 4
divisor		DWORD		2	; used in division calculation to determine if a number is composite
limit		DWORD		2	; used as part of the composite number calculation
innerLoop	DWORD		0	; used to set inner loop counter	
outerLoop	DWORD		0	; used to set outer loop counter
count		DWORD		0	; used to keep track of the number of composite numbers printed per line
bye1		BYTE		"These are genuine composite numbers certified by a genuine programmer, Susan", 0
bye2		BYTE		"Goodbye.", 0
endMsg		BYTE		"*** For a moment, nothing happened. Then, after a second or so, nothing continued to happen ***", 13, 10, 0
wrongNo		BYTE		"That number isn't in range. Please try again! ", 13, 10, 0

.code
main PROC

	call	introduction
	call	getUserData
	call	showComposites
	call	farewell

	exit				; exit to operating system
main ENDP

; introduction
; Description: Procedure to introduce the program and the programmer to the user
; Receives: None
; Returns: None
; Pre-conditions: None
; Post-conditions: None
; Registers changed: edx

introduction PROC				
	mov		edx, OFFSET intro1		; Display the program title and programmer's name
	call	WriteString
	call	CrLf
	ret
introduction ENDP


; getUserData
; Description: Procedure to display instructions to user
; Receives: None
; Returns: None - validate sub-procedure called inside this procedure which returns the number of composites 
;		   to be displayed in the specified range [1...400] (numComp)
; Pre-conditions: None 
; Post-conditions: None - validate sub-procedure returns numComp in the specified range [1..400]
; Registers changed: edx

getUserData PROC
	mov		edx, OFFSET prompt1
	call	WriteString
	mov		edx, OFFSET prompt2		; Instruct user to enter a number between 1 and 400 (inclusive)
	call	WriteString

	mov		edx, OFFSET blank		; Insert white space in code for readability
	call	WriteString
	call	CrLf

	call	validate				; call sub-procedure validate to receive and validate user input
	
	mov		edx, OFFSET blank		; insert white space for readability
	call	WriteString
	call	CrLf
	ret
getUserData ENDP


; validate
; Description: Procedure to obtain and validate user input for the number of composite numbers to be displayed
; Receives: UPPER_LIMIT and LOWER_LIMIT constants
; Returns: Number of composites to be displayed in the specified range [1...400] (numComp)
; Pre-conditions: User must be prompted to enter a number between 1 and 400 (inclusive)
; Post-conditions: numComp in the specified range [1..400]
; Registers changed: edx, eax

validate PROC
getNo:
	mov		edx, OFFSET prompt3		; Prompt user to enter a number
	call	WriteString 
	call	ReadInt					; Get user input
	mov		numComp, eax
	cmp		numComp, LOWER_LIMIT	; check the user has not entered a number less than 1
	jb		error
	cmp		numComp, UPPER_LIMIT	; check the user has not entered a number greater than 400
	ja		error
	jmp		validNo					; if program reaches here, the number entered by the user is in range

error:
	mov		edx, OFFSET wrongNo		; tell user they entered a number out of range
	call	WriteString
	jmp		getNo					; re-prompt user for a valid number

validNo:	
	ret								; return to getUserData procedure after valid number entered
validate ENDP


; showComposites
; Description: Procedure to calculate the composite numbers
; Receives: numComp, divisor, limit, outerLoop, innerLoop variables
; Returns: None - isComposite sub-procedure called inside this procedure which displays the composite numbers 
;		   and increments or resets the count variable, which keeps track of the number of composites printed 
;		   per line
; Pre-conditions: numComp in the specified range, limit is set to 2, compNo set to 4, divisor initially set to 2
; Post-conditions: None - isComposite sub-procedure called inside this procedure which increments or resets the 
;				   count variable to 0
; Registers changed: ecx, edx, eax

showComposites PROC
	mov		ecx, numComp			; set the outer loop counter to the number of composites to be displayed
	
outer:
	mov		outerLoop, ecx			; save outer loop count
	mov		edx, 0					; clear dividend before division
	mov		eax, compNo				
	div		limit					; determine the counter for the inner loop which tests a range of divisors to determine if a number is composite
	mov		innerLoop, eax			
	add		innerLoop, edx			; add the remainder of dividing by 2 (1 or 0)
	mov		ecx, innerLoop			; set inner loop count
	mov		divisor, 2				; start the divisor at 2

inner:
	mov		edx, 0					; clear dividend before division
	mov		eax, compNo				
	div		divisor					; start by dividing with the number 2 to check if the number can be factored
	cmp		edx, 0					
	je		yes						; if there is no remainder after the division, a factor has been found indicating that the number is a composite
	inc		divisor					; if there is a remainder after the division, increase divisor by 1
	loop	inner						
	
innerDone:	
	mov		ecx, outerLoop			; restore outer loop
	inc		compNo
	jmp		outer
	
yes:
	mov		eax, compNo
	call	isComposite				; call sub-procedure to print out composite number
	mov		ecx, outerLoop			; restore outer loop
	inc		compNo
	loop	outer					; move onto the next number and repeat outer loop

	mov		edx, OFFSET blank		; insert white space for readability
	call	WriteString
	call	CrLf
	ret
showComposites ENDP


; isComposite
; Description: Procedure to display the composite numbers, separated by 3 spaces, 10 terms per line
; Receives: Composite number to be displayed (compNo) in eax
; Returns: count variable increased or reset to 0
; Pre-conditions: compNo in eax
; Post-conditions: count is incremented or reset to 0
; Registers changed: edx

isComposite PROC
	call	WriteDec				; display composite number on screen
	mov		edx, OFFSET spaces
	call	WriteString				; insert 3 spaces after each composite number
	inc		count					; add one to the number of composite numbers displayed per line
	cmp		count, 10
	jb		continue
	call	Crlf					; start a new line every 10 numbers
	mov		count, 0				; reset count
	jmp		continue	

continue:
	ret	
isComposite ENDP


; farewell
; Description: Procedure to display a goodbye message to the user
; Receives: none
; Returns: none
; Pre-conditions: none
; Post-conditions: none
; Registers changed: edx

farewell PROC
	mov		edx, OFFSET blank		; Insert white space in code for readability
	call	WriteString
	call	CrLf

	mov		edx, OFFSET bye1		; Display parting message to user
	call	WriteString
	call	CrLf
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf
	mov		edx, OFFSET bye2		
	call	WriteString
	call	CrLf
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf
	mov		edx, OFFSET endMsg		; Display additional parting message to user
	call	WriteString
	call	CrLf
	ret
farewell ENDP

END main
