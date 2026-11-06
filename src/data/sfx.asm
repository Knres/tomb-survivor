;; Efectos de sonido.
;; Uso: ld hl, SfxNombre / call sys_sound_play_sfx
;;
;; Reparto de canales (dos efectos del mismo canal no suenan a la vez):
;;   CH1: salto, muerte, nivel, escudo, menu (mover y OK)
;;   CH2: libre para la musica
;;   CH4: aterrizar, danio
;; Muerte y danio van en canales distintos: si coinciden, suenan los dos.

SECTION "SFX", ROM0
;; Formato: DB byte bajo del primer registro, nº de bytes, valores...

;; ---------- JUGADOR ----------

SfxSalto::                    ;; CH1: tono grave que sube rapido
    DB LOW(rNR10), 5
    DB $25, $80, $F2, $E2, $85    ;; NR10 sube cada ~16 ms, se corta solo al llegar arriba

SfxAterrizar::                ;; CH4: golpe metalico muy corto
    DB LOW(rNR41), 4
    DB $30, $D2, $7D, $C0         ;; NR41 dura ~60 ms, NR42 vol 13, NR43 ruido metalico grave, NR44 respetar duracion

;; ---------- OBJETOS ----------

SfxEscudo::                   ;; CH1: "ding" agudo y hueco (coger el escudo)
    DB LOW(rNR10), 5
    DB $00, $40, $F2, $9D, $87    ;; NR10 sin barrido, NR11 timbre hueco, nota fija (~1300 Hz)

;; ---------- MUERTE ----------

SfxMuerte::                   ;; CH1: tono hueco que cae (pierde la ultima vida)
    DB LOW(rNR10), 5
    DB $5C, $40, $F6, $00, $87    ;; NR10 baja despacio, NR12 se apaga lento

SfxDanio::                    ;; CH4: golpe metalico corto (pierde una vida y sigue jugando)
    DB LOW(rNR41), 4
    DB $00, $A2, $59, $80         ;; NR42 vol 10 se apaga rapido, NR43 ruido metalico

;; ---------- NIVEL ----------

SfxNivel::                    ;; CH1: tono que sube lento, largo
    DB LOW(rNR10), 5
    DB $36, $80, $F5, $02, $86

;; ---------- MENU ----------

SfxMenuOk::                   ;; CH1: tono que sube un poco (confirmar en el menu)
    DB LOW(rNR10), 5
    DB $16, $80, $F2, $C4, $86

SfxMenuMover::                ;; CH1: "tic" hueco y corto (cambiar de opcion en el menu)
    DB LOW(rNR10), 5
    DB $00, $C0, $E1, $7C, $87    ;; NR10 sin barrido, NR11 duty 75% (suena como el hueco), NR12 vol 14 se apaga muy rapido
