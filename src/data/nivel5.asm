SECTION "Mapa Nivel 5", ROM0

mapa_nivel_5::
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=0 techo
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=1
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=2
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=3
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=4
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=5
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=6
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=7
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=8
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=9
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=10
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=11
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=12
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=13
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=14
	DB $05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06 ;; Y=15 suelo

mapa_nivel_5_posicion_inicial_jugador::
	;;  X*8,  Y*8 (pos.px = pos.tile * 8)
	DB  8*8, 14*8

mapa_nivel_5_enemigos::
	;; =================================================
	;; Consulta el nivel_test.asm para saber que hay que poner para cada parte, 
	;; sobre todo para vx y vy no siempre son velocidades
	;; =================================================

	;; 1. Entidades pre-inicializadas
		;; TIPO_ENEMIGO,      X*8,  Y*8,  VX,  VY, ATTR_FLIP
		;; ↓ END NO QUITAR
;	DB KIND_PINCHOS,      1*8, 14*8,  30,   8, ATTR_FLIP_X
;	DB KIND_PINCHOS,      18*8, 14*8,  30,   8, ATTR_FLIP_X
	DB KIND_FIN_ENEMIGOS_FIJOS
	
	;; 2. Entidanes NO pre-inicializadas <-- Se cargan en un momento determinado
		;;	PS: En cada segundo como maximo solo puede spawnear 1 enemigo
		;;	PSS: el contador va cuenta hacia atra, por lo que hay que colocar lo de mayor a menor (29 --> 1)
	
		;; SEGUNDO_SPAWN, TIPO_ENEMIGO,      X*8,  Y*8,  VX,  VY, ATTR_FLIP
		;;DB 25,            KIND_ESTALACTITA,  8*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 29,				KIND_DARDO, 	 18*8,  14*8, -3, 	3, ATTR_FLIP_X
		DB 29,				KIND_DARDO, 	 1*8,  14*8, 3, 	3, 0
		DB 28,				KIND_DARDO, 	 18*8,  13*8, -3, 	3, ATTR_FLIP_X
		DB 28,				KIND_DARDO, 	 1*8,  13*8, 3, 	3, 0
		DB 27,				KIND_DARDO, 	 18*8,  12*8, -3, 	2, ATTR_FLIP_X
		DB 27,				KIND_DARDO, 	 1*8,  12*8, 3, 	2, 0

		DB 24,				KIND_DARDO, 	 1*8,  13*8, 3, 	3, 0
		DB 24,				KIND_DARDO, 	 1*8,  10*8, 3, 	3, 0
		DB 24,				KIND_DARDO, 	 1*8,  14*8, 3, 	3, 0
			

		DB 22,				KIND_DARDO, 	 18*8,  13*8, -3, 	3, ATTR_FLIP_X
		DB 22,				KIND_DARDO, 	 18*8,  10*8, -3, 	3, ATTR_FLIP_X
		DB 22,				KIND_DARDO, 	 18*8,  14*8, -3, 	3, ATTR_FLIP_X
		
		DB 20,				KIND_DARDO, 	 18*8,  14*8, -3, 	3, ATTR_FLIP_X
		DB 19,				KIND_DARDO, 	 1*8,  13*8, 3, 	3, 0
		DB 18,				KIND_DARDO, 	 18*8,  12*8, -3, 	3, ATTR_FLIP_X
		DB 18,				KIND_DARDO, 	 1*8,  14*8, 3, 	3, 0

		DB 15,				KIND_DARDO, 	 1*8,  14*8, 3, 	3, 0
		DB 15,				KIND_DARDO, 	 18*8,  14*8, -3, 	3, ATTR_FLIP_X
		DB 14,				KIND_DARDO, 	 1*8,  13*8, 3, 	3, 0
		DB 13,				KIND_DARDO, 	 1*8,  12*8, 3, 	3, 0
		DB 13,				KIND_DARDO, 	 18*8,  14*8, -3, 	3, ATTR_FLIP_X

		DB 12,				KIND_DARDO, 	 18*8,  12*8, -3, 	3, ATTR_FLIP_X
		DB 12,				KIND_DARDO, 	 1*8,  14*8, 3, 	3, 0
		DB 11,				KIND_DARDO, 	 18*8,  13*8, -3, 	3, ATTR_FLIP_X
		DB 10,				KIND_DARDO, 	 18*8,  14*8, -3, 	3, ATTR_FLIP_X
		DB 10,				KIND_DARDO, 	 1*8,  14*8, 3, 	3, 0

		DB 9,				KIND_DARDO, 	 18*8,  13*8, -3, 	3, ATTR_FLIP_X
		DB 8,				KIND_DARDO, 	 1*8,  13*8, 3, 	3, 0
		DB 8,				KIND_DARDO, 	 18*8,  14*8, -3, 	3, ATTR_FLIP_X
		DB 7,				KIND_DARDO, 	 1*8,  14*8, 3, 	3, 0

		DB 5,				KIND_DARDO, 	 1*8,  14*8, 3, 	3, 0
		DB 5,				KIND_DARDO, 	 18*8,  14*8, -3, 	3, ATTR_FLIP_X
		DB 4,				KIND_DARDO, 	 1*8,  14*8, 3, 	3, 0
		DB 4,				KIND_DARDO, 	 18*8,  14*8, -3, 	3, ATTR_FLIP_X
		DB 3,				KIND_DARDO, 	 1*8,  14*8, 3, 	2, 0
		DB 3,				KIND_DARDO, 	 18*8,  14*8, -3, 	2, ATTR_FLIP_X
		

		;; ↓ END NO QUITAR
	DB LIST_END 
mapa_nivel_5_enemigos_fin::