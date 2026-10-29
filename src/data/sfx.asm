;; Efectos de sonido.
;; Uso: ld hl, SfxNombre / call sys_sound_play_sfx
;;
;; Reparto de canales (dos efectos del mismo canal no suenan a la vez):
;;   CH1: salto, muerte, nivel, menu OK
;;   CH2: Libre en para la musica
;;   CH4: aterrizar, danio
;; Muerte y danio van en canales distintos: si coinciden, suenan los dos.

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

SfxMuerte::                   ;; CH1: tono que cae (pierde la ultima vida)
    DB LOW(rNR10), 5
    DB $4C, $80, $F6, $00, $87    ;; NR10 barrido hacia abajo lento, empieza agudo

SfxDanio::                    ;; CH4: golpe corto (pierde una vida y sigue jugando)
    DB LOW(rNR41), 4
    DB $00, $F2, $39, $80         ;; NR42 vol 15 se apaga rapido, NR43 ruido metalico

;; ---------- NIVEL ----------

SfxNivel::                    ;; CH1: tono que sube lento, largo
    DB LOW(rNR10), 5
    DB $45, $80, $F7, $00, $85

;; ---------- MENU ----------

SfxMenuOk::                   ;; CH1: tono agudo que sube un poco
    DB LOW(rNR10), 5
    DB $17, $80, $F2, $06, $87
