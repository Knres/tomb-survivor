SECTION "Scene victoria", ROM0

;; Victoria: SURVIVED, despues el titulo
scene_victoria::
    DW scene_victoria_init
    DW manager_escena_temporizada_update    ;; el update es el comun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Entra en la victoria: pantalla SURVIVED y sonido, despues al titulo.
;; I: -
;; O: -
;; M: A, BC, DE, HL
scene_victoria_init::
    ld   hl, pantalla_victoria
    ld   de, scene_menu
    call manager_escena_temporizada_init

    ld   hl, SfxNivel
    jp   sys_sound_play_sfx