;; INPUT:  A = tile
;; OUTPUT: Z = 1 if it's a platform; Z = 0 if not
check_platform:
    cp TILE_SUELO
    ret z

    cp TILE_PLAT_DERECHA
    ret z

    cp TILE_PLAT_IZQUIERDA
    ret z

    or 1         ;; Z = 0
    ret

;; INPUT:  A = tile
;; OUTPUT: Z = 1 if it's a wall Z = 0 if not
check_wall::
    cp TILE_PARED_NUEVA
    ret z

    ;; No es pared
    or 1
    ret