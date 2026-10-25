;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Registros 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Sonidos
EXPORT DEF rNR10 = $FF10   ;; CH1 barrido
EXPORT DEF rNR21 = $FF16   ;; CH2 onda/duración
EXPORT DEF rNR41 = $FF20   ;; CH4 longitud
EXPORT DEF rNR50 = $FF24   ;; Volumen maestro
EXPORT DEF rNR51 = $FF25   ;; Canales -> altavoz izq/der
EXPORT DEF rNR52 = $FF26   ;; Encendido del APU

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
    EXPORT DEF BGP_CONFIG   = (P_COLOR_BLACK << 6) | (P_COLOR_DARK_GRAY << 4) | (P_COLOR_LIGHT_GRAY << 2) | P_COLOR_WHITE
    EXPORT DEF OBJ0P_CONFIG = (P_COLOR_BLACK << 6) | (P_COLOR_DARK_GRAY << 4) | (P_COLOR_LIGHT_GRAY << 2) | P_COLOR_WHITE
    EXPORT DEF OBJ1P_CONFIG = (P_COLOR_BLACK << 6) | (P_COLOR_DARK_GRAY << 4) | (P_COLOR_LIGHT_GRAY << 2) | P_COLOR_WHITE

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
    EXPORT DEF LCD_WINDOW_OFF = %00000000   ;; Desactiva la capa Ventana (HUD)
    EXPORT DEF LCD_WINDOW_ON  = %00100000   ;; Activa la capa Ventana (HUD)
    DEF LCD_WIN_TILEMAP_9800  = %00000000   ;; Ventana usa el mapa $9800
    DEF LCD_WIN_TILEMAP_9C00  = %01000000   ;; Ventana usa el mapa $9C00
    DEF LCD_POWER_OFF         = %00000000   ;; Apaga la pantalla
    DEF LCD_POWER_ON          = %10000000   ;; Enciende la pantalla
    EXPORT DEF LCD_CONFIG = LCD_BG_DISPLAY_ON | LCD_OBJ_ON | LCD_OBJ_SIZE_8X8 | LCD_BG_TILEMAP_9800 | LCD_TILE_DATA_8000 | LCD_WINDOW_OFF | LCD_WIN_TILEMAP_9C00 |LCD_POWER_ON

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
;; EXPORT DEF INITIAL_TILE_BYTES = tile_data_end - tile_data ;; definida en "./data/gfx.asm"

EXPORT DEF TILEMAP_WIDTH     = 32   ;; / 32x32
EXPORT DEF TILEMAP_HEIGHT    = 32   ;; \

;; OAM
EXPORT DEF OAM_START = $FE00
EXPORT DEF OAM_SIZE  = 160      ;; 40 sprites * 4 bytes cada uno.
EXPORT DEF OAM_END   = $FE9E
EXPORT DEF OAM_X_OFFSET = 8 
EXPORT DEF OAM_Y_OFFSET = 16

;; WRAM
EXPORT DEF WRAM_START = $C000
EXPORT DEF WRAM_END   = $DFFF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Otros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXPORT DEF VBLANK_START = $90   ;; 144 en decimal


;; TILES
EXPORT DEF TILE_FONDO = $00     ;; fondo
EXPORT DEF TILE_SUELO = $01     ;; suelo -> pisble, colisiona y no muere se mantiene al jugador encima
EXPORT DEF TILE_PARED = $02     ;; pared -> al colisionar con ellas muere el jugador
EXPORT DEF TILE_JUGADOR = $03	;; jugador


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Info. de niveles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXPORT DEF LEVEL_MAP_WIDTH  = 20
EXPORT DEF LEVEL_MAP_HEIGHT = 16

EXPORT DEF LEVEL_HUD_ORIGIN_X = 0   ;; en tiles
EXPORT DEF LEVEL_HUD_ORIGIN_Y = 16  ;; en tiles
EXPORT DEF LEVEL_HUD_HEIGHT = 2     ;; en tiles

EXPORT DEF LEVEL_FLOOR_Y = 16       ;; en tiles

EXPORT DEF WINDOW_X_OFFSET = 7              ;; en px
EXPORT DEF WINDOW_START_X = LEVEL_HUD_ORIGIN_X *8 + WINDOW_X_OFFSET ;; en px
EXPORT DEF WINDOW_START_Y = LEVEL_HUD_ORIGIN_Y *8                   ;; en px
                                            ;; *8 por que el 1 tiles = 8px

EXPORT DEF HUD_START_POS_X = WINDOW_START_X ;; en px
EXPORT DEF HUD_START_POS_Y = WINDOW_START_Y ;; en px

