.386
.model flat,stdcall
option casemap:none

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
include \masm32\include\masm32rt.inc

.data?
resultBuffTextToShow db 326 dup(?)
resultBuffByte db 32 dup(?)
resultBuffWord db 64 dup(?)
resultBuffCDEF db 176 dup(?)
resultBuffA1 db 16 dup(?)
resultBuffA1Negative db 16 dup(?)
resultBuffA2 db 32 dup(?)
resultBuffA2Neg db 32 dup(?)
resultBuffB2 db 32 dup(?)
resultBuffB2Neg db 32 dup(?)
resultBuffC DB 16 DUP (?)
resultBuffCNeg DB 16 DUP (?)
resultBuffD DB 16 DUP (?)
resultBuffDNeg DB 16 DUP (?)
resultBuffE DB 32 DUP (?)
resultBuffENeg DB 32 DUP (?)
resultBuffF DB 32 DUP (?)
resultBuffFNeg DB 32 DUP (?)

.data
MsgBoxCaption db "Labaratorna 1, 13 variant, IP-05, Kononenko", 0
resultFormOfByte db "A_B= %d", 9, "-A_B= %d", 0
resultFormOfWord db "A_W= %s", 9, "-A_W= %s", 10,
	"B_W= %s", 9, "-B_W= %s", 0
resultFormOfCDEF db "C= %d", 9, "-C= %d", 10,
	"D= %s", 9, 9, "-D= %s", 10,
	"E= %s", 9, 9, "-E= %s", 10,
	"F= %s", 9, "-F= %s", 0	
resultFormOfFinalText db "%s", 10, "%s", 10, "%s", 0
ValOfA1NonNeg dd 8
ValOfA1Neg dd -8
ValOfA2NonNeg dq 8.0
ValOfA2Neg dq -8.0
ValOfB2NonNeg dq 804.0
ValOfB2Neg dq -804.0
ValOfCNonNeg dd 8042001
ValOfCNeg dd -8042001
ValOfDNonNeg dq 0.015
ValOfDNeg dq -0.015
ValOfENonNeg dq 1.57
ValOfENeg dq -1.57
ValOFFNonNeg dq 15707.033
ValOfFNeg dq -15707.033

.code
start:

invoke FloatToStr2, ValOfA2NonNeg, addr resultBuffA2
invoke FloatToStr2, ValOfA2Neg, addr resultBuffA2Neg
invoke FloatToStr2, ValOfB2NonNeg, addr resultBuffB2
invoke FloatToStr2, ValOfB2Neg, addr resultBuffB2Neg
invoke FloatToStr2, ValOfDNonNeg, addr resultBuffD
invoke FloatToStr2, ValOfDNeg, addr resultBuffDNeg
invoke FloatToStr2, ValOfENonNeg, addr resultBuffE
invoke FloatToStr2, ValOfENeg, addr resultBuffENeg
invoke FloatToStr2, ValOFFNonNeg, addr resultBuffF
invoke FloatToStr2, ValOfFNeg, addr resultBuffFNeg	

invoke wsprintf, addr resultBuffByte, addr resultFormOfByte, ValOfA1NonNeg, ValOfA1Neg
invoke wsprintf, addr resultBuffWord, addr resultFormOfWord,
	addr resultBuffA2, addr resultBuffA2Neg, addr resultBuffB2, addr resultBuffB2Neg 
invoke wsprintf, addr resultBuffCDEF, addr resultFormOfCDEF, ValOfCNonNeg, ValOfCNeg,
	addr  resultBuffD, addr resultBuffDNeg, addr resultBuffE, addr resultBuffENeg,
	addr resultBuffF, addr resultBuffFNeg
invoke wsprintf, addr resultBuffTextToShow, addr resultFormOfFinalText,
	addr resultBuffByte, addr resultBuffWord, addr resultBuffCDEF

invoke MessageBox, 0, addr resultBuffTextToShow, addr MsgBoxCaption, 0
invoke ExitProcess, 0

end start
