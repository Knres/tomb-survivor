SECTION "System pantalla", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dibuja una pantalla completa (20x18 tiles) desde la ROM al tilemap,
;; con la pantalla apagada.
;; I: HL = direccion de la pantalla en ROM (20x18 bytes, fila a fila)
;; O: -
;; M: A, BC, DE, HL
sys_pantalla_dibujar::
    push hl                                 ;; \ Guardar la pantalla: wait_vblank modifica HL
    call wait_vblank                        ;; | La pantalla solo se puede apagar en VBLANK
    pop  hl                                 ;; / HL = pantalla otra vez

    xor  a                                  ;; \ Apagar la pantalla
    ldh  [rLCDC], a                         ;; /

    ld   de, TILEMAP_BG_START               ;; DE = destino: primera fila del tilemap
    ld   b, PANTALLA_ALTO                   ;; B  = filas que quedan

.fila
    ld   c, PANTALLA_ANCHO                  ;; C  = columnas que quedan en esta fila

.columna
    ld   a, [hl+]                           ;; \ A = tile de la pantalla (HL avanza solo)
    ld   [de], a                            ;; | escribirlo en el tilemap
    inc  de                                 ;; | DE no avanza solo: avanzarlo a mano
    dec  c                                  ;; | una columna menos
    jr   nz, .columna                       ;; / mientras queden columnas

    ld   a, e                               ;; \ DE += TILEMAP_WIDTH - PANTALLA_ANCHO
    add  a, TILEMAP_WIDTH - PANTALLA_ANCHO  ;; |   (saltar los 12 tiles que no se ven
    ld   e, a                               ;; |    para llegar a la fila siguiente)
    jr   nc, .sin_acarreo                   ;; | si E no se ha pasado de 255, D no cambia
    inc  d                                  ;; / si se ha pasado, D + 1
.sin_acarreo
    dec  b                                  ;; \ una fila menos
    jr   nz, .fila                          ;; / mientras queden filas

    ld   a, LCD_CONFIG                      ;; \ Volver a encender la pantalla
    ldh  [rLCDC], a                         ;; / (con la ventana/HUD apagada)
    ret
