; ========================================================================
;
; Curso de Assembly para Microcontroladores PIC 002
; Link do curso: https://www.youtube.com/channel/UCazAvTtoRlOrFDWDJDB2DKQ
;
; MCU: PIC16F84A    Clock: 4MHz
;
; Autor: https://github.com/Guilherme-De-Marchi
; Data: 10-21
;
; ========================================================================


	list		p=16f84a			; PIC16F84A

  
; --- Includes ---

	#include  <p16f84a.inc>
  

; --- Fuse bits ---

	__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF
    
    
; --- Memory pagination ---

	#define	bank0	bcf  STATUS,RP0		; Select memory bank 0	
	#define  bank1	bsf  STATUS,RP0		; Select memory bank 1
	
	
; --- Inputs ---

	#define  btn1		PORTA,RA0		; RA0 pin from PORTA
	
	
; --- Outputs ---

	#define  led1		PORTB,RB0		; RB0 pin from PORTB
	

; --- Reset vector ---

	org		H'0000'
	goto  main			; Program starts here
		
	
; --- Interruption vector ---

	org		H'0004'
	retfie
	
	
; --- Main ---

main:

	bank1			; Select bank 1
	
	movlw  H'FF'		; Binary: 1111 1111
	movwf  TRISA		; All PORTA -> INPUT
	
	movlw  H'FE'		; Binary: 1111 1110
	movwf  TRISB		; PORTB RB0 -> OUTPUT
	
	bank0			; Select bank 0
	
	movlw  H'FF'		; Binary: 1111 1111
	movwf  PORTB		; PORTB RB0 -> HIGH
	
	goto   $			; Infinite loop
	
	end