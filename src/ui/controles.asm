SECTION "Instrucciones de los controles", ROM0

;; Mostrar las dos lineas mientras se espera la primera direccion.
;; M: A, B, DE, HL
controles_mostrar::
    call wait_vblank
    ld hl, controles_texto_salto
    ld de, CONTROLES_POS_SALTO
    ld b, controles_texto_salto_fin - controles_texto_salto
    call memcpy8

    call wait_vblank
    ld hl, controles_texto_giro
    ld de, CONTROLES_POS_GIRO
    ld b, controles_texto_giro_fin - controles_texto_giro
    jp memcpy8

;; Dejar las mismas casillas transparentes/vacias cuando empieza el nivel.
;; IMPORTANTE: solo llamar en nivel 1, porque otros mapas pueden tener
;; plataformas o decoraciones en esas coordenadas.
;; M: A, B, HL
controles_borrar::
    call wait_vblank
    ld hl, CONTROLES_POS_SALTO
    ld a, TILE_FONDO
    ld b, controles_texto_salto_fin - controles_texto_salto
    call memset8

    call wait_vblank
    ld hl, CONTROLES_POS_GIRO
    ld a, TILE_FONDO
    ld b, controles_texto_giro_fin - controles_texto_giro
    jp memset8

;; Cada DB es un ID de tile, no una letra ASCII.
;; 15 caracteres: "PRESS A TO JUMP"
controles_texto_salto:
    DB TILE_LETRA_P, TILE_LETRA_R, TILE_LETRA_E, TILE_LETRA_S, TILE_LETRA_S
    DB TILE_FONDO, TILE_LETRA_A, TILE_FONDO
    DB TILE_LETRA_T, TILE_LETRA_O, TILE_FONDO
    DB TILE_LETRA_J, TILE_LETRA_U, TILE_LETRA_M, TILE_LETRA_P
controles_texto_salto_fin:

;; 14 caracteres: "<- OR -> TO TURN"
controles_texto_giro:
    DB TILE_FLECHA_IZQ, TILE_FONDO, TILE_LETRA_O, TILE_LETRA_R, TILE_FONDO
    DB TILE_FLECHA_DCHA, TILE_FONDO, TILE_LETRA_T, TILE_LETRA_O, TILE_FONDO
    DB TILE_LETRA_T, TILE_LETRA_U, TILE_LETRA_R, TILE_LETRA_N
controles_texto_giro_fin: