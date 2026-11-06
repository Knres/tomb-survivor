SECTION "System pantalla", ROM0

sys_pantalla_dibujar::
    ;; Dibuja una pantalla completa: copia sus tiles a la VRAM y su mapa (20x18) al tilemap.
    ;; Se hace con la pantalla apagada. Al encender, la ventana (HUD) queda apagada.
    ;; Ojo: los tiles de la pantalla sustituyen a los del juego, la partida los vuelve a cargar.
    ;; I: HL = pantalla (DW tiles, DW bytes de tiles, mapa de 20x18 fila a fila)
    ;; O: -
    ;; M: A, BC, DE, HL
	push hl
	call wait_vblank
	pop hl
	
	xor a
	ldh [rLCDC], a
	
	ld a, [hl+]
	ld e, a
	ld a, [hl+]
	ld d, a
	
	ld a, [hl+]
	ld c, a
	ld a, [hl+]
	ld b, a

	push hl
	ld h, d
	ld l, e
	ld de, TILE_DATA_START
	call memcpy8_bc
	pop hl
	
	ld de, TILEMAP_BG_START
	ld b, PANTALLA_ALTO
	
	.fila
		ld c, PANTALLA_ANCHO
		.columna
			ld a, [hl+]
			ld [de], a
			inc de
			dec c
			jr nz, .columna
		ld a, e
		add TILEMAP_WIDTH - PANTALLA_ANCHO
		ld e, a
		jr nc, .sin
		inc d
		.sin:
		
		dec b
		jr nz, .fila

	ld a, LCD_CONFIG
	ldh [rLCDC], a
	ret
