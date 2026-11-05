SECTION "Sistema colisiones", ROM0

system_colisiones_update::
    ;; punto situado bajo el pie izquierdo
    ld a, [jugador_y]
    add JUGADOR_ALTO
    ld d, a

    ld a, [jugador_x]
    ld e, a

    call map_is_solid_at
    jr nz, .hay_superficie

    ;; punto situado bajo el pie derecho
    ld a, [jugador_x]
    add JUGADOR_ALTO - 1
    ld e, a

    call map_is_solid_at
    ret z

.hay_superficie:

    ;; colocar al jugador, ha alcanzado o cruzado el borde superior
    ;; la superficie empieza en el multiplo de 8 de los pies
    ld a, d
    and $F8
    sub JUGADOR_ALTO
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

map_tile_address::
    ;; D = Y en px E = X en px
    ;; HL = direccion del tile en el mapa

    ;; fila = Y / 8
    ld a, d
    srl a
    srl a
    srl a
    ld l, a
    ld h, 0

    ;; fila * 20
    add hl, hl       ;; fila * 2
    ld b, h
    ld c, l          ;; BC = fila * 2

    add hl, hl       ;; fila * 4
    add hl, hl       ;; fila * 8
    add hl, hl       ;; fila * 16
    add hl, bc       ;; fila * 18
    add hl, bc       ;; fila * 20

    ;; columna = X / 8
    ld a, e
    srl a
    srl a
    srl a
    ld c, a
    ld b, 0
    add hl, bc

    ;; Sumar dirección del mapa
    push hl
    call get_mapa_nivel_actual
    pop bc
    add hl, bc
    ret


map_is_solid_at::
    ;; D = Y, E = X
    ;; Z = libre, NZ = sólido

    call map_tile_address
    ld a, [hl]

    cp TILE_PLAT_DERECHA
    jr z, .solido

    cp TILE_PLAT_IZQUIERDA
    jr z, .solido

    cp TILE_PARED_NUEVA
    jr z, .solido

    xor a
    ret

.solido:
    or 1
    ret

game_handle_collisions::

    ld hl, game_check_collision_player
    call manager_entity_for_each

    ret

game_check_collision_player::

    ld hl, E_KIND ;; Comprobar que no es el jugador
    add hl, de  ;; DE = entidad actual
    ld a, [hl]
    cp KIND_JUGADOR
    ret z

    ld a, [de] ;; Comprobar que puede colisionar
    bit CMP_COLLIDER_BIT, a
    ret z

    ld hl, E_KIND
    add hl, de
    ld a, [hl]
    ld b, a  ;; Guardo en b el tipo porque a se modifica en sys_collision_overlaps

    ld hl, entity_array ;; hl = jugador

    ;; Comprobar solapamiento
    call sys_collision_overlaps
    ret nc

    ld a, b 

    cp KIND_ESCORPION
    jr z, .is_enemy

    cp KIND_MURCIELAGO
    jr z, .is_enemy

    cp KIND_MOMIA
    jr z, .is_enemy

    cp KIND_PINCHOS
    jr z, .is_enemy

    cp KIND_ESTALACTITA
    jr z, .is_enemy

    cp KIND_DARDO
    jr z, .is_enemy

    cp KIND_ESCUDO
    jr z, .pickup_shield

    ret

.pickup_shield::
    dec de ;; Recupero la dirección inicial de la entidad
    dec de

    ld a, 1
    ld [escudo_jugador], a

    ld hl, E_CMP ;; Desactivo entidad de escudo
    add hl, de
    res CMP_ALIVE_BIT, [hl]
    ret

.is_enemy:
    call is_invincible ;; Compruebo invencibilidad
    ret c

    ld a, [reloj_fin_nivel] ;; Guardar el segundo en el que recibe daño
    ld [ultimo_hit], a

    ld a, 1
    ld [hit_reciente], a

    ;; Comprobar si el jugador tiene escudo
    ld a, [escudo_jugador]
    and a
    jr z, .lower_health

    ;; Consumir el escudo
    xor a
    ld [escudo_jugador], a
    ret

.lower_health
    ld a, [jugador_vidas]
    and a
    ret z

    dec a
    ld [jugador_vidas], a
    call hud_draw_hearts
    ret

is_invincible::
    ld a, [hit_reciente]
    and a
    ret z

    ld a, [ultimo_hit] ;; Calculo segundos transcurridos
    ld b, a

    ld a, [reloj_fin_nivel]
    ld c, a

    ld a, b
    sub c

    cp TIEMPO_INVENCIBLE
    ret