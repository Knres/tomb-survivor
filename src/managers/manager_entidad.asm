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
