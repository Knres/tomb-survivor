EXPORT DEF MAX_ENTITIES = 4 ;; MODIFICAR NUMERO DE ENTIDADES MAXIMAS

EXPORT DEF OAM_ENTRY_SIZE = 4
EXPORT DEF SHADOW_OAM_SIZE = MAX_ENTITIES * OAM_ENTRY_SIZE

EXPORT DEF ENTITY_SIZE = 8
EXPORT DEF ENTITY_ARRAY_SIZE = MAX_ENTITIES * ENTITY_SIZE

SECTION "Entidades y Jugador", WRAM0, ALIGN[8]

entity_array:: DS ENTITY_ARRAY_SIZE ;; MAX_ENTITIES * ENTITY_SIZE
shadow_oam:: DS SHADOW_OAM_SIZE ;; MAX_ENTITIES * OAM_ENTRY_SIZE
shadow_cursor:: DS 2
jugador_x:: DS 1    ;; recordar que es en px 
jugador_y:: DS 1    ;; recordar que es en px
jugador_direccion_movimiento:: DS 1
    
SECTION "Nivel actual", WRAM0
nivel_actual:: DS 1

SECTION "Escena actual", WRAM0
escena_update:: DS 2