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