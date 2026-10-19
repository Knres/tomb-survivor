;;----------LICENSE NOTICE-------------------------------------------------------------------------------------------------------;;
;;  This file is part of GBTelera: A Gameboy Development Framework                                                               ;;
;;  Copyright (C) 2024 ronaldo / Cheesetea / ByteRealms (@FranGallegoBR)                                                         ;;
;;                                                                                                                               ;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    ;;
;; files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy,    ;;
;; modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the         ;;
;; Softwareis furnished to do so, subject to the following conditions:                                                           ;;
;;                                                                                                                               ;;
;; The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.;;
;;                                                                                                                               ;;
;; THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          ;;
;; WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         ;;
;; COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   ;;
;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         ;;
;;-------------------------------------------------------------------------------------------------------------------------------;;


SECTION "Sistema", WRAM0
continuar_bucle: DS 1   ;;  tan solo sirve para mantener el bucle principal, es el true en un while true
estado_actual: DS 1     ;;  guarda el numero de estado en el que se encuentra el bucle principal. Hay hasta 256 posibles estados, pero no vamos a usar tantos

EXPORT DEF ESTADO_INICIAL = 0
EXPORT DEF ESTADO_UNO = 1
EXPORT DEF ESTADO_DOS = 2
EXPORT DEF ESTADO_ERROR = $FF


SECTION "Entry point", ROM0[$150]

wait_VBLANK:
    ld a, [$FF44]
    cp 144
    jr nz, wait_VBLANK
    ret

main::
    di     ;; Disable Interrupts
    ld a, 1
    ld hl, continuar_bucle ;; inicializo continuar_bucle
    ld [hl], a
    ld hl, estado_actual
    ld a,  ESTADO_UNO
    ld [hl], a
    bucle_principal:
    ;      ld bc, ESTADO_ERROR  ;; SOLO SIRVE PARA VER SI ESTA YENDO A UN ESTADO QUE NO DEBE, NO HACE BUCLE Y TERMINA LA EJECUCION CON BC = $FF
        call wait_VBLANK
        call scene_manager
        jr bucle_principal
    fin:


halt   ;; Halt the CPU (stop procesing here)