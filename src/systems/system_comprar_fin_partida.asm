SECTION "Comprobacion fin", ROM0

comprobar_jugador_vivo::
    ld a, [jugador_vidas]
    cp 0
    ret nz

    ld hl, scene_gameover
    call manager_escena_cambiar
    ld a, VIDAS_JUGADOR ;; reseteo las vidas y voy a gameover
    ld [jugador_vidas], a
ret