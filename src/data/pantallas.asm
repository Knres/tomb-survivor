SECTION "Pantallas", ROM0

;; Ancho de una fila en tiles. Debe valer lo mismo que PANTALLA_ANCHO (defs.asm):
;; aqui hace falta como DEF local porque DS necesita el valor al ensamblar.
DEF FILA = 20

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pantalla de titulo: 20x18 tiles, fila a fila.
;; Cada fila tiene que sumar FILA (20) tiles.
pantalla_titulo::
    DS FILA * 6, TILE_FONDO   ;; filas 0-5: vacias

    ;; fila 6: SURVIVE (6 + 7 + 7 = 20)
    DS 6, TILE_FONDO
    DB TILE_LETRA_S, TILE_LETRA_U, TILE_LETRA_R, TILE_LETRA_V, TILE_LETRA_I, TILE_LETRA_V, TILE_LETRA_E
    DS 7, TILE_FONDO

    DS FILA * 5, TILE_FONDO   ;; filas 7-11: vacias

    ;; fila 12: START (7 + 5 + 8 = 20)
    DS 7, TILE_FONDO
    DB TILE_LETRA_S, TILE_LETRA_T, TILE_LETRA_A, TILE_LETRA_R, TILE_LETRA_T
    DS 8, TILE_FONDO

    DS FILA * 5, TILE_FONDO   ;; filas 13-17: vacias