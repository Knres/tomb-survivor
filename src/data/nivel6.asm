SECTION "Mapa Nivel 6", ROM0

mapa_nivel_6::
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=0 techo
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=1
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=2
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=3
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=4
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=5
	DB $07,$00,$00,$00,$00,$00,$00,$06,$05,$05,$06,$06,$05,$00,$00,$00,$00,$00,$00,$07 ;; Y=6 plataforma superior
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=7
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=8
	DB $07,$00,$00,$05,$06,$05,$06,$00,$00,$00,$00,$00,$00,$06,$06,$06,$05,$00,$00,$07 ;; Y=9 plataformas laterales
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=10
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=11
	DB $07,$00,$06,$06,$05,$05,$00,$00,$06,$06,$05,$06,$00,$00,$06,$05,$05,$05,$00,$07 ;; Y=12 plataformas inferiores
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=13
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=14
	DB $05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06 ;; Y=15 suelo

mapa_nivel_6_posicion_inicial_jugador::
	;;  X*8,  Y*8 (pos.px = pos.tile * 8)
	DB 17*8, 14*8

mapa_nivel_6_enemigos::
	;; =================================================
	;; Consulta el nivel_test.asm para saber que hay que poner para cada parte, 
	;; sobre todo para vx y vy no siempre son velocidades
	;; =================================================

	;; 1. Entidades pre-inicializadas
		;; TIPO_ENEMIGO,      X*8,  Y*8,  VX,  VY, ATTR_FLIP
		DB KIND_PINCHOS,      3*8, 15*8,  35,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,     14*8, 15*8,  55,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,      8*8, 12*8,  45,   0, ATTR_FLIP_X
		DB KIND_PINCHOS,     13*8,  9*8,  25,   0, ATTR_FLIP_X
;		DB KIND_PINCHOS,     11*8,  6*8,  25,   0, ATTR_FLIP_X
		DB KIND_SERPIENTE,	 18*8, 8*8,    0,  -1, 0
		DB KIND_SERPIENTE,	 1*8,  8*8,    0,   1, ATTR_FLIP_X | ATTR_FLIP_Y
		DB KIND_ESCORPION,    6*8, 14*8,  -1,   0, 0
		DB KIND_MOMIA,       10*8, 14*8,   6,  20, 0
		DB KIND_MURCIELAGO,  10*8,  5*8,   2,  30, ATTR_FLIP_X
		DB KIND_MURCIELAGO,  4*8,  11*8,  -2,  30, 0
		DB KIND_MURCIELAGO,  7*8,  8*8,   2,  30, ATTR_FLIP_X
		DB KIND_MURCIELAGO,  2*8,  4*8,   -2,  30, 0

		;; ↓ END NO QUITAR
	DB KIND_FIN_ENEMIGOS_FIJOS
	
	;; 2. Entidanes NO pre-inicializadas <-- Se cargan en un momento determinado
		;;	PS: En cada segundo como maximo solo puede spawnear 1 enemigo
		;;	PSS: el contador va cuenta hacia atra, por lo que hay que colocar lo de mayor a menor (29 --> 1)
	
		;; SEGUNDO_SPAWN, TIPO_ENEMIGO,      X*8,  Y*8,  VX,  VY, ATTR_FLIP
		DB 28,           KIND_ESTALACTITA,  3*8,  0*8,   16,   0, ATTR_FLIP_Y
		DB 28,           KIND_ESTALACTITA,  5*8,  0*8,   16,   0, ATTR_FLIP_Y
		DB 24, 			 KIND_ESCUDO, 		9*8,  5*8,   15,   0, 0
		
		DB 20,           KIND_ESTALACTITA, 15*8,  0*8,   16,   0, ATTR_FLIP_Y
		
		DB 18, 			 KIND_DARDO,	   18*8, 10*8,   -3,   3, ATTR_FLIP_X
		DB 18, 			 KIND_DARDO,	   18*8, 11*8,   -3,   3, ATTR_FLIP_X
		DB 18, 			 KIND_DARDO,	   18*8, 12*8,   -3,   3, ATTR_FLIP_X
		DB 18, 			 KIND_DARDO,	   18*8, 5*8,   -3,   3, ATTR_FLIP_X
 
		DB 17,           KIND_ESTALACTITA,  4*8,  0*8,   16,   0, ATTR_FLIP_Y
		DB 16,           KIND_ESTALACTITA,  5*8,  0*8,   16,   0, ATTR_FLIP_Y
		DB 16,            KIND_ESTALACTITA, 14*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 16,            KIND_ESTALACTITA,  16*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 16,            KIND_ESTALACTITA, 15*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 16,            KIND_ESTALACTITA,  13*8,  0*8,  16,  0, ATTR_FLIP_Y
		DB 16, 			 KIND_DARDO,	   18*8, 5*8,   -3,   3, ATTR_FLIP_X
		DB 10, 			 KIND_DARDO,	   18*8,  7*8,   -3,   3, ATTR_FLIP_X
		DB 10, 			 KIND_DARDO,	   18*8,  8*8,   -3,   3, ATTR_FLIP_X
		DB 10, 			 KIND_DARDO,	   18*8,  9*8,   -3,   3, ATTR_FLIP_X
		DB 10, 			 KIND_DARDO,	   18*8, 5*8,   -3,   3, ATTR_FLIP_X
 
		;; ↓ END NO QUITAR
	DB LIST_END 
mapa_nivel_6_enemigos_fin::