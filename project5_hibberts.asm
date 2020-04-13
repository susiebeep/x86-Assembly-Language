TITLE Program 5 - Sorting & Counting Random Integers    (project5_hibberts.asm)

; Author: Susan Hibbert
; Last Modified: 27th February 2020
; OSU email address: hibberts@oregonstate.edu
; Course number/section: CS_271_C400_W2020
; Project Number:  5             Due Date: 1st March 2020
; Description: This program generates 200 random numbers in the range of 10 to 29 (inclusive), displays
; the unsorted list, sorts the list in ascending order, displays the median value, displays the sorted 
; list in ascending order then displays the number of instances of each generated value.

INCLUDE Irvine32.inc
; LO, HI and ARRAYSIZE declared as global constants
LO = 10
HI = 29
ARRAYSIZE = 200			; size of random number array
COUNTSIZE = 20			; size of counts array


.data

blank		BYTE		" ", 0
spaces		BYTE		"  ", 0	; separates each random integer by 2 spaces
count		DWORD		0	; used to keep track of the number of random integers printed per line
intro1		BYTE		"*** Welcome to Program 5 - Sorting and Counting Random Integers by Susan Hibbert ***", 13, 10, 0
intro2		BYTE		"This program generates 200 random numbers in the range of 10 to 29 (inclusive), displays the unsorted list, sorts the list, ", 0
intro3		BYTE		"displays the median value, displays the list in ascending order then displays the number of instances of each generated value", 13, 10, 0
bye1		BYTE		"***Goodbye***", 0
title1		BYTE		"The unsorted, random numbers:", 13, 10, 0
title2		BYTE		"List Median: ", 0
title3		BYTE		"The sorted, random numbers in ascending order:", 13, 10, 0
title4		BYTE		"The instances of each random number between 10 and 29, starting with 10, are as follows:", 13, 10, 0
array		DWORD		ARRAYSIZE	DUP(?)	; uninitialized array which will store the 200 random integers
counts		DWORD		COUNTSIZE	DUP(?)	; uninitialized counts array which will store the number of instances of each value in [10...29] in the array of random numbers
count1		DWORD		0 ; used in countList procedure to hold count of each integer


.code
main PROC
	call	Randomize			; initializes the starting seed value of the RandomRange procedure

	push	OFFSET intro3
	push	OFFSET intro2
	push	OFFSET intro1
	call	introduction		; introduce program and programmer and provide instructions to the user

	push	LO
	push	HI
	push	ARRAYSIZE
	push	OFFSET array
	call	fillArray			; fill the array with 200 random integers in [10...29]
	
	push	ARRAYSIZE
	push	OFFSET array
	push	OFFSET title1
	push	OFFSET count
	push	OFFSET spaces
	call	displayList			; display the array (unsorted)

	push	ARRAYSIZE
	push	OFFSET array
	call	sortList			; sort the array

	push	OFFSET blank		
	call	whiteSpace			; insert white space for readability

	push	ARRAYSIZE
	push	OFFSET array
	push	OFFSET title2
	call	displayMedian		; calculate and display median value of sorted array

	push	OFFSET blank		
	call	whiteSpace			; insert white space for readability

	push	ARRAYSIZE
	push	OFFSET array
	push	OFFSET title3
	push	OFFSET count
	push	OFFSET spaces
	call	displayList			; display the sorted array
	
	push	OFFSET blank		; insert white space for readability
	call	whiteSpace

	push	HI
	push	LO
	push	ARRAYSIZE
	push	OFFSET array
	push	OFFSET counts
	push	OFFSET count1
	call	countList			; count the number of instances of each number in [10..29] in the random integer array and store in counts array


	push	COUNTSIZE
	push	OFFSET counts
	push	OFFSET title4
	push	OFFSET count
	push	OFFSET spaces
	call	displayList			; display the counts array

	push	OFFSET blank		
	call	whiteSpace			; insert white space for readability

	push	OFFSET bye1			
	call	farewell			; display goodbye message to user

	exit	; exit to operating system
main ENDP



; whiteSpace
; Description: Procedure to display white space in program for readability
; Receives: Address of blank on the system stack
; Returns: None, displays white space on screen
; Pre-conditions: None
; Post-conditions: None, displays white space on screen
; Registers changed: edx

whiteSpace PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 8]		
	call	WriteString			; Insert white space in code for readability
	call	CrLf

	pop		ebp
	ret		4
whiteSpace ENDP



; introduction
; Description: Procedure to introduce the program and the programmer and provide brief instructions to the user
; Receives: Addresses of intro1, intro2 and intro3 on the system stack
; Returns: None, displays message on screen
; Pre-conditions: None
; Post-conditions: None, displays message on screen
; Registers changed: edx

