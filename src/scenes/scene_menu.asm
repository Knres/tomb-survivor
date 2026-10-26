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

    ld   hl, pantalla_titulo
    jp   sys_pantalla_dibujar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cada frame en el titulo: con START, empieza la partida.
;; I: -
;; O: -
;; M: -
scene_menu_update::
    ;; TODO: cuando el input tenga los botones recien pulsados:
    ;;   si START se acaba de pulsar ->
    ;;     ld   hl, SfxMenuOk
    ;;     call sys_sound_play_sfx
    ;;     ld   hl, scene_ingame
    ;;     jp   manager_escena_cambiar
    ret