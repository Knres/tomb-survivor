SECTION "Entity manager", ROM0

manager_entity_for_each::
	;; Llama a la rutina de HL una vez por cada entidad viva.
	;; I: HL = dir. ; DE = entidad actual al entrar en ella.
	;; O: -
	;; M: A, B, DE, HL.
	ld de, entity_array ;; de = primera entidad
	ld b, MAX_ENTITIES  ;; b = contador

    .next
    	ld a, [de]
    	bit CMP_ALIVE_BIT, a
    	jr z, .skip

    	push bc
    	push de
    	push hl

    	call call_hl
    	
        pop hl
    	pop de
    	pop bc

        .skip
	    ld a, e
	    add a, ENTITY_SIZE
	    ld e, a

	    dec b
	jr nz, .next
ret

buscar_memoria_entidad_libre::
	;; Busca una entidad con CMP_ALIVE == 0
	;; I: -
	;; O: DE = dir. mememoria libre; C = 1 si no hay ninguno.
	;; M: A, B, DE
	ld de, entity_array
	ld b, MAX_ENTITIES

	.next_slot
		ld a, [de]
		bit CMP_ALIVE_BIT, a
		jr nz, .siguiente_slot
			;; Z --> slot libre; devolver DE con C = 0.
			and a
		ret

		;; cambiar de a siguiente cmp
		.siguiente_slot
		ld a, e
		add a, ENTITY_SIZE
		ld e, a
		jr nc, .no_carry
			inc d
		.no_carry
		;; de --> next cmp
		
		dec b
	jr nz, .next_slot
		;; Z --> no queda memoria libre
		scf	;; C = 0
	;; ret
ret

manager_entity_init_enemies::
	;; Crea las entidades descritas por la tabla del nivel actual
	;; KIND_FIN_ENEMIGOS_FIJOS --> fin de enemigos en mapa nivel
	;; I: -
	;; O: -
	;; M: A, B, DE, HL
	call get_enemigos_nivel_actual		;; hl = dir. definicion de enemigos
	ld de, entity_array + ENTITY_SIZE	;; de = dir. array de entidades
	ld b, MAX_ENTITIES - 1				;; (el jugador ocupa 1)

	.next_enemy
		;; hl --> dir. KIND en datos nivel
		ld a, [hl]				;; a = KIND en datos nivel
		cp KIND_FIN_ENEMIGOS_FIJOS	;; comprobar si quedan más enemigos por cargar
		jr nz, .no_fin_lista
			;; Z -->  no quedan guardar next direccion 
			;;	      que es segundo de spawn de entidades no pre inicializadas
			
			;; hl --> DB KIND_FIN_ENEMIGOS_FIJOS
			inc hl	;; HL --> Segundo, spawn de primer enemigo no pre-inicializado

			ld a, l
			ld [next_segundo_spwan], a
			ld a, h
			ld [next_segundo_spwan + 1], a
		ret

		.no_fin_lista
		push bc					;; guardar contador b
		push hl					;; hl --> dir. KIND en datos nivel
		
		;; CMP
		ld a, CMP_ALIVE | CMP_SPRITE | CMP_COLLIDER ;; / a = enemigo vivo, con sprite y caja de colisión
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

		cp KIND_DARDO
		jr z, .tile_dardo
		
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
		jr .aplicar

		.tile_dardo
			ld a, TILE_DARDO
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
		;; de: dir. next posicion de entidad en array de entidad
		
		pop hl	;; next KIND en datos nivel
		pop bc 	;; recuperar contador b
		dec b
	jp nz, .next_enemy
ret


ia_enemigo_update::
	;; Llama a ai correspondiente, de las entidades vivas
	;; I: DE = dir. base de la entidad
	;; O: -
	;; M: A, HL
	push de		;; guardar dir. base de entidad

	ld hl, E_KIND	;; / 
	add hl, de		;; | hl = &entidad_kind 
	ld a, [hl]		;; \ a = kind

	pop de		;; recuperar dir. base de entidad

	cp KIND_JUGADOR
	ret z
	
	cp KIND_ESCORPION
	jp z, ia_escorpion
	
	cp KIND_MURCIELAGO
	jp z, ia_murcielago
	
	cp KIND_MOMIA
	jp z, ia_momia
	
	cp KIND_PINCHOS
	jp z, ia_pinchos
	
	cp KIND_ESTALACTITA
	jp z, ia_estalactita

	cp KIND_DARDO
	jp z, ia_dardo

	;; cp
	;; jp z,
