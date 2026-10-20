;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Registros 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Pantalla y Graficos
EXPORT DEF rLCDC = $FF40 ;; Control de LCD
EXPORT DEF rSCY  = $FF42 ;; Scroll Vertidal   (Y) del fondo
EXPORT DEF rSCX  = $FF43 ;; Scroll Horizontal (X) del fondo
EXPORT DEF rLY   = $FF44 ;; Linea horizontal que la pantalla está dibujando
EXPORT DEF rWY   = $FF4A ;; Pos. Vertical   (Y) ventana aux.
EXPORT DEF rWX   = $FF4B ;; Pos. Horizontal (X) ventana aux.

;; Copia y colores
EXPORT DEF rDMA  = $FF46 ;; Tranf. Directa a Memoria, inicia copiado rapido de datos RAM -> OAM. Ejecutar desde HRAM ($FF80).
EXPORT DEF rBGP  = $FF47 ;; Def. paleta de color del fondo y ventana (0-4)
EXPORT DEF rOBJ0P= $FF48 ;; Def. tono de grise para 1er grupo de objetos/sprites (0 tranparente)
EXPORT DEF rOBJ1P= $FF49 ;; Def. tono de grise para 2do grupo de objetos/sprites (0 tranparente)

;; Temporizador e Interrupciones
EXPORT DEF rIE   = $FFFF ;; Habilitar interrupciones
EXPORT DEF rDIV  = $FF04 ;; Registro divisor, aumento constante

;; Joypad
EXPORT DEF rJOYP = $FF00 ;; Lectura de JoyPad

    ;; rBGP($FF47), rOBJ0P($FF48), rOBJ1P($FF49). Tonos de grises
    DEF P_COLOR_WHITE      = 0    ;; %00
    DEF P_COLOR_LIGHT_GRAY = 1    ;; %01
    DEF P_COLOR_DARK_GRAY  = 2    ;; %10
    DEF P_COLOR_BLACK      = 3    ;; %11
    DEF BGP_STANDARD   = (P_COLOR_BLACK << 6) | (P_COLOR_DARK_GRAY << 4) | (P_COLOR_LIGHT_GRAY << 2) | P_COLOR_WHITE
    DEF OBJ0P_STANDARD = (P_COLOR_BLACK << 6) | (P_COLOR_DARK_GRAY << 4) | (P_COLOR_LIGHT_GRAY << 2) | P_COLOR_WHITE
    DEF OBJ1P_STANDARD = (P_COLOR_BLACK << 6) | (P_COLOR_DARK_GRAY << 4) | (P_COLOR_LIGHT_GRAY << 2) | P_COLOR_WHITE

    ;; rLCDC ($FF40)
    DEF LCD_BG_DISPLAY_OFF    = %00000000   ;; Desactiva fondo (se vuelve blanco)
    DEF LCD_BG_DISPLAY_ON     = %00000001   ;; Activa fondo
    DEF LCD_OBJ_OFF           = %00000000   ;; Desactiva Sprites
    DEF LCD_OBJ_ON            = %00000010   ;; Activa Sprites
    DEF LCD_OBJ_SIZE_8X8      = %00000000   ;; Sprites de 8x8 píxeles
    DEF LCD_OBJ_SIZE_8X16     = %00000100   ;; Sprites de 8x16 píxeles (modo alto)
    DEF LCD_BG_TILEMAP_9800   = %00000000   ;; Fondo usa el mapa $9800
    DEF LCD_BG_TILEMAP_9C00   = %00001000   ;; Fondo usa el mapa $9C00
    DEF LCD_TILE_DATA_8800    = %00000000   ;; Graficos usando bloque $8800 (con signo)
    DEF LCD_TILE_DATA_8000    = %00010000   ;; Graficos usando bloque $8000 (sin signo)
    DEF LCD_WINDOW_OFF        = %00000000   ;; Desactiva la capa Ventana (HUD)
    DEF LCD_WINDOW_ON         = %00100000   ;; Activa la capa Ventana (HUD)
    DEF LCD_WIN_TILEMAP_9800  = %00000000   ;; Ventana usa el mapa $9800
    DEF LCD_WIN_TILEMAP_9C00  = %01000000   ;; Ventana usa el mapa $9C00
    DEF LCD_POWER_OFF         = %00000000   ;; Apaga la pantalla
    DEF LCD_POWER_ON          = %10000000   ;; Enciende la pantalla
    DEF LCD_CONFIG = LCD_POWER_ON | LCD_BG_DISPLAY_ON | LCD_OBJ_ON | LCD_OBJ_SIZE_8X8 | LCD_TILE_DATA_8000 | LCD_BG_TILEMAP_9800

    ;; rIE ($FFFF)
    DEF IE_VBLANK  = %00000001 ; Interrupción al terminar de dibujar pantalla (60Hz)
    DEF IE_LCD_STAT= %00000010 ; Interrupción por cambio de modo de video o línea LYC
    DEF IE_TIMER   = %00000100 ; Interrupción cuando el timer se desborda
    DEF IE_SERIAL  = %00001000 ; Interrupción por cable link (red de datos compartida)
    DEF IE_JOYPAD  = %00010000 ; Interrupción al presionar cualquier botón
    DEF IE_CONFIG = IE_VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VRAM, OAM (Memoria de objetos), WRAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; VRAM
