
; -------------------------------------------------------------------------
;
;	Error handling and debugging modules
;		By Vladikcomper
;
;	File:		error.asm
;	Contents:	Error handler functions and calls
;
; -------------------------------------------------------------------------

	if DEBUG

; -------------------------------------------------------------------------
; Error handler control flags
; -------------------------------------------------------------------------

; Screen appearence flags
_eh_address_error	equ	$01	; use for address and bus errors only (tells error handler to display additional "Address" field)
_eh_show_sr_usp		equ	$02	; displays SR and USP registers content on error screen

; Advanced execution flags
; WARNING! For experts only, DO NOT USES them unless you know what you're doing
_eh_return		equ	$20
_eh_enter_console	equ	$40
_eh_align_offset	equ	$80

; -------------------------------------------------------------------------
; Errors vector table
; -------------------------------------------------------------------------

; Default screen configuration
_eh_default		equ	0	;_eh_show_sr_usp

; -------------------------------------------------------------------------

Exception:
	__ErrorMessage "UNEXPECTED ERROR", _eh_default

AddrError:
	__ErrorMessage "ADDRESS ERROR", _eh_default|_eh_address_error

BadInstr:
	__ErrorMessage "ILLEGAL INSTRUCTION", _eh_default

DivideBy0:
	__ErrorMessage "ZERO DIVIDE", _eh_default

; -------------------------------------------------------------------------
; Import error handler global functions
; -------------------------------------------------------------------------

ErrorHandler.__global__error_initconsole		equ	ErrorHandler+$146
ErrorHandler.__global__errorhandler_setupvdp		equ	ErrorHandler+$234
ErrorHandler.__global__console_loadpalette		equ	ErrorHandler+$A1C
ErrorHandler.__global__console_setposasxy_stack		equ	ErrorHandler+$A58
ErrorHandler.__global__console_setposasxy		equ	ErrorHandler+$A5E
ErrorHandler.__global__console_getposasxy		equ	ErrorHandler+$A8A
ErrorHandler.__global__console_startnewline		equ	ErrorHandler+$AAC
ErrorHandler.__global__console_setbasepattern		equ	ErrorHandler+$AD4
ErrorHandler.__global__console_setwidth			equ	ErrorHandler+$AE8
ErrorHandler.__global__console_writeline_withpattern	equ	ErrorHandler+$AFE
ErrorHandler.__global__console_writeline		equ	ErrorHandler+$B00
ErrorHandler.__global__console_write			equ	ErrorHandler+$B04
ErrorHandler.__global__console_writeline_formatted	equ	ErrorHandler+$BB0
ErrorHandler.__global__console_write_formatted		equ	ErrorHandler+$BB4

; -------------------------------------------------------------------------
; Error handler external functions (compiled only when used)
; -------------------------------------------------------------------------

	if ref(ErrorHandler.__extern_scrollconsole)
ErrorHandler.__extern__scrollconsole:

	endif

	if ref(ErrorHandler.__extern__console_only)
ErrorHandler.__extern__console_only:
	dc.l	$46FC2700, $4FEFFFF2, $48E7FFFE, $47EF003C
	jsr		ErrorHandler.__global__errorhandler_setupvdp(pc)
	jsr		ErrorHandler.__global__error_initconsole(pc)
	dc.l	$4CDF7FFF, $487A0008, $2F2F0012, $4E7560FE
	endif

	if ref(ErrorHandler.__extern__vsync)
ErrorHandler.__extern__vsync:
	dc.l	$41F900C0, $000444D0, $6BFC44D0, $6AFC4E75
	endif

; -------------------------------------------------------------------------
; Include error handler binary module
; -------------------------------------------------------------------------

