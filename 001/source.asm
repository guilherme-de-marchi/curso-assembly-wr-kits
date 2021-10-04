; ====================================================== 
;                                                        
; Curso de Assembly para Microcontroladores PIC 001
; Link do professor: https://www.youtube.com/channel/UCazAvTtoRlOrFDWDJDB2DKQ
;
; MCU: PIC16F84A    Clock: 4MHz
;
; Autor: https://github.com/Guilherme-De-Marchi
; Data: 10-21
;                                                   
; ======================================================

  list	p=16f84a						; Microcontrolador utilizado: PIC16F84A

; --- Arquivos incluidos no projeto ---
  #include <p16f84a.inc>				; Inclui o arquivo INC do PIC16F84A
  
; --- FUSE Bits ---
    __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF
    
; --- Paginacao de memoria ---
  #define	bank0	bcf STATUS,RP0	; Mnemonico para o banco de memoria 0
  #define 	bank1	bsf STATUS,RP0	; Mnemonico para o banco de memoria 1
  
; --- Entradas ---
  #define	btn1		PORTB,RB1		; Entrada de botao no pino RB1
  
; --- Saidas ---
  #define	led1		PORTA,RA1		; Saida de led no pino RA1
  
; --- Vetor de Reset ---
	org		H'0000'					; Execucao após RESET começa aqui
	goto	inicio					; Vai para a label inicio
      
; --- Vetor de Interrupcao ---
	org		H'0004'					; Trata as interrupcoes aqui
	retfie							; Retorna ao workflow padrao
      
; --- Programa principal ---
inicio:

	bank1							; Muda para o banco 1
	movlw	H'02'					; Move H'02' para o registrador de trabalho
	movwf	TRISB					; Move o valor do registrador de trabalho para TRISB
	bank0							; Volta para o banco 0
	
	end								; Final do programa