EXPORT DEF VRAM_START = $8000
EXPORT DEF VRAM_END   = $9FFF

EXPORT DEF TILE_DATA_START   = $8000
EXPORT DEF TILE_MAP_START    = $9800
EXPORT DEF TILEMAP_BG_START  = $9800
EXPORT DEF TILEMAP_HUD_START = $9C00

EXPORT DEF TILEMAP_WIDTH     = 32   ;; / 32x32
EXPORT DEF TILEMAP_HEIGHT    = 32   ;; \

;; OAM
EXPORT DEF OAM_START = $FE00
EXPORT DEF OAM_SIZE  = 160      ;; 40 sprites * 4 bytes cada uno.
EXPORT DEF OAM_END   = $FE9E

;; WRAM
EXPORT DEF WRAM_START = $C000
EXPORT DEF WRAM_END   = $DFFF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Otros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXPORT DEF VBLANK_START = $90   ;; 144 en decimal


;; TILES
EXPORT DEF TILE_FONDO = $00 ;; fondo
EXPORT DEF TILE_SUELO = $01 ;; suelo (el jugador se puede poner encima)
EXPORT DEF TOLE_JUGADOR = $19	;; jugador


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INFO. DE NIVELES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXPORT DEF LEVEL_TOTAL_FILA  = 17 ;; las 17 primeras filas se utilizaran para copiar datos del map
EXPORT DEF LEVEL_TEXT_COLM = 2  ;; / En que posición empieza los tiles para poner el
EXPORT DEF LEVEL_TEXT_FILA = 18 ;; \ numro de nivel en el que se encuentra

EXPORT DEF TAM_VRAM = 32        ;; tamaño VRAM 32 x 32
EXPORT DEF VENTANA_SIZE = TAM_VRAM * LEVEL_TOTAL_FILA ;; celdas iniciales a cargar

;; NIVEL 1
EXPORT DEF LEVEL_1_TOTAL_COLM = 48      ;; columnas que tiene el mapa
EXPORT DEF INIT_POS_X_JUGADOR = 0
EXPORT DEF INIT_POS_Y_JUGADOR = 11


SECTION "Aux", ROM0

habilitar_objetos::
    ;; I: nada
    ;; O: nada
    ;; M: hl
    ld hl, rLCDC
    set 1, [hl]     ;;
ret

wait_vblank::
    ;; I:
    ;; o:
    ;; M: HL, A
    ld hl, rLY

    .do_while:
        ld a, [hl]
        cp VBLANK_START
    jr nz, .do_while
ret

memcpy8::
    ;; I: HL origen
    ;; I: DE destino
    ;; I: B contador
    ;; O: -
    ;; M: HL, DE, B, A
    ld a, [hl]
    ld [de], a
    inc hl
    inc de
    dec b
    jr nz, memcpy8
ret