SECTION "System Spawn", ROM0

system_spawn_enemies:
   ld a, 0
   ld [enemigos_activos], a
   .bucle:
      ld a, [hl] 
      cp LIST_END
      jr nz, .no_fin
      ld a, h
      ret z

      .no_fin:
         ld a, [hl+] ; col
         ld c, a
         ld a, [hl+] ; fila
         ld b, a
         ld d, h ; guardo hl en de
         ld e, l
         ld hl, EnemyTemplate
         call game_spawn_at
         ld h, d ; recupero hl
         ld l, e
         ld a, [enemigos_activos]
         inc a
         ld [enemigos_activos], a
         jr .bucle


