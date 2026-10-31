SECTION "Scene ingame", ROM0

;; Escena de partida
scene_ingame::
    DW scene_ingame_init
    DW scene_ingame_update

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Entra en la partida: carga el mapa de nivel_actual, crea entidades y enciende el HUD.
;; nivel_actual lo pone quien empieza la partida (1 = partida nueva).
;; I: -
;; O: -
;; M: A, BC, DE, HL
scene_ingame_init::
    call init_reloj
    call system_render_load_map
    call system_prerender_init_entities
    call system_prerender_init_jugador
    ld hl, musica_partida
    call sys_music_play

    ;; ===================================
    ;; pureba
        ;; mover esto a una funcion o algo
        xor a                    ;; / no se llama a update de enemigos si 
        ld [enemigos_activos], a ;; \ enemigos_activos = 0, se activa tras primer imput
    ;;=====================================

    call manager_entity_init_enemies
jp init_hud

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cada frame en la partida: mueve al jugador y prepara los sprites.
;; Aqui iran fisicas, colisiones...
;; I: -
;; O: -
;; M: A, BC, DE, HL
scene_ingame_update::
    call system_jugador_update        ;; input del jugador: direccion y salto
    call system_fisicas_update        ;; fisicas: aplica velocidad y gravedad
    call system_render_scroll         ;; el scroll, pero como max_x_y van ha ser 0 no modifica
    call system_colisiones_update     ;; deteccion de colisiones
    call jugador_sprite_update
    call system_prerender_pos_jugador ;; actualiza la posicion del jugador en memoria y las prepara para el OAM
    ld a, [reloj_activo]
    cp RELOJ_ENCENDIDO ;; SI EL RELOJ ESTA APAGADO NO HACE FALTA QUE ENTRE A LO DE SPAWNEAR ENEMIGOS DURANTE EL NIVEL
    jr nz, .continua
    call spawn_enemigo_no_fijo
    .continua:
    ;; ===================================
    ;; pureba
    ;; mover esto a una funcion o algo
        ld a, [enemigos_activos]
        and a       ;; a == 0?
        jr nz, .actualiza_ia
            ;; pulsar cualquier tacla para comenzar
                ld a, [joypad_pressed]
                and a
                jr z, .no_actulizar_ia

                ld a, 1
                ld [enemigos_activos], a
                call activar_reloj
            .actualiza_ia
                ld hl, ia_enemigo_update          ;; actualizar a las entidades
                call manager_entity_for_each
        .no_actulizar_ia
    ;;=====================================
jp   system_prerender_update      ;; preparar los sprites de como ha quedado todo