

SECTION "Mapa Nivel Test", ROM0

mapa_nivel_T::
	;; $00 vacio, 
	;; $05 $06 suelo -> pisble, colisiona y no muere se mantiene al jugador encima
	;; $07 pared -> al colisionar con ellas muere el jugador
	;;  01  02  03  04  05  06  07  08  09  10  11  12  13  14  15  16  17  18  19  20 <- X
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=0
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=1
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=2
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=3
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=4
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=5
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=6
	DB $07,$00,$00,$00,$00,$06,$06,$05,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=7
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=8
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=9
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$06,$05,$05,$00,$00,$07 ;; Y=10
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=11
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=12
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=13
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=14
	DB $05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06 ;; Y=15 suelo


mapa_nivel_T_posicion_inicial_jugador::
	;; Posción (X, Y) inicial del jugador dentro del mapa	
	;; La posicion no deve ser mayora al tamaño del mapa
	;;		X > 0 && X < 20
	;;		Y > 0 && Y < 15
	;; =========================================================
	;;  X*8,  Y*8 (pos.px = pos.tile * 8) <-- las posicion se pone en px
	DB  8*8, 14*8

mapa_nivel_T_enemigos::
	;; =================================================
	;; TIPO_ENEMIGO (KIND_FIN_ENEMIGOS_FIJOS, KIND_JUGADOR, KIND_ESCORPION, KIND_MURCIELAGO, KIND_MOMIA, KIND_PINCHOS, KIND_ESTALACTITA, KIND_DARDO)
	;;		Es la mascara KIND que indicara que tipo de enemigo sera, la que 
	;;      se usa para asignar sprite correspondiente y para llamar a su ia correspondiente
	;; =================================================
	;; X*8, Y*8 (POSICION INICIAL DE LA ENTIDAD) 
	;;		Indicaran la posicion inicial de la entidad (enemigo)
	;; 		Las posiciones seran en px (pos.px = pos.tile * 8), para ajustarlo al tile, hay que multiplicar por 8
	;; =================================================
	;; ATTR_FLIP (Valores validos: 0, ATTR_FLIP_X, ATTR_FLIP_Y, ATTR_FLIP_X | ATTR_FLIP_Y)
	;; 		La orientacion de los sprites se tendran que adaptar segun senesidades,
	;; 		teniendo en cuenta que los sprites que dan la vuelta (escorpion/murcielago)
	;; 		al chocar con las paredes laterales, solo invieten su orientación,
	;; 		si el spite esta colocado al reves, se vera al reves en las dos direcciones
	;;   	
	;;		p.e. el sprite de escorpion esta orientado hacia la izquierda, 
	;;   		si vx < 0 --> ATTR_FLIP = 0
	;;   		si vx > 0 --> ATTR_FLIP_X
	;; =================================================
	;; VX, VY (VELOCIDAD?)
	;; 		VX e VY se utilizaria como ¿velocidad de movimiento? de las entidades <-- velocidad en px
	;;
	;; 		PINCHOS: no usa VX y VY como velocidades
	;; 				VX = temporizador de ciclos (en frames) para cambiar de estado
	;; 					 este temporizador lo que se ponga aqui solo afecta al primer cambio de fase
	;;                   para el next ciclo ya sera = PINCHOS_PAUSA_FASE
	;; 					 se puede poner un numero diferente para que no aparente que todos los pinchos se mueven a la vez	
	;; 				VY = fase (poner 0 o 8, no otros valores). 
	;; 					 0-7 : subida ;; 8 --> fin subida
	;; 					 8-15: bajada ;; 0 --> fin bajada <-- llegando a 16 se ponea a 0 
	;; 		ESTALACTITA: no usa VX y VY como velocidades
	;; 				VX = radio de deteccion horizontal (tolerancia de deteccion) en px
	;; 				VY = estado (esperando para caer o cayendo)
	;; 
	;;		ESCORPION y MURCIELAGO: no usa vy como velocidad (solo tienen vx) 
	;; 				VY = contador de cuanto tiempo cambiar de frame
	;; 
	;;		MOMIA: no utiliza vy como velocidad
	;;				VY = contador de movimiento y cambio de frame
	;; =================================================
	;; SEGUNDO_SPAWN (29 --> 1)
	;;		SOLO PARA ENTINADES NO PRE-INICIALIZADAS punto 2
	;;		Indican en el segundo que spawnea al enemigo
	;;		En cada segundo como maximo solo puede spawnear 1 enemigo
	;;		PS: el contador va cuenta hacia atra, por lo que hay que colocar lo de mayor a menor (29 --> 1)
	;; =================================================

	;; =================================================
	;; Consulta el nivel_test.asm para saber que hay que poner para cada parte, 
	;; sobre todo para vx y vy no siempre son velocidades
	;; =================================================
	
	;; 1. Entidades pre-inicializadas <-- Cargadas al entrar al nivel
		;; TIPO_ENEMIGO,      X*8,  Y*8,  VX,  VY, ATTR_FLIP
		DB KIND_ESCORPION,   16*8, 14*8,  -1,   0, 0
		DB KIND_MURCIELAGO,  16*8,  8*8,   2,  30, ATTR_FLIP_X
		DB KIND_PINCHOS,      3*8, 15*8,  37,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,      7*8, 14*8,   8,   8, 0
	
		;; ↓ END NO QUITAR
	DB KIND_FIN_ENEMIGOS_FIJOS
	
	;; 2. Entidanes NO pre-inicializadas <-- Se cargan en un momento determinado
		;;	PS: En cada segundo como maximo solo puede spawnear 1 enemigo
		;;	PSS: el contador va cuenta hacia atra, por lo que hay que colocar lo de mayor a menor (29 --> 1)
		;; =================================================

		;; SEGUNDO_SPAWN, TIPO_ENEMIGO,      X*8,  Y*8,  VX,  VY, ATTR_FLIP
		DB 28,            KIND_ESTALACTITA, 16*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 27,            KIND_MOMIA,        3*8, 14*8,   4, 20, 0
		DB 26,            KIND_MOMIA,       17*8, 14*8,  -4, 20, 0
		DB 25,            KIND_ESTALACTITA,  8*8,  0*8,  16,  0, ATTR_FLIP_Y
	
		;; ↓ END NO QUITAR
	DB LIST_END
mapa_nivel_T_enemigos_fin::