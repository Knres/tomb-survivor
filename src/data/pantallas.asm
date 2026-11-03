;; Pantallas que no son niveles: titulo, game over, nivel completado y victoria.
;; Cada una esta en su propio archivo (data/pantalla_titulo.asm, ...) con sus tiles y su mapa.
;; Las dibuja sys_pantalla_dibujar (systems/system_pantalla.asm).

;; Pantalla de nivel completado: el numero del nivel se escribe en la fila 16, columna 12.
;; ($9800 = TILEMAP_BG_START; aqui hace falta el valor porque es un DEF)
EXPORT DEF POS_NUMERO_NIVEL = $9800 + 16 * 32 + 12

;; En los tiles de la pantalla de nivel, el numero n es el tile PANT_NIVEL_NUM_0 + n (del 1 al 8)
EXPORT DEF PANT_NIVEL_NUM_0 = 0
