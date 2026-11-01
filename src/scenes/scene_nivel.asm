SECTION "Scene nivel", ROM0

;; Nivel completado: GREAT + numero de nivel, despues el nivel siguiente.
;; Si era el ultimo nivel, va directamente a la victoria.
scene_nivel::
    DW scene_nivel_init
    DW manager_escena_temporizada_update    ;; el update es el comun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Entra en nivel completado.
;;   - Si nivel_actual es el ultimo (NUM_NIVELES): a la victoria.
;;   - Si no: muestra GREAT + numero, suena SfxNivel y pasa al nivel siguiente.
;; I: -
;; O: -
;; M: A, BC, DE, HL
scene_nivel_init::
    call sys_music_stop
    ld a, RELOJ_PARADO
    ld [reloj_activo], a

    ld   a, [nivel_actual]
    cp   NUM_NIVELES
    jr   c, .hay_siguiente

    ld   hl, scene_victoria
    jp   manager_escena_cambiar

.hay_siguiente
    ld   hl, pantalla_nivel
    ld   de, scene_ingame
    call manager_escena_temporizada_init

    call wait_vblank
    ld   a, [nivel_actual]
    add  a, PANT_NIVEL_NUM_0             ;; numero dentro de los tiles de la pantalla de nivel
    ld   [POS_NUMERO_NIVEL], a

    ld   hl, nivel_actual
    inc  [hl]

    ld   hl, SfxNivel
    jp   sys_sound_play_sfx