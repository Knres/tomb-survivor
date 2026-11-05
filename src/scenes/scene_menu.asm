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
    jp   sys_pantalla_dibujar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cada frame en el titulo: con START, empieza la partida.
;; I: -
;; O: -
;; M: -
scene_menu_update::
    ld a, [joypad_pressed]
    and 1 << START_BIT
    ld b, a

    ld a, [menu_start_anterior]
    ld c, a

    ld a, b
    ld [menu_start_anterior], a

    and a
    ret z
    ld a, c
    and a
    ret nz

    ld  a, 1
    ld [nivel_actual], a

    ld   hl, SfxMenuOk
    call sys_sound_play_sfx

    ld   hl, scene_ingame
    jp   manager_escena_cambiar

    ret