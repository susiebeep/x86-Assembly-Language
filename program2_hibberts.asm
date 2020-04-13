TITLE Program 2 - Fibonacci Numbers     (program2_hibberts.asm)

; Author: Susan Hibbert
; Last Modified: 20th January 2020
; OSU email address: hibberts@oregonstate.edu
; Course number/section: CS_271_C400_W2020
; Project Number: 2                Due Date: 26th January 2020
; Description: This program calculates Fibonacci numbers. It is comprised of the following steps:
; 1. Display the program title and programmer’s name. Then get the user’s name, and greet the user 
; 2. Prompt the user to enter the number of Fibonacci terms to be displayed. Advise the user to enter an integer
;	 in the range [1 .. 46].
; 3. Get and validate the user input (n). Display an error message if the number entered is out-of-range and 
;	 re-prompt user to enter a correct integer
; 4. Calculate and display all of the Fibonacci numbers up to and including the nth term. The results will be
;	 displayed 5 terms per line with at least 5 spaces between each term.
; 5. Display a parting message that includes the user’s name, and terminate the program.

INCLUDE Irvine32.inc

UPPER_LIMIT = 46	; upper limit is defined and used as a constant
LOWER_LIMIT = 1		; lower limit is defined and used as a constant

.data

blank		BYTE		" ", 0
blank1		BYTE		"     ", 0 ; 5 spaces to separate each Fibonacci number
intro1		BYTE		"Program 2 - Fibonacci Numbers by Susan Hibbert", 13, 10, 0
askName		BYTE		"What is your name?", 13, 10, 0
userName	BYTE		33 DUP(0) ; string to be entered by the user, initialized with the null-terminated character 0
hello		BYTE		"Hello, ", 0
bye			BYTE		"Goodbye, ", 0
endMsg		BYTE		"Results certified by Susan Hibbert", 13, 10, 0
prompt1		BYTE		"How many Fibonacci terms would you like me to display?", 13, 10, 0
prompt2		BYTE		"Please enter an integer between 1 and 46 (inclusive): ", 13, 10, 0
fibNo		DWORD		?	; number of Fibonacci terms to be entered by the user (between 1 and 46)
wrongNo		BYTE		"That number is out of range! Please enter a number in the range of 1 - 46: ", 13, 10, 0
display		BYTE		"Fibonacci Numbers: ", 13, 10, 0
temp		DWORD		-1	; used when calculating next Fibonacci number in the sequence
count		DWORD		0 ; used to keep track of the number of Fibonacci numbers printed per line

.code
main PROC

; INTRODUCTION
; Display the program title and programmer's name
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf

; Get the user's name
	mov		edx, OFFSET askName
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32		;although the array userName is 33 bytes long, the last byte is for the null-terminating character 0
	call	ReadString

; Insert white space in code for readability
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf

; Greet user
	mov		edx, OFFSET hello
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

; Insert white space in code for readability
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf

; USER INSTRUCTIONS	
; Ask the user how many Fibonacci terms they would like and
; advise them to enter an integer between 1 and 46 inclusive
	mov		edx, OFFSET prompt1
	call	WriteString
	mov		edx, OFFSET prompt2
	call	WriteString 

; GET USER DATA
; user enters number of Fibonacci terms they would like
top:
	call	ReadInt
	mov		fibNo, eax

; user's input is validated to ensure they entered a number
; between 1 and 46
	cmp		fibNo, UPPER_LIMIT ; compare user's input to 46
	ja		error				; display error message if they have entered a value greater than 46
	cmp		fibNo, LOWER_LIMIT	; compare user's input to 1
	jl		error				; display error message if they have entered a value less than 1
	jmp		continue

error:
	mov		edx, OFFSET wrongNo ; tell user they entered a value that was out of range
	call	WriteString
	jmp		top	; re-prompt user for a number
	
; DISPLAY FIBONACCI NUMBERS
; Insert white space in code for readability
continue:	
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf
	mov		edx, OFFSET display
	call	WriteString
	call	CrLf
	
	mov		ecx, fibNo ; initialize loop counter with number of terms to be printed
	mov		eax, 0 ; initialize accumulator to 0
	mov		ebx, 1

; checkCondition checks two conditions:
; 1. It checks whether the first term of the Fibonacci sequence is being printed on screen, and;
; 2. It ensures a new line is started after every 5 terms of the sequence are printed on screen
checkCond:
	cmp		eax, 0	; determine if program is calculating first term of the Fibonacci sequence
	je		firstTerm ; if it is the first term, display the first term on the screen (i.e. 1)
	cmp		count, 5	; check how many terms have been printed on the screen
	je		fifthTerm	; if 5 terms have been printed start a new line
	jmp		fibLoop ; else continue with the calculation of the next term

;loop to calculate the Fibonacci sequence
fibLoop:
	mov		temp, eax
	add		temp, ebx
	mov		eax, ebx
	mov		ebx, temp
	call	WriteDec ; display Fibonacci term on the screen, which is stored in eax
	mov		edx, OFFSET blank1
	call	WriteString ; insert 5 blank spaces after each term
	inc		count ; add one to the count of the numbers printed per line
	loop	checkCond ; repeat loop until displayed the specified number of terms
	jmp		theEnd

firstTerm: ; program branches to here when displaying the first term of the sequence (i.e. 1)
	inc		eax
	inc		count
	call	WriteDec
	mov		edx, OFFSET blank1
	call	WriteString
	cmp		fibNo, 1 ; if user only wanted one term displayed, display the end message	
	je		theEnd
	dec		ecx	; subtract one from the loop counter manually
	jmp		checkCond ; continue calculating the rest of the terms of the sequence

fifthTerm: ; program branches here after 5 terms have been printed on a line
	call	CrLf 
	mov		count, 0 ; reset the count
	jmp		fibLoop ; continue with the calculations

; Insert white space in code for readability
theEnd:	
	call	CrLf
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf

; FAREWELL
; Say goodbye to the user
	mov		edx, OFFSET endMsg
	call	WriteString
	mov		edx, OFFSET bye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main
