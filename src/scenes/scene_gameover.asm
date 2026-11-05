SECTION "Scene gameover", ROM0

;; Game over: se muestra DURACION_PANTALLA frames y vuelve al titulo
scene_gameover::
    DW scene_gameover_init
    DW manager_escena_temporizada_update    ;; el update es el comun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Entra en game over: pantalla GAME OVER, despues al titulo.
;; I: -
;; O: -
;; M: A, BC, DE, HL
scene_gameover_init::
    ld a, 1
    ld [hay_partida], a
    
    call sys_music_stop
    ld   hl, pantalla_gameover
    ld   de, scene_menu
    jp   manager_escena_temporizada_init