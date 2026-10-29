SECTION "Musica", ROM0
     ;; Formato: DB tono_bajo, tono_alto, duracion_en_frames
     ;; Tono 0 = silencio. Duracion 0 = fin: tono 0 vuelve a empezar, tono 1 para la musica.
;; Titulo: lenta, misteriosa, ambiente de piramide (negra = 30 frames)
musica_titulo::
    DB LOW(NOTA_A3),  HIGH(NOTA_A3),  30
    DB LOW(NOTA_AS3), HIGH(NOTA_AS3), 30
    DB LOW(NOTA_CS4), HIGH(NOTA_CS4), 60
    DB LOW(NOTA_D4),  HIGH(NOTA_D4),  30
    DB LOW(NOTA_CS4), HIGH(NOTA_CS4), 30
    DB LOW(NOTA_AS3), HIGH(NOTA_AS3), 30
    DB LOW(NOTA_A3),  HIGH(NOTA_A3),  90
    DB LOW(NOTA_E4),  HIGH(NOTA_E4),  30
    DB LOW(NOTA_F4),  HIGH(NOTA_F4),  30
    DB LOW(NOTA_E4),  HIGH(NOTA_E4),  30
    DB LOW(NOTA_D4),  HIGH(NOTA_D4),  60
    DB LOW(NOTA_CS4), HIGH(NOTA_CS4), 30
    DB LOW(NOTA_A3),  HIGH(NOTA_A3),  90
    DB 0, 0, 30
    DB 0, 0, 0

;; Partida: rapida, tensa, ambiente de piramide (corchea = 12 frames)
musica_partida::
    DB LOW(NOTA_A3),  HIGH(NOTA_A3),  12
    DB LOW(NOTA_AS3), HIGH(NOTA_AS3), 12
    DB LOW(NOTA_CS4), HIGH(NOTA_CS4), 12
    DB LOW(NOTA_D4),  HIGH(NOTA_D4),  12
    DB LOW(NOTA_E4),  HIGH(NOTA_E4),  24
    DB LOW(NOTA_D4),  HIGH(NOTA_D4),  12
    DB LOW(NOTA_CS4), HIGH(NOTA_CS4), 12
    DB LOW(NOTA_AS3), HIGH(NOTA_AS3), 12
    DB LOW(NOTA_CS4), HIGH(NOTA_CS4), 12
    DB LOW(NOTA_AS3), HIGH(NOTA_AS3), 12
    DB LOW(NOTA_A3),  HIGH(NOTA_A3),  48
    DB 0, 0, 12
    DB LOW(NOTA_D4),  HIGH(NOTA_D4),  12
    DB LOW(NOTA_E4),  HIGH(NOTA_E4),  12
    DB LOW(NOTA_F4),  HIGH(NOTA_F4),  12
    DB LOW(NOTA_G4),  HIGH(NOTA_G4),  12
    DB LOW(NOTA_A4),  HIGH(NOTA_A4),  24
    DB LOW(NOTA_G4),  HIGH(NOTA_G4),  12
    DB LOW(NOTA_F4),  HIGH(NOTA_F4),  12
    DB LOW(NOTA_E4),  HIGH(NOTA_E4),  12
    DB LOW(NOTA_F4),  HIGH(NOTA_F4),  12
    DB LOW(NOTA_E4),  HIGH(NOTA_E4),  12
    DB LOW(NOTA_D4),  HIGH(NOTA_D4),  12
    DB LOW(NOTA_CS4), HIGH(NOTA_CS4), 12
    DB LOW(NOTA_AS3), HIGH(NOTA_AS3), 12
    DB LOW(NOTA_A3),  HIGH(NOTA_A3),  24
    DB 0, 0, 0

;; Victoria: corta, triunfal, no se repite
musica_victoria::
    DB LOW(NOTA_A3),  HIGH(NOTA_A3),  8
    DB LOW(NOTA_CS4), HIGH(NOTA_CS4), 8
    DB LOW(NOTA_E4),  HIGH(NOTA_E4),  8
    DB LOW(NOTA_A4),  HIGH(NOTA_A4),  30
    DB 0, 0, 6
    DB LOW(NOTA_G4),  HIGH(NOTA_G4),  8
    DB LOW(NOTA_F4),  HIGH(NOTA_F4),  8
    DB LOW(NOTA_E4),  HIGH(NOTA_E4),  8
    DB LOW(NOTA_F4),  HIGH(NOTA_F4),  8
    DB LOW(NOTA_G4),  HIGH(NOTA_G4),  8
    DB LOW(NOTA_A4),  HIGH(NOTA_A4),  60
    DB 1, 0, 0 