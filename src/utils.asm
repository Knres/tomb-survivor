SECTION "Aux", ROM0

init_game::
    ;; hace la inicializacion para cuando arranque el juego, 
    ;; prepara todo el entorno para empezar el jugo 
    ;; (¡¡no es inicializar una partida en un nivel!!)
    ;; I: -
    ;; O: -
    ;; M: A, BC, DE, HL
    ;; call init_reloj ;;<-- se ha movideo ingame (init game es la inicializacion del juego, no del nivel)
    ld a, VIDAS_JUGADOR
    ld [jugador_vidas], a

    ld a, 1
    ld [nivel_actual], a

    xor a
    ld [hay_partida], a

    call init_scroll
    call init_palet
    call init_lcd
    call sys_sound_init
    call sys_music_stop

    call init_oam
    call system_render_load_tiles
ret


init_scroll::
    ;; pone el fondo en pos (0,0)
    ;; I: -
    ;; O: -
    ;; M: A, HL
    xor a           ;; a = 0
    ldh [rSCX], a
    ldh [rSCY], a
ret


init_window::
    ;; inicializar ventana el la posicion que hay definida
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, WINDOW_START_X
    ldh [rWX], a
    ld a, WINDOW_START_Y
    ldh [rWY], a

    call activar_lcd_window
ret

activar_lcd_window::
    ;; activar window en LCDC
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, [rLCDC]
    or LCD_WINDOW_ON
    ldh [rLCDC], a
ret

desactivar_lcd_window::
    ;; desactivar window en LCDC
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, [rLCDC]
    and ~LCD_WINDOW_ON ;;~LCD_WINDOW_ON invierte sus bits, modificando solo el bit que hay a 1 en la mascara LCD_WINDOW_ON
    ldh [rLCDC], a
ret

init_palet::
    ;; establecer los config de las paletas
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, BGP_CONFIG
    ldh [rBGP], a
    ld a, OBJ0P_CONFIG
    ldh [rOBJ0P], a
    ld a, OBJ1P_CONFIG
    ldh [rOBJ1P], a
ret

init_lcd::
    ;; establece config de lcd
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, LCD_CONFIG
    ldh [rLCDC], a
ret

init_oam::
    ;; inicializar OAM (40 sprites)
    ;; I: -
    ;; O: -
    ;; M: A, B, HL
    call wait_vblank

    ld hl, OAM_START    ;; dir por la que comienza
    xor a               ;; a = 0
    ld b, OAM_SIZE      ;; contador
jp memset8

init_reloj::
    ;; inicializar reloj de tiempo real
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, 0
    ld [frame_actual], a
    call resetear_reloj
    call desactivar_reloj
ret

wait_vblank::
    ;; espera el inicio de vblank
    ;; I: -
    ;; o: -
    ;; M: HL, A
    ld hl, rLY

    .do_while:
        ld a, [hl]
        cp VBLANK_START
    jr nz, .do_while
ret

memcpy8::
    ;; copia los valores de hl a de, con un contador que es b
    ;; I: HL origen
    ;; I: DE destino
    ;; I: B contador
    ;; O: -
    ;; M: HL, DE, B, A
    ld a, [hl+]
    ld [de], a

    inc de
    dec b
    jr nz, memcpy8
ret

memcpy8_bc::
    ;; copia los valores de hl -> de, con un contador bc
    ;; I: HL = origen; DE = destino; BC = cantidad de bytes.
    ;; O: -
    ;; M: A, BC, DE, HL
    .do_while
        ld a, [hl+]
        ld [de], a

        inc de
        dec bc      ;; dec bc no activa flags
        
        ld a, b
        or c        ;; (a == 0 || c == 0) ?
    jr nz, .do_while
ret

memset8::
    ;; hl = a <-- con contador b
    ;; I: HL = destino; A = valor a poner; B = cantidad de bytes.
    ;; O: -
    ;; M: B, HL
    .do_while
        ld [hl+], a

        dec b
    jr nz, .do_while
ret

call_hl::
    ;; salta a dir. indicada en hl, hace return
    ;; I: HL = direccion de la rutina.
    ;; O: -
    ;; M: PC
jp hl

digit2tile::
    ;; Convierte un digito a su indice de tile numerico.
    ;; I: A = digito (depende de las que hay hechas en gfx.asm)
    ;; O: A = indice del tile
    ;; M: A, flags
    add a, TILE_NUM_0
ret

