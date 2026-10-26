SECTION "Joypad", ROM0
DEF UP_BIT = 2
DEF DOWN_BIT = 3
DEF LEFT_BIT = 1
DEF RIGHT_BIT = 0

press_update::
    ; 0  0    0     0    0 0 0      0
    ; 0 = false, 1 = true (logica invertida a como funciona la lectura por joypad, me parece mas intuitiva)
    ; up down right left a b start  select
    ld a, 0
    ld [joypad_pressed], a  ;; reseteo el valor de joypad_pressed

    ld hl, $FF00
    ld a, %00100000 ;; Select Direction keys group
    ld [hl], a
    ld a, [hl]
    ld a, [hl]
    ld a, [hl]
    ld b, a
    
    ld a, [joypad_pressed]  ; cojo lo de joypad_pressed

    .pruebo_arriba:
        bit UP_BIT, b
        jr nz, .pruebo_abajo
        set 7, a
    .pruebo_abajo:
        bit DOWN_BIT, b
        jr nz, .guarda
        set 6, a

    .guarda:
        ld [joypad_pressed], a
    ret

sys_input_update::
    ld a, [joypad_pressed] ; recojo lo que hay originalmente en joypad_pressed para comparar una vez actualizado y modificar [joypad_held]
    ld c, a                ; lo guardo en c, ya que a es modificado durante press_update
    call press_update
    
    ld a, [joypad_pressed]
    
    and c                  ; solo conservo los bits que llevan dos iteraciones siendo pulsados

    ld a, c

    ld [joypad_held], a

    ret