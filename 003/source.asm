; ===============================================================
;
; Curso de Assembly para Microcontroladores PIC 003
;
; MCU: PIC16F84A	Clock: 4MHz
;
; Btn1 -> Ativo em HIGH
; Led1 -> Ativo em HIGH
;
; Autor: https://github.com/Guilherme-De-Marchi
; Data: 10-21
;
; ===============================================================


  list	p=16f84a									; PIC16F84A
  
  
; --- Includes ---

  #include  <p16f84a.inc>							; Constantes da placa
  
  
; --- FUSE bits ---

  __config  _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF	; Configuracoes dos fuse bits
  
  
; --- Paginacao de memoria ---

  #define  bank0		bcf  STATUS,RP0				; Instrucao para selecionar o banco 0
  #define  bank1		bsf  STATUS,RP0				; Instrucao para selecionar o banco 1
  
  
; --- I/O ---

  #define  btn1		PORTA,RA0					; Instrucao para acessar o pino RA0
  #define  led1		PORTB,RB0					; Instrucao para acessar o pino RB0
  
  
; --- RESET vector ---

  org  	H'0000'
  goto	main										; Label principal
  
  
; --- INTERRUPTION vector ---

  org	H'0004'
  retfie
 
 
; --- Led1_on label ---

led1_on:
   
   bsf   led1										; Led1 -> HIGH
   goto  main
    
     
; --- Led1_off label ---

led1_off:
   
   bcf  led1										; Led1 -> LOW
   goto main
   
   
; --- Led1_invert label ---

led1_invert:
  
   btfss  led1									; Led1 == 1?
   goto   led1_on									; Nao
   goto   led1_off								; Sim
    
       
; --- MAIN label ---

main:
  
   bank1
   movlw  H'FE'
   movwf  TRISB									; PORTB RB0 -> Output
   bank0
   
   btfss  btn1									; Btn1 = 1?
   goto   main									; Nao
   goto   led1_invert								; Sim
   
   end