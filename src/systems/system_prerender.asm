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
	ld [jugador_y_anterior], a

	ld a, VIDAS_JUGADOR		;; inicializar las vidas
    ld [jugador_vidas], a	;; que tiene el jugador

	ld a, E_MOVE_NONE                   ;; / al comenzar la partida no tendra definida direccion de movimiento
	ld [jugador_direccion_movimiento], a;; \ para evitar que se emieza a mover antes de tiempo

	xor a
	ld [jugador_solicita_salto], a
	ld [jugador_en_suelo], a
	ld [jugador_a_anterior], a
	ld a, JUGADOR_ESPERA_FRAME
	ld [jugador_espera_cambio_frame], a

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

    xor a
	ld [hl+], a         ;; VY = 0 ; HL -> VX

    ld a, VX_JUGADOR
	ld [hl+], a         ;; guardar VX ; HL -> KIND

	ld a, KIND_JUGADOR
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
	;; call get_pos_inicial_jugador_nivel_actual

	ld hl, entity_array ;; hl -> CMP de primera entidad (jugador)
	inc hl ;; HL --> Y

	ld a, [jugador_y]   ;; recuperar Y
	add a, OAM_Y_OFFSET ;; coordenada de OAM
	ld [hl+], a         ;; guardar Y ; HL -> X

	ld a, [jugador_x]   ;; recuperar X
	add a, OAM_X_OFFSET ;; coordenada de OAM
	ld [hl], a          ;; guardar X ; HL -> TILE
ret

jugador_sprite_update::
	;; Modifica el sprite y aplica flip al sprite del jugador
	;; I: -
	;; O: -
	;; M: A, HL
	ld a, [jugador_direccion_movimiento]

	cp E_MOVE_LEFT
	jr nz, .mirar_izquierda	;; NZ -- mira a la izquierda
	
	cp E_MOVE_RIGHT
	jr nz, .mirar_derecha	;; nz --> mira a la derecha 
	
	
	
	jr .actualizar_sprite

	.mirar_izquierda
		ld hl, entity_array + E_ATTR
		set ATTR_BIT_FLIP_X, [hl]
	jr .actualizar_sprite

	.mirar_derecha
		ld hl, entity_array + E_ATTR
		res ATTR_BIT_FLIP_X, [hl]
	;;jr .actualizar_sprite

	.actualizar_sprite
	ld hl, entity_array + E_TILE	;; hl = entidad1_tile <-- entidad jugador
	ld a, [jugador_en_suelo]
	
	and a		;; a == 0? --> comprobar si esta en el suelo
	jr z, .saltando
		;; NZ --> No saltando
		ld a, [hl]
		cp TILE_JUGADOR_SALTO
		jr z, .cambiar_suelo ;; Z --> en ciclo anteriro era tile salto -> modificar a tile_jugador_1 2

	;; En el suelo
	ld a, [jugador_espera_cambio_frame]

	and a	;; a == 0?	--> modificar sprite?
	jr z, .cambiar_frame
		;; NZ --> no modificar sprite
		dec a								;; /
		ld [jugador_espera_cambio_frame], a	;; \ contador--
	ret nz ;;-> contador != 0

	;; contador == 0
	.cambiar_frame
		ld a, [hl]	;; tile actual

		cp TILE_JUGADOR_1
		jr z, .tile_2
			ld a, TILE_JUGADOR_1
			jr .guardar_tile
		.tile_2
			ld a, TILE_JUGADOR_2
		.guardar_tile

		ld [hl], a
		ld a, JUGADOR_ESPERA_FRAME	;; restablecer contador
		ld [jugador_espera_cambio_frame], a
	ret

	;; estado anterior fue saltando, ahora en suelo --> tile 1 por defecto
	.cambiar_suelo
		ld a, TILE_JUGADOR_1
		ld [hl], a
		ld a, JUGADOR_ESPERA_FRAME	;; reseteo de contador
		ld [jugador_espera_cambio_frame], a
	ret

	;; Saltando --> tile saltando
	.saltando
	ld a, TILE_JUGADOR_SALTO
	ld [hl], a
ret

system_jugador_update::
	;; cambio de direccion, pero sin modificar la posicion del jugador. La modifico en system_fisicas.
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
		;; por defecto no hay peticion de salto
		xor a
		ld [jugador_solicita_salto], a

		ld a, [joypad_pressed]
		and 1 << A_BIT ;; lo mismo que 'and %01000000'
		ld b, a ;; guardo el resultado en b para no perderlo

		ld a, [jugador_a_anterior] ;; recupero el estado de A del frame anterior
		ld c, a

		ld a, b ;; recupero el estado de A del frame actual
		ld [jugador_a_anterior], a ;; guardo el estado de A del frame actual para el siguiente frame

		and a
		ret z ;; si no se ha pulsdado A, no hago nada

		ld a, c
		and a
		ret nz ;; si A estaba pulsado en el frame anterior, no hago nada

		ld a, 1
		ld [jugador_solicita_salto], a ;; si A acaba de ser pulsado, se solicita salto
ret

system_jugador_pos_update::
	ld a, [jugador_direccion_movimiento]
	cp E_MOVE_LEFT
	jr z, .izquierda

	.derecha:
		call check_right_wall
		ld a, [jugador_x]
		inc a
		ld [jugador_x], a
		jr .salto

	.izquierda:
		call check_left_wall
		ld a, [jugador_x]
		dec a
		ld [jugador_x], a

	.salto:
;;		ld a, [jugador_tiempo_salto] ;; recupero [jugador_tiempo_salto] y si es distinto de 0 hago que el jugador vaya arriba
;;		cp 0
;;		jr z, .continua
;;		ld a, [jugador_y]
;;		dec a
;;		ld [jugador_y], a

	.continua:

	call system_prerender_pos_jugador
ret