;Trabalho de Organizacao de Computadores Digitais
;----------------------------------------------------
;Desenvolvedores:
;Gabriel Muniz Morao, NUSP 7236785
;Juliana Yendo, NUSP 9597020
;Stella Granatto Justo, NUSP 9558882
;----------------------------------------------------
; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco						0000 0000
; 256 marrom						0001 0000
; 512 verde						0010 0000
; 768 oliva						0011 0000
; 1024 azul marinho					0100 0000
; 1280 roxo						0101 0000
; 1536 teal						0110 0000
; 1792 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2560 lima						1010 0000
; 2816 amarelo						1011 0000
; 3072 azul						1100 0000
; 3328 rosa						1101 0000
; 3584 aqua						1110 0000
; 3840 branco						1111 0000

;----------------------------------------------------

jmp main
MsnTop: string "               ((ARROW()                "
Msn0: string "     G A M E  O V E R !!!     "
Msn1: string "DO YOU WANNA PLAY AGAIN? <Y/N>"
Msn2: string "                  SCORE:      "

Letra: var #1		; Contem a letra que foi digitada

posHeroi: var #1			; Contem a posicao atual da Heroi
posAntHeroi: var #1		; Contem a posicao anterior da Heroi

posBalao: var #1		; Contem a posicao atual do Balao
posAntBalao: var #1		; Contem a posicao anterior do Balao

posFlecha: var #1			; Contem a posicao atual do Flecha
posAntFlecha: var #1		; Contem a posicao anterior do Flecha
FlagFlecha: var #1		; Flag para ver se disparou ou nao (Barra de Espaco!!)
score: var #1
remains: var #1

;--------------- Codigo principal ---------------
main:
	
	call ApagaTela
	loadn R1, #telaInicialLinha0	; Endereco onde comeca a primeira linha do cenario!!
	loadn R2, #2816  				; cor amarela!
	call ImprimeTela2   			;  Rotina de Impresao de Cenario na Tela Inteira  
	
	call Intro
	call ApagaTela	
	
	loadn R1, #tela1Linha0	; Endereco onde comeca a primeira linha do cenario!!
	loadn R2, #2304  			; red color
	call ImprimeTela2   		;  Rotina de Impresao de Cenario na Tela Inteira

	loadn R1,#25
	loadn R2,#'9'
	call ImprimeRemains

	loadn R1,#37
	loadn R2,#'0'
	call ImprimeScore


	loadn R0, #160	
	store posHeroi, R0		; Zera Posicao Atual da Heroi
	store posAntHeroi, R0	; Zera Posicao Anterior da Heroi
	
	loadn R1, #0
	store FlagFlecha, R1		; Zera o Flag para marcar que ainda nao disparou!
	store posFlecha, R0		; Zera Posicao Atual do Flecha
	store posAntFlecha, R0	; Zera Posicao Anterior do Flecha
	
	loadn R0, #1195
	store posBalao, R0		; Zera Posicao Atual do Balao
	store posAntBalao, R0	; Zera Posicao Anterior do Balao
	
	loadn R0, #0			; Contador para os Mods	= 0
	loadn R2, #0			; Para verificar se (mod(c/10)==0

	Loop:
	
		loadn R1, #10
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/10)==0
		ceq MoveHeroi	; Chama Rotina de movimentacao da Heroi
	
		loadn R1, #30
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/30)==0
		ceq MoveBalao	; Chama Rotina de movimentacao do Balao
	
		loadn R1, #2
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/2)==0
		ceq MoveFlecha	; Chama Rotina de movimentacao do Flecha
	
		call Delay
		inc R0 	;c++
		jmp Loop
	rts
	
;Funcoes
;--------------------------

ImprimeRemains:
	outchar R2, R1
	dec R2
	store remains,R2
	rts


ImprimeScore:
	store score,R2
	outchar R2, R1 
	

	
MoveHeroi:
	push r0
	push r1
	
	call MoveHeroi_RecalculaPos		; Recalcula Posicao da Heroi

; So' Apaga e Redesenha se (pos != posAnt)
;	If (posHeroi != posAntHeroi)	{	
	load r0, posHeroi
	load r1, posAntHeroi
	cmp r0, r1
	jeq MoveHeroi_Skip
		call MoveHeroi_Apaga
		call MoveHeroi_Desenha		;}
  MoveHeroi_Skip:
	
	pop r1
	pop r0
	rts

