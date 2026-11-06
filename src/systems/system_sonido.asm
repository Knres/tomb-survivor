SECTION "System sonido", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Enciende el chip de sonido, volumen general al maximo y los 4 canales en los dos altavoces.
;; I: -
;; O: -
;; M: A
sys_sound_init:: 
	ld a, $80
	ld [rNR52], a
	
	ld a, $77
	ld [rNR50], a

	ld a, $FF
	ld[rNR51], a
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reproduce un efecto: copia sus valores a los registros del canal.
;; Formato del efecto: byte bajo del primer registro, n de bytes, valores (ver sfx.asm).
;; I: HL = efecto (SfxSalto, SfxDanio, ...)
;; O: -
;; M: A, B, DE, HL
sys_sound_play_sfx::
	ld a, [hl+]
	ld e, a
	ld d, $FF
	ld a, [hl+]
	ld b, a
	cp 0
	jr z, .fin
	.copiar:
	ld a, [hl+]
	ld [de], a
	inc de
	dec b
	jr nz, .copiar
	.fin:
	ret
