;; Gestor de niveles: seleccion y carga del mapa en VRAM.

SECTION "Manager de nivel", ROM0

get_mapa_nivel_actual::
	;; Lee de "nivel_actual" el numero de nivel y 
	;; guarda en hl la dir. mapa de ese nivel
	;; I: -
	;; O: HL = direccion del mapa seleccionado.
	;; M: A, HL.
	ld a, [nivel_actual]

	cp 1
	jr c, .nivel_invalido
	cp 10
	jr nc, .nivel_invalido

	cp 1
	jr z, .nivel_1
	
	cp 2
	jr z, .nivel_2
	
	cp 3
	jr z, .nivel_3
	
	cp 4
	jr z, .nivel_4
	
	cp 5
	jr z, .nivel_5
	
	cp 6
	jr z, .nivel_6
	
	cp 7
	jr z, .nivel_7
	
	cp 8
	jr z, .nivel_8
	

	.nivel_invalido
	ld a, 1
	ld [nivel_actual], a

	.nivel_1
		ld hl, mapa_nivel_1
	ret
	.nivel_2
		ld hl, mapa_nivel_2
	ret
	.nivel_3
		ld hl, mapa_nivel_3
	ret
	.nivel_4
		ld hl, mapa_nivel_4
	ret
	.nivel_5
		ld hl, mapa_nivel_5
	ret
	.nivel_6
		ld hl, mapa_nivel_6
	ret
	.nivel_7
		ld hl, mapa_nivel_7
	ret
	.nivel_8
		ld hl, mapa_nivel_8
	ret

get_pos_inicial_jugador_nivel_actual::
	;; Lee de "nivel_actual" el numero de nivel y 
	;; guarda en hl la dir. pos_inicial_jugador de ese nivel
	;; I: -
	;; O: HL = direccion del mapa seleccionado.
	;; M: A, HL.
	ld a, [nivel_actual]

	cp 1
	jr c, .nivel_invalido
	cp 10
	jr nc, .nivel_invalido

	cp 1
	jr z, .nivel_1
	
	cp 2
	jr z, .nivel_2
	
	cp 3
	jr z, .nivel_3
	
	cp 4
	jr z, .nivel_4

	cp 5
	jr z, .nivel_5

	cp 6
	jr z, .nivel_6
	
	cp 7
	jr z, .nivel_7
	
	cp 8
	jr z, .nivel_8
	

	.nivel_invalido
	ld a, 1
	ld [nivel_actual], a

	.nivel_1
		ld hl, mapa_nivel_1_posicion_inicial_jugador
	ret
	
	.nivel_2
		ld hl, mapa_nivel_2_posicion_inicial_jugador
	ret

	.nivel_3
		ld hl, mapa_nivel_3_posicion_inicial_jugador
	ret
	
	.nivel_4
		ld hl, mapa_nivel_4_posicion_inicial_jugador
	ret
	
	.nivel_5
		ld hl, mapa_nivel_5_posicion_inicial_jugador
	ret
	
	.nivel_6
		ld hl, mapa_nivel_6_posicion_inicial_jugador
	ret
	
	.nivel_7
		ld hl, mapa_nivel_7_posicion_inicial_jugador
	ret
	
	.nivel_8
		ld hl, mapa_nivel_8_posicion_inicial_jugador
	ret
	
ret

get_enemigos_nivel_actual::
	;; Devuelve el inicio de la tabla de enemigos del nivel actual.
	;; I: -
	;; O: HL = direccion del primer registro KIND, X, Y, VX, VY, ATTR.
	;; M: A, HL
	ld a, [nivel_actual]

	cp 1
	jr c, .nivel_invalido	;; > 0

	cp 10
	jr nc, .nivel_invalido	;; < 10

	cp 1
	jr z, .nivel_1
	
	cp 2
	jr z, .nivel_2
	
	cp 3
	jr z, .nivel_3
	
	cp 4
	jr z, .nivel_4
	
	cp 5
	jr z, .nivel_5
	
	cp 6
	jr z, .nivel_6
	
	cp 7
	jr z, .nivel_7
	
	cp 8
	jr z, .nivel_8
	

	.nivel_invalido
	ld a, 1
	ld [nivel_actual], a

	.nivel_1
		ld hl, mapa_nivel_1_enemigos
	ret
	
	.nivel_2
		ld hl, mapa_nivel_2_enemigos
	ret
	
	.nivel_3
		ld hl, mapa_nivel_3_enemigos
	ret
	
	.nivel_4
		ld hl, mapa_nivel_4_enemigos
	ret
	
	.nivel_5
		ld hl, mapa_nivel_5_enemigos
	ret
	
	.nivel_6
		ld hl, mapa_nivel_6_enemigos
	ret
	
	.nivel_7
		ld hl, mapa_nivel_7_enemigos
	ret
	
	.nivel_8
		ld hl, mapa_nivel_8_enemigos
	ret
	
ret