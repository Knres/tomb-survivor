SECTION "System prerender", ROM0



system_prerender_init_entities::
	;; inicializa a cero todas las entidades.
	;; I: -
	;; O: -
	;; M: A, B, HL.
	ld hl, entity_array
	ld b, ENTITY_ARRAY_SIZE
	xor a
jp memset8


system_prerender_init_jugador::
	;; inicializa la primera entidad como jugador desde el spawn del nivel
	;; I: -
	;; O: -
	;; M: A, B, HL.

	call get_pos_inicial_jugador_nivel_actual
    ;;  hl -> X
	ld a, [hl+]         ;; / a = pos x del jugador; 
    ld [jugador_x], a   ;; | hl -> Y
	ld a, [hl]          ;; | a = pos y del jugador
	ld [jugador_y], a   ;; \ 


	ld a, E_MOVE_NONE                   ;; / al comenzar la partida no tendra definida direccion de movimiento
	ld [jugador_direccion_movimiento], a;; \ para evitar que se emieza a mover antes de tiempo 

	ld a, E_MOVE_NONE
	ld [jugador_tiempo_salto], a

	ld hl, entity_array ;; hl -> CMP de primera entidad (jugador)
	ld a, CMP_ALIVE | CMP_INPUT | CMP_COLLIDER | CMP_PHYSICS | CMP_SPRITE
    ld [hl+], a ;; guardar CMP ; HL -> Y

	ld a, [jugador_y]   ;; recuperar Y
	add a, OAM_Y_OFFSET ;; coordenada de OAM
	ld [hl+], a         ;; guardar Y ; HL -> X

	ld a, [jugador_x]   ;; recuperar X
	add a, OAM_X_OFFSET ;; coordenada de OAM
	ld [hl+], a         ;; guardar X ; HL -> TILE 

	ld a, TILE_JUGADOR  
	ld [hl+], a         ;; a = tile jugador ; HL -> ATTR
    
	xor a
	ld [hl+], a         ;; ATTR = 0 ; HL -> VY

    ld a, VY_JUGADOR
	ld [hl+], a         ;; guardar VY ; HL -> VX

    ld a, VX_JUGADOR
	ld [hl+], a         ;; guardar VX ; HL -> KIND

	ld a, KIND_JUGADOR
	ld [hl], a          ;; guardar KIND
ret

system_prerender_init_escorpion::
	ld hl, entity_array + ENTITY_SIZE	;; el enemigo escsorpion es la segunda entidad del array de entidades

	ld a, CMP_ALIVE | CMP_SPRITE
	ld [hl+], a ;; guardar CMP ; HL -> Y

	ld a, 64
	ld [hl+], a         ;; guardar Y ; HL -> X

	ld a, 32
	ld [hl+], a         ;; guardar X ; HL -> TILE 

	ld a, TILE_ESCORPION  
	ld [hl+], a         ;; a = tile enemigo ; HL -> ATTR
    
	xor a
	ld [hl+], a         ;; ATTR = 0 ; HL -> VY

    xor a
	ld [hl+], a         ;; VY = 0

	xor a
	ld [hl+], a         ;; VX = 0

	ld a, KIND_ENEMIGO
	ld [hl], a          ;; guardar KIND
ret

system_prerender_one::
	;; si la entidad en de tiene CMP, copia 4 bytes del sprite a shadow_cursor
    ;; deja shadow_cursor +4 pos. para el siguiente
	;; I: DE = entidad
	;; O: -
	;; M: A, B, HL.
    ld a, [de]      
    and CMP_SPRITE      ;; comprobar si esta CMP_SPRITE
    ret z               ;; no esta activo CMP_SPRITE -> ret

    ld hl, E_SPRITE     ;; 
    add hl, de          ;; HL = &entity.SPRITE

    ld a, [shadow_cursor]   ;; / recuperar cursor
    ld e, a                 ;; |
    ld a, [shadow_cursor+1] ;; | e = byte bajo
    ld d, a                 ;; \ d = byte alto

    ld b, 4                 ;; contador = 4 <-- [Y] [X] [TILE] [ATTR]

    call memcpy8            ;; hl --> de : 4

    ;; memcpy8 de 4 pos
    ld a, e                 ;; / guardar cursor
    ld [shadow_cursor], a   ;; | 
    ld a, d                 ;; | e = byte bajo
    ld [shadow_cursor+1], a ;; \ d = byte alto
