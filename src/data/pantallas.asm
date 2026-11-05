;; Pantallas que no son niveles: titulo, game over, nivel completado y victoria.
;; Cada una esta en su propio archivo (data/pantalla_titulo.asm, ...) con sus tiles y su mapa.
;; Las dibuja sys_pantalla_dibujar (systems/system_pantalla.asm).

;; Pantalla de nivel completado: el numero del nivel se escribe en la fila 16, columna 12.
;; ($9800 = TILEMAP_BG_START; aqui hace falta el valor porque es un DEF)
EXPORT DEF POS_NUMERO_NIVEL = $9800 + 16 * 32 + 12

;; En los tiles de la pantalla de nivel, el numero n es el tile PANT_NIVEL_NUM_0 + n (del 1 al 8)
EXPORT DEF PANT_NIVEL_NUM_0 = 0

;; Menu del titulo: tiles fijos de la pantalla de titulo y donde va cada cosa
EXPORT DEF PANT_TITULO_TILE_VACIO  = 1
EXPORT DEF PANT_TITULO_TILE_BARRA = 2
EXPORT DEF POS_RECUADRO_MENU  = $9800 + 15 * 32 + 6    ;; esquina del recuadro (2 filas x 8)

;; Barra gris que apaga la opcion no elegida: 9 sprites de x = 45 a x = 116.
;; Al ir detras del fondo solo se ve en el blanco del recuadro, asi que sus esquinas redondas la recortan.
;; Coordenadas de OAM (la OAM suma 8 en X y 16 en Y)
EXPORT DEF MENU_BARRA_X         = 45 + 8
EXPORT DEF MENU_BARRA_Y_RESUME  = 15 * 8 + 16
EXPORT DEF MENU_BARRA_Y_RESTART = 16 * 8 + 16
EXPORT DEF MENU_BARRA_SPRITES   = 9
