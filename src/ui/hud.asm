SECTION "HUD", ROM0

camera_axis::
    ;; Calcula la posicion de camara en un eje y la limita al rango permitido
    ;; I: A = posicion; B = offset; C = posicion maxima de camara
    ;; O: A = posicion de camara
    ;; M: A, BC

    sub b                   ;; a = a - b
                            ;; camara = posicion - offset
    jr nc, .not_negative    ;; NC -> no es negativo 
        xor a               ;;  C -> negativo a = 0 & ret
    ret                     ;; 
    
    .not_negative           ;; a = a - b
    cp c                    ;; a < c ? 
    ret c                   ;; C --> a < c --> ret valor A actual (camara = poscion -offset)

    ;; NC -> a > c -->  ret valor c (max camara)
    ld a, c
ret

get_camera_pos::
    ;; Devuelve las posiciones (x, y) de al camara
    ;; I: -
    ;; O: B = camara_Y; C = camara_X
    ;; M: A, BC
    ld a, [jugador_x]
    ld b, PANTALLA_ANCHO * TILE_SIZE / 2
    ld c, CAMERA_MAX_X
    call camera_axis
    ld c, a

    ld a, [jugador_y]
    ld b, PANTALLA_ALTO * TILE_SIZE / 2
    ld c, CAMERA_MAX_Y
    call camera_axis
    ld b, a
ret



hud_show::
    ;; Activar windows y posicionar hud
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, HUD_WINDOW_X
    ldh [rWX], a

    ld a, HUD_WINDOW_Y
    ldh [rWY], a
jp activar_lcd_window

init_hud::
    ;; inicializar el hud
    ;; I: -
    ;; O: -
    ;; M: A, BC, HL
    call hud_show
    call wait_vblank

    ;; porner a 0
        ld hl, TILEMAP_HUD_START
        xor a
        ld b, PANTALLA_ANCHO
        call memset8

        ld hl, TILEMAP_HUD_START + TILEMAP_WIDTH
        xor a
        ld b, PANTALLA_ANCHO
        call memset8
    
    ;; texto_nivel
    ld hl, HUD_TEXTO_NIVEL
    ld a, TILE_LETRA_L
    ld [hl+], a
    ld a, TILE_LETRA_E
    ld [hl+], a
    ld a, TILE_LETRA_V
    ld [hl+], a
    ld a, TILE_LETRA_E
    ld [hl+], a
    ld a, TILE_LETRA_L
    ld [hl+], a
    
    ld a, [nivel_actual]    ;; numero de nivel
    call digit2tile         ;; convertir a tile
    ld [hl], a

    call hud_draw_clock
jp hud_draw_hearts

hud_draw_clock::
    ;; Dibuja los segundos restantes como dos digitos.
    ;; I: -
    ;; O: -
    ;; M: A, BC, HL
    ld a, [reloj_fin_nivel]
    ld b, 0

    ;; b -> decenas
    ;; c -> unidades
    
    .decenas
        ;; calculo de decenas
        cp 10
        jr c, .end_decenas
        ;; NC que dan 
        sub 10      ;; / a - 10
        inc b       ;; \ decenas++
    jr .decenas
    .end_decenas

    ld c, a         ;; valor restante --> unidades
    call wait_vblank

    ;; decenas
    ld a, b
    call digit2tile
    ld [HUD_CONTADOR_TIEMPO], a

    ;; unidades
    ld a, c
    call digit2tile
    ld [HUD_CONTADOR_TIEMPO + 1], a
ret

hud_draw_hearts::
    ;; Dibujar las vidas que tiene el jugador
    ;; I: - 
    ;; O: - 
    ;; M: A, BC, HL
    ld a, [jugador_vidas]
    ;; ld a, 1
    ld c, a
    
    call wait_vblank
    ld b, VIDAS_JUGADOR         ;; contador de vidas max que puede tener el jugador
    ld hl, HUD_VIDAS_JUGADOR    ;; HL = primera celda de corazones
    
    .do_while
        ld a, c                 ;; a = corazones que tiene
        or a                    ;; a == 0 ?
        ld a, TILE_NO_CORAZON   ;; a <-- tile de corazon vacio (por defecto)

        jr z, .dibujar          ;; a == 0 -> Z
            ;; a > 0 --> le que dan vidas

            ld a, TILE_CORAZON          ;; a <-- tile de corazon relleno
            dec c                       ;; c--
        .dibujar                
        ld [hl+], a             ;; dibujar corazon; hl -> next corazon
        dec b                   ;; b--
    jr nz, .do_while            ;; b > 0  -> se pueden dibujar más --> volver 

    ;; b == 0 -> se ha alcanzaro el maximo de corezones 
    ;;           que se pueden dibujar -> salir
ret