;--------------------------------
	
MoveHeroi_Apaga:		; Apaga a Heroi preservando o Cenario!
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5	

	load R0, posAntHeroi	; R0 = posAnt
	
	; As linhas a seguir consideram a existencia de um cenario
	loadn R1, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela1Linha0 + posAnt
	loadn R4, #40
	div R3, R0, R4	; R3 = posAnt/40
	add R2, R2, R3	; R2 = Tela1Linha0 + posAnt + posAnt/40
	
	loadn R5, #' '	; R5 = Char (Tela(posAnt))
	
	outchar R5, R0	; Apaga arco 3
	dec R0
	outchar R5, R0	; Apaga pes heroi
	inc R0
	sub R0, R0, R4	; Subtrai 40 da posicao para apagar o arco 2
	outchar R5, R0	; Apaga o arco 2
	dec R0
	outchar R5, R0	; Apaga o tronco do heroi
	inc R0
	sub R0, R0, R4	; Subtrai 40 da posicao para apagar o arco 1
	outchar R5, R0	; Apaga o arco 1
	dec R0
	outchar R5, R0	; Apaga a cabeca do heroi	
	
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;----------------------------------	
	
MoveHeroi_RecalculaPos:		; Recalcula posicao da Heroi em funcao das Teclas pressionadas
	push R0
	push R1
	push R2
	push R3

	load R0, posHeroi
	
	inchar R1				; Le Teclado para controlar a Heroi
		
	loadn R2, #'w'
	cmp R1, R2
	jeq MoveHeroi_RecalculaPos_W
		
	loadn R2, #'s'
	cmp R1, R2
	jeq MoveHeroi_RecalculaPos_S
	
	loadn R2, #' '
	cmp R1, R2
	jeq MoveHeroi_RecalculaPos_Flecha
	
  MoveHeroi_RecalculaPos_Fim:	; Se nao for nenhuma tecla valida, vai embora
	store posHeroi, R0
	pop R3
	pop R2
	pop R1
	pop R0
	rts  
	
  FazNada:
  	nop
  	jmp MoveHeroi_RecalculaPos_Fim
  	
  MoveHeroi_RecalculaPos_W:	; Move Heroi para Cima	
	
	; Evitar que o arqueiro se mova para o header
	loadn R1, #80
	cmp R0, R1
	jeq FazNada
	
	loadn R1, #40
	
	cmp R0, R1		; Testa condicoes de Contorno
	jle MoveHeroi_RecalculaPos_Fim
	sub R0, R0, R1	; pos = pos - 40
	jmp MoveHeroi_RecalculaPos_Fim

  MoveHeroi_RecalculaPos_S:	; Move Heroi para Baixo
  
  ; Evitar que o arqueiro se mova para o footer
	loadn R1, #1080
	cmp R0, R1
	jeq FazNada
  
	;loadn R1, #1159
	;cmp R0, R1		; Testa condicoes de Contorno 
	;jgr MoveHeroi_RecalculaPos_Fim
	loadn R1, #40
	add R0, R0, R1	; pos = pos + 40
	jmp MoveHeroi_RecalculaPos_Fim	
	
  MoveHeroi_RecalculaPos_Flecha:	
	loadn R1, #1			; Se AFlechau:
	store FlagFlecha, R1		; FlagFlecha = 1
	store posFlecha, R0		; posFlecha = posHeroi
	

	load R2, remains
	loadn R3, #'0'
	cmp R2, R3
	jle GameOver
	
	loadn R1, #25
	call ImprimeRemains

		
	jmp MoveHeroi_RecalculaPos_Fim
	call ApagaTela	
;----------------------------------
MoveHeroi_Desenha:	; Desenha caractere da Heroi
	push R0
	push R1
	push R2
	
	Loadn R1, #'"'	; Cabeca heroi	
	load R0, posHeroi
	outchar R1, R0
	
	Loadn R1, #'#'	; Arco 1		
	inc R0
	outchar R1, R0
	
	Loadn R1, #'$'	; Corpo heroi	
	dec R0
	Loadn R2, #40
	add R0, R0, R2
	outchar R1, R0
	
	Loadn R1, #'%'	; Arco 2		
	inc R0
	outchar R1, R0
	
	Loadn R1, #'&'	; Corpo heroi	
	dec R0
	Loadn R2, #40
	add R0, R0, R2
	outchar R1, R0
	
	Loadn R1, #'''	; Arco 2		
	inc R0
	outchar R1, R0
	
	store posAntHeroi, R0	; Atualiza Posicao Anterior da Heroi = Posicao Atual	 
	
	pop R2
	pop R1
	pop R0
	rts

	
