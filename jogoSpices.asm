
;				Integrentes:
; Agnes Bressan de Almeida - 13677100
; Carolina Elias de Almeida Américo - 13676687
; Caroline Severiano Clapis - 13864673
; Rauany Martinez Secci - 13721217
; Rhayna Christiani Vasconcelos Marques Casado - 13676429

jmp main																									

Letra: var #1

personagem: string "z" ; Para desenhar o personagem (o caracter é substituido no charmap)
obstaculo: string "o"	; Para desenhar o obstaculo (o caracter é substituido no charmap)
placar : string "SCORE: " ; String do placar

posperso: var #490 ; Posicao padrao do personagem
pontos: var #1	; seta 1 para funcionar pontuacao

delay1: var #5000	; Variaveis para usar como parametro para o delay(quanto maior forem, mais lenta é cada 'ciclo')
delay2: var #5000

Rand : var #30			; Tabela de nrs. Randomicos entre 1 - 3	
	static Rand + #0, #3
	static Rand + #1, #2
	static Rand + #2, #2
	static Rand + #3, #3
	static Rand + #4, #3
	static Rand + #5, #2
	static Rand + #6, #1
	static Rand + #7, #2
	static Rand + #8, #1
	static Rand + #9, #3
	static Rand + #10, #2
	static Rand + #11, #1
	static Rand + #12, #3
	static Rand + #13, #3
	static Rand + #14, #2
	static Rand + #15, #1
	static Rand + #16, #2
	static Rand + #17, #3
	static Rand + #18, #1
	static Rand + #19, #2
	static Rand + #20, #1
	static Rand + #20, #2
	static Rand + #21, #3
	static Rand + #22, #2
	static Rand + #23, #2
	static Rand + #24, #1
	static Rand + #25, #1
	static Rand + #26, #3
	static Rand + #27, #2
	static Rand + #28, #3
	static Rand + #29, #2

	
IncRand: var #1



;-------------------------------------------------------------------------------



