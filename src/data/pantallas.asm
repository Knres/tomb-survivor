SECTION "Pantallas", ROM0

;; Ancho de una fila en tiles. Debe valer lo mismo que PANTALLA_ANCHO (defs.asm):
;; aqui hace falta como DEF local porque DS necesita el valor al ensamblar.
DEF FILA = 20

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pantalla de titulo: 20x18 tiles, fila a fila.
;; Cada fila tiene que sumar FILA (20) tiles.
pantalla_titulo::
    DS FILA * 5, TILE_FONDO
    ;; fila 6: TOMB (7 + 6 + 7 = 20)
    DS 7, TILE_FONDO
    DB TILE_LETRA_T, TILE_LETRA_O, TILE_LETRA_M, TILE_LETRA_B, TILE_FONDO, TILE_TUMBA
    DS 7, TILE_FONDO

    ;; fila 7: SURVIVOR (6 + 8 + 6 = 20)
    DS 6, TILE_FONDO
    DB TILE_LETRA_S, TILE_LETRA_U, TILE_LETRA_R, TILE_LETRA_V, TILE_LETRA_I, TILE_LETRA_V, TILE_LETRA_O, TILE_LETRA_R
    DS 6, TILE_FONDO

    DS FILA * 5, TILE_FONDO

    ;; fila 12: START (7 + 5 + 8 = 20)
    DS 7, TILE_FONDO
    DB TILE_LETRA_S, TILE_LETRA_T, TILE_LETRA_A, TILE_LETRA_R, TILE_LETRA_T
    DS 8, TILE_FONDO

    DS FILA * 5, TILE_FONDO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pantalla de game over: GAME OVER centrado.
pantalla_gameover::
    DS FILA * 8, TILE_FONDO

    ;; fila 8: GAME OVER (5 + 9 + 6 = 20)
    DS 5, TILE_FONDO
    DB TILE_LETRA_G, TILE_LETRA_A, TILE_LETRA_M, TILE_LETRA_E, TILE_FONDO
    DB TILE_LETRA_O, TILE_LETRA_V, TILE_LETRA_E, TILE_LETRA_R
    DS 6, TILE_FONDO

    DS FILA * 9, TILE_FONDO


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pantalla de nivel completado: GREAT + numero.
;; El numero lo escribe scene_nivel_init en POS_NUMERO_NIVEL.
pantalla_nivel::
    DS FILA * 8, TILE_FONDO

    ;; fila 8: GREAT + espacio + numero (6 + 7 + 7 = 20)
    DS 6, TILE_FONDO
    DB TILE_LETRA_G, TILE_LETRA_R, TILE_LETRA_E, TILE_LETRA_A, TILE_LETRA_T, TILE_FONDO
    DB TILE_FONDO
    DS 7, TILE_FONDO

    DS FILA * 9, TILE_FONDO

;; Direccion del tilemap donde va el numero: fila 8, columna 12.
;; ($9800 = TILEMAP_BG_START; aqui hace falta el valor porque es un DEF)
EXPORT DEF POS_NUMERO_NIVEL = $9800 + 8 * 32 + 12

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pantalla de victoria: SURVIVED centrado.
pantalla_victoria::
    DS FILA * 8, TILE_FONDO
    ;; fila 8: SURVIVED (6 + 8 + 6 = 20)
    DS 6, TILE_FONDO
    DB TILE_LETRA_S, TILE_LETRA_U, TILE_LETRA_R, TILE_LETRA_V, TILE_LETRA_I, TILE_LETRA_V, TILE_LETRA_E, TILE_LETRA_D
    DS 6, TILE_FONDO

    DS FILA * 9, TILE_FONDO