ret

ia_mov_izq_der::
	;; I: DE = dir. base de la entidad
	;; O: -
	;; M: A, B, HL

	ld hl, E_VX	
	add hl, de		;; hl = dir. vx de la entidad

	ld a, [hl]
	ld b, a			;; b = vx

	ld hl, E_X		
	add hl, de		;; hl = dir. x

	ld a, [hl]		;; / a = x actual
	add a, b		;; \ x = x + vx
	
	call entidad_comprobar_salida_horizontal
	ld [hl], a		;; guardar x, sin salir de los limites
	
	jr nc, .no_sale	;; NC --> no se sale horizontalmente 
		;; C --> se sale horizontaleme
		push de

		ld h, d			;; / hl = entidad
		ld l, e			;; \ para entidad_cambiar_dir_movimiento_horizontal
		call entidad_cambiar_dir_movimiento_horizontal
		
		pop de
	.no_sale
ret

ia_escorpion::
	;; Escorpión. En el suelo, se mueve de derecha-izquierda y gira tras tocar pared
	;; I: DE = dir. base de la entidad
	;; O: -
	;; M: A, B, HL
	;; VY cuenta los updates que faltan para cambiar el frame.
	ld hl, E_VY	;; /
	add hl, de	;; | recuperar vy (contador)
	ld a, [hl]	;; \ 
	
	and a					;; contador == 0?
	jr z, .cambiar_frame 	;; Z --> cambiar frame
		;; NZ --> contador --
		dec [hl]
		jr nz, .mover
	.cambiar_frame
	
	ld a, ESCORPION_ESPERA_FRAME	;; / resetear
	ld [hl], a						;; \ contador


	ld hl, E_TILE
	add hl, de
	ld a, [hl]
	
	cp TILE_ESCORPION_1
	jr z, .frame_2
		ld a, TILE_ESCORPION_1
		jr .guardar_frame
	.frame_2
		ld a, TILE_ESCORPION_2
	.guardar_frame
	ld [hl], a

	.mover
	call ia_mov_izq_der
ret

ia_murcielago::
	;; Murcielago. Igual que el escorpion pero en el cielo
	;; por el momento la logica es la misma que el escorpion --> call ia_escorpion
	
	;; VY cuenta los updates que faltan para cambiar el frame.
	ld hl, E_VY	;; /
	add hl, de	;; | recuperar vy (contador)
	ld a, [hl]	;; \ 
	
	and a					;; contador == 0?
	jr z, .cambiar_frame 	;; Z --> cambiar frame
		;; NZ --> contador --
		dec [hl]
		jr nz, .mover
	.cambiar_frame
	
	ld a, MURCIELAGO_ESPERA_FRAME	;; / resetear 
	ld [hl], a						;; \ contador


	ld hl, E_TILE
	add hl, de
	ld a, [hl]
	
	cp TILE_MURCIELAGO_1
	jr z, .frame_2
		ld a, TILE_MURCIELAGO_1
		jr .guardar_frame
	.frame_2
		ld a, TILE_MURCIELAGO_2
	.guardar_frame
	ld [hl], a

	.mover
	call ia_mov_izq_der
ret

