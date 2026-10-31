;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Registros 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Sonidos
EXPORT DEF rNR10 = $FF10   ;; CH1 barrido
EXPORT DEF rNR21 = $FF16   ;; CH2 onda/duración
EXPORT DEF rNR22 = $FF17      ;; CH2 volumen
EXPORT DEF rNR23 = $FF18      ;; CH2 tono (byte bajo)
EXPORT DEF rNR24 = $FF19      ;; CH2 play + tono (byte alto)
EXPORT DEF rNR41 = $FF20   ;; CH4 longitud
EXPORT DEF rNR50 = $FF24   ;; Volumen maestro
EXPORT DEF rNR51 = $FF25   ;; Canales -> altavoz izq/der
EXPORT DEF rNR52 = $FF26   ;; Encendido del APU
EXPORT DEF MUSICA_VOLUMEN = $73   ;; volumen 7, se apaga poco a poco


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
;; mascaras de lectura de joypad_pressed y joypad_held
EXPORT DEF UP_BIT = 0   
EXPORT DEF DOWN_BIT = 1
EXPORT DEF LEFT_BIT = 2
EXPORT DEF RIGHT_BIT = 3
EXPORT DEF START_BIT = 4
EXPORT DEF SELECT_BIT = 5
EXPORT DEF A_BIT = 6
EXPORT DEF B_BIT = 7
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
EXPORT DEF INICIO_RELOJ = 30    ;; inicio del reloj del nivel que determina cuándo acaba este
EXPORT DEF FIN_RELOJ = 0
EXPORT DEF FIN_SEGUNDO = 59
EXPORT DEF INICIO_SEGUNDO = 0
EXPORT DEF RELOJ_PARADO = 0
EXPORT DEF RELOJ_ENCENDIDO = 1
;; TILES
EXPORT DEF TILE_FONDO = $00             ;; fondo
EXPORT DEF TILE_SUELO = $01             ;; suelo temporal
;;EXPORT DEF TILE_JUGADOR = $03	        ;; jugador temporal

EXPORT DEF TILE_ESCORPION2 = $02        ;; escorpion2
EXPORT DEF TILE_ESCORPION = $04         ;; escorpion
EXPORT DEF TILE_PLAT_DERECHA = $05      ;; plataforma derecha
EXPORT DEF TILE_PLAT_IZQUIERDA = $06    ;; plataforma izquierda
EXPORT DEF TILE_PARED_NUEVA = $07       ;; pared nueva
EXPORT DEF TILE_CORAZON    = $08        ;; corazon
EXPORT DEF TILE_NO_CORAZON = $09        ;; no corazon
EXPORT DEF TILE_PINCHOS    = $0A        ;; pinchos
EXPORT DEF TILE_MURCIELAGO_1 = $0B      ;; murcielago, frame 1
EXPORT DEF TILE_MURCIELAGO_2 = $0C      ;; murcielago, frame 2
EXPORT DEF TILE_JUGADOR_TEMPORAL = $03  ;; jugador temporal
EXPORT DEF TILE_JUGADOR_1 = $0D         ;; jugador, frame 1
EXPORT DEF TILE_JUGADOR_2 = $0E         ;; jugador, frame 2
EXPORT DEF TILE_JUGADOR_SALTO = $0F     ;; jugador saltando
EXPORT DEF TILE_JUGADOR = TILE_JUGADOR_2;; frame por defecto
EXPORT DEF TILE_ESTALACTITA = TILE_PINCHOS   ;; estalactita TODO: sustituir sprite
EXPORT DEF TILE_DARDO = $10                  ;; dardo
EXPORT DEF TILE_ESCORPION_1 = TILE_ESCORPION ;; escorpion, frame 1 
EXPORT DEF TILE_ESCORPION_2 = TILE_ESCORPION2 ;; escorpion, frame 2 TODO: sustituir este frame
EXPORT DEF TILE_MOMIA_1 = TILE_PLAT_DERECHA
EXPORT DEF TILE_MOMIA_2 = TILE_PLAT_IZQUIERDA


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Info. tam. entidades/jugador
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXPORT DEF TILE_SIZE      = 8
EXPORT DEF JUGADOR_ALTO   = TILE_SIZE
EXPORT DEF TAM_COLISION   = 6
EXPORT DEF LIST_END       = $FF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Info. de niveles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXPORT DEF PANTALLA_ANCHO = 20
EXPORT DEF PANTALLA_ALTO  = 18

EXPORT DEF LEVEL_MAP_WIDTH  = 20
EXPORT DEF LEVEL_MAP_HEIGHT = 16

EXPORT DEF LEVEL_HUD_ORIGIN_X = 0   ;; en tiles
EXPORT DEF LEVEL_HUD_ORIGIN_Y = 16  ;; en tiles
EXPORT DEF LEVEL_HUD_HEIGHT = 2     ;; en tiles

