SECTION "Scene menu", ROM0

;; Escena de titulo
scene_menu::
    DW scene_menu_init
    DW scene_menu_update

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Entra en el titulo: quita los sprites y dibuja la pantalla.
;; Al encender con LCD_CONFIG, el HUD (ventana) queda apagado.
;; I: -
;; O: -
;; M: A, BC, DE, HL
scene_menu_init::
    ld   hl, shadow_oam
    xor  a
    ld   b, SHADOW_OAM_SIZE
    call memset8

    ld a, 1
    ld [menu_start_anterior], a

    ld hl, musica_titulo
    call sys_music_play

    ld   hl, pantalla_titulo
    call   sys_pantalla_dibujar

    ld a, $FF
    ld [menu_dpad_anterior], a

    ld a, [hay_partida]
    and a
    jr z, .no_partida
    ld a, OPCION_RESUME
    ld [menu_opcion], a
    jp menu_dibujar_barra

    ;; Sin partida solo se puede empezar: se tapa RESUME/RESTART
    ;; con START centrado y no se pone barra.
    .no_partida:
        call wait_vblank
        ld hl, pantalla_titulo_start
        ld de, POS_RECUADRO_MENU
        ld b, 8
        call memcpy8
        ld de, POS_RECUADRO_MENU + 32
        ld b, 8
        call memcpy8
        ld a, OPCION_RESTART
        ld [menu_opcion], a
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pone la barra gris encima de la opcion que NO esta elegida.
;; Son sprites detras del fondo: solo se ven donde el fondo es blanco,
;; asi que las letras siguen encima y las esquinas del recuadro la redondean.
;; Se escribe en shadow_oam: system_render_update la copia a la OAM en VBlank.
;; I: -
;; O: -
;; M: A, BC, D, HL
menu_dibujar_barra:
    ld b, MENU_BARRA_Y_RESTART          ;; RESUME elegido -> se apaga RESTART
    ld a, [menu_opcion]
    cp OPCION_RESUME
    jr z, .poner
    ld b, MENU_BARRA_Y_RESUME           ;; RESTART elegido -> se apaga RESUME

    .poner:
    ld hl, shadow_oam
    ld c, MENU_BARRA_X
    ld d, MENU_BARRA_SPRITES
    .sprite:
        ld a, b
        ld [hl+], a                     ;; Y
        ld a, c
        ld [hl+], a                     ;; X
        ld a, PANT_TITULO_TILE_BARRA
        ld [hl+], a                     ;; tile
        ld a, ATTR_PRIORIDAD
        ld [hl+], a                     ;; detras del fondo
        ld a, c
        add a, 8
        ld c, a                         ;; siguiente sprite, 8 px a la derecha
        dec d
    jr nz, .sprite
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cada frame en el titulo: arriba/abajo cambia de opcion (si hay partida)
;; y START empieza la partida (RESTART desde el nivel 1, RESUME donde se perdio).
;; I: -
;; O: -
;; M: A, BC, D, HL (+ lo que modifique scene_ingame_init)
scene_menu_update::
    ld a, [joypad_pressed]
    and (1 << UP_BIT) | (1 << DOWN_BIT)
    ld b, a

    ld a, [menu_dpad_anterior]
    ld c, a

    ld a, b
    ld [menu_dpad_anterior], a

    and a
    jr z, .confirmar
    ld a, c
    and a
    jr nz, .confirmar

    ld a,[hay_partida]
    and a
    jr z, .confirmar
    ld a, [menu_opcion]
    xor 1
    ld [menu_opcion], a
    call menu_dibujar_barra
    ld hl, SfxMenuMover
    call sys_sound_play_sfx

    .confirmar:
    ld a, [joypad_pressed]
    and 1 << START_BIT
    ld b , a

    ld a, [menu_start_anterior]
    ld c, a

    ld a, b
    ld [menu_start_anterior], a

    and a
    ret z
    ld a, c
    and a
    ret nz

    ld a, [menu_opcion]
    cp OPCION_RESTART
    jr nz,.empezar
    ld a, 5
    ld [nivel_actual], a

    .empezar:
    ld hl, SfxMenuOk
    call sys_sound_play_sfx

    ;; Se quitan los sprites de la barra: en la partida el tile 2 es otro dibujo
    ld hl, shadow_oam
    xor a
    ld b, SHADOW_OAM_SIZE
    call memset8

    ld hl, scene_ingame
    jp manager_escena_cambiar