ret

system_prerender_update::
	;; prepara shadow_oam, situa shadow_cursor = shadow_oam
    ;; llama a man_entity_for_each para popiar las entidades vivas.
	;; I: -
	;; O: -
	;; M: A, B, DE, HL.
	ld hl, shadow_oam       
    ld a, 0
    ld b, SHADOW_OAM_SIZE   ;; b = contador
    call memset8

    ld a, LOW(shadow_oam)
    ld [shadow_cursor], a   ;; byte bajo
    ld a, HIGH(shadow_oam)
    ld [shadow_cursor+1], a ;; byte alto

	ld hl, system_prerender_one
jp manager_entity_for_each

system_prerender_pos_jugador::
	call get_pos_inicial_jugador_nivel_actual

	ld hl, entity_array ;; hl -> CMP de primera entidad (jugador)
	inc hl ;; HL --> Y 

	ld a, [jugador_y]   ;; recuperar Y
	add a, OAM_Y_OFFSET ;; coordenada de OAM
	ld [hl+], a         ;; guardar Y ; HL -> X

	ld a, [jugador_x]   ;; recuperar X
	add a, OAM_X_OFFSET ;; coordenada de OAM
	ld [hl], a          ;; guardar X ; HL -> TILE 
ret

system_jugador_update:
	;; cambio de direccion
	.izquierda:
		ld a, [joypad_pressed]
		bit LEFT_BIT, a
		jr z, .derecha	;; si no he pulsado left pruebo con right
		ld a, E_MOVE_LEFT
		ld [jugador_direccion_movimiento], a
		jr .salto

	.derecha:
		ld a, [joypad_pressed]
		bit RIGHT_BIT, a
		jr z, .salto ;; si no he presionado nada continuo sin cambios en la direccion
		ld a, E_MOVE_RIGHT
		ld [jugador_direccion_movimiento], a

	;; salto
	.salto:
		ld a, [joypad_pressed]
		bit A_BIT, a
		jr z, .continua_salto
		
		ld a, [jugador_tiempo_salto]
		cp 0
		jr nz, .continua_salto	;; compruebo si ya esta saltando, no puede saltar mientras esta saltando. Si jugador_tiempo_salto vale distinto de 0 prosigue

		;; si no esta saltando, hago que comience a saltar
		ld a, VY_JUGADOR ;; inicializo el valor a 5 frames de salto
		ld [jugador_tiempo_salto], a
		jr .continua

		.continua_salto:
		ld a, [jugador_tiempo_salto]
		cp 0
		jr z, .continua
		dec a ;; actualizo tiempo de salto
		ld [jugador_tiempo_salto], a

	.continua:
		call system_jugador_pos_update
ret

system_jugador_pos_update::
	ld a, [jugador_direccion_movimiento]
	cp E_MOVE_LEFT
	jr z, .izquierda
	
	.derecha:
		ld a, [jugador_x]
		inc a
		ld [jugador_x], a
		jr .salto

	.izquierda:
		ld a, [jugador_x]
		dec a
		ld [jugador_x], a
		
	.salto:
		ld a, [jugador_tiempo_salto] ;; recupero [jugador_tiempo_salto] y si es distinto de 0 hago que el jugador vaya arriba
		cp 0
		jr z, .continua
		ld a, [jugador_y]
		dec a
		ld [jugador_y], a

	.continua:

	call system_prerender_pos_jugador
ret