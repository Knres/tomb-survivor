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
    call system_render_load_map
    call system_prerender_init_entities
    call system_prerender_init_jugador
    call system_prerender_init_escorpion
    jp   init_hud

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cada frame en la partida: mueve al jugador y prepara los sprites.
;; Aqui iran fisicas, colisiones...
;; I: -
;; O: -
;; M: A, BC, DE, HL
scene_ingame_update::
    call system_jugador_update        ;; input del jugador: direccion y salto
    call system_fisicas_update        ;; fisicas: aplica velocidad y gravedad
    call system_colisiones_update     ;; deteccion de colisiones
    call system_prerender_pos_jugador ;; actualiza la posicion del jugador en memoria y las prepara para el OAM
    jp   system_prerender_update      ;; preparar los sprites de como ha quedado todo