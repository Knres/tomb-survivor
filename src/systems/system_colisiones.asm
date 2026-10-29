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

    ;; sonido de aterrizar, solo si caia de verdad
    ;; estando de pie VY solo vale GRAVEDAD (un frame de gravedad), eso no es un aterrizaje
    ld a, [entity_array + E_VY]
    cp GRAVEDAD + 1
    jr c, .sin_sonido

    ld hl, SfxAterrizar
    call sys_sound_play_sfx

    .sin_sonido:

    ;; detenemos la caída y permitimos salto
    xor a
    ld [entity_array + E_VY], a  ;; detener caída

    ld a, 1
    ld [jugador_en_suelo], a     ;; permitir el próximo salto

    ret

check_platform:
;; Entrada:  A = tile
;; Salida: Z = 1 si es una platforma; Z = 0 si no
    cp TILE_SUELO
    ret z

    cp TILE_PLAT_DERECHA
    ret z

    cp TILE_PLAT_IZQUIERDA
    ret z

    or 1         ;; Z = 0
    ret

check_wall:
;; Entrada A = tile, Salida Z=1 pared
    cp TILE_PARED_NUEVA
    ret z
    or 1
    ret

;; Comprueba si hay una pared a la derecha.
;; Salida: Z = 1 si hay pared; Z = 0 si no hay pared.
check_right_wall::
    ld a, [jugador_x]
    add 8
    srl a
    srl a
    srl a
    ld b, a                  ;; B = columna del mapa

    ld a, [jugador_y]
    add 4
    srl a
    srl a
    srl a
    ld c, a                  ;; C = fila del mapa

    call get_tile_at_bc
    ret


;; Comprueba si hay una pared a la izquierda.
;; Salida: Z = 1 si hay pared; Z = 0 si no hay pared.
check_left_wall::
    ld a, [jugador_x]
    and a
    ret z                    ;; En el borde izquierdo, bloquear

    dec a
    srl a
    srl a
    srl a
    ld b, a                  ;; B = columna del mapa

    ld a, [jugador_y]
    srl a
    srl a
    srl a
    ld c, a                  ;; C = fila del mapa

    call get_tile_at_bc
    ret

;; Entrada: B = columna, C = fila.
;; Salida: Z = 1 si el tile es una pared.
get_tile_at_bc::
    call get_mapa_nivel_actual

    ld a, c
    .fila:    ;; Avanzar hasta la fila solicitada: 20 bytes por fila.
        and a
        jr z, .columna
        ld de, LEVEL_MAP_WIDTH
        add hl, de
        dec a
        jr .fila

    .columna:    ;; Avanzar hasta la columna solicitada.
        ld e, b
        ld d, 0
        add hl, de

    ld a, [hl]   ;; Leer el tile y comprobar si es una pared.
    call check_wall
    ret

;; 📥 Entrada: DE: entidad 1, HL: entidad 2
;; ⫷▬ Salida (el carry): C, se solapan. NC, no se solapan
;; ❌ Puede modificar A, DE, HL
sys_collision_overlaps::
inc de ;; Y1
inc hl ;; Y2
ld a, [de] ;; A = Y1 - Y2
sub [hl]
jr nc, .y_positive ;; \ Positivo: ya es |dY|
cpl ;; | Negativo: |dY| = -dY
inc a ;; / (cpl + inc: complemento a dos)
.y_positive
cp TAM_COLISION ;; Carry si |dY| < TAM_COLISION
ret nc ;; No hay solape
inc de ;; X1
inc hl ;; X2
ld a, [de] ;; A = X1 - X2
sub [hl]
jr nc, .x_positive ;; Positivo: ya es |dX|
cpl ;; Negativo: |dX| = -dX
inc a ;; (cpl + inc: complemento a dos)
.x_positive
cp TAM_COLISION ;; Carry si |dX| < TAM_COLISION:
ret ;; C = se solapan, NC = no se solapan