SECTION "Sistema colisiones", ROM0

system_colisiones_update::
    ;; comprueba si el jugador está bajando
    ld a, [entity_array + E_VY]

    bit 7, a
    ret nz  ;; VY negativa, está subiendo

    and a
    ret z   ;; VY = 0, no está bajando

    ;; comprobamos la posición anterior de los pies, debe estar sobre el suelo (Y anterior + alto jugador < 120)
    ld a, [jugador_y_anterior]
    add a, JUGADOR_ALTO
    ret c ;; evitar desbordamiento

    cp LEVEL_FLOOR_PX + 1
    ret nc                  ;; pies anteriores > 120, ya estaba por debajo

    ;; comprobar la posición nueva de los pies, deben haber alcanzado o cruzado el borde superior del suelo (Y nueva + alto jugador >= 120)
    ld a, [jugador_y]
    add a, JUGADOR_ALTO     ;; pies nuevos = Y nueva + alto jugador
    ret c                   ;; evitar desbordamiento

    cp LEVEL_FLOOR_PX
    ret c                   ;; pies nuevos < 120, aún no llega al suelo

    ;; colocar al jugador, ha alcanzado o cruzado el borde superior
    ld a, LEVEL_FLOOR_PX - JUGADOR_ALTO ;; 120 - 8: jugador justo sobre el suelo
    ld [jugador_y], a

    ;; detenemos la caída y permitimos salto
    xor a
    ld [entity_array + E_VY], a  ;; detener caída

    ld a, 1
    ld [jugador_en_suelo], a     ;; permitir el próximo salto

    ret

check_platform:
;; INPUT:  A = tile
;; OUTPUT: Z = 1 if it's a platform; Z = 0 if not
    cp TILE_SUELO
    ret z

    cp TILE_PLAT_DERECHA
    ret z

    cp TILE_PLAT_IZQUIERDA
    ret z

    or 1         ;; Z = 0
    ret

check_wall:
;; INPUT:  A = tile
;; OUTPUT: Z = 1 if it's a wall Z = 0 if not
    cp TILE_PARED_NUEVA
    ret z

    ;; No es pared
    or 1
    ret