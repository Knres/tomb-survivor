

SECTION "Mapa Nivel 1", ROM0

mapa_nivel_1::
	;; $00 vacio, 
	;; $05 $06 suelo -> pisble, colisiona y no muere se mantiene al jugador encima
	;; $07 pared -> al colisionar con ellas muere el jugador
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=0 techo
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=1
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=2
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=3
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$05,$00,$00,$00,$00,$00,$00,$07 ;; Y=4
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=5
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=6
	DB $07,$00,$00,$00,$00,$06,$06,$05,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=7
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=8
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=9
	DB $07,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$06,$06,$05,$05,$00,$00,$07 ;; Y=10
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=11
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=12
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=13
	DB $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07 ;; Y=14
	DB $05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06,$05,$06 ;; Y=15 suelo


mapa_nivel_1_posicion_inicial_jugador::
	;; las posiciones no pueden ser mayores que el mapa (quedarian fuera)
	;; se cargara en la entidad 1 siempre
	
	;; X  , Y (estan en px, pixeles = tiles * 8 )
	DB 8*8, 14*8

mapa_nivel_1_enemigos::
	;; Las orientaciones de los sprites se tendran que cambiar segun la direccion (vx o vy)
	;; por lo que hay que aplicarle un ATTR_FLIP_X o ATTR_FLIP_Y (0 si no tiene).
	;;   	p.e. el sprite de escorpion esta orientado hacia la izquierda, 
	;;   	si vx < 0 --> ATTR_FLIP = 0
	;;   	si vx > 0 --> ATTR_FLIP_X
	;; tanto x, y, vx, xy estan en px.
	
	;; ================================================
	;; Especial PINCHOS no usa VX y VY como velocidades
		;; VX = temporizador de ciclos (en frames) para cambiar de estado
			;; este temporizador lo que se ponga aqui solo afecta al primer cambio de fase
			;; para el next ciclo ya sera = PINCHOS_PAUSA_FASE
			;; se puede poner un numero diferente para que no aparente que todos los pinchos se mueven a la vez	
		;; VY = fase (poner 0 o 8, no otros valores). 
								;; 0-7 : subida ;; 8 --> fin subida
								;; 8-15: bajada ;; 0 --> fin bajada <-- llegando a 16 se ponea a 0 
	;; =================================================

	;; TIPO_ENEMIGO,        X,    Y,  VX, VY, ATTR_FLIP
	DB KIND_ESCORPION,   16*8, 14*8,  -1,  0, 0
	DB KIND_MURCIELAGO,  16*8,  8*8,   2,  0, ATTR_FLIP_X
	
	DB KIND_PINCHOS,      3*8, 15*8,  37,  0, ATTR_FLIP_Y
	DB KIND_PINCHOS,      7*8, 14*8,   8,  8, ATTR_FLIP_Y
	DB KIND_FIN_ENEMIGOS
mapa_nivel_1_enemigos_fin::