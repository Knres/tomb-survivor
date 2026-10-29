SECTION "System Reloj", ROM0

system_actualizar_reloj:
    call system_actualiza_frame_actual
    jr nz, .continua
    ld a, [reloj_fin_nivel]
    cp FIN_RELOJ
    jr z, .continua ;; si ha llegado el contador a 0 puede continuar, no debe bajar de 0, si no, se resta 1
    dec a
    ld [reloj_fin_nivel], a
    .continua:
ret

system_actualiza_frame_actual:
    ;; I - 
    ;; O - flag(z)
    ;; M - a, [frame_actual]
    ;; Z --> se resta 1 al reloj
    ld a, [frame_actual]
    cp FIN_SEGUNDO
    jr z, .reset

    inc a
    jr .set

    .reset:
    ld a, INICIO_SEGUNDO
    cp a ;; devuelve z --> hay que restar 1 al reloj porque ha pasado un segundo
    jr .set


    .set:
    ld [frame_actual], a
ret