ia_momia::
	;; En el suelo y se mueve horizontalmente, solo en una direccion 
	;; se movera "muy lento", para acdamovimietno cambiara su sprite 1 <--> 2
	;; cuando sale de pantalla cmp --> NO vivo 
	ld hl, E_VX
	add hl, de
	ld a, [hl]
	and a
	jr z, .actualizar_contador
	ld hl, E_ATTR
	add hl, de
	bit 7, a
	jr nz, .mirar_izquierda
	set ATTR_BIT_FLIP_X, [hl]
	jr .actualizar_contador

	.mirar_izquierda
	res ATTR_BIT_FLIP_X, [hl]
	
	;; VY --> contador para el movimiento y cambio de sprite
	.actualizar_contador
	ld hl, E_VY	;; /
	add hl, de	;; | recuperar vy (cotador)
	ld a, [hl]	;; \

	and a		;; a == 0?
	jr z, .mover	;; Z --> fin de contador --> mover y actualizar sprite
		;; NZ --> no fin de contador
		dec [hl]	;; contador --
	ret nz

	;; contador ya = 0
	.mover
		ld hl, E_X	;; /
		add hl, de	;; |
		ld a, [hl]	;; |
		ld b, a		;; \ b = x actual

		ld hl, E_VX	;; /
		add hl, de	;; |
		ld a, [hl]	;; \ a = vx
		
		and a	;; vx == 0?
		jr z, .borrar ;; Z --> Ya ha esperado un ciclo tocando borde --> borrar	
	
		add b		;; a +b = new posicion x 
		call entidad_comprobar_salida_horizontal
		;; a = x corregida
	jr c, .toca_borde


	ld hl, E_X
	add hl, de
	ld [hl], a

	ld hl, E_VY
	add hl, de
	ld [hl], MOMIA_ESPERA_FRAME

	ld hl, E_TILE
	add hl, de
	ld a, [hl]
	
	cp TILE_MOMIA_1
	jr z, .frame_2
		ld a, TILE_MOMIA_1
		jr .guardar_frame
	.frame_2
		ld a, TILE_MOMIA_2
	.guardar_frame
		ld [hl], a
	ret

	.toca_borde
		ld hl, E_VX	;; /
		add hl, de	;; |
		xor a		;; |
		ld [hl], a	;; \ xv = 0
	ret

	.borrar
	ld hl, E_CMP
	add hl, de
	res CMP_ALIVE_BIT, [hl]
ret

ia_pinchos::
	;; Pinchos. En el suelo, no se mueven salen y bajan en ciclo,

	;; VX cuenta frames; 
	;; VY recorre las fases 0-7 arriba y 8-15 abajo.
	ld hl, E_VX	;; / 
	add hl, de	;; | recuperar vx (contador)
	ld a, [hl]	;; \  

	and a			;; contador == 0?
	jr z, .fase_mov	;; Z --> Fase de movimientos
		;; NZ --> modificar conttdor
		
		dec [hl]	;; / contador --
		ld a, [hl]	;; |
		and a		;; \ contador == 0?
	ret nz			;;   != 0 --> no hace nada

	.fase_mov
		ld hl, E_VY	;; / recuperar vy (fase)
		add hl, de	;; | 0-7 : subida
		ld a, [hl]	;; \ 8-15: bajada
	
		cp PINCHOS_FASE_SUBIDA 	;; a - 8 
		jr nc, .bajar			;; 3 - 8 = -5 --> C subida 
			;; C --> subida

			inc a		;; / val. fase ++
			ld [hl], a	;; \ guadar incremento de fase
			ld b, -1	;; b= dir. movimiento (subir-bajar)
			
			jr .mover_y
		.bajar
			inc a					;; val. fase ++
			cp PINCHOS_FASE_BAJADA	;; ha terminadoo fase bajada (> 15?)
			jr c, .no_fin_bajada	;; C --> no
				;;  NC --> Si, > 15 --> volver a fase subida -> = 0
				
				xor a	;; a = 0
			.no_fin_bajada
			ld [hl], a 		;; guadar incremento de fase
			ld b, 1			;; b= dir. movimiento (subir-bajar)
			
			;; jr .mover_y
		.mover_y
			ld hl, E_Y	;; /
			add hl, de	;; \ hl --> &entidad.y

			ld a, [hl]	;; /
			add a, b    ;; | Mover arriba o abajo al pincho
			ld [hl], a	;; \

		
		;; comprobar si ha termiando de subir-bajar
		;; si ha terminado aplicar una espera para que se mantenga
		ld hl, E_VY		;; /
		add hl, de		;; | recuperar vy (fase)
		ld a, [hl]		;; \

		cp PINCHOS_FASE_SUBIDA	;; es fin de fase subida?
		jr z, .poner_espera		;; Z --> si lo es
			;; NZ --> no es fin de fase subida
			and a				;; es fin de fase bajada (a == 0?)
			jr z, .poner_espera	;; Z --> si lo es
				;; NZ -> no es fin bajada 
				ld a, PINCHOS_ESPERA_SUBIDA_BAJARA
		jr .guardar_espera

		.poner_espera
			ld a, PINCHOS_ESPERA_FASE

		.guardar_espera
		ld hl, E_VX	;; /
		add hl, de	;; | guardar espera
		ld [hl], a	;; \
	;; end_fase_mov
