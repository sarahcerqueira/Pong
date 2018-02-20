.data
.global _start
.equ barra_e_y, 0x50a0
.equ barra_d_y, 0x5090
.equ bola_x, 0x5080
.equ bola_y, 0x5070
.equ ad_0_d, 0x5060
.equ ad_1_e, 0x5050
.equ iniciar, 0x5040
.equ busy, 0x5030
.equ rst, 0x5020
.equ aleatorio, 0x5010

.equ i, 0x30
.equ i2, 0x30
.equ i3, 0x39
.equ i4, 0x14
.equ i5, 0x56
.equ i6, 0x6D
.equ i7, 0x70
.equ i8, 0x0C
.equ i9, 0x06
.equ i10, 0x01
.equ Home, 0x02

.equ P, 0x50
.equ DoisPontos, 0x3A
.equ Zero, 0x30
.equ Um, 0x31
.equ Dois, 0x32
.equ Tres, 0x33
.equ Quatro, 0x34
.equ Cinco, 0x35
.equ Espaço, 0xA0

.text

# Registradores ocupados
# r2 -> armazena endereços de memoria
# r3 -> armazena valor do endereço de memoria
# r4 -> axiliar em contas
# r5 -> utilizado na conversão potenciometro para vga
# r6 -> Pontos jogador da esquerda
# r7 -> Pontos jogador da direita
# r9 -> armazema incremento de x
# r10 -> armazena incremento de y
# r11 -> armazena 0 se for para incrmentar x, ou 1 para diminuir
# r12 ->  armazena 0 se for para incrmentar y, ou 1 para diminuir
# r15 ->  delay
# r16 -> delay atual
# r17 -> bola x
# r18 -> bola y
# r19 -> barra_e
# r20 -> barra_y
# r21 -> quadrante



# Inicia todos os dados do jogo
_start:
	#Dados para iniciar o lcd
	movia r22, Zero
	movia r23, Zero
	call lcd

	#Pocição inicial da bola
	call posicao_inicial_bola

	# Posição inicial da barra esquerda
	movi r2, ad_1_e
	ldw r3, 0(r2)

	#Identifica o intervalo onde a barra esta
	movi r4, 4				# n = valor analogico/ 4
	custom 2, r5, r3, r4	# resto da divisão entre o valo analogico /4
	custom 1, r3, r3, r4	# pega a divisão entre o valor analogico /4
	#/ Identifica o intervalo onde a barra esta

	call converte			# Converte o valor analogico do potenciometro para uma posição na tela

	movi r2, barra_e_y
	stw r3, 0(r2)      		# escreve o valor da barra_e_y na tela
	mov r19, r3				# Guarda o y atual da barra em r19

	# Posição inicial da barra direita
	movi r2, ad_0_d
	ldw r3, 0(r2)

	#Identifica o intervalo onde a barra esta
	movi r4, 4				# n = valor analogico/ 4
	custom 2, r5, r3, r4	# resto da divisão entre o valo analogico /4
	custom 1, r3, r3, r4	# pega a divisão entre o valor analogico /4
	# /Identifica o intervalo onde a barra esta

	call converte			# Converte o valor analogico do potenciometro para uma posição na tela

	movia r2, barra_d_y
	stw r3, 0(r2)		  	# escreve o valor da barra_d_y na tela
 	mov r20, r3				# Guarda o y atual da barra em r20

   # Seta a velocidade inicial da bola
   call velocidade_inicial_bola

	# Pontos iniciais dos jogadores 1 e 2
	addi r6, r0, 0
	addi r7, r0, 0

	#Angulo inicial
	call angulo_aleatorio
	
	br inicia_jogo

#Escreve na LCD do fpga através a custom 3
lcd:
	movi r4, 1
	movia r2, i
	custom 3, r3, r0, r2
	movia r2, i2
	custom 3, r3, r0, r2
	movia r2, i3
	custom 3, r3, r0, r2
	movia r2, i4
	custom 3, r3, r0, r2
	movia r2, i5
	custom 3, r3, r0, r2
	movia r2, i6
	custom 3, r3, r0, r2
	movia r2, i7
	custom 3, r3, r0, r2
	movia r2, i8
	custom 3, r3, r0, r2
	movia r2, i9
	custom 3, r3, r0, r2
	movia r2, i10
	custom 3, r3, r0, r2

	movia r2, P
	custom 3, r3, r4, r2
	movia r2, Um
	custom 3, r3, r4, r2
	movia r2, DoisPontos
	custom 3, r3, r4, r2
	#mov r2, r22
	custom 3, r3, r4, r22
	movia r2, Espaço
	custom 3, r3, r4, r2
	movia r2, P
	custom 3, r3, r4, r2
	movia r2, Dois
	custom 3, r3, r4, r2
	movia r2, DoisPontos
	custom 3, r3, r4, r2
	#mov r2, r23
	custom 3, r3, r4, r23
	ret


