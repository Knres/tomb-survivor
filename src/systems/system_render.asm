SECTION "System render", ROM0

system_render_scroll::
    ;; Actualiza el scroll del fondo con la posicion de camara
    ;; I: -
    ;; O: -
    ;; M: A, BC
    call get_camera_pos     
        ;; b = camera Y
        ;; c = camera X

    ld a, c
    ldh [rSCX], a

    ld a, b
    ldh [rSCY], a
ret

system_render_load_map::
    ;; copia el mapa del nivel actual de ROM --> VRAM
    ;; El mapa del nivel solo se carga una ver
    ;; solo se ejecuta cuado hay un cambio o seleccion de nivel
	;; I: -
	;; O: -
	;; M: A, BC, DE, HL.
	call get_mapa_nivel_actual  ;; hl = dir. mapa elegido
	
    ld de, TILE_MAP_START   ;; de = $9800
	ld b, LEVEL_MAP_HEIGHT  
    ;; b = contador fila (Y)
    ;; c = contador colm (X)
    .fila
	    push bc ;; guardar b para recupearlo al final
	    push hl ;; guardar hl porque se pieder en wait_vblank
	    call wait_vblank
	    pop hl  ;; hl = dir. mapa elegido

	    ld c, LEVEL_MAP_WIDTH   ;; c = contador colm

        .colm
	        ld a, [hl+]
	        ld [de], a
	        inc e       ;; no modifica d, se desplaza dentro de la fila
	        dec c
	    jr nz, .colm
        ;; se ha recorrido ya la fila -> next fila
	    ld a, e                             ;; /
	    add a, TAM_VRAM - LEVEL_MAP_WIDTH   ;; | salto de linea -> next fila
        ld e, a                             ;; \
	    jr nc, .no_carry    ;; NC -> no hay acarreo
        
        ;; si hay acarreo
        inc d

        .no_carry
	        pop bc  ;; b = contador fila (Y)
	    dec b
	jr nz, .fila
ret

system_render_load_tiles::
	;; Copia Tiles ROM --> VRAM.
	;; I: -
	;; O: -
	;; M: A, BC, DE, HL.
	call wait_vblank
	xor a
	ldh[rLCDC],a

	ld hl, tile_data
	ld de, TILE_DATA_START
	ld bc, INITIAL_TILE_BYTES
	call memcpy8_bc

	ld a, LCD_CONFIG
	ldh [rLCDC], a 
	ret

system_render_update::
	;; Copia shadow_oam(WRAM) -> OAM real.
	;; I: -
	;; O: -
	;; M: A, B, DE, HL.
	call wait_vblank

	ld hl, shadow_oam
	ld de, OAM_START
	ld b, SHADOW_OAM_SIZE
jp memcpy8