main:
	
	call LimpaTela
	
	; Desenha a tela inicial
	loadn r1, #tela0Linha0
	loadn r2, #256              ;cor marrom
	call DesenhaCenario
	loadn r1, #tela10Linha0	
	loadn r2, #768              ;cor oliva
	call DesenhaCenario	
	loadn r1, #tela11Linha0
	loadn r2, #1792             ;cor prata
	call DesenhaCenario
	
	
	Loop_Inicio:
		; Espera que a tecla enter seja digitada para iniciar o jogo
		call LeInput 		; 
		loadn r0, #13
		load r1, Letra
		cmp r0, r1
		jne Loop_Inicio	; se a tecla digitada não for enter, ele volta ao loop
	
	setamento:
		
		push r2
		loadn r2, #0				; Inicializa os pontos
		store pontos, r2
		pop r2
		
		loadn r0, #1800
		store delay1, R0             ; delay meteoro
		
		loadn r0, #100                ; delay pulo
		store delay2, r0
	
	
	
			

	InicioJogo:		; Inicializa variaveis e registradores usados no jogo antes de comecar o loop principal
		
		
		call LimpaTela				;	Imprime a tela basica do jogo
		
		loadn r1, #tela1Linha0
		loadn r2, #512
		call DesenhaCenario
		
		;loadn R1, #tela3Linha0	; Endereco onde comeca a primeira linha do cenario!!
		;loadn R2, #2816		    ;   cor amarelo, meotoro
		;call DesenhaCenario   		;  Rotina de Impresao de Cenario na Tela Inteira
		
		;loadn R1, #tela4Linha0	; Endereco onde comeca a primeira linha do cenario!!
		;loadn R2, #512   			; verde, copa 
		;call DesenhaCenario  		;  Rotina de Impresao de Cenario na Tela Inteira
		
		;loadn R1, #tela6Linha0	; Endereco onde comeca a primeira linha do cenario!!
		;loadn R2, #256		    ;   cor marrom, tronco
		;call DesenhaCenario   		;  Rotina de Impresao de Cenario na Tela Inteira
		
		;loadn R1, #tela7Linha0	; Endereco onde comeca a primeira linha do cenario!!
		;loadn R2, #2304		    ;   raios do metoro
		;call DesenhaCenario   		;  Rotina de Impresao de Cenario na Tela Inteira
		
		;loadn R1, #tela8Linha0	; Endereco onde comeca a primeira linha do cenario!!
		;loadn R2, #1536    		   ;mato
		;call DesenhaCenario   		;  Rotina de Impresao de Cenario na Tela Inteira
		
		;loadn R1, #tela9Linha0	; Endereco onde comeca a primeira linha do cenario!!
		;loadn R2, #1024   		; ESTRELAS
		;call DesenhaCenario   		;  Rotina de Impresao de Cenario na Tela Inteira
		
		loadn r0, #3
		loadn r1, #placar		; Imprime a tela inicial
		loadn r2, #0
		call ImprimeStr
		
		loadn r7, #' '	; Tecla para que o personagem pule
		loadn r6, #490	; Posicao do personagem na tela (fixa no eixo x e variavel no eixo y)
		loadn r2, #519	; Posicao do obstaculo na tela (fixa no eixo x e variavel no eixo y)
		load r4, personagem	; Guardando a string do personagem no registrador r4
		load r1, obstaculo	; Guardando a string do obstaculo no registrador r1
		loadn r5, #0	; Ciclo do pulo (0 = chao, entre 1 e 3 = sobe, maior que 3 = desce)
		
		jmp LoopJogo
	
		LoopJogo:		; Loop principal do jogo
		
			call VerificaColisao	; verifica se a posição do personagem é a mesma do obstáculo
			
			call AtPontos 		; Atualiza os pontos
			
			call AtPosicaoObstaculo 	; Move o obstaculo
			outchar r1, r2 				; Desenha o obstaculo
			
			call ControlePulo	; Todo ciclo principal do jogo, a funcao ControlePulo atualiza a posicao do personagem de acordo com a situacao
			
			; Desenha o personagem, atualizando sua posição
			call RemovePersonagem 
			call DesenhaPersonagem
			
			call DelayChecaPulo		; Todo ciclo principal do jogo, a funcao DelayChecaPulo atrasa a execucao e le uma tecla do teclado (que e' 'w' ou nao)
			push r3 			; Checa se pode pular (caso o personagem esteja no chao)
			loadn r3, #0 
			cmp r5, r3
				ceq ChecaPulo ; A funcao checa se o jogador mandou o personagem pular
			pop r3
				
			
		jmp LoopJogo 	; Volta para o loop
	
	
	GameOver:
		; Imprime a tela do fim do jogo	
		call LimpaTela				
		loadn r1, #tela2Linha0
		loadn r2, #3584
		call DesenhaCenario	
		loadn r1, #tela5Linha0
		loadn r2, #2304
		call DesenhaCenario
		load r5, pontos
		loadn r6, #865	
		call PrintaNumero
		call LeInput
		
		
		; Espera que a tecla 's' seja digitada para reiniciar o jogo
		loadn r0, #'n'
		load r1, Letra
		cmp r0, r1
		jeq fim_de_jogo
		
		loadn r0, #'s'
		cmp r0, r1
		jne GameOver
		
		call LimpaTela
	
		pop r2
		pop r1
		pop r0

		pop r0	; Da um Pop a mais para acertar o ponteiro da pilha, pois nao vai dar o RTS !!
		jmp setamento	
		
fim_de_jogo:
	call LimpaTela
	halt



;--------------------------------------------------------------------------------------------------------------



; Espera que uma tecla seja digitada e salva na variavel global "Letra"
LeInput:
	; Protegendo valores dos registradores
	push r0
	push r1
	loadn r1, #255	; caso não tenha nenhum input

   LeInputLoop:
		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			; Compara r0 com 255
		jeq LeInputLoop	; Fica lendo ate' que digite uma tecla valida

	store Letra, r0			; Salva a tecla na variavel global "Letra"

	; Restaura r0 e r1
	pop r1
	pop r0
	rts


; Substitui todas as posições pelo caractere de espaço ' '
LimpaTela:
	push r0
	push r1
	
	loadn r0, #1200		; quantidade de posições da tela
	loadn r1, #' '		; "espaco" (caractere que será printado na tela)
	
	; Apaga as 1200 posicoes da Tela
	LimpaTela_Loop:
		dec r0		; diminui o valor de r0
		outchar r1, r0
		jnz LimpaTela_Loop
 
	pop r1
	pop r0
	rts	
	
; Desenha um cenário (30 linhas) na tela
DesenhaCenario:
	push r0	
	push r1	; endereco da primeira linha do cenário
	push r2	; cor do cenário para ser impresso
	push r3	
	push r4	
	push r5	
	push r6	

	loadn r0, #0  	; posicao inicial
	loadn r3, #40  	; incremento (número de colunas)
	loadn r4, #41  	; incremento do ponteiro das linhas da tela (41 por causa do '\0')
	loadn r5, #1200 ; número total de posições
	loadn r6, #tela0Linha0	; endereço da primeira linha
	
   DesenhaCenarioLoop:
		call ImprimeStr2
		add r0, r0, r3  	; incrementa posicao para a segunda linha na tela
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria
		add r6, r6, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria
		cmp r0, r5			
		jne DesenhaCenarioLoop	; se r0 ainda não chegou em 1200, continua no loop

	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
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
		inc r6
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
	

;------------------------

;********************************************************
;                   ImprimeStr
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
	
; Controle do pulo/posicao do personagem
ControlePulo:
	push r0
	
	; Caso o ciclo do pulo esteja em 1, 2, 3 ou 4, o personagem sobe
	loadn r0, #1
	cmp r5, r0
		ceq Cima

	loadn r0, #2
	cmp r5, r0
		ceq Cima
		
	loadn r0, #3
	cmp r5, r0
		ceq Cima
		
	loadn r0, #4
	cmp r5, r0
		ceq Cima
		
	; Começa a descida
	loadn r0, #5
	cmp r5, r0
		ceq Baixo
		
	loadn r0, #6
	cmp r5, r0
		ceq Baixo
		
	loadn r0, #7
	cmp r5, r0
		ceq Baixo
		
	loadn r0, #8
	cmp r5, r0
		ceq Baixo
		
	; Caso o personagem estaja no chao (ciclo = 0), o ciclo nao deve ser alterado aqui	
	loadn r0, #0
	cmp r5, r0
		cne IncrementaPulo	; Caso esteja no ar, o ciclo deve continuar sendo incrementado
		
	loadn r0, #9	; Ate que o ciclo chegue em 9, entao se torna 0 novamente (personagem esta no chao novamente)
	cmp r5, r0
		ceq ZeraPulo
				
		
	pop r0
	rts
	
;********************************************************
;               ATUALIZA POSICAO DO OBSTACULO
;********************************************************

;	Funcao que atualiza a posicao do obstaculo na tela de acordo com a necessidade da situacao

AtPosicaoObstaculo:
	
	push r0
	loadn r0 , #' '
	
	outchar r0, r2
	
	dec r2

	;if posicao do obstaculo = 480 (fim da tela para a esquerda)
	loadn r0, #480
	cmp r2, r0
		ceq ResetaObstaculo
		
	loadn r0, #440
	cmp r2, r0
		ceq ResetaObstaculo
		
	loadn r0, #400
	cmp r2, r0
		ceq ResetaObstaculo
		
	pop r0
	rts

;********************************************************
;                       ResetaObstaculo
;********************************************************

; Funcao que reseta a posicao do obstaculo

ResetaObstaculo:
	push r0
	push r1
	push r3
	
	loadn r2, #519		; Posicao (padrao do obstaculo)
	
	call GeraPosicao	; Gera a nova  posicao para o obstaculo
	
	loadn r1, #1		;  Caso 1
	cmp r3,r1
	ceq AlteraPos1
	
	loadn r1, #2		; Caso 2
	cmp r3,r1
	ceq AlteraPos2
	
	pop r3
	pop r1
	pop r0
	rts

	
;********************************************************
;                       GeraPosicao
;********************************************************

; Funcao que gera uma posicao aleatoria para o obstaculo

GeraPosicao :
	push r0
	push r1
	

						; sorteia nr. randomico entre 0 - 7
	loadn r0, #Rand 	; declara ponteiro para tabela rand na memoria!
	load r1, IncRand	; Pega Incremento da tabela Rand
	add r0, r0, r1		; Soma Incremento ao inicio da tabela Rand
						; R2 = Rand + IncRand
	loadi r3, r0 		; busca nr. randomico da memoria em R3
						; R3 = Rand(IncRand)
						
	inc r1				; Incremento ++
	loadn r0, #30
	cmp r1, r0			; Compara com o Final da Tabela e re-estarta em 0
	jne ResetaVetor
		loadn r1, #0		; re-estarta a Tabela Rand em 0
  ResetaVetor:
	store IncRand, r1	; Salva incremento ++
	
	
	pop r1
	pop r0
	rts

;********************************************************
;                       ResetaAleatorio
;********************************************************

; Funcao que reseta a semente para a funcao de geracao aleatoria

ResetaAleatorio:	
		
		push r2
		loadn r2,#28
		
		sub r1,r2,r2 
		
		pop r2
		rts

;********************************************************
;     				  AlteraPos1
;********************************************************

; Caso 1 da posicao do obstaculo

AlteraPos1:
		push r1
		
		loadn r1,#40
		sub r2,r2,r1
		

		pop r1
		rts
	
;********************************************************
;     				  AlteraPos2
;********************************************************

; Caso 2 da posicao do obstaculo

AlteraPos2:
		push r1
		
		loadn r1,#80
		sub r2,r2,r1	
		
		pop r1
		rts

;********************************************************
;                     ChecaPulo
;********************************************************	

; Funcao que checa se o jogador pressionou 'space' e, se sim, inicia o ciclo do pulo

ChecaPulo:

	push r3
	load r3, Letra 			; Caso ' space' tenha sido pressionado	
	cmp r7, r3
		ceq IncrementaPulo		; Inicia o ciclo do pulo
	pop r3 		
	rts


; Incrementa o ciclo do pulo
IncrementaPulo:
	inc r5
	rts
	

; Reseta o ciclo do pulo
ZeraPulo:

	loadn r5, #0
	rts
	
	
; Diminui em 40 a posição do personagem (sobe 1 linha)	
Cima:
	push r1
	push r2
	
	call RemovePersonagem	; remove o personagem da posição atual
	
	loadn r1, #40
	sub r6, r6, r1
	
	pop r2
	pop r1
	rts 
	
; Aumenta em 40 a posição do personagem (desce 1 linha)	
Baixo:
	push r1
	push r2
	
	call RemovePersonagem	; remove o personagem da posição atual
	
	loadn r1, #40
	add r6, r6, r1
	
	pop r2
	pop r1
	rts

; Aumenta em 1 os pontos do jogador
AumentaPontos:
	push r1
	push r2
	
	load r2, pontos	
	inc r2	
	load r1, delay1
	dec r1

	store delay1, r1
	
	load r1, delay2
	dec r1
	dec r1

	store delay2, r1
	
	store pontos, r2
	
	pop r2
	pop r1
	rts

AtPontos:
	push r1
	push r5
	push r6
	
	loadn r1, #490		; Caso o obstaculo tenha passado pela posicao do jogador, incrementa a pontuacao
	cmp r2, r1
		ceq AumentaPontos
	
	loadn r1, #450		; Idem, porem para o caso do obstaculo estar em  outra linha
	cmp r2, r1
		ceq AumentaPontos
		
	loadn r1, #410		; Idem, porem para o caso do obstaculo estar em  outra linha
	cmp r2, r1
		ceq AumentaPontos
		
	load r5, pontos
	
	loadn r6, #11
	
	call PrintaNumero	; Imprime a pontuacao na tela
	
	pop r6
	pop r5
	pop r1
	rts	
	
;********************************************************
;                    DelayChecaPulo
;********************************************************
 
; Funcao que da' o delay de um ciclo do jogo e tambem le uma tecla do teclado

DelayChecaPulo:
	push r0
	push r1
	push r2
	push r3
	
	load r0, delay1
	loadn r3, #255
	store Letra, r3		; Guarda 255 na Letra pro caso de nao apertar nenhuma tecla
	
	loop_delay_1:
		load r1, delay2

; Bloco de ler o Teclado no meio do DelayChecaPulo!!		
			loop_delay_2:
				inchar r2
				cmp r2, r3 
				jeq loop_skip
				store Letra, r2		; Se apertar uma tecla, guarda na variavel Letra
			
	loop_skip:			
		dec r1
		jnz loop_delay_2
		dec r0
		jnz loop_delay_1
		jmp sai_dalay
	
	sai_dalay:
		pop r3
		pop r2
		pop r1
		pop r0
	rts

;********************************************************
;                    PrintaNumero
;********************************************************

; Imprime um numero de 2 digitos na tela

PrintaNumero:	; R5 contem um numero de ate' 2 digitos e R6 a posicao onde vai imprimir na tela

	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #10
	loadn r2, #48
	
	div r1, r5, r0	; Divide o numero por 10 para imprimir a dezena
	
	add r3, r1, r2	; Soma 48 ao numero pra dar o Cod.  ASCII do numero
	outchar r3, r6
	
	inc r6			; Incrementa a posicao na tela
	
	mul r1, r1, r0	; Multiplica a dezena por 10
	sub r1, r5, r1	; Pra subtrair do numero e pegar o resto
	
	add r1, r1, r2	; Soma 48 ao numero pra dar o Cod.  ASCII do numero
	outchar r1, r6
	
	pop r3
	pop r2
	pop r1
	pop r0

	rts

;********************************************************
;                    DesenhaPersonagem
;********************************************************

; Desenha o personagem na tela
DesenhaPersonagem:
	push r0
	
	outchar r4, r6 ; Printa o corpo do personagem	
	dec r4
	loadn r0, #40
	sub r6, r6, r0
	outchar r4, r6 ; Printa a cabeca  do personagem
	add r6, r6, r0
	inc r4
	
	pop r0			
	rts
	

; Coloca um caractere de espaço no lugar do personagem, removendo-o da tela
RemovePersonagem:
	push r4
	push r0
	
	; r6 é a posição da parte de baixo do personagem
	
	; Removendo a parte de baixo do personagem
	loadn r4, #' '
	outchar r4, r6 	
	
	; removendo a parte de cima do personagem
	loadn r0, #40
	sub r6, r6, r0	; sobe 1 linha
	outchar r4, r6 
	add r6, r6, r0
	
	pop r0
	pop r4
	rts
	

; Se a posição do personagem foi igual a do obstaculo, o jogo é finalizado
VerificaColisao:
	push r0
	
	; r2 é a posição do obstáculo e r6 a da parte de baixo do personagem
	
	; comparando com a parte inferior do personagem
	cmp r2, r6
	jeq GameOver
	
	; comparando a posição do obstáculo com a cabeça do personagem
	loadn r0,#40
	sub r6,r6,r0	; sobe uma linha (parte de cima do personagem)
	cmp r2, r6
	jeq GameOver	

	add r6,r6,r0	; desce uma linha (volta pra posição da parte de baixo do personagem)
	
	pop r0
	rts

													   
;---------------------------------------------------------------
; Tela de inicio:
;---------------------------------------------------------------

tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "         _____          ____            "
tela0Linha6  : string "        |_   _|        /    \\           "
tela0Linha7  : string "          | |         |  __  |          "
tela0Linha8  : string "          | |         | |__| |          "
tela0Linha9  : string "         _| |_               |          "                   
tela0Linha10 : string "        |_____ _  ___  \\____/___        "               
tela0Linha11 : string "              | | | |     |  _  |       "               
tela0Linha12 : string "              | | | |     | |_| |       "            
tela0Linha13 : string "              | | | |     |  _  |       "                   
tela0Linha14 : string "              | |_| |     | | | |       "                  
tela0Linha15 : string "               \\___/      |_| |_|       "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "        A E T  E P C  P R  J G R        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "

;---------------------------------------------------------------
; Tela padrao do jogo
;---------------------------------------------------------------

tela1Linha0  : string "                                        "
tela1Linha1  : string "                                        "
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
tela1Linha13 : string "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
tela1Linha14 : string "                                        "
tela1Linha15 : string "                                        "
tela1Linha16 : string "                                        "
tela1Linha17 : string "                                        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "                                        "
tela1Linha20 : string "                                        "
tela1Linha21 : string "                                        "
tela1Linha22 : string "                                        "
tela1Linha23 : string "                                        "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                                        "
tela1Linha28 : string "                                        "
tela1Linha29 : string "                                        "

;---------------------------------------------------------------
; Tela de fim de jogo
;---------------------------------------------------------------

tela2Linha0  : string "                                        "
tela2Linha1  : string "                                        "
tela2Linha2  : string "                                        "
tela2Linha3  : string "                                        "
tela2Linha4  : string "                                        "
tela2Linha5  : string "                                        "
tela2Linha6  : string "========================================"
tela2Linha7  : string "  _____   _____  ______ ______ __   __  "
tela2Linha8  : string " |  __ \\ /  _  \\|      |   ___|  | |  | "
tela2Linha9  : string " | |__) |  |_|  |_    _|  |___|  | |  | "
tela2Linha10 : string " |  ___/|   _   | |  | |      |  | |  | "
tela2Linha11 : string " |  __ \\|  | |  | |  | |   ___|  |_|  | "
tela2Linha12 : string " | |__) |  | |  | |  | |  |___|       | "
tela2Linha13 : string " |_____/|__| |__| |__| |______|\\_____/  "
tela2Linha14 : string "                                        "
tela2Linha15 : string "========================================"
tela2Linha16 : string "                                        "
tela2Linha17 : string "                                        "
tela2Linha18 : string "                                        "
tela2Linha19 : string " S PARA JOGAR NOVAMENTE/N PARA ENCERRAR "                                   
tela2Linha20 : string "                                        "
tela2Linha21 : string "               PONTOS:                  "
tela2Linha22 : string "       					               "
tela2Linha23 : string "                                        "
tela2Linha24 : string "                                        "
tela2Linha25 : string "                                        "
tela2Linha26 : string "                                        "
tela2Linha27 : string "                                        "
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "

; Declara e preenche tela linha por linha (40 caracteres): 
;linha 98
tela3Linha0  : string "                                        "
tela3Linha1  : string "                                        "
tela3Linha2  : string "                                        "
tela3Linha3  : string "                                        "
tela3Linha4  : string "                          |             "
tela3Linha5  : string "                         OOO            "
tela3Linha6  : string "                      - OOOOO -         "
tela3Linha7  : string "                         OOO            "
tela3Linha8  : string "                          |             "
tela3Linha9  : string "                                        "
tela3Linha10 : string "                                        "
tela3Linha11 : string "                                        "
tela3Linha12 : string "                                        "
tela3Linha13 : string "                                        "
tela3Linha14 : string "                                        "
tela3Linha15 : string "                                        "
tela3Linha16 : string "                                        "
tela3Linha17 : string "                                        "
tela3Linha18 : string "                                        "
tela3Linha19 : string "                                        "
tela3Linha20 : string "                                        "
tela3Linha21 : string "                                        "
tela3Linha22 : string "                                        "
tela3Linha23 : string "                                        "
tela3Linha24 : string "                                        "
tela3Linha25 : string "                                        "
tela3Linha26 : string "                                        "
tela3Linha27 : string "                                        "
tela3Linha28 : string "                                        "
tela3Linha29 : string "                                        "

tela4Linha0  : string "                                        "
tela4Linha1  : string "                                        "
tela4Linha2  : string "                                        "
tela4Linha3  : string "                                        "
tela4Linha4  : string "                                        "
tela4Linha5  : string "                                        "
tela4Linha6  : string "                                        "
tela4Linha7  : string "                                        "
tela4Linha8  : string "                                        "
tela4Linha9  : string "                                        "
tela4Linha10 : string "                                        "
tela4Linha11 : string "                                        "
tela4Linha12 : string "                                        "
tela4Linha13 : string "                                        "
tela4Linha14 : string "                      ::     ::         "
tela4Linha15 : string "                 ::  :  :   :  :  ::    "
tela4Linha16 : string "                :  ::    :      ::  :   "
tela4Linha17 : string "                  :  :         :  :     "
tela4Linha18 : string "                      :       :         "
tela4Linha19 : string "        ::                              "
tela4Linha20 : string "  ::   :  :                             "
tela4Linha21 : string " :  : :                   ::            "
tela4Linha22 : string "   :    :         ::     :  :           "
tela4Linha23 : string "                 :   : :                "
tela4Linha24 : string "                :   :    :              "
tela4Linha25 : string "                   :      :             "
tela4Linha26 : string "                  :         :           "
tela4Linha27 : string "                                        "
tela4Linha28 : string "                                        "
tela4Linha29 : string "                                        "

tela5Linha0  : string "                                        "
tela5Linha1  : string "                                        "
tela5Linha2  : string "                                        "
tela5Linha3  : string "                                        "
tela5Linha4  : string "                                        "
tela5Linha5  : string "               DINO FUGA                "
tela5Linha6  : string "                                        "
tela5Linha7  : string "                                        "
tela5Linha8  : string "                                        "
tela5Linha9  : string "                                        "
tela5Linha10 : string "                                        "
tela5Linha11 : string "                                        "
tela5Linha12 : string "                                        "
tela5Linha13 : string "                                        "
tela5Linha14 : string "                                        "
tela5Linha15 : string "                                        "
tela5Linha16 : string "                                        "
tela5Linha17 : string "                                        "
tela5Linha18 : string "                                        "
tela5Linha19 : string "                                        "
tela5Linha20 : string "                                        "
tela5Linha21 : string "                                        "
tela5Linha22 : string "                                        "
tela5Linha23 : string "                                        "
tela5Linha24 : string "                                        "
tela5Linha25 : string "                                        "
tela5Linha26 : string "                                        "
tela5Linha27 : string "                                        "
tela5Linha28 : string "                                        "
tela5Linha29 : string "                                        "

tela6Linha0  : string "                                        "
tela6Linha1  : string "                                        "
tela6Linha2  : string "                                        "
tela6Linha3  : string "                                        "
tela6Linha4  : string "                                        "
tela6Linha5  : string "                                        "
tela6Linha6  : string "                                        "
tela6Linha7  : string "                                        "
tela6Linha8  : string "                                        "
tela6Linha9  : string "                                        "
tela6Linha10 : string "                                        "
tela6Linha11 : string "                                        "
tela6Linha12 : string "                                        "
tela6Linha13 : string "                                        "
tela6Linha14 : string "                                        "
tela6Linha15 : string "                                        "
tela6Linha16 : string "                                        "
tela6Linha17 : string "                   ..           ..      "
tela6Linha18 : string "                   ..           ..      "
tela6Linha19 : string "                  ..             ..     "
tela6Linha20 : string "                 ..               ..    "
tela6Linha21 : string "     ..                            ..   "
tela6Linha22 : string "     ..                             ..  "
tela6Linha23 : string "     ..                                 "
tela6Linha24 : string "     ..              ..                 "
tela6Linha25 : string "     ..              ..                 "
tela6Linha26 : string "                     ..                 "
tela6Linha27 : string "                     ..                 "
tela6Linha28 : string "                     ..                 "
tela6Linha29 : string "                                        "

tela7Linha0  : string "                           /   /    /   "
tela7Linha1  : string "                          /   ///  /    "
tela7Linha2  : string "                         / / // / /     "
tela7Linha3  : string "                       // //// / //     "
tela7Linha4  : string "                      //// / // //      "
tela7Linha5  : string "                      ///     / /       "
tela7Linha6  : string "                               //       "
tela7Linha7  : string "                            / ///       "
tela7Linha8  : string "                                        "
tela7Linha9  : string "                                        "
tela7Linha10 : string "                                        "
tela7Linha11 : string "                                        "
tela7Linha12 : string "                                        "
tela7Linha13 : string "                                        "
tela7Linha14 : string "                                        "
tela7Linha15 : string "                                        "
tela7Linha16 : string "                                        "
tela7Linha17 : string "                                        "
tela7Linha18 : string "                                        "
tela7Linha19 : string "                                        "
tela7Linha20 : string "                                        "
tela7Linha21 : string "                                        "
tela7Linha22 : string "                                        "
tela7Linha23 : string "                                        "
tela7Linha24 : string "                                        "
tela7Linha25 : string "                                        "
tela7Linha26 : string "                                        "
tela7Linha27 : string "                                        "
tela7Linha28 : string "                                        "
tela7Linha29 : string "                                        "

tela8Linha0  : string "                                        "
tela8Linha1  : string "                                        "
tela8Linha2  : string "                                        "
tela8Linha3  : string "                                        "
tela8Linha4  : string "                                        "
tela8Linha5  : string "                                        "
tela8Linha6  : string "                                        "
tela8Linha7  : string "                                        "
tela8Linha8  : string "                                        "
tela8Linha9  : string "                                        "
tela8Linha10 : string "                                        "
tela8Linha11 : string "                                        "
tela8Linha12 : string "                                        "
tela8Linha13 : string "                                        "
tela8Linha14 : string " ^^^^     ^^^^                          "
tela8Linha15 : string "^^^^   ^^^^                             "
tela8Linha16 : string "    ^^^^                                "
tela8Linha17 : string " ^^^^      ^^^^                         "
tela8Linha18 : string "            ^^^^                        "
tela8Linha19 : string "            ^^^^                        "
tela8Linha20 : string "                                        "
tela8Linha21 : string "            ^^^^                        "
tela8Linha22 : string "           ^^^^                         "
tela8Linha23 : string "                                        "
tela8Linha24 : string "          ^^^^                ^^^^      "
tela8Linha25 : string "                                   ^^^^ "
tela8Linha26 : string "^^^^    ^^^^                      ^^^^  "
tela8Linha27 : string "    ^^^^                        ^^^^    "
tela8Linha28 : string "  ^^^^    ^^^^   ^^^^     ^^^^   ^^^^   "
tela8Linha29 : string "   ^^^^  ^^^^  ^^^^  ^^^^          ^^^^ "

tela9Linha0  : string "                                        "
tela9Linha1  : string " *         *                            "
tela9Linha2  : string "                  *                     "
tela9Linha3  : string "   *    *                              "
tela9Linha4  : string "                                        "
tela9Linha5  : string "      *        *                        "
tela9Linha6  : string "   *        *                           "
tela9Linha7  : string "        *         *                     "
tela9Linha8  : string "                                        "
tela9Linha9  : string "                                        "
tela9Linha10 : string "                                        "
tela9Linha11 : string "                                        "
tela9Linha12 : string "                                        "
tela9Linha13 : string "                                        "
tela9Linha14 : string "                                        "
tela9Linha15 : string "                                        "
tela9Linha16 : string "                                        "
tela9Linha17 : string "                                        "
tela9Linha18 : string "                                        "
tela9Linha19 : string "                                        "
tela9Linha20 : string "                                        "
tela9Linha21 : string "                                        "
tela9Linha22 : string "                                        "
tela9Linha23 : string "                                        "
tela9Linha24 : string "                                        "
tela9Linha25 : string "                                        "
tela9Linha26 : string "                                        "
tela9Linha27 : string "                                        "
tela9Linha28 : string "                                        "
tela9Linha29 : string "                                        "

tela10Linha0  : string "                                        "
tela10Linha1  : string "                                        "
tela10Linha2  : string "                                        "
tela10Linha3  : string "                                        "
tela10Linha4  : string "                                        "
tela10Linha5  : string "   ____        ___  __                  "
tela10Linha6  : string "  |    \\      |   \\ | |                 "
tela10Linha7  : string "  |  _  |     | |\\ \\| |                 "
tela10Linha8  : string "  | |_| |     | | \\   |                 "
tela10Linha9  : string "  |     |     | |  \\  |                 "                   
tela10Linha10 : string "  |____/      | |   __|                 "               
tela10Linha11 : string "        |  ___      |  ___              "               
tela10Linha12 : string "        | |___      | | __              "            
tela10Linha13 : string "        |  ___      | ||_               "                   
tela10Linha14 : string "        | |         | |_|               "                  
tela10Linha15 : string "        |_|          \\____              "
tela10Linha16 : string "                                        "
tela10Linha17 : string "                                        "
tela10Linha18 : string "                                        "
tela10Linha19 : string "         P R E  S A O  A A  O A   		"
tela10Linha20 : string "                                        "
tela10Linha21 : string "                                        "
tela10Linha22 : string "                                        "
tela10Linha23 : string "                                        "
tela10Linha24 : string "                                        "
tela10Linha25 : string "                                        "
tela10Linha26 : string "                                        "
tela10Linha27 : string "                                        "
tela10Linha28 : string "                                        "
tela10Linha29 : string "                                        "


tela11Linha0  : string "                                        "
tela11Linha1  : string "                                        "
tela11Linha2  : string "                                        "
tela11Linha3  : string "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
tela11Linha4  : string "                                        "
tela11Linha5  : string "                                        "
tela11Linha6  : string "                                        "
tela11Linha7  : string "                                        "
tela11Linha8  : string "                                        "
tela11Linha9  : string "                                        "                   
tela11Linha10 : string "                                        "               
tela11Linha11 : string "                                        "               
tela11Linha12 : string "                                        "            
tela11Linha13 : string "                                        "                   
tela11Linha14 : string "                                        "                  
tela11Linha15 : string "                                        "
tela11Linha16 : string "                                        "
tela11Linha17 : string "                                        "
tela11Linha18 : string "                                        "
tela11Linha19 : string "                                  		"
tela11Linha20 : string "                                        "
tela11Linha21 : string "                                        "
tela11Linha22 : string "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
tela11Linha23 : string "                                        "
tela11Linha24 : string "                                        "
tela11Linha25 : string "                                        "
tela11Linha26 : string "                                        "
tela11Linha27 : string "                                        "
tela11Linha28 : string "                                        "
tela11Linha29 : string "                                        "