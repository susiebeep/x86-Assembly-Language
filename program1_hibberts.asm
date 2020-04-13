TITLE Program 1 - Elementary Arithmetic     (program1_hibberts.asm)

; Author: Susan Hibbert
; Last Modified: 9th January 2019
; OSU email address: hibberts@oregonstate.edu
; Course number/section: CS_271_C400_W2020
; Project Number: 1                Due Date: 19th January 2020
; Description: This program is an elementary arithmetic program which has the following steps:
; 1. Displays name and program title on the output screen.
; 2. Displays instructions for the user.
; 3. Prompts the user to enter three numbers (A, B, C) in descending order.
; 4. Calculates and displays the sum and differences: (A+B, A-B, A+C, A-C, B+C, B-C, A+B+C).
; 5. Displays a terminating message.

INCLUDE Irvine32.inc

.data

intro1		BYTE		"Elementary Arithmetic by Susan Hibbert", 13, 10, 0
prompt1		BYTE		"Enter 3 numbers A > B > C, and I'll show you the sums and differences!", 13, 10, 0
promptA		BYTE		"First Number A: ", 0
promptB		BYTE		"Second Number B: ", 0
promptC		BYTE		"Third Number C: ", 0
blank		BYTE		" ", 0
numA		DWORD		?	; first number A entered by user
numB		DWORD		?	; second number B entered by user
numC		DWORD		?	; third number C entered by user
sumAB		DWORD		0	; stores result of A + B
subAB		DWORD		0	; stores result of A - B
sumAC		DWORD		0	; stores result of A + C
subAC		DWORD		0	; stores result of A - C
sumBC		DWORD		0	; stores result of B + C
subBC		DWORD		0	; stores result of B - C
sumABC		DWORD		0	; stores result of A + B + C
goodBye		BYTE		"Impressed? Bye!", 13, 10, 0

.code
main PROC

; Introduction
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf

; Provide the User with Instructions
	mov		edx, OFFSET prompt1
	call	WriteString
	call	CrLf

; Get the Data:
; Get the first number A from the user
	mov		edx, OFFSET promptA
	call	WriteString
	call	ReadInt
	mov		numA, eax

; Get the second number B from the user
	mov		edx, OFFSET promptB
	call	WriteString
	call	ReadInt
	mov		numB, eax

; Get the third number C from the user
	mov		edx, OFFSET promptC
	call	WriteString
	call	ReadInt
	mov		numC, eax

; Insert white space in code for readability
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf

; Calculate the Required Values:
; Calculate A + B
	mov		eax, numA
	add		eax, numB
	mov		sumAB, eax

; Calculate A - B
	mov		eax, numA
	sub		eax, numB
	mov		subAB, eax

; Calculate A + C
	mov		eax, numA
	add		eax, numC
	mov		sumAC, eax

; Calculate A - C
	mov		eax, numA
	sub		eax, numC
	mov		subAC, eax

; Calculate B + C
	mov		eax, numB
	add		eax, numC
	mov		sumBC, eax

; Calculate B - C
	mov		eax, numB
	sub		eax, numC
	mov		subBC, eax

; Calculate A + B + C
	mov		eax, sumAB
	add		eax, numC
	mov		sumABC, eax

; Display the Results:
; Display A + B
	mov		eax, numA
	call	WriteDec
	mov		al, '+'
	call	WriteChar
	mov		eax, numB
	call	WriteDec
	mov		al, '='
	call	WriteChar
	mov		eax, sumAB
	call	WriteDec
	call	CrLF

; Display A - B
	mov		eax, numA
	call	WriteDec
	mov		al, '-'
	call	WriteChar
	mov		eax, numB
	call	WriteDec
	mov		al, '='
	call	WriteChar
	mov		eax, subAB
	call	WriteDec
	call	CrLF

; Display A + C
	mov		eax, numA
	call	WriteDec
	mov		al, '+'
	call	WriteChar
	mov		eax, numC
	call	WriteDec
	mov		al, '='
	call	WriteChar
	mov		eax, sumAC
	call	WriteDec
	call	CrLF

; Display A - C
	mov		eax, numA
	call	WriteDec
	mov		al, '-'
	call	WriteChar
	mov		eax, numC
	call	WriteDec
	mov		al, '='
	call	WriteChar
	mov		eax, subAC
	call	WriteDec
	call	CrLF

; Display B + C
	mov		eax, numB
	call	WriteDec
	mov		al, '+'
	call	WriteChar
	mov		eax, numC
	call	WriteDec
	mov		al, '='
	call	WriteChar
	mov		eax, sumBC
	call	WriteDec
	call	CrLF

; Display B - C
	mov		eax, numB
	call	WriteDec
	mov		al, '-'
	call	WriteChar
	mov		eax, numC
	call	WriteDec
	mov		al, '='
	call	WriteChar
	mov		eax, subBC
	call	WriteDec
	call	CrLF

; Display A + B + C
	mov		eax, numA
	call	WriteDec
	mov		al, '+'
	call	WriteChar
	mov		eax, numB
	call	WriteDec
	mov		al, '+'
	call	WriteChar
	mov		eax, numC
	call	WriteDec
	mov		al, '='
	call	WriteChar
	mov		eax, sumABC
	call	WriteDec
	call	CrLF

; Insert white space in code for readability
	mov		edx, OFFSET blank
	call	WriteString
	call	CrLf

; Say Goodbye
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf	

	exit	; exit to operating system
main ENDP

END main