#Posição da bola considerando a tela 650 x 486
posicao_inicial_bola:
  # Posição inical x da bola
  movi r2, bola_x
  addi r17, r0, 315			# (Tela_x/2) -10
  stw r17, 0(r2)			# Escreve valor inicial da bola em x

  # Posição inical y da bola
  movi r2, bola_y
  addi r18, r0, 243			# (Tela_y/2)-10
  stw r18, 0(r2)			# Escreve valor inicial da bola em y
  ret

#r16 guarda a velocidade atual da bola
velocidade_inicial_bola:
	movi r16, 20
	ret

# Adiciona 1 a divisão do valor análogico por 4 para saber o intervalo ao qual o valor pertence : n = n + 1
soma:
  	addi r3, r3, 1
  	addi r5, r0, 0		# Torna o teste falso

# Converte o valor analógico para um valor correspondente no vga : n * 6 + 2
# Onde n é o intervalo onde a barra está
converte:
  	bne r5, r0, soma
  	movi r4, 6
  	custom 0, r3, r3, r4	# Multiplica quociente por 6
  	addi r3, r3, 2
  	ret

# Aguarda botão de inicializar ser apertado
inicia_jogo:
  	movi r2, iniciar
  	ldw r3, 0(r2)
  	bne r3, r0, play
  	br inicia_jogo


# Toda lógica do jogo se concentra nesse bloco
play:
  	# Posição da barra esquerda
  	movi r2, ad_1_e
  	ldw r3, 0(r2)

	#Identifica o intervalo onde a barra esta
  	movi r4, 4            # n = valor analogico/ 4
  	custom 2, r5, r3, r4	# resto da divisão entre o valo analogico /4
  	custom 1, r3, r3, r4	# pega a divisão entre o valor analogico /4
	#/ Identifica o intervalo onde a barra esta

  	call converte			# Converte o valor analogico do potenciometro para uma posição na tela

  	movi r2, barra_e_y
  	stw r3, 0(r2)        # escreve o valor da barra_e_y na tela
    mov r19, r3			# Guarda o y atual da barra em r19

  	# Posição da barra direita
  	movi r2, ad_0_d
  	ldw r3, 0(r2)

	#Identifica o intervalo onde a barra esta
  	movi r4, 4				# n = valor analogico/ 4
  	custom 2, r5, r3, r4	# resto da divisão entre o valo analogico /4
  	custom 1, r3, r3, r4	# pega a divisão entre o valor analogico /4
	#/Identifica o intervalo onde a barra esta	

  	call converte			# Converte o valor analogico do potenciometro para uma posição na tela

  	movi r2, barra_d_y
  	stw r3, 0(r2)        # escreve o valor da barra_d_y na tela
	mov r20, r3 	 	 # Guarda o y atual da barra em r20

  	call atualiza_x	 #Atualiza valor de x de acordo com o quadrante(add ou sub), e com valor do seu incremento
    call atualiza_y  #Atualiza valor de y de acordo com o quadrante(add ou sub), e com valor do seu incremento
	
	# Verifica se o botão de start foi apertado
    movi r2, rst
	ldw r3, 0(r2)
    bne r3, r0, _start	#Se o botão foi aperto reinicia o jogo

  	# Prepara o delay
    mov r15, r16		#Pega o valor atual do delay
  	slli r15, r15, 12
  	call delay

  	# Verifica se houve colisão entre a bola e as barras, as laterais e a margem superior e inferior
  	call verifica_colisao

	#Se não houve conlisão continua o jogo
  	br play


# Passe de incremento que corresponde aos ângulos
grau_15:
    addi r9, r0, 4				# Incremento de x
	addi r10, r0, 1				# Incremento de y
	br identifica_quadrante

grau_30:
	addi r9, r0, 2				# Incremento de x
	addi r10, r0, 1				# Incremento de y
	br identifica_quadrante	 

grau_45:
	 addi r9, r0, 1				# Incremento de x
	 addi r10, r0, 1				# Incremento de y
	 br identifica_quadrante

grau_60:
	addi r9, r0, 1				# Incremento de x
	addi r10, r0, 2				# Incremento de y
	br identifica_quadrante

grau_180:
	addi r9, r0, 0				# Incremento de x
	addi r10, r0, 1				# Incremento de y
	br identifica_quadrante

