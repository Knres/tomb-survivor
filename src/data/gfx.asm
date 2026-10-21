;; cada tiles es de 16 bytes 8 filas con dos planos de bits
;; 1er byte es el plano bajo
;; 2do byte es el plano alto
SECTION "Initial level tiles", ROM0
tile_data::
	;; Tile 0 ($00): fondo vacio
	DB %00000000, %00000000 ;; fila 0
	DB %00000000, %00000000 ;; fila 1
	DB %00000000, %00000000 ;; fila 2
	DB %00000000, %00000000 ;; fila 3
	DB %00000000, %00000000 ;; fila 4
	DB %00000000, %00000000 ;; fila 5
	DB %00000000, %00000000 ;; fila 6
	DB %00000000, %00000000 ;; fila 7

	;; Tile 1 ($01): suelo solido
	DB %11111111, %11111111 ;; fila 0
	DB %11111111, %11111111 ;; fila 1
	DB %11111111, %11111111 ;; fila 2
	DB %11111111, %11111111 ;; fila 3
	DB %11111111, %11111111 ;; fila 4
	DB %11111111, %11111111 ;; fila 5
	DB %11111111, %11111111 ;; fila 6
	DB %11111111, %11111111 ;; fila 7

	;; Tile 2 ($02): pared, 
	DB %11111111, %11111111 ;; fila 0
	DB %10011001, %10011001 ;; fila 1
	DB %10011001, %10011001 ;; fila 2
	DB %11111111, %11111111 ;; fila 3
	DB %11111111, %11111111 ;; fila 4
	DB %10011001, %10011001 ;; fila 5
	DB %10011001, %10011001 ;; fila 6
	DB %11111111, %11111111 ;; fila 7

	;; Tile 3 ($03): jugador 
	DB %11100111, %11100111 ;; fila 0
	DB %00100100, %00100100 ;; fila 1
	DB %10100100, %10100100 ;; fila 2
	DB %01100100, %01100100 ;; fila 3
	DB %00111110, %00111110 ;; fila 4
	DB %00100101, %00100101 ;; fila 5
	DB %00100100, %00100100 ;; fila 6
	DB %11100111, %11100111 ;; fila 7
tile_data_end::

EXPORT DEF INITIAL_TILE_BYTES = tile_data_end - tile_data
