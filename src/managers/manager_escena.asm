SECTION "Manager escena", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cambia a otra escena: guarda su update y ejecuta su init.
;; Cada escena es un bloque en ROM:  DW init  /  DW update
;; I: HL = escena (scene_menu, scene_ingame, ...)
;; O: -
;; M: todos (ejecuta el init de la escena)
manager_escena_cambiar::
    ld   a, [hl+]               ;; \ DE = direccion del init (bytes 0-1 de la escena)
    ld   e, a                   ;; |   byte bajo
    ld   a, [hl+]               ;; |
    ld   d, a                   ;; /   byte alto  (HL -> update)

    ld   a, [hl+]               ;; \ escena_update = direccion del update (bytes 2-3)
    ld   [escena_update], a     ;; |   byte bajo
    ld   a, [hl]                ;; |
    ld   [escena_update + 1], a ;; /   byte alto

    ld   h, d                   ;; \ HL = direccion del init
    ld   l, e                   ;; /
    jp   hl                     ;; Saltar al init: como es un salto y no un call,
                                ;; su ret vuelve directamente a quien llamo a cambiar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ejecuta el update de la escena actual. Llamar una vez por frame.
;; I: -
;; O: -
;; M: todos (ejecuta el update de la escena)
manager_escena_update::
    ld   a, [escena_update]     ;; \ HL = *(escena_update)
    ld   l, a                   ;; |   = direccion del update de la escena actual
    ld   a, [escena_update + 1] ;; |
    ld   h, a                   ;; /
    jp   hl                     ;; Saltar al update: su ret vuelve al bucle principal
