SECTION "Aux", ROM0

init_game::
    ;; hace la inicializacion para cuando arranque el juego, 
    ;; prepara todo el entorno para empezar el jugo 
    ;; (¡¡no es inicializar una partida en un nivel!!)
    ;; I: -
    ;; O: -
    ;; M: A, B, DE, HL
    call init_scroll
    call init_palet
    call init_lcd

    call init_oam
    call system_render_load_tiles
ret

init_scroll::
    ;; pone el fondo en pos (0,0)
    ;; I: -
    ;; O: -
    ;; M: A, HL
    xor a           ;; a = 0
    ld [rSCX], a
    ld [rSCY], a
ret

init_hud::
    ;; inicializar ventana el la posicion que hay definida
    ;; I: -
    ;; O: -
    ;; M: A

    call init_window
ret

init_window::
    ;; inicializar ventana el la posicion que hay definida
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, WINDOW_START_X
    ld [rWX], a
    ld a, WINDOW_START_Y
    ld [rWY], a

    call activar_lcd_window
ret

activar_lcd_window::
    ;; activar window en LCDC
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, [rLCDC]
    or LCD_WINDOW_ON
    ld [rLCDC], a
ret

desactivar_lcd_window::
    ;; desactivar window en LCDC
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, [rLCDC]
    and ~LCD_WINDOW_ON ;;~LCD_WINDOW_ON invierte sus bits, modificando solo el bit que hay a 1 en la mascara LCD_WINDOW_ON
    ld [rLCDC], a
ret

init_palet::
    ;; establecer los config de las paletas
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, BGP_CONFIG
    ld [rBGP], a
    ld a, OBJ0P_CONFIG
    ld [rOBJ0P], a
    ld a, OBJ1P_CONFIG
    ld [rOBJ1P], a
ret

init_lcd::
    ;; establece config de lcd
    ;; I: -
    ;; O: -
    ;; M: A
    ld a, LCD_CONFIG
    ld [rLCDC], a
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