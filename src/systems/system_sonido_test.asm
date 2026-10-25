;; =====================================================================
;; HERRAMIENTA DE PRUEBA DE SONIDO (no es parte del juego)
;; Cada boton reproduce un efecto de data/sfx.asm, para ajustarlos de oido.
;; Para quitarla: borrar este archivo y las 2 llamadas de main.asm
;;   (call sys_sound_test_init / call sys_sound_test_update)
;;
;;   A      -> SfxSalto          B     -> SfxMuerte
;;   SELECT -> SfxMuerteBicho    START -> SfxNivel
;;   ARRIBA -> SfxMenuOk         ABAJO -> SfxAterrizar
;;   IZQ.   -> SfxMenuMover      DER.  -> (libre)
;; =====================================================================

;; Bits de la lectura combinada (1 = pulsado): %DULR SsBA
DEF TEST_BTN_A_BIT      = 0
DEF TEST_BTN_B_BIT      = 1
DEF TEST_BTN_SELECT_BIT = 2
DEF TEST_BTN_START_BIT  = 3
DEF TEST_BTN_RIGHT_BIT  = 4
DEF TEST_BTN_LEFT_BIT   = 5
DEF TEST_BTN_UP_BIT     = 6
DEF TEST_BTN_DOWN_BIT   = 7

DEF JOYP_SELECT_BUTTONS = %00010000   ;; bit 5 = 0 -> grupo A, B, Select, Start
DEF JOYP_SELECT_DPAD    = %00100000   ;; bit 4 = 0 -> grupo cruceta
DEF JOYP_SELECT_NONE    = %00110000   ;; ningun grupo

SECTION "Sonido test WRAM", WRAM0
sound_test_prev: DS 1       ;; botones pulsados en el frame anterior (1 = pulsado)

SECTION "Sonido test", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Inicializa la herramienta de prueba (la RAM no empieza a 0).
;; INPUT: -
;; RETURNS: -
;; MODIFICA: A
sys_sound_test_init::
    ld   a, $FF                     ;; \ "Todo pulsado" en el frame anterior:
    ld   [sound_test_prev], a       ;; / nada suena por error en el primer frame
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lee los 8 botones y, si uno se ACABA de pulsar, reproduce su efecto.
;; Solo suena uno por frame (el primero que encuentra).
;; Llamar una vez por frame.
;; INPUT: -
;; RETURNS: -
;; MODIFICA: A, BC, DE, HL
sys_sound_test_update::
    ld   hl, rJOYP                  ;; HL = registro del joypad

    ld   a, JOYP_SELECT_BUTTONS     ;; \ Seleccionar grupo de botones
    ld   [hl], a                    ;; /
    ld   a, [hl]                    ;; \
    ld   a, [hl]                    ;; | Leer 3 veces para estabilizar
    ld   a, [hl]                    ;; /
    and  $0F                        ;; \ B = %0000 SsBA (0 = pulsado)
    ld   b, a                       ;; /

    ld   a, JOYP_SELECT_DPAD        ;; \ Seleccionar grupo de la cruceta
    ld   [hl], a                    ;; /
    ld   a, [hl]                    ;; \
    ld   a, [hl]                    ;; | Leer 3 veces para estabilizar
    ld   a, [hl]                    ;; /
    and  $0F                        ;; \ A = %0000 DULR
    swap a                          ;; | A = %DULR 0000
    or   b                          ;; | A = %DULR SsBA (0 = pulsado)
    cpl                             ;; | Invertir: 1 = pulsado
    ld   b, a                       ;; / B = botones pulsados ahora

    ld   a, JOYP_SELECT_NONE        ;; \ Dejar el joypad sin grupo
    ld   [hl], a                    ;; /

    ld   a, [sound_test_prev]       ;; \ A = pulsados el frame anterior
    cpl                             ;; | A = NO pulsados el frame anterior
    and  b                          ;; | A = pulsados ahora y no antes
    ld   c, a                       ;; / C = recien pulsados (flanco)

    ld   a, b                       ;; \ Guardar para el siguiente frame
    ld   [sound_test_prev], a       ;; /

    ld   hl, SfxSalto               ;; \ A -> salto
    bit  TEST_BTN_A_BIT, c          ;; |
    jp   nz, sys_sound_play_sfx     ;; /

    ld   hl, SfxMuerte              ;; \ B -> muerte (pared)
    bit  TEST_BTN_B_BIT, c          ;; |
    jp   nz, sys_sound_play_sfx     ;; /

    ld   hl, SfxMuerteBicho         ;; \ SELECT -> muerte (bicho)
    bit  TEST_BTN_SELECT_BIT, c     ;; |
    jp   nz, sys_sound_play_sfx     ;; /

    ld   hl, SfxNivel               ;; \ START -> pasar de nivel
    bit  TEST_BTN_START_BIT, c      ;; |
    jp   nz, sys_sound_play_sfx     ;; /

    ld   hl, SfxMenuOk              ;; \ ARRIBA -> menu OK
    bit  TEST_BTN_UP_BIT, c         ;; |
    jp   nz, sys_sound_play_sfx     ;; /

    ld   hl, SfxAterrizar           ;; \ ABAJO -> aterrizar
    bit  TEST_BTN_DOWN_BIT, c       ;; |
    jp   nz, sys_sound_play_sfx     ;; /

    ld   hl, SfxMenuMover           ;; \ IZQUIERDA -> menu mover
    bit  TEST_BTN_LEFT_BIT, c       ;; |
    jp   nz, sys_sound_play_sfx     ;; /

    ret                             ;; Ningun boton nuevo: no suena nada
