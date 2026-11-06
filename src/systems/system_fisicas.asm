SECTION "Sistema fisicas", ROM0

system_fisicas_update::
    ;; Primera entidad = jugador.
    ;; Modifica: A, B, HL.

    ;; se guarda Y antes del movimiento ya que colisiones la necesitará para detectar aterrizajes.
    ld a, [jugador_y]
    ld [jugador_y_anterior], a

    ;; se elige velocidad horizontal según la dirección de movimiento
    ld a, [jugador_direccion_movimiento]
    cp E_MOVE_LEFT
    jr z, .izquierda

    cp E_MOVE_RIGHT
    jr z, .derecha

    ;; Sin dirección.
    xor a
    jr .guardar_vx

    .izquierda:
        ld a, -VX_JUGADOR & $FF
        jr .guardar_vx

    .derecha:
        ld a, VX_JUGADOR

    .guardar_vx:
    ld [entity_array + E_VX], a

    ;; sin movimiento horizontal
    and a
    jr z, .sin_movimiento_horizontal

    ;; si la velocidad es negativa, va hacia la izquierda
    bit 7, a
    jr nz, .mover_izquierda

    ;; movimiento hacia la derecha
    call check_right_wall
    jr z, .sin_movimiento_horizontal

    ld a, [jugador_x]
    add VX_JUGADOR
    ld [jugador_x], a
    jr .sin_movimiento_horizontal

    .mover_izquierda:
        call check_left_wall
        jr z, .sin_movimiento_horizontal

        ld a, [jugador_x]
        add -VX_JUGADOR
        ld [jugador_x], a

.sin_movimiento_horizontal:

        ;; inicia salto si se ha solicitado y está en el suelo o apoyado
        ld a, [jugador_solicita_salto]
        and a
        jr z, .gravedad

        ld a, [jugador_en_suelo]
        and a
        jr z, .gravedad

        ld a, -IMPULSO_SALTO & $FF ;; negativo porque va hacia arriba, es lo mismo que cpl y inc a, pero en una instruccion
        ld [entity_array + E_VY], a ;; se guarda la velocidad vertical (salto)

        xor a
        ld [jugador_en_suelo], a

        ;; Consumir petición.
        ld [jugador_solicita_salto], a

        ld [jugador_frame_vertical], a

        ;Sonido de salto
        ld hl, SfxSalto
        call sys_sound_play_sfx
        
        ;; Aplicar el impulso completo este frame
        jr .mover_y

    ;; gravedad y limite de caida
    .gravedad:
        ld a, [jugador_frame_vertical]
        xor 1                   ;; alterna entre 0 y 1
        ld [jugador_frame_vertical], a
        ret nz

        ld hl, entity_array + E_VY
        ld a, [hl]

        ;; si VY es negativa, todavía está subiendo
        bit 7, a
        jr nz, .aplicar_gravedad

        ;; comparar con el máximo solo si VY >= 0
        cp VELOCIDAD_MAX_CAIDA
        jr nc, .mover_y

    ;; gravedad se aplica incluso si está apoyado, para que pueda caer si se sale del borde de una plataforma
    .aplicar_gravedad:
        add a, GRAVEDAD
        ld [hl], a

    ;; aplicamos la velocidad vertical
    .mover_y:
        ld a, [entity_array + E_VY]
        ld b, a

        ld a, [jugador_y]
        add a, b
        ld [jugador_y], a

        ;; colisiones decidirá si vuelve a estar apoyado
        xor a
        ld [jugador_en_suelo], a
        ret