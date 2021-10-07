; ====================================================
;
; MCU: PIC16F84A
; CLOCK: 4MHz
;
; Author: https://github.com/Guilherme-De-Marchi
; Date: 10-21
;
; ====================================================
;
;
; ---------------- Circuit commands ------------------ 
;
; This PIC will be part of a circuit that will receive
; commands via usb, and will have the function of
; interpreting a sequence of 6 bits and sending to an
; 8 bits multiplexer the direction equivalent to the
; received command.
;
; - - - - - - - - - Commands list - - - - - - - - - - 
;
; Command:Send	B'1111111' 
; Output:		B'000'
; Description:	Releases the coordinate register bus
;
; Command:Reset	B'0000000'
; Output:		B'001'
; Description:	Clear all Monitor memory and
;				registers
;
; Command:?		B'1000000'
; Output:		B'010'
; Description:	Not implemented yet
;
; Command:?		B'0111111'
; Output:		B'011'
; Description:	Not implemented yet
;
; - - - - - - - I/O Configuration - - - - - - - - - -
;
; PORTA [RA0~RA2] -> Command Multiplexer Output
;
; PORTB [RBO~RB6] -> Command input
; +-----[RBO~RB5] -> Index of coordinate
; +---------[RB6] -> Direction of coordinate
;
; ---------------------------------------------------


	list		p=16f84a									; PIC16F84A


; --- Includes ---

#include	<p16f84a.inc>


; --- FUSE bits ---

	__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF


; --- Memory pagination ---

#define	bank0	bcf	STATUS,RP0					; Instruction -> Switch for Mem. Bank 0
#define	bank1	bsf	STATUS,RP0					; Instruction -> Switch for Mem. Bank 1


; --- General purpose registers ---

	cblock	H'0C'

	; - - Commands GPR - -
	; See "Commands list" on this code header for more information
	
	SND_CMD											; Send command
	SND_OUT											; Send output
	
	RST_CMD											; Reset command
	RST_OUT											; Reset output
	
	; - - Normal GPR - -

; * NOT USED *
;	COORDR											; Row coordinate
;	COORDC											; Column coordinate
; * NOT USED *

	endc


; --- RESET vector ---

	org		H'0000'
	goto	main


; --- INTERRUPTION vector ---

	org 		H'0004'
	retfie
	

; --- Execute send command . label ---
	
run_snd:

	movf	SND_OUT,W							; W = SND_OUT
	movwf	PORTA								; PORTA = SND_OUT
	return
		
		
; --- Execute reset command . label ---

run_rst:

	movf	RST_OUT,W							; W = RST_OUT
	movwf	PORTA								; PORTA = RST_OUT
	return


; * NOT USED *
; ### Coordinate register . label group ###
;
;  #  Register row coordinate  #
;
;reg_r_coord:
;
;												; PORTB[RB0~RB5] represents a row coordinate
;	movf	PORTB,W								; W = PORTB
;	movwf	COORDR								; COORDR = PORTB
;	return
;
;
;  #  Register column coordinate  #
;
;reg_c_coord:
;
;												; PORTB[RB0~RB5] represents a column coordinate
;	movf	PORTB,W								; W = PORTB
;	movwf	COORDC								; COORDC = PORTB
;	return
;	
;	
;  #  Coordinate direction verification  #
;
;reg_coord:
;
;	btfss	PORTB,RB6							; PORTB[RB6] = 0?
;	goto	reg_r_coord							; YES
;	goto	reg_c_coord							; NO
; * NOT USED *
	
; --- Command verification . label ---

cmd_vrf:
	
	; If PORTB equals to <command_image>, STATUS[Z] = 1
	
	movfw	SND_CMD								; W = SND_CMD
	xorwf	PORTB,W								; W = PORTB XOR W
	btfsc	STATUS,Z								; STATUS[Z] = 1?
	goto 	run_snd								; YES
	
	movfw	RST_CMD								; W = RST_CMD
	xorwf	PORTB,W								; W = PORTB XOR W
	btfsc	STATUS,Z								; STATUS[Z] = 1?
	goto 	run_rst								; YES		

; * NOT USED *	
;	; If PORTB is not a valid command:
;				
;	goto 	reg_coord
; * NOT USED *


; --- Main . label ---

main:

	; - - Initializing general purpose registers - -
	
	;  -  Initializing commands GPR  -  
												; See "Commands list" on this code header for more information
	movlw	H'7F'								; B'01111111' = Send command image
	movwf	SND_CMD								; Initialize Send command image
	movlw	H'00'								; B'00000000' = Send command output
	movwf	SND_OUT								; Initialize Send command output
	
	movlw	H'00'								; B'00000000' = Reset command image
	movwf	RST_CMD								; Initialize Reset command image
	movlw	H'01'								; B'00000001' = Reset command output
	movwf	RST_OUT								; Initialize Reset command output
	
	; - - Setting I/O pins - -
	; See "I/O configuration" for more information
	
	bank1										; Access memory bank 1
	
	movlw	H'F8'								; B'11111000'
	movwf	TRISA								; TRISA[RA0~RA2] -> Output
												; TRISB[RB0~RB6] -> Input by default
	
	bank0										; Back to memory bank 0
	
	
; --- Infinite Loop . label ---	

loop:
	
	call cmd_vrf									; Call command_verification label as a sub-routine 
	
	goto loop									; Make this label dont stop executing
	
	end											; End of main label