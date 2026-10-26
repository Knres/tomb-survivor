SECTION "Escenas", ROM0

scene_manager::
    ld a, [estado_actual]
        
    ; if  ESTADO_INICIAL
    ;;cp ESTADO_INICIAL
    ;;jp z, inicio

    ; ELSEIF ESTADO_UNO
    cp ESTADO_UNO
    ;;jp z, estado_1
    
    ; ELSEIF ESTADO_DOS
    cp ESTADO_DOS
    ;;jp z, estado_2
    
    ; ELSE
    ret

;; ESTO DEBE IR EN OTROS ARCHIVOS Y HACER LUEGO UN "IMPORT"
;inicio::
;    ld bc, 0 ; SOLO MUESTRA DE FORMA VISUAL QUE ESTADO ES, SE PUEDE QUITAR
    ; LOGICA
;    ret   ;; VUELVE AL BUCLE PRINCIPAL
;      jp fin

;estado_1::
;    ld bc, 1 ; SOLO MUESTRA DE FORMA VISUAL QUE ESTADO ES, SE PUEDE QUITAR
;    ; LOGICA
;    ret  ;; VUELVE AL BUCLE PRINCIPAL
;      jp fin

;estado_2::
;    ld bc, 2 ; SOLO MUESTRA DE FORMA VISUAL QUE ESTADO ES, SE PUEDE QUITAR
;    ; LOGICA
;    ret   ;; VUELVE AL BUCLE PRINCIPAL
;      jp fin