#Define o proximo angulo através de um sorteio em verilog
angulo_aleatorio:
	movi r3, aleatorio
	ldw  r4, 0(r3)		#Ler o valor sortedo, que está entre 0 e 3
	
	beq r0, r4, grau_15
	movi r3, 1
	beq r3, r4, grau_30
	movi r3, 2
	beq r3, r4, grau_45
	movi r3, 3
	beq r3, r4, grau_60
	
# Buscar em qual quadrante está a bola em relação ao seu primeiro pixel
# x > 325 : só pode está no quadrante 2 ou 4 (lembrando que a bola tem raio 10)
# x < 325: só pode está no quadrante 1 ou 3
identifica_quadrante:
	movi r4, 325
	bgt r17, r4, quadrante24

# y > 243 : terceiro quadrante
# y < 243 : primeiro quadrante
quadrante13:  
	movi r4, 243
	bgt r18, r4, terceiro_quadrante
	br primeiro_quadrante

# y > 243 : quarto quadrante
# y < 243 : segundo quadrante
quadrante24:
	movi r4, 243
	bgt r18, r4, quarto_quadrante
	br segundo_quadrante

# De acordo com o quadrante a orientação de x e y muda
# Se 0 incrementa, se 1 diminui
# r11 x
# r12 y

# +x +y
primeiro_quadrante:
	addi r21, r0, 1
	addi r11, r0, 0
  	addi r12, r0, 0
  	br verifica_velocidade_bola

# -x +y
segundo_quadrante:
  addi r21, r0, 2
  addi r11, r0, 1
  addi r12, r0, 0
  br verifica_velocidade_bola

# +x -y
terceiro_quadrante:
  addi r21, r0, 3
  addi r11, r0, 0
  addi r12, r0, 1
  br verifica_velocidade_bola

# -x -y
quarto_quadrante:
  addi r21, r0, 4
  addi r11, r0, 1
  addi r12, r0, 1
  br verifica_velocidade_bola


# Atualizam posição de x e y de acordo com o grau e o quadrante
atualiza_x:
  bne r11, r0, sub_x  # verifica se vai subtrair ou adicionar

  add r17, r17, r9      # Incrementa x da bola
  movia r2, bola_x
  stw r17, 0(r2)       # Atualiza posição x da bola na tela
  ret

sub_x:
  sub r17, r17, r9      # Subtrai x da bola
  movia r2, bola_x
  stw r17, 0(r2)       # Atualiza posição x da bola na tela
  ret

atualiza_y:
   bne r12, r0, sub_y  # verifica se vai subtrair ou adicionar

  add r18, r18, r10      # Incrementa y da bola

  movia r2, bola_y
  stw r18, 0(r2)       # Atualiza posição y da bola na tela
  ret

sub_y:
  sub r18, r18, r10      # Subtrai y da bola

  movia r2, bola_y
  stw r18, 0(r2)       # Atualiza posição y da bola na tela
  ret

#AGuarda um tempo para que o usuário possa ver o jogo
delay:
	subi r15, r15, 1
	bne r15, r0, delay
	ret

#Verifica colisão em X das barras com a bola
verifica_colisao:

	#Se x < 15 pode ter colidido com barra esquerda
	addi r4, r0, 15
	bge r4, r17, verifica_colisao_barra_e

	mov r3, r17

	#Se x > 625 pode ter colidido com barra direita
	addi r3, r3, 20
	addi r4, r0, 625
	bge r3, r4, verifica_colisao_barra_d

	#Verifica se colidiu com as barras superiores ou inferiores
	addi r3, r0, 8
	bge r3, r18, colisao_tb

	#Verifica se colidiu com as barras superiores ou inferiores
	addi r3, r0, 478
	mov r2, r18
	addi r2, r2, 20		#Adiciona devido ao raio 10
	bge r2, r3, colisao_tb

	#Se nao colidiu com ningu?m retorna
	ret

# Se a bota colidiu com a margem de cima ou com a debaixo é necessario trocar o movimento 
# se não a bola vai voltar para onde veio
colisao_tb:
	movi r3, 1
	beq r21, r3, terceiro_quadrante
	movi r3, 2
	beq r21, r3, quarto_quadrante
	movi r3, 3
	beq r21, r3, primeiro_quadrante
	movi r3, 4
	beq r21, r3, segundo_quadrante
	

# Verifica se colidiu tamb?m com o y0 da barra esquerda
verifica_colisao_barra_e:
	beq r18, r19, intervalo_colisao_e  	#Se y0 da barra ? igual ao da bola: identifica quadrante para determinar o movimento de volta
	bgt r18, r19, verifica_colisao_barra_e2 # Se y0 da bola for maior que o y0 da barra
	
	# Verifica a bola em relação barra para identificar quando a bola tocar na ponta da barra
	mov r3, r18	
	addi r3, r3, 20
	bge r3, r19, intervalo_colisao_e

  	#Se n?o houve colis?o retorna
  	br gol_d

