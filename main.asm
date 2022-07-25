.DEVICE ATmega328P

    ; Vector de Main
    .ORG 0
    		RJMP Main
    
    Main:	
    ;====== Inicialioz Stack====
    	LDI R16,low(RAMEND)		
      	OUT SPL,R16
        LDI R16, high(RAMEND)
        OUT SPH, R16
    
    ;===== Seteo puertos ============
    	LDI R16, 0xFF
    	OUT DDRB, R16	;Puerto D como salida
    	LDI R16, 0x00
    	OUT DDRC, R16	;Puerto C como entrada
    
    ;==== Configuro ADC ========
    	LDI R16, (1<<ADEN)|(1<<ADPS2)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0)	
    	STS ADCSRA, R16	
    	LDI r16, (0<<REFS1)|(1<<REFS0)|(1<<ADLAR)|(0<<MUX3)
    	    |(0<<MUX2)|(0<<MUX1)|(0<<MUX0) 
    	STS ADMUX, R16	;Entrada - justificado a derecha
    
    READ_ADC:
    	LDS R16, ADCSRA ;leo el registro
    	SBR R16, (1<<ADSC)	;Pongo un 1 en el bit ADSC
    	STS ADCSRA, R16	;Comienza la conversion
    
    KEEP_POLING:
    	LDS R16, ADCSRA 
    	SBRS R16,ADIF		;Verifico final de conversion
    	RJMP KEEP_POLING
    
    	SBR R16, ADIF	
    	STS ADCSRA, R16	  ;Sobre escribo ADIF con 1
    
    	LDS	R17, ADCH	  ;Leo los registros convertidos
    	LSR R17
    	LSR R17
    	OUT	PORTB,R17
    	RJMP READ_ADC	  ;Vuelve a leer