;----------------------------------
;----------------------------------
;----------------------------------

MoveBalao:
	push r0
	push r1
	
	call MoveBalao_RecalculaPos
	
; So' Apaga e Redesenha se (pos != posAnt)
;	If (pos != posAnt)	{	
	load r0, posBalao
	load r1, posAntBalao
	cmp r0, r1
	jeq MoveBalao_Skip
		call MoveBalao_Apaga
		call MoveBalao_Desenha		;}
  MoveBalao_Skip:
	
	pop r1
	pop r0
	rts
		
; ----------------------------
		
MoveBalao_Apaga:
	push R0
	push R4
	push R5

	load R0, posAntBalao	; R0 == posAnt
		loadn r5, #' '		; Se o Flecha passa sobre o Heroi, apaga com um X, senao apaga com o cenario 
  
  ;MoveBalao_Apaga_Fim:	
  	loadn R4, #40
	outchar R5, R0	; Apaga Balao 4
	dec R0
	outchar R5, R0	; Apaga Balao 3
	inc R0
	sub R0, R0, R4
	outchar R5, R0	; Apaga Balao 2
	dec R0
	outchar R5, R0	; Apaga Balao 1	
	
	
	pop R5
	pop R4
	pop R0
	rts

MoveBalao_RecalculaPos:
	push R0
	push R1
	push R2
	push R3
	
	load R0, posBalao
	
 ; Case 1 : posBalao = posBalao -40
   MoveBalao_RecalculaPos_Case1:
	loadn r1, #40
	loadn r2, #80
	sub r0, r0, r1
	cmp r0,r2
		jel RetomaPos
		
  	jmp MoveBalao_RecalculaPos_FimSwitch	; Break do Switch


   RetomaPos:
	loadn R0, #1195
	jmp MoveBalao_RecalculaPos_Case1


 ; Fim Switch:
  MoveBalao_RecalculaPos_FimSwitch:	
	store posBalao, R0	; Grava a posicao alterada na memoria
	pop R3
	pop R2
	pop R1
	pop R0
	rts

;----------------------------------
MoveBalao_Desenha:
	push R0
	push R1
	push R2
	
	loadn R1, #'{'	; Balao 1
	load R0, posBalao
	outchar R1, R0	
	
	loadn R1, #'|'	; Balao 2
	inc R0
	outchar R1, R0
	
	loadn R1, #'}' ; Balao 3	
	loadn R2, #40
	dec R0
	add R0, R0, R2
	outchar R1, R0
	
	loadn R1, #'~'	; Balao 2
	inc R0
	outchar R1, R0
	
	store posAntBalao, R0	
	
	pop R2
	pop R1
	pop R0
	rts

;----------------------------------
;----------------------------------
;--------------------------

MoveFlecha:
	push r0
	push r1
	
	call MoveFlecha_RecalculaPos

; So' Apaga e Redesenha se (pos != posAnt)
;	If (pos != posAnt)	{	
	load r0, posFlecha
	load r1, posAntFlecha
	cmp r0, r1
	jeq MoveFlecha_Skip
		call MoveFlecha_Apaga
		call MoveFlecha_Desenha		;}
  MoveFlecha_Skip:
	
	pop r1
	pop r0
	rts

;-----------------------------
	
MoveFlecha_Apaga:
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5	

	; Compara Se (posAntFlecha == posAntHeroi)
	load R0, posAntFlecha	; R0 = posAnt
		loadn R5, #' '		; Se o Flecha passa sobre o Heroi, apaga com um X, senao apaga com o cenario 		

  ;MoveFlecha_Apaga_Fim:	
	outchar R5, R0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	dec R0			; Decrementa a posicao do Obj
	outchar R5, R0	; Apaga o segundo elemento que compoe o Obj
	
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;----------------------------------	
	
	
; if FlechaFlag = 1
;	posFlecha++
;	
	
