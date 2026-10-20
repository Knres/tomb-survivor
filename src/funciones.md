pressed_update:
    modifica: a, hl, joypad_pressed (valor), flags

scene_manager:
    modifica: a, flags


wait_vblank:
    modifica: a, flags
    
wait_vblank::
    ;; I:
    ;; o:
    ;; M: HL, A

habilitar_objetos::
    ;; I: nada
    ;; O: nada
    ;; M: hl

memcpy8::
    ;; I: HL origen
    ;; I: DE destino
    ;; I: B contador
    ;; O: -
    ;; M: HL, DE, B, A