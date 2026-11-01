SECTION "System Spawn", ROM0

spawn_enemigo_no_fijo:
    ld a, [frame_actual]
    cp INICIO_SEGUNDO
    ret nz            ;; como no quiero que spawnee el enemigo 1 vez por frame hasta que cambie de segundo, solo lo hace en el primer frame del segundo
    ld a, [next_segundo_spwan]
    ld l, a

    ld a, [next_segundo_spwan + 1]
    ld h, a

    ld a, [hl]  ;; recuperar valor de s_spawn
    
    cp LIST_END ;;
    ret z       ;;

    ld a, [reloj_fin_nivel] ;; si [reloj_fin_nivel] = [hl] ([siguiente_enemigo]), spawneo el enemigo
    cp [hl]
    ret nZ
    call spawn_enemigo
    call siguiente_enemigo_update
    jr spawn_enemigo_no_fijo    ;; intenta hacerlo otra vez por si hay mas de un enemigo en el mismo segundo de spawn
ret

siguiente_enemigo_update:
    ld a, [next_segundo_spwan]
    ld l, a

    ld a, [next_segundo_spwan + 1]
    ld h, a

    ld bc, 7    ;; 7 es la logitud de datos de entidad no pre inicializada
    add hl, bc

    ld a, l
    ld [next_segundo_spwan], a

    ld a, h
    ld [next_segundo_spwan + 1], a
ret 


spawn_enemigo:
    call buscar_memoria_entidad_libre
    jr c, .sin_memo_libre
    inc hl		;; saltar el byte de segundo; HL apunta a KIND
	push hl     ;; hl --> dir. KIND en datos nivel
    
    ld a, CMP_ALIVE | CMP_SPRITE;; / a = enemigo vivo y con sprite 
    ld hl, E_CMP				;; |
    add hl, de					;; | hl --> &entidad.cmp
    ld [hl], a					;; \
    
    ;; KIND y TILE
    pop hl					;; hl --> dir. KIND en datos nivel
    
    ld a, [hl+]				;; a = KIND en datos nivel
                            ;; hl --> dir. X en datos nivel
    push hl					;; push 

    ld hl, E_KIND			;; / 
    add hl, de				;; | hl = &entidad.kind
    ld [hl], a				;; \ 


    ;; asignacion de tile segun KIND
    ;; TODO: añadir la asignacion de los sprites correspondientes

    cp KIND_ESCORPION
    jr z, .tile_escorpion

    cp KIND_MURCIELAGO
    jr z, .tile_murcielago

    cp KIND_MOMIA
    jr z, .tile_momia

    cp KIND_PINCHOS
    jr z, .tile_pinchos

    cp KIND_ESTALACTITA
    jr z, .tile_estalactita
    
    jr .aplicar

    .tile_escorpion
        ld a, TILE_ESCORPION_1
    jr .aplicar

    .tile_murcielago
        ld a, TILE_MURCIELAGO_1
    jr .aplicar

    .tile_momia
        ld a, TILE_MOMIA_1
    jr .aplicar

    .tile_pinchos
        ld a, TILE_PINCHOS
    jr .aplicar

    .tile_estalactita
        ld a, TILE_ESTALACTITA
    ;; jr .aplicar
    
    .aplicar

    ld hl, E_TILE		;; / 
    add hl, de			;; | hl = &entidad.tile
    ld [hl], a			;; \ asignar tile correspondiente
    
    
    ;; X
    pop hl				;; hl --> dir. X en datos nivel
    ld a, [hl+]			;; / a = X en datos nivel
    add a, OAM_X_OFFSET	;; \ + offset_X
    push hl				;; hl --> dir. Y en datos nivel
    
    ld hl, E_X			;; /
    add hl, de			;; /
    ld [hl], a			;; \
    

    ;; Y
    pop hl				;; hl --> dir. Y en datos nivel
    ld a, [hl+]			;; / a = Y en datos nivel
    add a, OAM_Y_OFFSET	;; \ + offset_y
    push hl				;; hl --> dir. VX en datos nivel

    ld hl, E_Y			;; /
    add hl, de			;; |  hl = &entidad.y
    ld [hl], a			;; \
    

    ;; VX
    pop hl				;; hl --> dir. VX en datos nivel
    ld a, [hl+]			;; a = VX en datos nivel
    push hl				;; hl --> dir. VY en datos nivel

    ld hl, E_VX
    add hl, de
    ld [hl], a
    
    ;; VY
    pop hl				;; hl --> dir. VY en datos nivel
    ld a, [hl+]			;; a = vy
    push hl				;; hl --> dir. ATTR en datos nivel

    ld hl, E_VY
    add hl, de
    ld [hl], a

    
    ;; ATTR
    pop hl				;; hl --> dir. ATTR en datos nivel
    ld a, [hl+]			;; a = attr
    push hl				;; next KIND en datos nivel

    ld hl, E_ATTR
    add hl, de
    ld [hl], a
    
    
    ld a, e
    add a, ENTITY_SIZE
    ld e, a
    jr nc, .sin_acarreo
        inc d
    .sin_acarreo
    pop hl
    ret

    .sin_memo_libre
ret