ErrorHandler:
	dc.b	$46,$FC,$27,$00,$4F,$EF,$FF,$F2,$48,$E7,$FF,$FE,$4E,$BA,$02,$26,$49,$EF,$00,$4A,$4E,$68,$2F,$08,$47,$EF,$00,$40,$4E,$BA,$01,$28
	dc.b	$41,$FA,$02,$AA,$4E,$BA,$0A,$DE,$22,$5C,$45,$D4,$4E,$BA,$0B,$82,$4E,$BA,$0A,$7A,$49,$D2,$1C,$19,$6A,$02,$52,$49,$47,$D1,$08,$06
	dc.b	$00,$00,$67,$0E,$43,$FA,$02,$8D,$45,$EC,$00,$02,$4E,$BA,$0B,$62,$50,$4C,$43,$FA,$02,$8E,$45,$EC,$00,$02,$4E,$BA,$0B,$54,$43,$FA
	dc.b	$02,$90,$45,$EC,$00,$02,$4E,$BA,$0B,$48,$45,$EC,$00,$06,$4E,$BA,$01,$A6,$43,$FA,$02,$8A,$2F,$01,$45,$D7,$4E,$BA,$0B,$34,$4E,$BA
	dc.b	$0A,$2C,$58,$4F,$08,$06,$00,$06,$66,$00,$00,$A6,$45,$EF,$00,$04,$4E,$BA,$09,$F8,$3F,$01,$70,$03,$4E,$BA,$09,$C4,$30,$3C,$64,$30
	dc.b	$7A,$07,$4E,$BA,$01,$04,$32,$1F,$70,$11,$4E,$BA,$09,$B2,$30,$3C,$61,$30,$7A,$06,$4E,$BA,$00,$F2,$30,$3C,$73,$70,$7A,$00,$2F,$0C
	dc.b	$45,$D7,$4E,$BA,$00,$E4,$58,$4F,$08,$06,$00,$01,$67,$14,$43,$FA,$02,$3C,$45,$D7,$4E,$BA,$0A,$DE,$43,$FA,$02,$3D,$45,$D4,$4E,$BA
	dc.b	$0A,$D0,$58,$4F,$4E,$BA,$09,$A4,$52,$41,$70,$01,$4E,$BA,$09,$70,$20,$38,$00,$78,$41,$FA,$02,$2B,$4E,$BA,$00,$DC,$20,$38,$00,$70
	dc.b	$41,$FA,$02,$27,$4E,$BA,$00,$D0,$4E,$BA,$09,$A2,$34,$4C,$43,$F8,$00,$00,$53,$49,$4E,$BA,$09,$74,$7A,$19,$9A,$41,$6B,$0A,$61,$32
	dc.b	$4E,$BA,$00,$44,$51,$CD,$FF,$FA,$08,$06,$00,$05,$66,$08,$60,$FE,$72,$00,$4E,$BA,$09,$A0,$2E,$CB,$4C,$DF,$7F,$FF,$48,$7A,$FF,$F0
	dc.b	$2F,$2F,$FF,$C4,$4E,$75,$43,$FA,$01,$40,$45,$FA,$01,$E6,$4E,$FA,$08,$88,$4F,$EF,$FF,$D0,$41,$D7,$7E,$FF,$20,$FC,$28,$53,$50,$29
	dc.b	$30,$FC,$3A,$20,$60,$18,$4F,$EF,$FF,$D0,$41,$D7,$7E,$FF,$30,$FC,$20,$2B,$32,$0A,$92,$4C,$4E,$BA,$05,$AA,$30,$FC,$3A,$20,$70,$05
	dc.b	$72,$EC,$B4,$C9,$6D,$02,$72,$EE,$10,$C1,$32,$1A,$4E,$BA,$05,$BC,$10,$FC,$00,$20,$51,$C8,$FF,$EA,$42,$18,$41,$D7,$72,$00,$4E,$BA
	dc.b	$09,$5E,$4F,$EF,$00,$30,$4E,$75,$4F,$EF,$FF,$F0,$7E,$FF,$41,$D7,$30,$C0,$30,$FC,$3A,$20,$10,$FC,$00,$EC,$22,$1A,$4E,$BA,$05,$84
	dc.b	$42,$18,$41,$D7,$72,$00,$4E,$BA,$09,$36,$52,$40,$51,$CD,$FF,$E0,$4F,$EF,$00,$10,$4E,$75,$22,$00,$48,$41,$46,$01,$66,$20,$51,$4F
	dc.b	$2E,$88,$24,$40,$43,$FA,$00,$21,$0C,$5A,$4E,$F9,$66,$08,$43,$FA,$00,$10,$2F,$52,$00,$04,$45,$D7,$4E,$BA,$09,$BA,$50,$4F,$4E,$75
	dc.b	$D0,$E8,$BF,$EC,$C8,$E0,$00,$D0,$E8,$3C,$75,$6E,$64,$65,$66,$69,$6E,$65,$64,$3E,$E0,$00,$43,$F8,$00,$00,$59,$49,$B2,$CA,$65,$0C
	dc.b	$0C,$52,$00,$40,$65,$0A,$54,$4A,$B2,$CA,$64,$F4,$72,$00,$4E,$75,$22,$12,$4E,$75,$4B,$F9,$00,$C0,$00,$04,$4D,$ED,$FF,$FC,$4A,$55
	dc.b	$44,$D5,$69,$FC,$41,$FA,$00,$26,$30,$18,$6A,$04,$3A,$80,$60,$F8,$70,$00,$2A,$BC,$40,$00,$00,$00,$2C,$80,$2A,$BC,$40,$00,$00,$10
	dc.b	$2C,$80,$2A,$BC,$C0,$00,$00,$00,$3C,$80,$4E,$75,$80,$04,$81,$34,$82,$20,$84,$04,$85,$00,$87,$00,$8B,$00,$8C,$81,$8D,$00,$8F,$02
	dc.b	$90,$11,$91,$00,$92,$00,$00,$00,$44,$00,$00,$00,$00,$00,$00,$01,$00,$10,$00,$11,$01,$00,$01,$01,$01,$10,$01,$11,$10,$00,$10,$01
	dc.b	$10,$10,$10,$11,$11,$00,$11,$01,$11,$10,$11,$11,$FF,$FF,$40,$00,$00,$02,$00,$28,$00,$28,$00,$00,$00,$80,$00,$FF,$0E,$EE,$FF,$F2
	dc.b	$00,$CE,$FF,$F2,$0E,$EA,$FF,$F2,$0E,$86,$FF,$F2,$EA,$E0,$FA,$01,$F0,$26,$00,$EA,$41,$64,$64,$72,$65,$73,$73,$3A,$20,$E8,$BB,$EC
	dc.b	$C0,$00,$EA,$4C,$6F,$63,$61,$74,$69,$6F,$6E,$3A,$20,$EC,$83,$00,$EA,$4D,$6F,$64,$75,$6C,$65,$3A,$20,$E8,$BF,$EC,$C8,$00,$EA,$43
	dc.b	$61,$6C,$6C,$65,$72,$3A,$20,$E8,$BB,$EC,$C0,$00,$FA,$10,$E8,$75,$73,$70,$3A,$20,$EC,$83,$00,$FA,$03,$E8,$73,$72,$3A,$20,$EC,$81
	dc.b	$00,$EA,$56,$49,$6E,$74,$3A,$20,$00,$EA,$48,$49,$6E,$74,$3A,$20,$00,$00,$02,$F9,$00,$00,$00,$00,$00,$00,$00,$00,$18,$3C,$3C,$18
	dc.b	$18,$00,$18,$00,$6C,$6C,$6C,$00,$00,$00,$00,$00,$6C,$6C,$FE,$6C,$FE,$6C,$6C,$00,$18,$7E,$C0,$7C,$06,$FC,$18,$00,$00,$C6,$0C,$18
	dc.b	$30,$60,$C6,$00,$38,$6C,$38,$76,$CC,$CC,$76,$00,$18,$18,$30,$00,$00,$00,$00,$00,$18,$30,$60,$60,$60,$30,$18,$00,$60,$30,$18,$18
	dc.b	$18,$30,$60,$00,$00,$EE,$7C,$FE,$7C,$EE,$00,$00,$00,$18,$18,$7E,$18,$18,$00,$00,$00,$00,$00,$00,$18,$18,$30,$00,$00,$00,$00,$FE
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$38,$38,$00,$06,$0C,$18,$30,$60,$C0,$80,$00,$7C,$C6,$CE,$DE,$F6,$E6,$7C,$00,$18,$78,$18,$18
	dc.b	$18,$18,$7E,$00,$7C,$C6,$0C,$18,$30,$66,$FE,$00,$7C,$C6,$06,$3C,$06,$C6,$7C,$00,$0C,$1C,$3C,$6C,$FE,$0C,$0C,$00,$FE,$C0,$FC,$06
	dc.b	$06,$C6,$7C,$00,$7C,$C6,$C0,$FC,$C6,$C6,$7C,$00,$FE,$C6,$06,$0C,$18,$18,$18,$00,$7C,$C6,$C6,$7C,$C6,$C6,$7C,$00,$7C,$C6,$C6,$7E
	dc.b	$06,$C6,$7C,$00,$00,$1C,$1C,$00,$00,$1C,$1C,$00,$00,$18,$18,$00,$00,$18,$18,$30,$0C,$18,$30,$60,$30,$18,$0C,$00,$00,$00,$FE,$00
	dc.b	$00,$FE,$00,$00,$60,$30,$18,$0C,$18,$30,$60,$00,$7C,$C6,$06,$0C,$18,$00,$18,$00,$7C,$C6,$C6,$DE,$DC,$C0,$7E,$00,$38,$6C,$C6,$C6
	dc.b	$FE,$C6,$C6,$00,$FC,$66,$66,$7C,$66,$66,$FC,$00,$3C,$66,$C0,$C0,$C0,$66,$3C,$00,$F8,$6C,$66,$66,$66,$6C,$F8,$00,$FE,$C2,$C0,$F8
	dc.b	$C0,$C2,$FE,$00,$FE,$62,$60,$7C,$60,$60,$F0,$00,$7C,$C6,$C0,$C0,$DE,$C6,$7C,$00,$C6,$C6,$C6,$FE,$C6,$C6,$C6,$00,$3C,$18,$18,$18
	dc.b	$18,$18,$3C,$00,$3C,$18,$18,$18,$D8,$D8,$70,$00,$C6,$CC,$D8,$F0,$D8,$CC,$C6,$00,$F0,$60,$60,$60,$60,$62,$FE,$00,$C6,$EE,$FE,$D6
	dc.b	$D6,$C6,$C6,$00,$C6,$E6,$E6,$F6,$DE,$CE,$C6,$00,$7C,$C6,$C6,$C6,$C6,$C6,$7C,$00,$FC,$66,$66,$7C,$60,$60,$F0,$00,$7C,$C6,$C6,$C6
	dc.b	$C6,$D6,$7C,$06,$FC,$C6,$C6,$FC,$D8,$CC,$C6,$00,$7C,$C6,$C0,$7C,$06,$C6,$7C,$00,$7E,$5A,$18,$18,$18,$18,$3C,$00,$C6,$C6,$C6,$C6
	dc.b	$C6,$C6,$7C,$00,$C6,$C6,$C6,$C6,$6C,$38,$10,$00,$C6,$C6,$D6,$D6,$FE,$EE,$C6,$00,$C6,$6C,$38,$38,$38,$6C,$C6,$00,$66,$66,$66,$3C
	dc.b	$18,$18,$3C,$00,$FE,$86,$0C,$18,$30,$62,$FE,$00,$7C,$60,$60,$60,$60,$60,$7C,$00,$C0,$60,$30,$18,$0C,$06,$02,$00,$7C,$0C,$0C,$0C
	dc.b	$0C,$0C,$7C,$00,$10,$38,$6C,$C6,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$30,$30,$18,$00,$00,$00,$00,$00,$00,$00,$78,$0C
	dc.b	$7C,$CC,$7E,$00,$E0,$60,$7C,$66,$66,$66,$FC,$00,$00,$00,$7C,$C6,$C0,$C6,$7C,$00,$1C,$0C,$7C,$CC,$CC,$CC,$7E,$00,$00,$00,$7C,$C6
	dc.b	$FE,$C0,$7C,$00,$1C,$36,$30,$FC,$30,$30,$78,$00,$00,$00,$76,$CE,$C6,$7E,$06,$7C,$E0,$60,$7C,$66,$66,$66,$E6,$00,$18,$00,$38,$18
	dc.b	$18,$18,$3C,$00,$0C,$00,$1C,$0C,$0C,$0C,$CC,$78,$E0,$60,$66,$6C,$78,$6C,$E6,$00,$18,$18,$18,$18,$18,$18,$1C,$00,$00,$00,$6C,$FE
	dc.b	$D6,$D6,$C6,$00,$00,$00,$DC,$66,$66,$66,$66,$00,$00,$00,$7C,$C6,$C6,$C6,$7C,$00,$00,$00,$DC,$66,$66,$7C,$60,$F0,$00,$00,$76,$CC
	dc.b	$CC,$7C,$0C,$1E,$00,$00,$DC,$66,$60,$60,$F0,$00,$00,$00,$7C,$C0,$7C,$06,$7C,$00,$30,$30,$FC,$30,$30,$36,$1C,$00,$00,$00,$CC,$CC
	dc.b	$CC,$CC,$76,$00,$00,$00,$C6,$C6,$6C,$38,$10,$00,$00,$00,$C6,$C6,$D6,$FE,$6C,$00,$00,$00,$C6,$6C,$38,$6C,$C6,$00,$00,$00,$C6,$C6
	dc.b	$CE,$76,$06,$7C,$00,$00,$FC,$98,$30,$64,$FC,$00,$0E,$18,$18,$70,$18,$18,$0E,$00,$18,$18,$18,$00,$18,$18,$18,$00,$70,$18,$18,$0E
	dc.b	$18,$18,$70,$00,$76,$DC,$00,$00,$00,$00,$00,$00,$43,$FA,$05,$D2,$0C,$59,$DE,$B2,$66,$70,$70,$FE,$D0,$59,$74,$FC,$76,$00,$48,$41
	dc.b	$48,$81,$D2,$41,$D2,$41,$B2,$40,$62,$5C,$67,$5E,$20,$31,$10,$00,$67,$58,$47,$F1,$08,$00,$48,$41,$70,$00,$30,$1B,$B2,$53,$65,$4C
	dc.b	$43,$F3,$08,$FE,$45,$E9,$FF,$FC,$E2,$48,$C0,$42,$B2,$73,$00,$00,$65,$14,$62,$04,$D6,$C0,$60,$1A,$47,$F3,$00,$04,$20,$0A,$90,$8B
	dc.b	$6A,$E6,$59,$4B,$60,$0C,$45,$F3,$00,$FC,$20,$0A,$90,$8B,$6A,$D8,$47,$D2,$92,$5B,$74,$00,$34,$1B,$D3,$C2,$48,$41,$42,$41,$48,$41
	dc.b	$D2,$83,$70,$00,$4E,$75,$70,$FF,$4E,$75,$48,$41,$70,$00,$30,$01,$D6,$80,$52,$83,$32,$3C,$FF,$FF,$48,$41,$59,$41,$6A,$8E,$70,$FF
	dc.b	$4E,$75,$47,$FA,$05,$3C,$0C,$5B,$DE,$B2,$66,$4A,$D6,$D3,$78,$00,$72,$00,$74,$00,$45,$D3,$51,$CC,$00,$06,$16,$19,$78,$07,$D6,$03
	dc.b	$D3,$41,$52,$42,$B2,$52,$62,$0A,$65,$EC,$B4,$2A,$00,$02,$67,$12,$65,$E4,$58,$4A,$B2,$52,$62,$FA,$65,$DC,$B4,$2A,$00,$02,$65,$D6
	dc.b	$66,$F0,$10,$EA,$00,$03,$67,$0A,$51,$CF,$FF,$C6,$4E,$94,$64,$C0,$4E,$75,$53,$48,$4E,$75,$70,$00,$4E,$75,$4E,$FA,$00,$2E,$4E,$FA
	dc.b	$00,$22,$76,$0F,$34,$01,$E8,$4A,$C4,$43,$10,$FB,$20,$6A,$51,$CF,$00,$06,$4E,$94,$65,$5E,$C2,$43,$10,$FB,$10,$5C,$51,$CF,$00,$56
	dc.b	$4E,$D4,$48,$41,$61,$04,$65,$4C,$48,$41,$74,$04,$76,$0F,$E5,$79,$18,$01,$C8,$43,$10,$FB,$40,$40,$51,$CF,$00,$04,$4E,$94,$65,$34
	dc.b	$E5,$79,$18,$01,$C8,$43,$10,$FB,$40,$2E,$51,$CF,$00,$04,$4E,$94,$65,$22,$E5,$79,$18,$01,$C8,$43,$10,$FB,$40,$1C,$51,$CF,$00,$04
	dc.b	$4E,$94,$65,$10,$E5,$79,$18,$01,$C8,$43,$10,$FB,$40,$0A,$51,$CF,$00,$04,$4E,$D4,$4E,$75,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39
	dc.b	$41,$42,$43,$44,$45,$46,$4E,$FA,$00,$26,$4E,$FA,$00,$1A,$74,$07,$70,$18,$D2,$01,$D1,$00,$10,$C0,$51,$CF,$00,$06,$4E,$94,$65,$04
	dc.b	$51,$CA,$FF,$EE,$4E,$75,$48,$41,$61,$04,$65,$18,$48,$41,$74,$0F,$70,$18,$D2,$41,$D1,$00,$10,$C0,$51,$CF,$00,$06,$4E,$94,$65,$04
	dc.b	$51,$CA,$FF,$EE,$4E,$75,$4E,$FA,$00,$10,$4E,$FA,$00,$48,$47,$FA,$00,$9A,$02,$41,$00,$FF,$60,$04,$47,$FA,$00,$8C,$42,$00,$76,$09
	dc.b	$38,$1B,$34,$03,$92,$44,$55,$CA,$FF,$FC,$D2,$44,$94,$43,$44,$42,$80,$02,$67,$0E,$06,$02,$00,$30,$10,$C2,$51,$CF,$00,$06,$4E,$94
	dc.b	$65,$10,$38,$1B,$6A,$DC,$06,$01,$00,$30,$10,$C1,$51,$CF,$00,$04,$4E,$D4,$4E,$75,$47,$FA,$00,$2E,$42,$00,$76,$09,$28,$1B,$34,$03
	dc.b	$92,$84,$55,$CA,$FF,$FC,$D2,$84,$94,$43,$44,$42,$80,$02,$67,$0E,$06,$02,$00,$30,$10,$C2,$51,$CF,$00,$06,$4E,$94,$65,$D4,$28,$1B
	dc.b	$6A,$DC,$60,$9E,$3B,$9A,$CA,$00,$05,$F5,$E1,$00,$00,$98,$96,$80,$00,$0F,$42,$40,$00,$01,$86,$A0,$00,$00,$27,$10,$FF,$FF,$03,$E8
	dc.b	$00,$64,$00,$0A,$FF,$FF,$27,$10,$03,$E8,$00,$64,$00,$0A,$FF,$FF,$48,$C1,$60,$08,$4E,$FA,$00,$06,$48,$81,$48,$C1,$08,$03,$00,$03
	dc.b	$66,$04,$48,$7A,$00,$CE,$48,$E7,$50,$60,$4E,$BA,$FD,$80,$66,$0C,$2E,$81,$4E,$BA,$FE,$0E,$4C,$DF,$06,$0A,$4E,$75,$4C,$DF,$06,$0A
	dc.b	$08,$03,$00,$02,$67,$08,$47,$FA,$00,$0A,$4E,$FA,$00,$B8,$70,$FF,$4E,$75,$3C,$75,$6E,$6B,$6E,$6F,$77,$6E,$3E,$00,$10,$FC,$00,$2B
	dc.b	$51,$CF,$00,$06,$4E,$94,$65,$D2,$48,$41,$4A,$41,$67,$00,$FE,$5A,$4E,$BA,$FE,$58,$4E,$FA,$FE,$52,$08,$03,$00,$03,$66,$BC,$4E,$FA
	dc.b	$FE,$42,$48,$E7,$F8,$10,$10,$D9,$5F,$CF,$FF,$FC,$6E,$14,$67,$18,$16,$20,$74,$70,$C4,$03,$4E,$BB,$20,$1A,$64,$EA,$4C,$DF,$08,$1F
	dc.b	$4E,$75,$4E,$94,$64,$E0,$60,$F4,$53,$48,$4E,$94,$4C,$DF,$08,$1F,$4E,$75,$47,$FA,$FD,$E6,$B7,$02,$D4,$02,$4E,$FB,$20,$5A,$4E,$71
	dc.b	$4E,$71,$47,$FA,$FE,$A2,$B7,$02,$D4,$02,$4E,$FB,$20,$4A,$4E,$71,$4E,$71,$47,$FA,$FE,$52,$B7,$02,$D4,$02,$4E,$FB,$20,$3A,$53,$48
	dc.b	$4E,$75,$47,$FA,$FF,$2C,$14,$03,$02,$42,$00,$03,$D4,$42,$4E,$FB,$20,$26,$4A,$40,$6B,$08,$4A,$81,$67,$16,$4E,$FA,$FF,$60,$4E,$FA
	dc.b	$FF,$78,$26,$5A,$10,$DB,$67,$D6,$51,$CF,$FF,$FA,$4E,$94,$64,$F4,$4E,$75,$52,$48,$60,$3C,$50,$4B,$32,$1A,$4E,$D3,$58,$4B,$22,$1A
	dc.b	$4E,$D3,$52,$48,$60,$22,$50,$4B,$32,$1A,$60,$04,$58,$4B,$22,$1A,$6A,$0C,$44,$81,$10,$FC,$00,$2D,$53,$47,$65,$D4,$4E,$D3,$10,$FC
	dc.b	$00,$2B,$53,$47,$65,$CA,$4E,$D3,$51,$CF,$00,$06,$4E,$94,$65,$C0,$10,$D9,$51,$CF,$FF,$BC,$4E,$D4,$4B,$F9,$00,$C0,$00,$04,$4D,$ED
	dc.b	$FF,$FC,$4A,$51,$6B,$10,$2A,$99,$41,$D2,$38,$18,$4E,$BA,$01,$F6,$43,$E9,$00,$20,$60,$EC,$54,$49,$4E,$63,$2A,$19,$26,$C5,$26,$D9
	dc.b	$26,$D9,$36,$FC,$5D,$00,$47,$FA,$00,$3A,$2A,$85,$70,$00,$32,$19,$4E,$93,$2A,$BC,$40,$00,$00,$00,$72,$00,$4E,$93,$2A,$BC,$C0,$00
	dc.b	$00,$00,$70,$00,$76,$03,$3C,$80,$34,$19,$3C,$82,$34,$19,$6A,$FA,$72,$00,$4E,$B3,$20,$10,$51,$CB,$FF,$EE,$3A,$BC,$81,$74,$2A,$85
	dc.b	$4E,$75,$2C,$80,$2C,$80,$2C,$80,$2C,$80,$2C,$80,$2C,$80,$2C,$80,$2C,$80,$51,$C9,$FF,$EE,$4E,$75,$4C,$AF,$00,$03,$00,$04,$48,$E7
	dc.b	$60,$10,$4E,$6B,$0C,$2B,$00,$5D,$00,$0C,$66,$18,$34,$13,$02,$42,$E0,$00,$C2,$EB,$00,$0A,$D4,$41,$D4,$40,$D4,$40,$36,$82,$23,$D3
	dc.b	$00,$C0,$00,$04,$4C,$DF,$08,$06,$4E,$75,$2F,$0B,$4E,$6B,$0C,$2B,$00,$5D,$00,$0C,$66,$12,$72,$00,$32,$13,$02,$41,$1F,$FF,$82,$EB
	dc.b	$00,$0A,$20,$01,$48,$40,$E2,$48,$26,$5F,$4E,$75,$2F,$0B,$4E,$6B,$0C,$2B,$00,$5D,$00,$0C,$66,$18,$3F,$00,$30,$13,$D0,$6B,$00,$0A
	dc.b	$02,$40,$5F,$FF,$36,$80,$23,$DB,$00,$C0,$00,$04,$36,$DB,$30,$1F,$26,$5F,$4E,$75,$2F,$0B,$4E,$6B,$0C,$2B,$00,$5D,$00,$0C,$66,$04
	dc.b	$37,$41,$00,$08,$26,$5F,$4E,$75,$2F,$0B,$4E,$6B,$0C,$2B,$00,$5D,$00,$0C,$66,$06,$58,$4B,$36,$C1,$36,$C1,$26,$5F,$4E,$75,$61,$D4
	dc.b	$48,$7A,$FF,$AA,$48,$E7,$7E,$12,$4E,$6B,$0C,$2B,$00,$5D,$00,$0C,$66,$1C,$2A,$1B,$4C,$93,$00,$5C,$48,$46,$4D,$F9,$00,$C0,$00,$00
	dc.b	$72,$00,$12,$18,$6E,$0E,$6B,$28,$48,$93,$00,$1C,$27,$05,$4C,$DF,$48,$7E,$4E,$75,$51,$CB,$00,$0E,$D6,$42,$DA,$86,$08,$85,$00,$1D
	dc.b	$2D,$45,$00,$04,$D2,$44,$3C,$81,$72,$00,$12,$18,$6E,$E6,$67,$D8,$02,$41,$00,$1E,$4E,$FB,$10,$02,$DA,$86,$72,$1D,$03,$85,$60,$20
	dc.b	$60,$26,$60,$2A,$60,$32,$60,$3A,$14,$18,$60,$14,$18,$18,$60,$D8,$60,$36,$12,$18,$D2,$41,$76,$80,$48,$43,$CA,$83,$48,$41,$8A,$81
	dc.b	$36,$02,$2D,$45,$00,$04,$60,$C0,$02,$44,$07,$FF,$60,$BA,$02,$44,$07,$FF,$00,$44,$20,$00,$60,$B0,$02,$44,$07,$FF,$00,$44,$40,$00
	dc.b	$60,$A6,$00,$44,$60,$00,$60,$A0,$3F,$04,$1E,$98,$38,$1F,$60,$98,$48,$7A,$FE,$FA,$2F,$0C,$49,$FA,$00,$16,$4F,$EF,$FF,$F0,$41,$D7
	dc.b	$7E,$0E,$4E,$BA,$FD,$3E,$4F,$EF,$00,$10,$28,$5F,$4E,$75,$42,$18,$44,$47,$06,$47,$00,$0F,$90,$C7,$2F,$08,$4E,$BA,$FF,$28,$20,$5F
	dc.b	$7E,$0E,$4E,$75,$74,$1E,$10,$18,$12,$00,$E6,$09,$C2,$42,$3C,$B1,$10,$00,$D0,$00,$C0,$42,$3C,$B1,$00,$00,$51,$CC,$FF,$EA,$4E,$75

; -------------------------------------------------------------------------
; WARNING!
;	DO NOT put any data from now on! DO NOT use ROM padding!
;	Symbol data should be appended here after ROM is compiled
;	by ConvSym utility, otherwise debugger modules won't be able
;	to resolve symbol names.
; -------------------------------------------------------------------------

	else
Exception	EQU	ICD_BLK
AddrError	EQU	ICD_BLK
BadInstr	EQU	ICD_BLK
DivideBy0	EQU	ICD_BLK
	endif

; -------------------------------------------------------------------------