# Verifica se o y da bola ? < do que o y0 da barra + 80
verifica_colisao_barra_e2:
	mov r3, r19
    addi r3, r3, 80
    bge r3, r18, intervalo_colisao_e
    br gol_d

# Verifica se colidiu tamb?m com o y0 da barra direita
verifica_colisao_barra_d:
	beq r18, r20, intervalo_colisao_d #Se y0 da barra ? igual ao da bola: identifica quadrante para determinar o movimento de volta
	bgt r18, r20, verifica_colisao_barra_d2 # Se y0 da bola for maior que o y0 da barra

	# Verifica a bola em relação barra para identificar quando a bola tocar na ponta da barra
	mov r3, r18
	addi r3, r3, 20
	bge r3, r20,intervalo_colisao_d

	br gol_e

# Verifica se o y da bola ? < do que o y0 da barra + 80
verifica_colisao_barra_d2:
	mov r4, r20
	addi r4, r4, 80
	bge r4, r18, intervalo_colisao_d
	br gol_e

#Adiciona pontos ao jogador da esquerda
gol_e:
  addi r6, r6, 1
  call converte_numero	#Converte o número de pontos em hexa para o displat lcd
  call lcd				# Atualiza lcd

  addi r2, r0, 5		#Verifica se acabou o jogo, caso o jogador tenha 5 pontos
  beq r2, r6, _start	# Inicia uma nova partida
  br reiniciar			#Continua a partida

gol_d:
  addi r7, r7, 1
  call converte_numero2	#Converte o número de pontos em hexa para o displat lcd
  call lcd				# Atualiza lcd

  addi r2, r0, 5		#Verifica se acabou o jogo, caso o jogador tenha 5 pontos
  beq r2, r7, _start	# Inicia uma nova partida
  br reiniciar			#Continua a partida

# Preparada para iniciar uma nova partida após um dos jogadores fazer um ponto
reiniciar:
  call posicao_inicial_bola
  call velocidade_inicial_bola
  br inicia_jogo

# Verifica se ainda pode aumenta a velocidade da bola
verifica_velocidade_bola:
  addi r4, r0, 10
  bgt r16, r4, aumenta_velocidade_bola # Verifica se o número base da velocidade é menor do que o limite
  ret

aumenta_velocidade_bola:
  subi r16, r16, 1
  ret

# Pega a barra na qual a bola colodiu
intervalo_colisao_e:
	mov r3, r19
	br identifica_intervalo_colisao

# Pega a barra na qual a bola colodiu
intervalo_colisao_d:
	mov r3, r20
	br identifica_intervalo_colisao

# Busca em qual intervalo da barra o y da bola colidiu para identificar o angulo de retorno
#No r3 já deve está o y da barra
identifica_intervalo_colisao:
	addi r3, r3, 16
	bge  r3, r18, angulo_aleatorio
	addi r3, r3, 16
	bge  r3, r18, grau_45
	addi r3, r3, 16
	bge  r3, r18, grau_180
	addi r3, r3, 16
	bge  r3, r18, grau_45
	br angulo_aleatorio

# Converte os pontos do jogador da esqueda para o hexadecimal correspondente no lcd
converte_numero:
	movi r3, 1
	beq r6, r3, lcd_1e
	movi r3, 2
	beq r6, r3, lcd_2e
	movi r3, 3
	beq r6, r3, lcd_3e
	movi r3, 4
	beq r6, r3, lcd_4e
	movi r3, 5
	beq r6, r3, lcd_5e

lcd_1e:
	movia r22, Um
	ret

lcd_2e:
	movia r22, Dois
	ret

lcd_3e:
	movia r22, Tres
	ret

lcd_4e:
	movia r22, Quatro
	ret

lcd_5e:
	movia r22, Cinco
	ret

# Converte os pontos do jogador da direita para o hexadecimal correspondente no lcd
converte_numero2:
	movi r3, 1
	beq r7, r3, lcd_1d
	movi r3, 2
	beq r7, r3, lcd_2d
	movi r3, 3
	beq r7, r3, lcd_3d
	movi r3, 4
	beq r7, r3, lcd_4d
	movi r3, 5
	beq r7, r3, lcd_5d

lcd_1d:
	movia r23, Um
	ret

lcd_2d:
	movia r23, Dois
	ret

lcd_3d:
	movia r23, Tres
	ret

lcd_4d:
	movia r23, Quatro
	ret

lcd_5d:
	movia r23, Cinco
	ret