ret

ia_dardo:
	;; para el dardo vy determina cuantos segundos debe esperar hasta que de propulse en su direccion. Una vez se propulsa se cambia ese valor a EN_VUELO
	ld hl, E_VY
	add hl, de ;; obtengo vy
	ld a, [hl]
	
	cp EN_VUELO
	jr z, .se_mueve
	
	ld c, a


	.standby:
		ld a, [frame_actual] ;; si no es el inicio de un segundo no hace nada
		cp INICIO_SEGUNDO
		ret nz
	ld b, b
		
		ld a, c		;; recupero b para modificar el contador
		dec a
		cp 0
		jr nz, .sigue_parado		;; si llega a 0 empieza el movimiento
		ld a, EN_VUELO
		ld [hl], a		;; modifico para que en la siguiente actualizacion empiece a volar
		jr .fin


	.sigue_parado:
		ld [hl], a
		jr .fin
	
	.se_mueve:
		ld hl, E_VX	
		add hl, de		;; hl = dir. vx de la entidad

		ld a, [hl]
		ld b, a			;; b = vx

		ld hl, E_X		
		add hl, de		;; hl = dir. x

		ld a, [hl]		;; / a = x actual
		add a, b		;; \ x = x + vx
		
		call entidad_comprobar_salida_horizontal ;; c si se sale, nc si no se sale
		ld [hl], a
		ret nc
	
	.destruir:
		ld hl, E_CMP
		add hl, de
		res CMP_ALIVE_BIT, [hl]

	.fin:
ret

ia_estalactita::
	;; Estalactitas. Se generan el el techo y caen cuando el jugador pasa por debajo (cuando x la estalactita = x jugador)
	;; añadir un tolerancia suficiente (igual a la velocidad del jugador?) para que cuando caiga pueda tocar al jugador si el jugador no modifica nada
	;; si ya esta cayendo no hay que detectar si el jugador esta dentro de rango o no
	;; I: DE = dir. base de la entidad
	;; O: -
	;; M: A, B, HL

	;; E_VX = radio de deteccion horizontal (tolerancia de deteccion)
	;; E_VY = estado
	ld hl, E_VY 	;; / 
	add hl, de 		;; | recuperar vy (estado)
	ld a, [hl]		;; \ 

	cp ESTALACTITA_ESTADO_CAYENDO
	jr z, .caer
		;; NZ --> no cayendo
		cp ESTALACTITA_ESTADO_FINALIZADO
		ret z

	;; ACTIVACION
	ld a, [jugador_x]	;; /
	add OAM_X_OFFSET	;; |
	ld b, a				;; \ b = jugador_x

	ld hl, E_X			;; /
	add hl, de			;; |
	ld a, [hl]			;; \ a = entidad_x

	sub b				;; entidad_x - jugador_x

	jr nc, .no_negativo
		cpl		;; / -a -> a
		inc a	;; \ a = |a|
	.no_negativo
	;; a = |a|
	ld b, a			;; b = |entidad_x - jugador_x|

	ld hl, E_VX		;; /
	add hl, de		;; | recuperar vx (radio de deteccion horizontal (tolerancia de deteccion))
	ld a, [hl]		;; \ a = tolerancia deteccion

	cp b			;; (a - b)
					;;  5 - 7 = -2 --> C --> fuera de rango 
	ret c

	;; NC --> dentro de rango
	;; Cambiar estado a cayendo
	ld hl, E_VY							;; /
	add hl, de							;; |
	ld a, ESTALACTITA_ESTADO_CAYENDO	;; |
	ld [hl], a							;; \ cambiar estado a cayendo


	;; Cayendo
	.caer
		ld hl, E_Y					;; /
		add hl, de					;; | hacer bajar la entidad
		ld a, [hl]					;; |
		add ESTALACTITA_VELOCIDAD	;; \ a = nueva pos. Y

		call entidad_comprobar_salida_vertical	;; O: a corregida
		ld [hl], a
		cp OAM_Y_OFFSET + LEVEL_FLOOR_PX - TILE_SIZE	;; comprobar si esta en el sulo (pos corregida)
	ret nz

	;; Z --> toca suelo la pos corregida --> Eliminar
	ld hl, E_CMP
	add hl, de
	res CMP_ALIVE_BIT, [hl]
