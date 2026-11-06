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
    ld [reloj_activo],a

    ;; Si era el ultimo nivel no hay pantalla GREAT: directo a la victoria
    ld a, [nivel_actual]
    cp NUM_NIVELES
    jr c, .siguiente
    ld hl, scene_victoria
    jp manager_escena_cambiar

.siguiente:
		ld hl, pantalla_nivel
		ld de, scene_ingame
		call manager_escena_temporizada_init
		
		;; La pantalla ya esta dibujada: encima se escribe el numero del nivel superado.
		;; Con la LCD encendida, la VRAM solo se toca en VBlank.
		call wait_vblank
		
		ld a, [nivel_actual]
		add PANT_NIVEL_NUM_0
		ld [POS_NUMERO_NIVEL], a
		
		;; Avanza al nivel siguiente: es el que cargara scene_ingame al acabar el tiempo
		ld a, [nivel_actual]
		add 1
		ld [nivel_actual], a
		
		ld hl, SfxNivel
		jp sys_sound_play_sfx