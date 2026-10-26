SECTION "Scene ingame", ROM0

;; Escena de partida
scene_ingame::
    DW scene_ingame_init
    DW scene_ingame_update

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Entra en la partida: nivel 1, carga el mapa, crea entidades y enciende el HUD.
;; I: -
;; O: -
;; M: A, BC, DE, HL
scene_ingame_init::
;; Entra en la partida: carga el mapa de nivel_actual, crea entidades y enciende el HUD.
;; nivel_actual lo pone quien empieza la partida (1 = partida nueva).

    call system_render_load_map
    call system_prerender_init_entities
    call system_prerender_init_jugador
    call system_prerender_init_escorpion
    jp   init_hud

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cada frame en la partida. Aqui iran fisicas, colisiones...
;; I: -
;; O: -
;; M: A, B, DE, HL
scene_ingame_update::
    jp   system_prerender_update