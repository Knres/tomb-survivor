SECTION "Joypad", ROM0


;; ESTOS SON LOS VALORES CON LOS QUE SE LEE DEL JOYPAD, COMO SE REPITEN NUMEROS NO PUEDO USARLOS COMO MASCARA DE LECTURA DE JOYPAD_PRESSED O HELD, SOLO SE USAN AQUI, CONQUE NO SE EXPORTAN GLOBALMENTE
DEF UP_BIT_JOYPAD = 2   
DEF DOWN_BIT_JOYPAD = 3
DEF LEFT_BIT_JOYPAD = 1
DEF RIGHT_BIT_JOYPAD = 0
DEF START_BIT_JOYPAD = 3
DEF SELECT_BIT_JOYPAD = 2
DEF A_BIT_JOYPAD = 0
DEF B_BIT_JOYPAD = 1


press_update::
    ; 0  0    0     0    0 0 0      0
    ; up down right left a b start  select
    ; 0 = false, 1 = true (logica invertida a como funciona la lectura por joypad, me parece mas intuitiva)
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
        bit UP_BIT_JOYPAD, b
        jr nz, .pruebo_abajo
        set UP_BIT, a
    
    .pruebo_abajo:
        bit DOWN_BIT_JOYPAD, b
        jr nz, .pruebo_izquierda
        set DOWN_BIT, a
    
    .pruebo_izquierda:
        bit LEFT_BIT_JOYPAD, b
        jr nz, .pruebo_derecha
        set LEFT_BIT, a
    
    .pruebo_derecha:
        bit RIGHT_BIT_JOYPAD, b
        jr nz, .otros_botones
        set RIGHT_BIT, a

    .otros_botones:
        ld c, a     ;; guardo a porque debo otra vez usarlo para cambiar de tipo de boton      
        ld a, %00010000 ;; Select Action keys group
        ld [hl], a
        ld a, [hl]
        ld a, [hl]
        ld a, [hl]
        ld b, a
        ld a, c

    .pruebo_A:
        bit A_BIT_JOYPAD, b
        jr nz, .pruebo_B
        set A_BIT, a

    .pruebo_B:
        bit B_BIT_JOYPAD, b
        jr nz, .pruebo_start
        set B_BIT, a

    .pruebo_start:
        bit START_BIT_JOYPAD, b
        jr nz, .pruebo_select
        set START_BIT, a

    .pruebo_select:
        bit SELECT_BIT_JOYPAD, b
        jr nz, .guarda
        set SELECT_BIT, a

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