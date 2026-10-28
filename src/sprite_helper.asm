SECTION "Sprite helpers", ROM0

sprite_espejo_x::
	;; Voltea (espejo) al sprite en eje X
	;; I: HL = direccion base de la entidad
	;; O: -
	;; M: A, DE
	push hl ;; guardar dir. base de entidad

	ld de, E_ATTR
	add hl, de      ;; hl --> &entidad.attr

	ld a, [hl]      ;; / a= attr
	xor ATTR_FLIP_X ;;| invierte el valor de flip x; 0 <--> 1
	ld [hl], a      ;; \ guardar modificacion

	pop hl  ;; recuperar dir. base de entidad
ret

sprite_espejo_y::
	;; Voltea (espejo) al sprite en eje Y
	;; I: HL = direccion base de la entidad
	;; O: -
	;; M: A, DE
	push hl ;; guardar dir. base de entidad

	ld de, E_ATTR
	add hl, de      ;; hl --> &entidad.attr

	ld a, [hl]      ;; / a= attr
	xor ATTR_FLIP_Y ;;| invierte el valor de flip x; 0 <--> 1
	ld [hl], a      ;; \ guardar modificacion

	pop hl  ;; recuperar dir. base de entidad
ret