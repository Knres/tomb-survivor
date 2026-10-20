;; Gestor de niveles: seleccion y carga del mapa en VRAM.

SECTION "Manager de nivel", ROM0

get_mapa_nivel_actual::
	;; Lee de "nivel_actual" el numero de nivel y guarda en hl el mapa de ese nivel
	;; I: -
	;; O: HL = direccion del mapa seleccionado.
	;; M: A, HL.
	ld a, [nivel_actual]

	cp 1
	jr z, .nivel_1

	;; TODO: añadir los otros niveles
	;; cp 2
	;; jr z, .nivel_2

	;; por defecto el nivel 1
	ld a, 1
	ld [hl], a

	.nivel_1
		ld hl, mapa_nivel_1
	ret

	;; TODO: añadir los otros niveles
	;;	.nivel_2
	;;		ld hl, mapa_nivel_2
	;;	ret
ret