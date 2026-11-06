SECTION "System pantalla", ROM0

sys_pantalla_dibujar::
    ;; Dibuja una pantalla completa: copia sus tiles a la VRAM y su mapa (20x18) al tilemap.
    ;; Se hace con la pantalla apagada. Al encender, la ventana (HUD) queda apagada.
    ;; Ojo: los tiles de la pantalla sustituyen a los del juego, la partida los vuelve a cargar.
    ;; I: HL = pantalla (DW tiles, DW bytes de tiles, mapa de 20x18 fila a fila)
    ;; O: -
    ;; M: A, BC, DE, HL

    ;; la pantalla solo se puede apagar en VBLANK (wait_vblank modifica HL)
    push hl
    call wait_vblank
    pop hl

    xor a
    ldh [rLCDC], a

    ;; DE = tiles de la pantalla, BC = bytes de tiles; HL queda apuntando al mapa
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld d, a
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a

    ;; copiar los tiles al principio de la VRAM (tile 0 en adelante)
    push hl
    ld h, d
    ld l, e
    ld de, TILE_DATA_START
    call memcpy8_bc
    pop hl

    ;; copiar el mapa al tilemap, fila a fila
    ld de, TILEMAP_BG_START
    ld b, PANTALLA_ALTO

    .fila:
        ld c, PANTALLA_ANCHO

        .columna:
            ld a, [hl+]
            ld [de], a
            inc de
            dec c
            jr nz, .columna

        ;; saltar los 12 tiles del tilemap que no se ven para llegar a la fila siguiente
        ld a, e
        add a, TILEMAP_WIDTH - PANTALLA_ANCHO
        ld e, a
        jr nc, .sin_acarreo
        inc d
        .sin_acarreo:

        dec b
        jr nz, .fila

    ld a, LCD_CONFIG
    ldh [rLCDC], a
    ret