EXPORT DEF TAM_VRAM = 32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Info. entidades/jugador
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;; definidas en "wram.asm"
    ;; EXPORT DEF MAX_ENTITIES = 2 ;; MODIFICAR NUMERO DE ENTIDADES MAXIMAS
    ;;
    ;; EXPORT DEF OAM_ENTRY_SIZE = 4
    ;; EXPORT DEF SHADOW_OAM_SIZE = MAX_ENTITIES * OAM_ENTRY_SIZE
    ;;
    ;; EXPORT DEF ENTITY_SIZE = 8
    ;; EXPORT DEF ENTITY_ARRAY_SIZE = MAX_ENTITIES * ENTITY_SIZE
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EXPORT DEF E_CMP    = 0
EXPORT DEF E_Y      = 1
EXPORT DEF E_SPRITE = E_Y
EXPORT DEF E_X      = 2
EXPORT DEF E_TILE   = 3
EXPORT DEF E_ATTR   = 4
EXPORT DEF E_VY     = 5
EXPORT DEF E_VX     = 6
EXPORT DEF E_KIND   = 7

;;   bit  7 6 5 4 3 2 1 0                bit   7 6 5 4 3 2 1 0
;;   CMP |1|x|x|1|x|1|1|1|               KIND |x|x|x|x|x|x|x|x|
;; ALIVE ─┘ │ │ │ │ │ │ └─ SPRITE           x ─┘ │ │ │ │ │ │ └─ JUGADOR
;;       x ─┘ │ │ │ │ └─ PHYSICS              x ─┘ │ │ │ │ └─ ENEMIGO
;;         x ─┘ │ │ └─ COLLIDER                 x ─┘ │ │ └─ x
;;       INPUT ─┘ └─ x                            x ─┘ └─ x

EXPORT DEF CMP_SPRITE_BIT       = 0
EXPORT DEF CMP_PHYSICS_BIT      = 1
EXPORT DEF CMP_COLLIDER_BIT     = 2
;; EXPORT DEF CMP_              = 3
EXPORT DEF CMP_INPUT_BIT        = 4
;; EXPORT DEF CMP_              = 5
;; EXPORT DEF CMP_              = 6
EXPORT DEF CMP_ALIVE_BIT        = 7

EXPORT DEF CMP_SPRITE           = 1 << CMP_SPRITE_BIT
EXPORT DEF CMP_PHYSICS          = 1 << CMP_PHYSICS_BIT
EXPORT DEF CMP_COLLIDER         = 1 << CMP_COLLIDER_BIT
;; EXPORT DEF CMP_              = 1 << CMP_
EXPORT DEF CMP_INPUT            = 1 << CMP_INPUT_BIT ;; Controlled by the player. It has no data
;; EXPORT DEF CMP_              = 1 << CMP_5
;; EXPORT DEF CMP_              = 1 << CMP_6
EXPORT DEF CMP_ALIVE            = 1 << CMP_ALIVE_BIT

EXPORT DEF KIND_JUGADOR_BIT     = 0
EXPORT DEF KIND_ENEMIGO_BIT     = 1
;; EXPORT DEF CMP_              = 2
;; EXPORT DEF CMP_              = 3
;; EXPORT DEF CMP_              = 4
;; EXPORT DEF CMP_              = 5
;; EXPORT DEF CMP_              = 6
;; EXPORT DEF CMP_              = 7

EXPORT DEF KIND_JUGADOR         = 1 << KIND_JUGADOR_BIT
EXPORT DEF KIND_ENEMIGO         = 1 << KIND_ENEMIGO_BIT
;; EXPORT DEF CMP_              = 1 << CMP_2
;; EXPORT DEF CMP_              = 1 << CMP_3
;; EXPORT DEF CMP_              = 1 << CMP_4
;; EXPORT DEF CMP_              = 1 << CMP_5
;; EXPORT DEF CMP_              = 1 << CMP_6
;; EXPORT DEF CMP_              = 1 << CMP_7
;; Tipo de enemigo
    ;; TODO: definir tipos de enemigos tras tener una base funcional



;; Tipo de movimiento (por el momento solo habra 2: horizontal y vertical)
EXPORT DEF E_DIR_HORIZONTAL = 0
EXPORT DEF E_DIR_VERTICAL   = 1

;; Dirección a la que se mueve
EXPORT DEF E_MOVE_NONE      = 0
EXPORT DEF E_MOVE_LEFT      = 1
EXPORT DEF E_MOVE_RIGHT     = 2
EXPORT DEF E_MOVE_DOWN      = 3
EXPORT DEF E_MOVE_UP        = 4

EXPORT DEF VX_JUGADOR       = 5 ;; en px
EXPORT DEF VY_JUGADOR       = 5 ;; en px