MoveFlecha_RecalculaPos:
	push R0
	push R1
	push R2
	push R3
	
	load R1, FlagFlecha	; Se disparou, movimenta a Flecha!
	loadn R2, #1
	cmp R1, R2			; If FlagFlecha == 1  Movimenta o Flecha
	jne MoveFlecha_RecalculaPos_Fim2	; Se nao vai embora!
	
	load R0, posFlecha	; Testa se o Flecha Pegou no Balao
	inc R0
	load R1, posBalao
	loadn R2, #40
	sub R1, R1, R2
	cmp R0, R1			; IF posFlecha == posBalao  BOOM!!	
		jeq MoveFlecha_RecalculaPos_Boom
	
	loadn R1, #40		; Testa condicoes de Contorno 
	loadn R2, #39
	mod R1, R0, R1		
	cmp R1, R2			; Se Flecha chegou na ultima linha
	call MoveFlecha_Apaga
	jne MoveFlecha_RecalculaPos_Fim
	loadn R0, #0
	store FlagFlecha, R0	; Zera FlagFlecha
	store posFlecha, R0	; Zera e iguala posFlecha e posAntFlecha
	store posAntFlecha, R0
	jmp MoveFlecha_RecalculaPos_Fim2	
	
  MoveFlecha_RecalculaPos_Fim:
	inc R0
	store posFlecha, R0
  MoveFlecha_RecalculaPos_Fim2:
  	pop R3	
	pop R2
	pop R1
	pop R0
	rts

  MoveFlecha_RecalculaPos_Boom:	
  	loadn R3, #'*'
	outchar R3, R1
	call delay2
	call delay2
	call delay2
	loadn R3, #' '
	outchar R3,R1
	
	;Muda o score quando atinge o Balao
	loadn R1, #37
  	load R2, score
  	inc R2
  	call ImprimeScore
  	
	jmp RetomaPos ; apos fazer efeito de atingir o Balao,volta pro inicio
	   		
	
	GameOver:
	loadn R0, #160	
	store posHeroi, R0		; Zera Posicao Atual da Heroi
	store posAntHeroi, R0	; Zera Posicao Anterior da Heroi
	call ApagaTela
	loadn r0, #40
	loadn r1, #MsnTop
	loadn r2, #0
	call ImprimeStr
	
  
  	loadn r0, #526
	loadn r1, #Msn0
	loadn r2, #0
	call ImprimeStr
	
	;imprime quer jogar novamente	
	loadn r0, #605
	loadn r1, #Msn1
	loadn r2, #0
	call ImprimeStr
	
	loadn r0, #758
	loadn r1, #Msn2
	loadn r2, #0
	call ImprimeStr
	
	loadn R1, #783
	load R2, score
	call ImprimeScore
	
	call DigLetra
	loadn r0, #'y'
	load r1, Letra
	cmp r0, r1				; tecla == 'y' ?
	jne MoveFlecha_RecalculaPos_FimJogo	; tecla nao e' 'y'
	
	; Se quiser jogar novamente...
	call ApagaTela
	
	pop r2
	pop r1
	pop r0

	pop r0	; Da um Pop a mais para acertar o ponteiro da pilha, pois nao vai dar o RTS !!
	jmp main

  MoveFlecha_RecalculaPos_FimJogo:
	call ApagaTela
	halt



delay2:
	loadn R3,#120000000000000
wait:
	dec R3
	jnz wait
	
	
;----------------------------------
MoveFlecha_Desenha:
	push R0
	push R1
	push R2	
	
	loadn R1, #'('	; Flecha tras
	load R0, posFlecha
	loadn R2, #40
	add R0, R0, R2
	outchar R1, R0
	
	
	Loadn R2, #')'	; Flecha ponta
	inc R0
	outchar R2, R0	
	
	store posAntFlecha, R0
	
	pop R2
	pop R1
	pop R0
	rts

;----------------------------------

; ---------- Intro ---------------
Intro:
	push r1
	push r2

	loadn r1, #0
	loadn r2, #13 ; numero do enter

intro_volta:
	inchar r1
	cmp r1, r2
	jeq intro_fim	; se for o enter
	jmp intro_volta


intro_fim:
	pop r2
	pop r1
	rts

;********************************************************
;                       DELAY
;********************************************************		


Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	Push R0
	Push R1
	
	Loadn R1, #5  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	Loadn R0, #10000	; b - atrasa a Flecha
   Delay_volta: 
	Dec R0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	JNZ Delay_volta	
	Dec R1
	JNZ Delay_volta2
	
	Pop R1
	Pop R0
	
	RTS							;return

