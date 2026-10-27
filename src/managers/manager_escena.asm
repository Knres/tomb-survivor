SECTION "Manager escena", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cambia a otra escena: guarda su update y ejecuta su init.
;; Cada escena es un bloque en ROM:  DW init  /  DW update
;; I: HL = escena (scene_menu, scene_ingame, ...)
;; O: -
;; M: todos (ejecuta el init de la escena)
manager_escena_cambiar::
    ld   a, [hl+]
    ld   e, a
    ld   a, [hl+]
    ld   d, a

    ld   a, [hl+]
    ld   [escena_update], a
    ld   a, [hl]
    ld   [escena_update + 1], a

    ld   h, d
    ld   l, e
    jp   hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ejecuta el update de la escena actual. Llamar una vez por frame.
;; I: -
;; O: -
;; M: todos (ejecuta el update de la escena)
manager_escena_update::
    ld   a, [escena_update]
    ld   l, a
    ld   a, [escena_update + 1]
    ld   h, a
    jp   hl


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Init comun de las pantallas temporizadas (game over, nivel, victoria):
;; quita los sprites, dibuja la pantalla y arranca el contador.
;; I: HL = pantalla en ROM, DE = escena siguiente
;; O: -
;; M: A, BC, DE, HL
manager_escena_temporizada_init::
    ld   a, e
    ld   [escena_siguiente], a
    ld   a, d
    ld   [escena_siguiente + 1], a

    ld   a, DURACION_PANTALLA
    ld   [escena_contador], a

    push hl
    ld   hl, shadow_oam
    xor  a
    ld   b, SHADOW_OAM_SIZE
    call memset8
    pop  hl

    jp   sys_pantalla_dibujar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Update comun de las pantallas temporizadas: cuenta frames y,
;; al llegar a 0, pasa a escena_siguiente.
;; I: -
;; O: -
;; M: todos (al acabar, ejecuta el init de la escena siguiente)
manager_escena_temporizada_update::
    ld   hl, escena_contador
    dec  [hl]
    ret  nz

    ld   a, [escena_siguiente]
    ld   l, a
    ld   a, [escena_siguiente + 1]
    ld   h, a
    jp   manager_escena_cambiar