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


; 0  0    0     0    0 0 0      0
; up down right left a b start  select
; 0 = false, 1 = true (logica invertida a como funciona la lectura por joypad, me parece mas intuitiva)
joypad_pressed: DS 1    ;; almacena qué botones acaban de ser pulsados en este frame
joypad_held: DS 1    ;; almacena qué botones acaban de ser pulsados en este frame

EXPORT DEF ESTADO_INICIAL = 0
EXPORT DEF ESTADO_UNO = 1
EXPORT DEF ESTADO_DOS = 2
EXPORT DEF ESTADO_ERROR = $FF


SECTION "Entry point", ROM0[$150]

main::
    di     ;; Disable Interrupts
    ld a, 1
    ld hl, continuar_bucle ;; inicializo continuar_bucle
    ld [hl], a
    ld hl, estado_actual
    ld a,  ESTADO_UNO
    ld [hl], a

    ;; inicializacion de cosas
    call init_game  ;; llamar solo una vez por arranque de juego (¡¡ no arranque de nivel !!)

    ld hl, scene_menu
    call manager_escena_cambiar

    bucle_principal:
        ;ld bc, ESTADO_ERROR  ;; SOLO SIRVE PARA VER SI ESTA YENDO A UN ESTADO QUE NO DEBE, NO HACE BUCLE Y TERMINA LA EJECUCION CON BC = $FF
        call sys_input_update
        
;        .bucle:
;        ld a, [joypad_pressed]
;        cp 0
;        jr z, .sigue
;        jr .bucle

        .sigue:
        call manager_escena_update      ;; la escena actual hace lo suyo (jugador, prerender... van en scene_ingame_update)
        call sys_music_update            ;; actualiza la musica, si hay alguna nota en curso, la reproduce y la cuenta, si se acabo, pasa a la siguiente nota
        call system_render_update       ;; comun: copiar sprites a la OAM en VBLANK


        jr bucle_principal