ret

ia_serpiente::
	;; Serpiente. En paredes, se moveran de arriba a abajo,
	;; por el momento seran 
ret

entidad_comprobar_salida_horizontal::
	;; Limita la nueva X al area interior, sin solaparse con las paredes laterales.
	;; I: A = nueva X (X + VX), en coordenadas OAM
	;; O: A = X limitada; C = 1 si se salió por un extremo
	;; M: A
	cp OAM_X_OFFSET + TILE_SIZE	;; borde izquierdo + tile pared lateral
	jr c, .limite_izquierdo
		;; NC --> No se sale del borde iquierdo
		cp OAM_X_OFFSET + PANTALLA_ANCHO * TILE_SIZE - TILE_SIZE + 1 - TILE_SIZE;; borde derecho - tile pared lateral
		jr nc, .limite_derecho
			;; C --> No se sale del bored derecho
			and a ;; Carry = 0
		ret
	;; ret

	.limite_izquierdo
		ld a, OAM_X_OFFSET + TILE_SIZE	;; limite izq. + tile pared lateral
		scf
	ret

	.limite_derecho
		ld a, OAM_X_OFFSET + PANTALLA_ANCHO * TILE_SIZE - TILE_SIZE - TILE_SIZE	;; limite der. - tile pared lateral
		scf
	;; ret
ret

entidad_comprobar_salida_vertical::
	;; Limita la nueva Y al area interior, sin solaparse con el techo ni el suelo.
	;; I: A = nueva Y (Y + VY), en coordenadas OAM
	;; O: A = Y limitada; C = 1 si se salió por un extremo
	;; M: A
	cp OAM_Y_OFFSET ;;+ TILE_SIZE	;; borde superior + tile de techo
	jr c, .limite_superior
		;; NC --> No se sale del borde superior
		cp OAM_Y_OFFSET + LEVEL_FLOOR_PX - TILE_SIZE + 1	;; borde inferior + tile de suelo
		jr nc, .limite_inferior
			;; C --> No se sale del borde inferior
			and a ;; Carry = 0
		ret
	;; ret

	.limite_superior
		ld a, OAM_Y_OFFSET + TILE_SIZE	;; limite superior + tile de techo
		scf
	ret

	.limite_inferior
		ld a, OAM_Y_OFFSET + LEVEL_FLOOR_PX - TILE_SIZE	;; limite inferior - tile de suelo
		scf
	;; ret
ret

entidad_cambiar_dir_movimiento_horizontal::
	;; Modifica la direccion de movimieto dercha-izq de la entidad recibida
	;; I: HL =  dir. de entidad que se quiere modificar la direccion de movimiento
	;; O: -
	;; M: A, DE
	push hl	;; guardar dir. base de entidad
	
	ld de, E_VX
	add hl, de	;; hl -> &entidad.vx 

	ld a, [hl]	;; a = vx
	cpl			;; / invertir el valor de vx 
	inc a		;; \ vx -> -vx
	ld [hl], a	;; guardar vx modificado
	
	pop hl	;; recuperar la dir. base de la entidad
	call sprite_espejo_x
ret

entidad_cambiar_dir_movimiento_vertical::
	;; Modifica la direccion de movimieto arriba-abajo de la entidad recibida
	;; I: HL =  dir. de entidad que se quiere modificar la direccion de movimiento
	;; O: -
	;; M: A, DE
	push hl	;; guardar dir. base de entidad
	
	ld de, E_VY
	add hl, de	;; hl -> &entidad.vy 

	ld a, [hl]	;; a = vy
	cpl			;; / invertir el valor de vy
	inc a		;; \ vy -> -vy
	ld [hl], a	;; guardar vy modificado
	
	pop hl	;; recuperar la dir. base de la entidad
	call sprite_espejo_y
ret