;-------------------------------


;********************************************************
;                       IMPRIME TELA
;********************************************************	

ImprimeTela: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r4 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------

;---------------------------	
;********************************************************
;                   IMPRIME STRING
;********************************************************
	
ImprimeStr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;********************************************************
;                       IMPRIME TELA2
;********************************************************	

ImprimeTela2: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	loadn R6, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	
   ImprimeTela2_Loop:
		call ImprimeStr2
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		add r6, r6, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela2_Loop	; Enquanto r0 < 1200

	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;********************************************************
;                   IMPRIME STRING2
;********************************************************
	
ImprimeStr2:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '	; Espaco em Branco

   ImprimeStr2_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr2_Sai
		cmp r4, r5		; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr2_Skip
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		storei r6, r4
   ImprimeStr2_Skip:
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		inc r6			; Incrementa o ponteiro da String da Tela 0
		jmp ImprimeStr2_Loop
	
   ImprimeStr2_Sai:	
	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	

;********************************************************
;                   DIGITE UMA LETRA
;********************************************************

DigLetra:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push r0
	push r1
	loadn r1, #255	; Se nao digitar nada vem 255

   DigLetra_Loop:
		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			;compara r0 com 255
		jeq DigLetra_Loop	; Fica lendo ate' que digite uma tecla valida

	store Letra, r0			; Salva a tecla na variavel global "Letra"

	pop r1
	pop r0
	rts



;----------------
	
;********************************************************
;                       APAGA TELA
;********************************************************
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	

	
;------------------------	
; Declara uma tela vazia para ser preenchida em tempo de execucao:
tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "

; Declara e preenche tela linha por linha (40 caracteres):
tela1Linha0  : string " ((ARROW()      REMAINS:     SCORE:     "
tela1Linha1  : string "( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( "  
tela1Linha2  : string "                                        "
tela1Linha3  : string "                                        "
tela1Linha4  : string "                                        "
tela1Linha5  : string "                                        "
tela1Linha6  : string "                                        "
tela1Linha7  : string "                                        "
tela1Linha8  : string "                                        "
tela1Linha9  : string "                                        "
tela1Linha10 : string "                                        "
tela1Linha11 : string "                                        "
tela1Linha12 : string "                                        "
tela1Linha13 : string "                                        "
tela1Linha14 : string "                                        "
tela1Linha15 : string "                                        "
tela1Linha16 : string "                                        "
tela1Linha17 : string "                                        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "                                        "
tela1Linha21 : string "                                        "
tela1Linha22 : string "                                        "
tela1Linha23 : string "                                        "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                                        "
tela1Linha28 : string "                						   "
tela1Linha29 : string "                						   "

; Declara e preenche tela linha por linha (40 caracteres):					                  
;----------------------1234567890123456789012345678901234567890						
telaInicialLinha0  : string "                                        "
telaInicialLinha1  : string "                                        "
telaInicialLinha2  : string "               ((ARROW()                "
telaInicialLinha3  : string "                                        "
telaInicialLinha4  : string "                                        "
telaInicialLinha5  : string "                                        "
telaInicialLinha6  : string "                                        "
telaInicialLinha7  : string "                                        "
telaInicialLinha8  : string "                                        "
telaInicialLinha9  : string "                                        "
telaInicialLinha10 : string "                CONTROLS                "
telaInicialLinha11 : string "                                        "
telaInicialLinha12 : string "                                        "
telaInicialLinha13 : string "   MOVES:  UP [W], DOWN [S]             "
telaInicialLinha14 : string "                                        "
telaInicialLinha15 : string "   ARC SHOT:    SPACE                   "
telaInicialLinha16 : string "                                        "
telaInicialLinha17 : string "                                        "
telaInicialLinha18 : string "                                        "
telaInicialLinha19 : string "                                        "
telaInicialLinha20 : string "                                        "
telaInicialLinha21 : string "                                        "
telaInicialLinha22 : string "                                        "
telaInicialLinha23 : string "                                        "
telaInicialLinha24 : string "                                        "
telaInicialLinha25 : string "                                        "
telaInicialLinha26 : string "                                        "
telaInicialLinha27 : string "         PRESS ENTER TO START           "
telaInicialLinha28 : string "                                        "
telaInicialLinha29 : string "                                        "
