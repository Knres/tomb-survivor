SECTION "Scene victoria", ROM0

;; Victoria: SURVIVED, despues el titulo
scene_victoria::
    DW scene_victoria_init
    DW manager_escena_temporizada_update    ;; el update es el comun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Entra en la victoria: pantalla SURVIVED y musica de victoria, despues al titulo.
;; I: -
;; O: -
;; M: A, BC, DE, HL
scene_victoria_init::
    ;; Juego terminado: el titulo vuelve a START solo y la proxima partida empieza en el nivel 1
    ld a, 0
    ld [hay_partida], a
    ld a, 1
    ld [nivel_actual], a

    ld hl,musica_victoria
    call sys_music_play
    ld hl,pantalla_victoria
    ld de, scene_menu
    jp manager_escena_temporizada_init