introduction PROC				
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 8]		; Display the program title and programmer's name
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 12]		; Display brief instructions to the user
	call	WriteString
	mov		edx, [ebp + 16]		; Continue to display instructions to the user
	call	WriteString
	call	CrLf

	pop		ebp
	ret		12
introduction ENDP



; fillArray
; Description: Procedure to fill an array of size 200 with random integers in [10..29]
; Receives: Address of array and values of LO, HI and ARRAYSIZE on the system stack
; Returns: array initialized with random integers in [10..29] in unsorted order
; Pre-conditions: LO, HI and ARRAYSIZE are initialized, Randomize is called to initialize starting seed value of the RandomRange procedure
; Post-conditions: array initialized with random integers in [10..29] in unsorted order
; Registers changed: eax, ebx, ecx, esi

fillArray PROC				
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 8]		; address of array
	mov		ecx, [ebp + 12]		; size of array, ARRAYSIZE

randomNo:
	mov		ebx, [esi]			; get current element in array
	mov		eax, [ebp + 16]		; store HI (29), the high end of the random integer range, in eax
	sub		eax, [ebp + 20]		; calculate the range of integers as follows: HI - LO + 1, which is 29 - 10 + 1 = 20
	inc		eax
	call	RandomRange			; value in eax is [0..19]
	add		eax, [ebp + 20]		; add LO to value in eax, which is now [10..29]
	mov		[esi], eax			; store value in [10..29] in array
	add		esi, 4				; move onto next element in the array
	loop	randomNo			; fill rest of the array with random numbers

	pop		ebp
	ret		16
fillArray ENDP



; displayList
; Description: Procedure to display the contents of an array, with 2 spaces per number and 20 numbers per line
; Receives: Addresses of array, count, title1/title3/title4 and spaces, and the value of ARRAYSIZE/COUNTSIZE on the system stack
; Returns: None, array is displayed with 2 spaces between each array element and 20 elements per line
; Pre-conditions: array is not empty, ARRAYSIZE/COUNTSIZE has been initialized, spaces contains two spaces
; Post-conditions: None, array is displayed with 2 spaces between each array element and 20 elements per line
; Registers changed: eax, edx, edx, esi

displayList PROC				
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 16]		; display title of array to be printed
	call	WriteString
	call	Crlf

	mov		esi, [ebp + 20]		; address of array
	mov		ecx, [ebp + 24]		; size of array, ARRAYSIZE or COUNTSIZE
	mov		edx, 0
	mov		[ebp + 12], edx		; set count of printed numbers per line to zero

print:
	mov		eax, [esi]			; get current element
	call	WriteDec			
	mov		edx, [ebp + 8]		; display 2 spaces after each element
	call	WriteString		
	add		esi, 4				; move onto next element
	mov		edx, 1
	add		[ebp + 12], edx		
	mov		edx, 20
	cmp		[ebp + 12], edx		; start a new line if 20 numbers are printed on current line
	jb		continue
	call	Crlf
	mov		edx, 0
	mov		[ebp + 12], edx		; reset the count
	
continue:
	loop	print

	pop		ebp
	ret		20
displayList ENDP



; sortList
; Description: Procedure to sort array, based on the Bubble Sort Algorithm
; Receives: Address of array and value of ARRAYSIZE on the system stack
; Returns: array elements are sorted and stored in ascending order
; Pre-conditions: array is not empty, ARRAYSIZE is initialized
; Post-conditions: array is sorted in ascending order
; Registers changed: eax, ebx, ecx, esi

sortList PROC				
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 8]		; address of array
	mov		ecx, [ebp + 12]		; size of array, ARRAYSIZE
	dec		ecx					; set outer loop to (size of array) - 1

outer:
	push	ecx					; save outer loop
	mov		esi, [ebp + 8]		; point to start of array

inner:
	mov		ebx, [esi]			; ebx = current element
	mov		eax, [esi + 4]		; eax = next element
	cmp		eax, ebx				 
	jae		noSwap				; if next element is the same or bigger than the current element, do not swap them (already in sorted order)
	jb		swap				; if next element is smaller than current element, swap them
	
swap: 
	mov		ebx, esi
	push	ebx					; push address of current element (address 1)
	add		esi, 4
	mov		eax, esi
	push	eax					; push address of next element	(address 2)
	sub		esi, 4				; point back to current element
	call	exchangeElements	; call procedure to swap the two elements
	
noSwap:
	add		esi, 4
	loop	inner				; check the next pair of elements	
	
	pop		ecx
	loop	outer				; after (size of array - 1) iterations the array will be sorted

	pop		ebp
	ret		8
