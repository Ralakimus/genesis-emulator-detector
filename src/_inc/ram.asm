
; -------------------------------------------------------------------------
;
;	Genesis Emulator Detector
;		By Ralakimus 2019
;
;	File:		_inc/ram.asm
;	Contents:	RAM definitions
;
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; RAM definitions
; -------------------------------------------------------------------------

	rsset	USER_RAM

r_Local		rs.b	SYS_RAM-__rs		; Local RAM
r_Local_End	rs.b	0

; -------------------------------------------------------------------------
