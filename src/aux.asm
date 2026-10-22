SECTION "Aux", ROM0

habilitar_objetos::
    ;; habilidatar objetos
    ;; I: -
    ;; O: -
    ;; M: hl
    ld hl, rLCDC
    set 1, [hl]
ret

init_oam::
    ;; inicializar OAM (40 sprites)
    ;; I: -
    ;; O: -
    ;; M: A, B, HL.
    call wait_vblank
    
    ld hl, OAM_START
    xor a
    ld b, OAM_SIZE
jp memset8

wait_vblank::
    ;; espera el inicio de vblank
    ;; I: -
    ;; o: -
    ;; M: HL, A
    ld hl, rLY

    .do_while:
        ld a, [hl]
        cp VBLANK_START
    jr nz, .do_while
ret

memcpy8::
    ;; copia los valores de hl a de, con un contador que es b
    ;; I: HL origen
    ;; I: DE destino
    ;; I: B contador
    ;; O: -
    ;; M: HL, DE, B, A
    ld a, [hl+]
    ld [de], a

    inc de
    dec b
    jr nz, memcpy8
ret

memcpy8_bc::
    ;; copia los valores de hl -> de, con un contador bc
    ;; I: HL = origen; DE = destino; BC = cantidad de bytes.
    ;; O: -
    ;; M: A, BC, DE, HL
    .do_while
        ld a, [hl+]
        ld [de], a

        inc de
        dec bc      ;; dec bc no activa flags
        
        ld a, b
        or c        ;; (a == 0 || c == 0) ?
    jr nz, .do_while
ret

memset8::
    ;; hl = a <-- con contador b
    ;; I: HL = destino; A = valor a poner; B = cantidad de bytes.
    ;; O: -
    ;; M: B, HL
    .do_while
        ld [hl+], a

        dec b
    jr nz, .do_while
ret

call_hl::
    ;; salta a dir. indicada en hl, hace return
    ;; I: HL = direccion de la rutina.
    ;; O: -
    ;; M: PC
jp hl