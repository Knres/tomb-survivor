SECTION "Scene pause", ROM0

scene_pause::
    DW scene_pause_init
    DW scene_pause_update

scene_pause_init::
    
    ld a, [reloj_activo]
    ld [pause_reloj_activo], a  ;; guadar valor actual del reloj

    xor a
    ld [reloj_activo], a        ;; parar reloj

    call wait_vblank
    ld hl, TILEMAP_BG_START
    ld de, pause_saved_tiles
    ld b, 5 ;; PAUSE <-- 5 letras

    .guardar_tiles
        ld a, [hl+]
        ld [de], a  ;; guardar tile que hay detra de las letras pause
        inc de
        dec b
    jr nz, .guardar_tiles

    ;; Dibujar texto PAUSE
    ld hl, TILEMAP_BG_START
    ld a, TILE_LETRA_P
    ld [hl+], a
    ld a, TILE_LETRA_A
    ld [hl+], a
    ld a, TILE_LETRA_U
    ld [hl+], a
    ld a, TILE_LETRA_S
    ld [hl+], a
    ld a, TILE_LETRA_E
    ld [hl], a
ret

scene_pause_update::
    ;; Pulsar start para continuar
    ld a, [joypad_pressed]
    cp 0
    ret z
    call saltar_nivel

    ld a, [joypad_pressed]
    bit START_BIT, a
    ret z

    ld a, [joypad_held]
    bit START_BIT, a
    ret nz

    call wait_vblank
    ld hl, pause_saved_tiles
    ld de, TILEMAP_BG_START
    ld b, 5     ;; PAUSE <- 5 letras
    .restaurar_tiles
        ld a, [hl+] 
        ld [de], a  ;; recuperar tiles guardados
        inc de
        dec b
    jr nz, .restaurar_tiles

    ;; reiniciar reloj
    ld a, [pause_reloj_activo]
    ld [reloj_activo], a
    
    ld a, LOW(scene_ingame_update)
    ld [escena_update], a
    ld a, HIGH(scene_ingame_update)
    ld [escena_update + 1], a
ret

saltar_nivel:
    ld a, [joypad_held]
;    cp %00000011
    bit DOWN_BIT, a
    ret z
    ld b, b
    bit UP_BIT, a
    ret z

    ld b,b 
    ld a, 0
;    ld [reloj_fin_nivel], a

ret