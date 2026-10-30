SECTION "System Spawn", ROM0

spawn_enemigo_no_fijo:
    ld a, [frame_actual]
    cp INICIO_SEGUNDO
    ret nz            ;; como no quiero que spawnee el enemigo 1 vez por frame hasta que cambie de segundo, solo lo hace en el primer frame del segundo
    ld a, [siguiente_enemigo_high]
    ld h, a

    ld a, [siguiente_enemigo_low]
    ld l, a

    ld a, [reloj_fin_nivel]
    
    ;; si [reloj_fin_nivel] = [hl] ([siguiente_enemigo]), spawneo el enemigo
    cp [hl]
    ret nZ
    call siguiente_enemigo_update   
    ld b, b 
ret

siguiente_enemigo_update:
    ld a, [siguiente_enemigo_high]
    ld h, a

    ld a, [siguiente_enemigo_low]
    ld l, a

    inc hl

    ld a, h
    ld [siguiente_enemigo_high], a

    ld a, l
    ld [siguiente_enemigo_low], a
ret 
