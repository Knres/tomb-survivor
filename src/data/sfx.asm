;; Efectos de sonido.
;; Uso: ld hl, SfxNombre / call sys_sound_play_sfx
;;
;; Reparto de canales (dos efectos del mismo canal no suenan a la vez):
;;   CH1: salto, muerte (pared), nivel, menu OK
;;   CH2: menu mover (libre en partida para la musica)
;;   CH4: aterrizar, muerte (bicho)

SECTION "SFX", ROM0
;; Formato: DB byte bajo del primer registro, nº de bytes, valores...

;; ---------- JUGADOR ----------

SfxSalto::                    ;; CH1: tono que sube rapido
    DB LOW(rNR10), 5
    DB $15, $80, $F3, $00, $86

SfxAterrizar::                ;; CH4: golpe seco, cortado por duracion
    DB LOW(rNR41), 4
    DB $30, $81, $55, $C0         ;; NR41 duracion ~60 ms, NR42 vol 8, NR43 ruido grave, NR44 play + respetar duracion

;; ---------- MUERTE ----------

SfxMuerte::                   ;; CH1: tono que cae (pared)
    DB LOW(rNR10), 5
    DB $4C, $80, $F6, $00, $87    ;; NR10 barrido hacia abajo lento, empieza agudo

SfxMuerteBicho::              ;; CH4: ruido metalico (tocado por un bicho)
    DB LOW(rNR41), 4
    DB $00, $F4, $39, $80

;; ---------- NIVEL ----------

SfxNivel::                    ;; CH1: tono que sube lento, largo
    DB LOW(rNR10), 5
    DB $45, $80, $F7, $00, $85

;; ---------- MENU ----------

SfxMenuMover::                ;; CH2: "tic" agudo y corto
    DB LOW(rNR21), 4
    DB $40, $A1, $83, $87

SfxMenuOk::                   ;; CH1: tono agudo que sube un poco
    DB LOW(rNR10), 5
    DB $17, $80, $F2, $06, $87