sortList ENDP



; exchangeElements 
; Description: Procedure to swap the values of two array positions
; Receives: Addresses of two array elements on the system stack (address 1 - current element, address 2 - next element)
; Returns: Values stored at the two addresses have been swapped - value that was stored at address 1 is now stored at address 2 and vice versa
; Pre-conditions: array is not empty, value stored at address 2 is smaller than value stored at address 1
; Post-conditions: Values stored at the two addresses have been swapped - value that was stored at address 1 is now stored at address 2 and vice versa
; Registers changed: eax, ebx, edx

exchangeElements PROC
	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp + 8]		; store address of next element
	mov		eax, [ebp + 12]		; store address of current element
	mov		edx, [eax]			
	mov		[ebp - 4], edx		; save value of current element locally
	mov		edx, [ebx]
	mov		[ebp - 8], edx		; save value of next element locally
	mov		edx, [ebp - 4]
	mov		[ebx], edx			; copy current element into next element's position
	mov		edx, [ebp - 8]
	mov		[eax], edx			; copy next element into current element's position

	pop		ebp
	ret		8

exchangeElements ENDP



; displayMedian
; Description: Procedure to calculate and display median value of sorted list
; Receives: Addresses of array and title2 and value of ARRAYSIZE on the system stack
; Returns: Rounded-up median value in eax
; Pre-conditions: array is not empty, array is sorted in ascending order, ARRAYSIZE is initialized
; Post-conditions: Rounded-up median value in eax
; Registers changed: eax, ebx, ecx, edx, esi

displayMedian PROC				
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 8]		; Display title
	call	WriteString
	mov		esi, [ebp + 12]		; address of array
	mov		eax, [ebp + 16]		; size of array, ARRAYSIZE
	cdq							; extend eax into edx to prevent division overflow
	mov		ebx, 2
	div		ebx					; find which element number is the mid-point of the array (100th element if size is 200), store in eax
	dec		eax					; find index of mid-point of array (if 100th element this will be at array[99])
	mov		ebx, 4
	mul		ebx					; as array is a DWORD need to multiply index by 4
	add		esi, eax
	mov		eax, [esi]			; locate and store middle value
	add		esi, 4				; locate and store value after middle value
	mov		ebx, [esi]
	add		eax, ebx			; calculate the average of the middle two elements
	mov		ecx, 2
	div		ecx					
	add		eax, edx			; round up median value (remainder will either be 0 or 1)
	call	WriteDec

	pop		ebp
	ret		12
displayMedian ENDP



; countList
; Description: Procedure to calculate the number of instances of each random integer in [10..29]
; Receives: Addresses of count1, counts and array and the values of ARRAYSIZE, HI and LO on the system stack
; Returns: Count of each integer [10..29] is stored in consecutive positions in the counts array
; Pre-conditions: array is not empty, array is sorted in ascending order, ARRAYSIZE, HI and LO are initialized
; Post-conditions: Count of each integer [10..29] is stored in consecutive positions in the counts array
; Registers changed: eax, ebx, ecx, edx, edi, esi

countList PROC	
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 16]		; address of array
	mov		edi, [ebp + 12]		; address of counts array (to store instances of each integer)
	mov		ecx, [ebp + 20]		; size of array, ARRAYSIZE
	mov		ebx, [ebp + 24]		; initial search value (value of LO, 10)
	mov		eax, [ebp + 8]		; used to keep track of the count of each integer
	mov		eax, 0

search:
	cmp		[esi], ebx			; compare current array element to search value
	je		addCount			; add one to the count if array element is the same as search value
	jne		nextVal				; otherwise we have finished the count for that search value, move onto the next search value

addCount:
	add		eax, 1				; add one to count of integer
	add		esi, 4				; point to the next value
	loop	search				; check next array element against search value

nextVal:
	mov		[edi], eax			; store count of search value in counts array
	add		edi, 4				; point to next position in counts array in preparation for storing count of next search value
	inc		ebx					; add one to the search value
	cmp		ebx, [ebp + 28]		; check current search value is in range [10..29]	
	ja		quit			
	mov		eax, 0				; reset count to 0
	jmp		search

quit:
	pop		ebp
	ret		24
countList ENDP



; farewell
; Description: Procedure to display a goodbye message to the user
; Receives: Address of bye1 on the system stack
; Returns: None, message displayed on screen
; Pre-conditions: None
; Post-conditions: None, message displayed on screen
; Registers changed: edx

farewell PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 8]		; Display parting message to user
	call	WriteString
	call	CrLf
	
	pop		ebp
	ret		4
farewell ENDP

END main
