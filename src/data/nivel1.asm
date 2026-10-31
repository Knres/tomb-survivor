

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
	;; PINCHOS no usa VX y VY como velocidades
		;; VX = temporizador de ciclos (en frames) para cambiar de estado
			;; este temporizador lo que se ponga aqui solo afecta al primer cambio de fase
			;; para el next ciclo ya sera = PINCHOS_PAUSA_FASE
			;; se puede poner un numero diferente para que no aparente que todos los pinchos se mueven a la vez	
		;; VY = fase (poner 0 o 8, no otros valores). 
								;; 0-7 : subida ;; 8 --> fin subida
								;; 8-15: bajada ;; 0 --> fin bajada <-- llegando a 16 se ponea a 0 
	;; =================================================
	;; ESTALACTITA no usa VX y VY como velocidades
			;; VX = radio de deteccion horizontal (tolerancia de deteccion) en px
			;; VY = estado (esperando para caer o cayendo)
	;; Como Escorpion y Murcielago solo tienen vx, 
			;; VY = contador de cuanto tiempo cambiar de frame
	;; Momia utilizara vy como contador de movimiento y cambio de frame
	;; =================================================
		
	;; TIPO_ENEMIGO,        X,    Y,  VX, VY, ATTR_FLIP (en caso de girar en dos 2 direccion "ATTR_FLIP_X | ATTR_FLIP_Y")
	DB KIND_ESCORPION,   16*8, 14*8,  -1,  0, 0
	DB KIND_MURCIELAGO,  16*8,  8*8,   2,  30, ATTR_FLIP_X
	
	DB KIND_PINCHOS,      3*8, 15*8,  37,  0, ATTR_FLIP_X
	DB KIND_PINCHOS,      7*8, 14*8,   8,  8, 0

	DB KIND_ESTALACTITA, 13*8,  0*8,  2,  3, ATTR_FLIP_Y
	DB KIND_DARDO, 		  1*8,  2*8,  2,  3, ATTR_FLIP_Y ;; el dardo recibe en vy el temporizador para que salga propulsado. Asi el jugador ve que va a salir un dardo pero no sabe cuando
	DB KIND_DARDO, 		  18*8,  2*8,  -2,  3, ATTR_FLIP_Y ;; el dardo recibe en vy el temporizador para que salga propulsado. Asi el jugador ve que va a salir un dardo pero no sabe cuando
	DB KIND_FIN_ENEMIGOS_FIJOS
	
	;; ↓↓↓ ENEMIGOS NO PRE-INICIALIZADOS
	;; ¡¡En cada segundo solo se puede hacer un spawn!!
	;; Segundo, spawn TIPO_ENEMIGO,        X,    Y,  VX, VY, ATTR_FLIP (en caso de girar en dos 2 direccion "ATTR_FLIP_X | ATTR_FLIP_Y")
	DB 28,            KIND_ESTALACTITA, 16*8,  0*8,  16,  0, ATTR_FLIP_Y
	DB 27,            KIND_MOMIA,        3*8, 14*8,   4, 20, 0
	DB 26,            KIND_MOMIA,       17*8, 14*8,  -4, 20, 0
	DB 25,             KIND_ESTALACTITA,  8*8,  0*8,  16,  0, ATTR_FLIP_Y
	DB LIST_END
	


mapa_nivel_1_enemigos_fin::