EXPORT DEF LEVEL_FLOOR_Y = 15       ;; en tiles
EXPORT DEF LEVEL_FLOOR_PX = LEVEL_FLOOR_Y * TILE_SIZE

EXPORT DEF WINDOW_X_OFFSET = 7              ;; en px
EXPORT DEF WINDOW_START_X = LEVEL_HUD_ORIGIN_X *8 + WINDOW_X_OFFSET ;; en px
EXPORT DEF WINDOW_START_Y = LEVEL_HUD_ORIGIN_Y *8                   ;; en px
                                            ;; *8 por que el 1 tiles = 8px

EXPORT DEF HUD_WINDOW_X = WINDOW_START_X
EXPORT DEF HUD_WINDOW_Y = WINDOW_START_Y
EXPORT DEF HUD_TEXTO_NIVEL    = TILEMAP_HUD_START + 1
EXPORT DEF HUD_VIDAS_JUGADOR  = TILEMAP_HUD_START + 13
EXPORT DEF HUD_CONTADOR_TIEMPO= TILEMAP_HUD_START + 17

EXPORT DEF HUD_START_POS_X = WINDOW_START_X ;; en px
EXPORT DEF HUD_START_POS_Y = WINDOW_START_Y ;; en px


EXPORT DEF CAMERA_MAX_X = 0    ;; es 0 porque no se mueve el scroll
EXPORT DEF CAMERA_MAX_Y = 0    ;; es 0 porque no se mueve el scroll

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

;;   bit  7 6 5 4 3 2 1 0                  bit   7 6 5 4 3 2 1 0
;;   CMP |1|x|x|1|x|1|1|1|                 KIND |x|x|x|x|x|x|x|x|
;; ALIVE ─┘ │ │ │ │ │ │ └─ SPRITE             x ─┘ │ │ │ │ │ │ └─ JUGADOR
;;       x ─┘ │ │ │ │ └─ PHYSICS                x ─┘ │ │ │ │ └─ ESCORPION
;;         x ─┘ │ │ └─ COLLIDER        ESTALACTITAS ─┘ │ │ └─ MURCIELAGO
;;       INPUT ─┘ └─ x                        PINCHOS ─┘ └─ MOMIA

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
EXPORT DEF KIND_ESCORPION_BIT   = 1
EXPORT DEF KIND_MURCIELAGO_BIT  = 2
EXPORT DEF KIND_MOMIA_BIT       = 3
EXPORT DEF KIND_PINCHOS_BIT     = 4
EXPORT DEF KIND_ESTALACTITA_BIT = 5
EXPORT DEF KIND_DARDO_BIT       = 6
;; EXPORT DEF KIND_             = 7
        EXPORT DEF KIND_FIN_ENEMIGOS_FIJOS    = 0 ;; estilo centinela
        EXPORT DEF KIND_JUGADOR         = 1 << KIND_JUGADOR_BIT
        EXPORT DEF KIND_ESCORPION       = 1 << KIND_ESCORPION_BIT
        EXPORT DEF KIND_MURCIELAGO      = 1 << KIND_MURCIELAGO_BIT
        EXPORT DEF KIND_MOMIA           = 1 << KIND_MOMIA_BIT
        EXPORT DEF KIND_PINCHOS         = 1 << KIND_PINCHOS_BIT
        EXPORT DEF KIND_ESTALACTITA     = 1 << KIND_ESTALACTITA_BIT
        EXPORT DEF KIND_DARDO           = 1 << KIND_DARDO_BIT
        ;; EXPORT DEF KIND_             = 1 << CMP_7
;; TODO: definir tipos de enemigos tras tener una base funcional


EXPORT DEF ATTR_BIT_PRIORIDAD = 7 ;;(Prioridad OBJ-BG)
EXPORT DEF ATTR_BIT_FLIP_Y    = 6 ;; Volvar (espejo) el sprite en Y
EXPORT DEF ATTR_BIT_FLIP_X    = 5 ;; Volvar (espejo) el sprite en X
EXPORT DEF ATTR_BIT_PALET     = 4 ;; Selector paleta 0 --> OBJP0; 1 --> OBJP1 
        EXPORT DEF ATTR_PRIORIDAD   = 1 << ATTR_BIT_PRIORIDAD
        EXPORT DEF ATTR_FLIP_Y      = 1 << ATTR_BIT_FLIP_Y
        EXPORT DEF ATTR_FLIP_X      = 1 << ATTR_BIT_FLIP_X
        EXPORT DEF ATTR_PALET       = 1 << ATTR_BIT_PALET


;; Tipo de movimiento (por el momento solo habra 2: horizontal y vertical)
EXPORT DEF E_DIR_HORIZONTAL = 0
EXPORT DEF E_DIR_VERTICAL   = 1

