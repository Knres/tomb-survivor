SECTION "Mapa Nivel 7", ROM0

mapa_nivel_7::
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=0 techo
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=1
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=2
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=3
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=4
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=5
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=6
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=7
	DB $07,$00,$00,$00,$00,$00,$00,$06,$05,$05,$06,$06,$05,$00,$00,$00,$00,$00,$00,$07 ;; Y=8 plataforma superior
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=9 plataformas laterales
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=10
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=11
	DB $07,$00,$06,$06,$05,$05,$00,$00,$00,$00,$00,$00,$00,$00,$06,$05,$05,$05,$00,$07 ;; Y=12 plataformas inferiores
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=13
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=14
	DB $05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06 ;; Y=15 suelo

mapa_nivel_7_posicion_inicial_jugador::
	;;  X*8,  Y*8 (pos.px = pos.tile * 8)
	DB  8*8, 14*8

mapa_nivel_7_enemigos::
	;; =================================================
	;; Consulta el nivel_test.asm para saber que hay que poner para cada parte, 
	;; sobre todo para vx y vy no siempre son velocidadess
	;; =================================================

	;; 1. Entidades pre-inicializadas
		;; TIPO_ENEMIGO,      X*8,  Y*8,  VX,  VY, ATTR_FLIP
		DB KIND_PINCHOS,      1*8, 15*8,  10,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,      3*8, 15*8,  20,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,      5*8, 15*8,  30,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,      7*8, 15*8,  40,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,      9*8, 15*8,  50,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,      10*8, 15*8,  60,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,      12*8, 15*8,  70,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,      14*8, 15*8,  80,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,      16*8, 15*8,  90,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,      18*8, 15*8,  100,   0, ATTR_FLIP_X
		DB KIND_MURCIELAGO,   7*8, 9*8,  2,   30, ATTR_FLIP_X
		DB KIND_MURCIELAGO,   8*8, 10*8,  2,   30, ATTR_FLIP_X
		DB KIND_MURCIELAGO,   9*8, 11*8,  2,   30, ATTR_FLIP_X
		DB KIND_MURCIELAGO,   9*8, 6*8,  2,   30, ATTR_FLIP_X
		;; ↓ END NO QUITAR
	DB KIND_FIN_ENEMIGOS_FIJOS
	
	;; 2. Entidanes NO pre-inicializadas <-- Se cargan en un momento determinado
		;;	PS: En cada segundo como maximo solo puede spawnear 1 enemigo
		;;	PSS: el contador va cuenta hacia atra, por lo que hay que colocar lo de mayor a menor (29 --> 1)
	
		;; SEGUNDO_SPAWN, TIPO_ENEMIGO,      X*8,  Y*8,  VX,  VY, ATTR_FLIP
		;;DB 25,            KIND_ESTALACTITA,  8*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 24,            KIND_ESTALACTITA,  8*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 23,            KIND_ESTALACTITA,  9*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 21,            KIND_ESTALACTITA,  10*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 20,            KIND_ESTALACTITA,  8*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 18,            KIND_ESTALACTITA,  7*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 18,            KIND_ESTALACTITA,  11*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 18,            KIND_DARDO,  	     1*8,  6*8,  3,  3, 0
		DB 18,            KIND_DARDO,  		 18*8, 7*8,  -3,  3, ATTR_FLIP_X
		DB 18,            KIND_ESTALACTITA,  8*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 16,            KIND_ESTALACTITA,  8*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 16,            KIND_ESCUDO,  	 4*8,  11*8,  3,  0, 0
		DB 14,            KIND_ESTALACTITA,  10*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 12,            KIND_ESCUDO,  	 15*8,  11*8,  3,  0, 0
		DB 9,            KIND_DARDO,  		 18*8, 7*8,  -3,  3, ATTR_FLIP_X
		DB 9,            KIND_DARDO,  		 1*8, 7*8,    3,  3, 0
		DB 8,            KIND_DARDO,  		 18*8, 7*8,  -3,  3, ATTR_FLIP_X
		DB 8,            KIND_DARDO,  		 1*8, 7*8,    3,  3, 0
		DB 5,            KIND_DARDO,  		 18*8, 7*8,  -3,  3, ATTR_FLIP_X
		DB 5,            KIND_DARDO,  		 1*8, 7*8,  3,  3, 0
			
		;; ↓ END NO QUITAR


	DB LIST_END 
mapa_nivel_7_enemigos_fin::