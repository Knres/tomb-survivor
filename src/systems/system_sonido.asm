SECTION "System sonido", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Enciende el APU con volumen máximo y todos los canales en los dos altavoces.
;; INPUT: -
;; RETURNS: -
;; MODIFICA: A
sys_sound_init::
    ld   a, $80              ;; \ APU encendido
    ld   [rNR52], a          ;; /
    ld   a, $77              ;; \ Volumen maestro máximo (izq y der)
    ld   [rNR50], a          ;; /
    ld   a, $FF              ;; \ Los 4 canales a los dos altavoces
    ld   [rNR51], a          ;; /
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reproduce un efecto: copia sus bytes a los registros del canal.
;; INPUT: HL = dirección del efecto (SfxSalto, SfxMuerte, ...)
;; RETURNS: -
;; MODIFICA: A, B, DE, HL
sys_sound_play_sfx::
    ld   a, [hl+]            ;; \ DE = $FF00 + byte bajo del primer registro
    ld   e, a                ;; |
    ld   d, $FF              ;; /
    ld   a, [hl+]            ;; \ B = nº de bytes a copiar
    ld   b, a                ;; /  (HL -> primer valor)
    jp   memcpy8             ;; Copia a los registros y vuelve