;; Dirección a la que se mueve
EXPORT DEF E_MOVE_NONE      = 0
EXPORT DEF E_MOVE_LEFT      = 1
EXPORT DEF E_MOVE_RIGHT     = 2
EXPORT DEF E_MOVE_DOWN      = 3
EXPORT DEF E_MOVE_UP        = 4

EXPORT DEF VX_JUGADOR           = 1  ;; px por frame
;; EXPORT DEF VY_JUGADOR        = 20 ;; en frames de salto (tras 5 frames empieza a caer)
EXPORT DEF IMPULSO_SALTO        = 10 ;; velocidad inicial de salto
EXPORT DEF GRAVEDAD             = 1  ;; incremento de VY por frame
EXPORT DEF VELOCIDAD_MAX_CAIDA  = 4  ;; px por frame
EXPORT DEF VIDAS_JUGADOR        = 3  ;; vidas maximas e iniciales que tiene el jugador   


EXPORT DEF JUGADOR_ESPERA_FRAME = 10 ;; updates entre cambios de frame
;; ENTIDAD: MURCIELAGO
EXPORT DEF MURCIELAGO_ESPERA_FRAME = 20         ;; updates entre cambios de frame
;; ENTIDAD: ESCORPION
EXPORT DEF ESCORPION_ESPERA_FRAME = 15          ;; updates entre cambios de frame
;; ENTIDAD: ESCORPION
EXPORT DEF MOMIA_ESPERA_FRAME = 60              ;; updates entre pasos y cambio de frame
;; ENTIDAD: ESTALACTITA
EXPORT DEF ESTALACTITA_ESTADO_ESPERANDO = 0
EXPORT DEF ESTALACTITA_ESTADO_CAYENDO = 1
EXPORT DEF ESTALACTITA_ESTADO_FINALIZADO = 2
EXPORT DEF ESTALACTITA_VELOCIDAD = 1            ;; px por update
;; ENTIDAD: PINCHOS
EXPORT DEF PINCHOS_FASE_SUBIDA = TILE_SIZE      ;; <-- Sube una altura de un tile (8px) fase subida 0-7  --> 8 fin de fase
EXPORT DEF PINCHOS_FASE_BAJADA = TILE_SIZE * 2  ;; <-- Baja una altura de un tile       fase bajada 7-15 --> 0 fin de fase <-- si llega a 16 se pone a 0
EXPORT DEF PINCHOS_ESPERA_SUBIDA_BAJARA = 4     ;; pausa para la subida-bajada, a 1px por update es demasidao rapido
EXPORT DEF PINCHOS_ESPERA_FASE     = 120        ;; se mantiene en estado subido o bajado durante tantos frames

;; ENTIDAD: DARDO
EXPORT DEF EN_VUELO = $F0


EXPORT DEF DURACION_PANTALLA = 180
EXPORT DEF NUM_NIVELES = 1

;; Notas para la musica (tono del canal 2). C=do D=re E=mi F=fa G=sol A=la B=si, S=sostenido
EXPORT DEF NOTA_SILENCIO = 0
EXPORT DEF NOTA_C3  = $416
EXPORT DEF NOTA_CS3 = $44E
EXPORT DEF NOTA_D3  = $483
EXPORT DEF NOTA_DS3 = $4B5
EXPORT DEF NOTA_E3  = $4E5
EXPORT DEF NOTA_F3  = $511
EXPORT DEF NOTA_FS3 = $53B
EXPORT DEF NOTA_G3  = $563
EXPORT DEF NOTA_GS3 = $589
EXPORT DEF NOTA_A3  = $5AC
EXPORT DEF NOTA_AS3 = $5CE
EXPORT DEF NOTA_B3  = $5ED
EXPORT DEF NOTA_C4  = $60B
EXPORT DEF NOTA_CS4 = $627
EXPORT DEF NOTA_D4  = $642
EXPORT DEF NOTA_DS4 = $65B
EXPORT DEF NOTA_E4  = $672
EXPORT DEF NOTA_F4  = $689
EXPORT DEF NOTA_FS4 = $69E
EXPORT DEF NOTA_G4  = $6B2
EXPORT DEF NOTA_GS4 = $6C4
EXPORT DEF NOTA_A4  = $6D6
EXPORT DEF NOTA_AS4 = $6E7
EXPORT DEF NOTA_B4  = $6F7
EXPORT DEF NOTA_C5  = $706
EXPORT DEF NOTA_CS5 = $714
EXPORT DEF NOTA_D5  = $721
EXPORT DEF NOTA_DS5 = $72D
EXPORT DEF NOTA_E5  = $739
EXPORT DEF NOTA_F5  = $744
EXPORT DEF NOTA_FS5 = $74F
EXPORT DEF NOTA_G5  = $759
EXPORT DEF NOTA_GS5 = $762
EXPORT DEF NOTA_A5  = $76B
EXPORT DEF NOTA_AS5 = $773
EXPORT DEF NOTA_B5  = $77B
