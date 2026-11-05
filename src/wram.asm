EXPORT DEF MAX_ENTITIES = 25;; MODIFICAR NUMERO DE ENTIDADES MAXIMAS

EXPORT DEF OAM_ENTRY_SIZE = 4
EXPORT DEF SHADOW_OAM_SIZE = MAX_ENTITIES * OAM_ENTRY_SIZE

EXPORT DEF ENTITY_SIZE = 8
EXPORT DEF ENTITY_ARRAY_SIZE = MAX_ENTITIES * ENTITY_SIZE

SECTION "Entidades y Jugador", WRAM0, ALIGN[8]

entity_array::  DS ENTITY_ARRAY_SIZE ;; MAX_ENTITIES * ENTITY_SIZE
shadow_oam::    DS SHADOW_OAM_SIZE   ;; MAX_ENTITIES * OAM_ENTRY_SIZE
shadow_cursor:: DS 2
jugador_x::  DS 1    ;; recordar que es en px 
jugador_y::  DS 1    ;; recordar que es en px
jugador_direccion_movimiento:: DS 1
jugador_solicita_salto:: DS 1
jugador_en_suelo::       DS 1
jugador_y_anterior::     DS 1
jugador_a_anterior::     DS 1
jugador_frame_vertical:: DS 1
jugador_espera_cambio_frame:: DS 1
jugador_vidas::          DS 1
escudo_jugador::         DS 1
hit_reciente::           DS 1
ultimo_hit::             DS 1
enemigos_activos::       DS 1   ;; 0 -> no update enemigos (no hace call ia_enemigo_update)

SECTION "Entorno", WRAM0

musica_inicio::   DS 2     ;; Direccion de la primera nota
musica_ptr::      DS 2     ;; Direccion de la nota siguiente
musica_contador:: DS 1     ;; Frames que le quedan a la nota actual

pause_saved_tiles::  DS 5   ;; guarda los 5 tiles donde sustituye por texto PAUSE
pause_reloj_activo:: DS 1   ;; guarda el reloj actual para que no se acctualice en estado pausa

SECTION "Nivel actual", WRAM0
nivel_actual:: DS 1

SECTION "Escena actual", WRAM0
escena_update:: DS 2


SECTION "Escena temporizada", WRAM0
escena_contador::  DS 1
escena_siguiente:: DS 2

frame_actual:: DS 1 ;; cuenta el frame actual de cada segundo. Se reinicia a los 60 frames. Valores: 0-59
reloj_fin_nivel:: DS 1 ;; cuenta en que segundo se encuentra el nivel. Hace una cuenta regresiva desde INICIO_RELOJ a 0
reloj_activo:: DS  1 ;; 0 = parao, distinto = encendido
next_segundo_spwan:: DS 2

SECTION "Menu", WRAM0
menu_start_anterior:: DS 1
menu_opcion: DS 1
menu_dpad_anterior:: DS 1 
hay_partida:: DS 1