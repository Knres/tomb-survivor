SECTION "Sistema musica", ROM0

;; La musica va siempre por el canal 2 (los efectos usan CH1 y CH4).
;; Formato de las canciones en data/musica.asm.

sys_music_stop::
    ;; para la musica y silencia el canal 2
    ;; I: -
    ;; O: -
    ;; M: A

    ;; contador a 0 significa que no hay musica sonando
    xor a
    ld [musica_contador], a

    ;; volumen 0 apaga el canal
    ld [rNR22], a
    ret

sys_music_play::
    ;; empieza a sonar una cancion
    ;; I: HL = cancion
    ;; O: -
    ;; M: A

    ;; se guarda el inicio para poder volver a empezar al llegar al final
    ld a, l
    ld [musica_inicio], a
    ld a, h
    ld [musica_inicio + 1], a

    ld a, l
    ld [musica_ptr], a
    ld a, h
    ld [musica_ptr + 1], a

    ;; con 1, en el siguiente update llega a 0 y suena la primera nota
    ld a, 1
    ld [musica_contador], a
    ret

sys_music_update::
    ;; avanza la musica un frame, llamar una vez por frame
    ;; I: -
    ;; O: -
    ;; M: A, DE, HL

    ;; si no hay musica no se hace nada
    ld a, [musica_contador]
    or a
    ret z

    ;; mientras le queden frames, la nota actual sigue sonando
    dec a
    ld [musica_contador], a
    ret nz

    .siguiente_nota:
        ;; HL = direccion de la nota que toca
        ld hl, musica_ptr
        ld a, [hl+]
        ld h, [hl]
        ld l, a

        ;; DE = tono, A = duracion
        ld a, [hl+]
        ld e, a
        ld a, [hl+]
        ld d, a
        ld a, [hl+]

        ;; duracion 0 es el final de la cancion
        or a
        jr z, .volver

        ld [musica_contador], a

        ;; HL ya apunta a la nota siguiente, se guarda para el proximo cambio
        ld a, l
        ld [musica_ptr], a
        ld a, h
        ld [musica_ptr + 1], a

        ;; tono 0 es un silencio
        ld a, d
        or e
        jr z, .silencio

        ;; onda redonda, volumen y tono; el bit 7 de NR24 hace que suene
        ld a, $80
        ld [rNR21], a
        ld a, MUSICA_VOLUMEN
        ld [rNR22], a
        ld a, e
        ld [rNR23], a
        ld a, d
        or $80
        ld [rNR24], a
        ret

    .silencio:
        xor a
        ld [rNR22], a
        ret

    ;; al final, tono 1 = parar y tono 0 = volver a empezar
    .volver:
        ld a, e
        or a
        jp nz, sys_music_stop

        ld a, [musica_inicio]
        ld [musica_ptr], a
        ld a, [musica_inicio + 1]
        ld [musica_ptr + 1], a

        ;; se toca ya la primera nota, si no el contador se queda a 0 y la musica se pararia
        jr .siguiente_nota
