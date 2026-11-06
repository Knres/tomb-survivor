SECTION "Sistema musica", ROM0

;; La musica va siempre por el canal 2 (los efectos usan CH1 y CH4).
;; Formato de las canciones en data/musica.asm.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Para la musica y silencia el canal 2.
;; I: -
;; O: -
;; M: A
sys_music_stop::
	ld a, 0
	ld [musica_contador], a
	ld [rNR22], a
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Empieza a sonar una cancion. Con el contador a 1, el siguiente update toca la primera nota.
;; I: HL = cancion
;; O: -
;; M: A
sys_music_play::
	ld a, l
	ld [musica_inicio], a
	ld [musica_ptr], a
	ld a, h
	ld [musica_inicio + 1], a
	ld [musica_ptr + 1], a
	ld a, 1
	ld [musica_contador], a
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Avanza la musica un frame. Llamar una vez por frame.
;; Cuando se acaba la nota actual, toca la siguiente (o un silencio).
;; Al final de la cancion: tono 0 = vuelve a empezar, tono 1 = para.
;; I: -
;; O: -
;; M: A, DE, HL
sys_music_update::
	ld a, [musica_contador]
	cp 0
	ret z
	dec a
	ld [musica_contador], a
	ret nz
	.sigue:
		ld a, [musica_ptr]
		ld l, a
		ld a, [musica_ptr + 1]
		ld h, a

		ld a, [hl+]
		ld e, a
		ld a, [hl+]
		ld d, a
		ld a, [hl+]
		
		cp 0
		jr z, .fin
		
		ld [musica_contador], a
		ld a, l
		ld [musica_ptr], a
		ld a, h
		ld [musica_ptr + 1], a
		ld a, d
		cp 0
		jr z, .cero
		
		ld a, $80
		ldh [rNR21], a
		ld a, MUSICA_VOLUMEN
		ldh [rNR22], a
		ld a, e
		ldh [rNR23], a
		ld a, d
		or $80
		ldh [rNR24], a
		ret

	.fin:
		ld a, e
		cp 0
		jp nz, sys_music_stop

		ld a, [musica_inicio]
		ld [musica_ptr], a
		ld a, [musica_inicio + 1]
		ld [musica_ptr + 1], a
		jr .sigue
	.cero:
		ld a, 0
		ldh [rNR22], a
		ret
