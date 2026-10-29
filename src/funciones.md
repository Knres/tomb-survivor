<!-- Renderizar en VSCODE: Ctrl + Shift + V -->
# Documento funciones

En este documento se pondra todas las funciones, memorias y contantes del videojugo. (intentar mantener el formato o almenos dejarlo pegado para facilitar la busqueda mediante `Ctrl + F`)

Si es para buscar un nomrbe en espefico buscar en `Ctrl + F` "| nombre/etiqueta/etc |"

## Memoria
Las memorias reservadas se ubicaran dentro del archcivo **`wram.asm`**, en casos necesarios se definiran fuera de este archivo pero se dejara comentado su existencia.

**Aqui solo se registraran las que se han definido como globale `etiqueta::`(dos ::)**

| Etiqueta | Tamaño | ¿Para qué es? |
| -------- | ------ | ------------- |
| `entity_array` | `ENTITY_ARRAY_SIZE` (64 bytes) | Array de 8 entidades de 8 bytes (`CMP`, `Y`, `X`, `TILE`, `ATTR`, `VY`, `VX`, `KIND`). La primera es el jugador. |
| `shadow_oam` | `SHADOW_OAM_SIZE` (32 bytes) | Copia de los datos `Y`, `X`, `TILE`, `ATTR` de hasta 8 sprites, preparada antes de VBlank. |
| `shadow_cursor` | 2 bytes | Puntero al siguiente slot disponible en `shadow_oam`. |
| `jugador_x` | 1 byte | Posicion horizontal del jugador en pixeles. |
| `jugador_y` | 1 byte | Posicion vertical del jugador en pixeles. |
| `jugador_direccion_movimiento` | 1 byte | Direccion/intencion de movimiento del jugador. |
| `jugador_solicita_salto` | 1 byte | 1 si este frame se ha pedido saltar (A recien pulsado). Lo pone `system_jugador_update` y lo consume `system_fisicas_update`. |
| `jugador_en_suelo` | 1 byte | 1 si el jugador esta apoyado y puede saltar. Lo pone `system_colisiones_update`. |
| `jugador_y_anterior` | 1 byte | Y del jugador antes de moverse este frame, para detectar aterrizajes. |
| `jugador_a_anterior` | 1 byte | Boton A en el frame anterior, para que el salto solo reaccione al pulsarlo (no al mantenerlo). |
| `jugador_vidas` | 1 byte | Vidas que le quedan al jugador (empieza en `VIDAS_JUGADOR`). |
| `enemigos_activos` | 1 byte | 0 = los enemigos no se mueven todavia; pasa a 1 con la primera pulsacion en la partida. |
| `musica_inicio` | 2 bytes | Direccion de la primera nota de la cancion que suena (para volver a empezar). Declarada con `:` en `wram.asm`. |
| `musica_ptr` | 2 bytes | Direccion de la nota siguiente de la cancion. Declarada con `:` en `wram.asm`. |
| `musica_contador` | 1 byte | Frames que le quedan a la nota actual. 0 = no hay musica sonando. Declarada con `:` en `wram.asm`. |
| `nivel_actual` | 1 byte | Numero del nivel seleccionado. |
| `escena_update` | 2 bytes | Direccion del update de la escena actual (byte bajo, byte alto). La escribe `manager_escena_cambiar`. |
| `escena_contador` | 1 byte | Frames que quedan en una pantalla temporizada (game over, nivel, victoria). |
| `escena_siguiente` | 2 bytes | Escena a la que se pasa cuando `escena_contador` llega a 0 (byte bajo, byte alto). |
| `menu_start_anterior` | 1 byte | START en el frame anterior, para que el titulo solo reaccione al pulsarlo (no al mantenerlo). |
|  |  | <!-- NO MODIFICAR ESTA FILA, USAR PARA COPIAR Y PEGAR ARRIBA-->


## Constantes
Las constantes permaneceran en el archivo **`defs.asm`** en casos necesarios se definiran fuera de este archivo pero se dejara comentado su existencia.

**Aqui solo se registran constantes `EXPORT DEF`; los `DEF` locales no se listan.**

| Nombre | Valor | ¿Para qué es? |
| ------ | ----- | ------------- |
| `rLCDC` | `$FF40` | Control y configuracion del LCD. |
| `rSCY` | `$FF42` | Scroll vertical del fondo. |
| `rSCX` | `$FF43` | Scroll horizontal del fondo. |
| `rLY` | `$FF44` | Linea que esta dibujando el LCD. |
| `rWY` | `$FF4A` | Posicion vertical de la ventana. |
| `rWX` | `$FF4B` | Posicion horizontal de la ventana. |
| `rDMA` | `$FF46` | Registro DMA para copias OAM (requiere rutina en HRAM). |
| `rBGP` | `$FF47` | Paleta del fondo y ventana. |
| `rOBJ0P` | `$FF48` | Paleta de sprites 0. |
| `rOBJ1P` | `$FF49` | Paleta de sprites 1. |
| `rIE` | `$FFFF` | Habilitacion de interrupciones. |
| `rDIV` | `$FF04` | Divisor del temporizador. |
| `rJOYP` | `$FF00` | Registro de lectura del joypad. |
| `UP_BIT` ... `B_BIT` | 0 ... 7 | Bit de cada boton en `joypad_pressed` / `joypad_held`: UP 0, DOWN 1, LEFT 2, RIGHT 3, START 4, SELECT 5, A 6, B 7. |
| `rNR10` | `$FF10` | Primer registro del canal 1 de sonido (barrido). |
| `rNR21` | `$FF16` | Primer registro del canal 2 de sonido (onda/duracion). El canal 2 es el de la musica. |
| `rNR22` | `$FF17` | Volumen del canal 2. |
| `rNR23` | `$FF18` | Tono del canal 2 (byte bajo). |
| `rNR24` | `$FF19` | Play + tono del canal 2 (byte alto). |
| `rNR41` | `$FF20` | Primer registro del canal 4 de sonido (ruido, duracion). |
| `rNR50` | `$FF24` | Volumen maestro del sonido. |
| `rNR51` | `$FF25` | Salida de cada canal de sonido a altavoz izquierdo/derecho. |
| `rNR52` | `$FF26` | Encendido/apagado del chip de sonido (APU). |
| `MUSICA_VOLUMEN` | `$73` | Valor de NR22 para las notas de la musica: volumen 7 que se apaga poco a poco. Con `$70` la nota se mantiene hasta la siguiente. |
| `NOTA_SILENCIO` | 0 | Tono de un silencio en las canciones. |
| `NOTA_C3` ... `NOTA_B5` | `$416` ... `$77B` | Tono de cada nota musical para el canal 2 (tres octavas). C=do D=re E=mi F=fa G=sol A=la B=si, S=sostenido (`NOTA_CS4` = do# 4). |
| `BGP_CONFIG` | — | Configuracion inicial de tonos para fondo/ventana. |
| `OBJ0P_CONFIG` | — | Configuracion inicial de la paleta de sprites 0. |
| `OBJ1P_CONFIG` | — | Configuracion inicial de la paleta de sprites 1. |
| `LCD_WINDOW_OFF` | `%00000000` | Valor con la ventana desactivada en LCDC. |
| `LCD_WINDOW_ON` | `%00100000` | Mascara del bit de ventana en LCDC. |
| `LCD_CONFIG` | — | Configuracion inicial completa del registro LCDC. |
| `VRAM_START` | `$8000` | Inicio de VRAM. |
| `VRAM_END` | `$9FFF` | Final del rango de VRAM. |
| `TILE_DATA_START` | `$8000` | Inicio de los datos de tiles. |
| `TILE_MAP_START` | `$9800` | Inicio del tilemap principal. |
| `TILEMAP_BG_START` | `$9800` | Tilemap usado por el fondo. |
| `TILEMAP_HUD_START` | `$9C00` | Tilemap reservado para la ventana/HUD. |
| `TILEMAP_WIDTH` | 32 | Ancho del tilemap de VRAM, en tiles. |
| `TILEMAP_HEIGHT` | 32 | Alto del tilemap de VRAM, en tiles. |
| `OAM_START` | `$FE00` | Inicio de OAM. |
| `OAM_SIZE` | 160 | Bytes de OAM: 40 entradas de 4 bytes. |
| `OAM_END` | `$FE9E` | Ultima direccion OAM definida por el proyecto. |
| `OAM_X_OFFSET` | 8 | Offset entre X visible y X almacenada en OAM. |
| `OAM_Y_OFFSET` | 16 | Offset entre Y visible y Y almacenada en OAM. |
| `WRAM_START` | `$C000` | Inicio de WRAM. |
| `WRAM_END` | `$DFFF` | Final del rango de WRAM. |
| `VBLANK_START` | `$90` | Valor LY de inicio de VBlank (linea 144). |
| `TILE_FONDO` | `$00` | Indice de tile vacio. |
| `TILE_SUELO` | `$01` | Indice de tile de suelo. |
| `TILE_PARED` | `$02` | Indice de tile de pared. |
| `TILE_JUGADOR_TEMPORAL` | `$03` | Tile temporal del jugador. |
| `TILE_ESCORPION` | `$04` | Tile del escorpion. |
| `TILE_PLAT_DERECHA` | `$05` | Tile de plataforma (lado derecho). |
| `TILE_PLAT_IZQUIERDA` | `$06` | Tile de plataforma (lado izquierdo). |
| `TILE_PARED_NUEVA` | `$07` | Tile de pared (el que detectan las colisiones). |
| `TILE_CORAZON` | `$08` | Corazon lleno del HUD. |
| `TILE_NO_CORAZON` | `$09` | Corazon vacio del HUD. |
| `TILE_PINCHOS` | `$0A` | Tile de los pinchos. |
| `TILE_MURCIELAGO_1` / `_2` | `$0B` / `$0C` | Frames de animacion del murcielago. |
| `TILE_JUGADOR_1` / `_2` | `$0D` / `$0E` | Frames de animacion del jugador. |
| `TILE_JUGADOR_SALTO` | `$0F` | Jugador saltando. |
| `TILE_JUGADOR` | `TILE_JUGADOR_2` | Frame por defecto del jugador. |
| `TILE_SIZE` | 8 | Tamano de un tile en pixeles. |
| `JUGADOR_ALTO` | `TILE_SIZE` | Alto del jugador en pixeles. |
| `TAM_COLISION` | 6 | Distancia en pixeles por debajo de la cual dos entidades se solapan (`sys_collision_overlaps`). |
| `LEVEL_MAP_WIDTH` | 20 | Ancho logico del mapa del nivel, en tiles. |
| `LEVEL_MAP_HEIGHT` | 16 | Alto del area de juego, en tiles. |
| `LEVEL_HUD_ORIGIN_X` | 0 | Columna inicial prevista del HUD, en tiles. |
| `LEVEL_HUD_ORIGIN_Y` | 16 | Fila inicial prevista del HUD, en tiles. |
| `LEVEL_HUD_HEIGHT` | 2 | Alto previsto del HUD, en tiles. |
| `LEVEL_FLOOR_Y` | 15 | Coordenada logica del suelo, en tiles. |
| `LEVEL_FLOOR_PX` | `LEVEL_FLOOR_Y * TILE_SIZE` | Coordenada del suelo, en pixeles (120). |
| `WINDOW_X_OFFSET` | 7 | Ajuste de WX definido por el hardware Game Boy. |
| `WINDOW_START_X` | expresion | Posicion horizontal inicial de ventana en pixeles. |
| `WINDOW_START_Y` | expresion | Posicion vertical inicial de ventana en pixeles. |
| `HUD_START_POS_X` | alias | Alias de `WINDOW_START_X`, en pixeles. |
| `HUD_START_POS_Y` | alias | Alias de `WINDOW_START_Y`, en pixeles. |
| `HUD_WINDOW_X` / `HUD_WINDOW_Y` | alias | Posicion de la ventana del HUD (`WINDOW_START_X` / `WINDOW_START_Y`). |
| `HUD_TEXTO_NIVEL` | `TILEMAP_HUD_START + 1` | Donde se escribe LEVEL + numero en el HUD. |
| `HUD_VIDAS_JUGADOR` | `TILEMAP_HUD_START + 15` | Donde se dibujan los corazones en el HUD. |
| `CAMERA_MAX_X` / `CAMERA_MAX_Y` | 0 | Scroll maximo de la camara (0 = la pantalla no se mueve). |
| `TAM_VRAM` | 32 | Distancia entre filas consecutivas del tilemap en VRAM. |
| `E_CMP` | 0 | Offset del byte de componentes de una entidad. |
| `E_Y` | 1 | Offset de Y del sprite en la entidad. |
| `E_SPRITE` | `E_Y` | Offset del primer byte del bloque OAM de la entidad. |
| `E_X` | 2 | Offset de X del sprite. |
| `E_TILE` | 3 | Offset del indice de tile del sprite. |
| `E_ATTR` | 4 | Offset de atributos OAM. |
| `E_VY` | 5 | Offset de velocidad vertical. |
| `E_VX` | 6 | Offset de velocidad horizontal. |
| `E_KIND` | 7 | Offset del tipo de entidad. |
| `CMP_SPRITE_BIT` | 0 | Bit que indica que la entidad tiene sprite. |
| `CMP_PHYSICS_BIT` | 1 | Bit que indica que la entidad usa fisicas. |
| `CMP_COLLIDER_BIT` | 2 | Bit que indica que la entidad colisiona. |
| `CMP_INPUT_BIT` | 4 | Bit que indica que la entidad recibe input. |
| `CMP_ALIVE_BIT` | 7 | Bit que marca una entidad como viva. |
| `CMP_SPRITE` | mascara | Mascara del componente sprite. |
| `CMP_PHYSICS` | mascara | Mascara del componente fisicas. |
| `CMP_COLLIDER` | mascara | Mascara del componente colisionador. |
| `CMP_INPUT` | mascara | Mascara del componente de entrada. |
| `CMP_ALIVE` | mascara | Mascara del bit de entidad viva. |
| `KIND_JUGADOR_BIT` | 0 | Bit de tipo jugador. |
| `KIND_ESCORPION_BIT` ... `KIND_ESTALACTITA_BIT` | 1 ... 5 | Bit de cada tipo de enemigo: escorpion 1, murcielago 2, momia 3, pinchos 4, estalactita 5. |
| `KIND_JUGADOR` | mascara | Mascara para identificar al jugador. |
| `KIND_ESCORPION` ... `KIND_ESTALACTITA` | mascara | Mascara de cada tipo de enemigo (`1 << bit`). |
| `KIND_FIN_ENEMIGOS` | 0 | Centinela: fin de la tabla de enemigos de un nivel. |
| `ATTR_BIT_PRIORIDAD` ... `ATTR_BIT_PALET` | 7 ... 4 | Bits de atributos OAM: prioridad 7, espejo Y 6, espejo X 5, paleta 4. |
| `ATTR_PRIORIDAD` ... `ATTR_PALET` | mascara | Mascara de cada atributo OAM (`1 << bit`). |
| `E_DIR_HORIZONTAL` | 0 | Tipo de trayectoria horizontal de enemigo. |
| `E_DIR_VERTICAL` | 1 | Tipo de trayectoria vertical de enemigo. |
| `E_MOVE_NONE` | 0 | Sin direccion inicial de movimiento. |
| `E_MOVE_LEFT` | 1 | Movimiento hacia la izquierda. |
| `E_MOVE_RIGHT` | 2 | Movimiento hacia la derecha. |
| `E_MOVE_DOWN` | 3 | Movimiento hacia abajo. |
| `E_MOVE_UP` | 4 | Movimiento hacia arriba. |
| `VX_JUGADOR` | 1 px | Velocidad horizontal del jugador, por frame. |
| `IMPULSO_SALTO` | 10 | Velocidad vertical inicial del salto (hacia arriba). |
| `GRAVEDAD` | 1 | Lo que aumenta VY cada frame. |
| `VELOCIDAD_MAX_CAIDA` | 4 px | Velocidad maxima de caida, por frame. |
| `VIDAS_JUGADOR` | 3 | Vidas iniciales y maximas del jugador. |
| `MURCIELAGO_ESPERA_FRAME` | 20 | Updates entre cambios de frame del murcielago. |
| `PINCHOS_FASE_SUBIDA` / `PINCHOS_FASE_BAJADA` | 8 / 16 | Fin de la fase de subida y de bajada de los pinchos. |
| `PINCHOS_ESPERA_SUBIDA_BAJARA` | 4 | Updates entre cada pixel que suben o bajan los pinchos. |
| `PINCHOS_ESPERA_FASE` | 120 | Frames que los pinchos se quedan arriba o abajo. |
| `MAX_ENTITIES` | 8 | Capacidad del array de entidades (definida en `wram.asm`). |
| `OAM_ENTRY_SIZE` | 4 | Bytes por sprite en OAM. |
| `SHADOW_OAM_SIZE` | `MAX_ENTITIES * OAM_ENTRY_SIZE` | Bytes reservados para OAM sombra. |
| `ENTITY_SIZE` | 8 | Bytes por entidad en `entity_array`. |
| `ENTITY_ARRAY_SIZE` | `MAX_ENTITIES * ENTITY_SIZE` | Bytes reservados para el array. |
| `INITIAL_TILE_BYTES` | `tile_data_end - tile_data` | Tamano de los graficos de tiles en ROM. |
| `ESTADO_INICIAL` | 0 | Estado inicial del gestor/flujo. |
| `ESTADO_UNO` | 1 | Estado uno. |
| `ESTADO_DOS` | 2 | Estado dos. |
| `ESTADO_ERROR` | `$FF` | Estado de error. |
| `TILE_FUENTE` | `(fuente_data - tile_data) / 16` | Primer tile de la fuente (en `data/gfx.asm`). |
| `TILE_LETRA_A` ... `TILE_LETRA_L` | `TILE_FUENTE + n` | Tile de cada letra: A D E G I M O P R S T U V L. |
| `TILE_NUM_0` | `(numeros_data - tile_data) / 16` | Tile del 0; el numero n es `TILE_NUM_0 + n` (del 0 al 6). |
| `PANTALLA_ANCHO` | 20 | Tiles visibles en horizontal (una fila de pantalla). |
| `PANTALLA_ALTO` | 18 | Tiles visibles en vertical (filas de pantalla). |
| `DURACION_PANTALLA` | 180 | Frames que dura una pantalla temporizada (3 s a 60 fps). |
| `NUM_NIVELES` | 1 | Cuantos niveles tiene el juego. Al pasar el ultimo se va a la victoria. |
| `POS_NUMERO_NIVEL` | `$9800 + 8*32 + 12` | Direccion del tilemap donde se escribe el numero en la pantalla de nivel completado (definida en `data/pantallas.asm`). |
|  |  | <!-- NO MODIFICAR ESTA FILA, USAR PARA COPIAR Y PEGAR ARRIBA-->



## Funciones

### sin ordenar (solo ejemplo informal para el equipo)

> [!NOTE]
> Este bloque es un apunte temporal para compartir ideas entre compañeros. No forma parte del registro oficial del proyecto ni debe tomarse como definicion definitiva de una funcion.
>
> Se deja aqui un formato de ejemplo para ayudar a documentar funciones de forma rapida:
>
> ```asm {.javascript .numberLines}
> nombre_funcion::  ;; ./system/system_input
>     ;; Describe el comportamiento y los efectos en memoria
>     ;; I: -
>     ;; O: -
>     ;; M: A, HL
>     ;; ...
> ret
> ```

```asm {.javascript .numberLines}
ejermplo::      ;; indicar ubicacion gracias (archivo.asm en el que esta)
    ;; la descripcion
    ;; I: -
    ;; O: -
    ;; M: HL, DE, B, A
    
    ;; M: A
    ;; ...
ret

pressed_update:
    modifica: a, b, hl, joypad_pressed (valor), flags

sys_input_update:
    usa: pressed update
    modifica: a, b, c, hl, joypad_pressed (valor), joypad_held (valor), flags

scene_manager:
    modifica: a, flags
```

### Ya ordenadas
<!-- 
Utilizar " <br> " para salto de linea en la tabla
-->
| Ubicación | Nombre | Descripcion | Input | Output | Modifica |
| --- | --- | ----------- | --- | --- | --- |
| NO MOD. | NO QUITAR | ESTO_ES_PARA_ALARGAR_LA_DESCRIPCION_PARA_QUE_SEA_MÁS_LEGIBLE | ALARGAR_UN_POCO_ESTA_SECCION | ALARGAR_UN_POCO_ESTA_SECCION | ALARGAR_ESTA_SECCION | <!-- NO MODIFICAR ESTA FILA, USAR PARA AJUSTAR LA DISTANCIA DE LA TABLA-->
| utils.asm | init_game | Inicializa el arranque del juego: scroll, paletas, LCD, sonido (con la musica parada), OAM y carga de tiles del mapa base. | - | - | A, BC, DE, HL |
| utils.asm | init_scroll | Pone el fondo en la posicion inicial del scroll (0,0). | - | - | A, HL |
| utils.asm | init_window | Configura `rWX` y `rWY` y activa la ventana del LCD. | - | - | A |
| utils.asm | activar_lcd_window | Activa el bit de ventana del registro `rLCDC`. | - | - | A |
| utils.asm | desactivar_lcd_window | Desactiva el bit de ventana del registro `rLCDC` sin tocar el resto de bits. | - | - | A |
| utils.asm | init_palet | Carga la configuracion inicial de las paletas de fondo y sprites. | - | - | A |
| utils.asm | init_lcd | Escribe la configuracion completa del registro `rLCDC`. | - | - | A |
| utils.asm | init_oam | Limpia OAM con la rutina de espera a VBlank. | - | - | A, B, HL |
| utils.asm | wait_vblank | Espera a que la linea LCD alcance `VBLANK_START`. | - | - | A, HL |
| utils.asm | memcpy8 | Copia `B` bytes desde `HL` a `DE` usando incremento de punteros. | HL = origen, DE = destino, B = n | - | A, B, DE, HL |
| utils.asm | memcpy8_bc | Copia `BC` bytes desde `HL` a `DE` usando `BC` como contador. | HL = origen, DE = destino, BC = n | - | A, BC, DE, HL |
| utils.asm | memset8 | Rellena la zona apuntada por `HL` con el valor de `A` durante `B` bytes. | HL = destino, A = valor, B = n | - | A, B, HL |
| utils.asm | call_hl | Salta a la direccion apuntada por `HL` y vuelve con `ret` al salir de la subrutina. | HL = direccion | - | PC |
| utils.asm | digit2tile | Convierte un digito en el indice de su tile de numero. | A = digito | A = tile | A |
| manager_nivel.asm | get_mapa_nivel_actual | Devuelve en `HL` la direccion del mapa del nivel actual seleccionado por `nivel_actual`. | - | HL = direccion del mapa | A, HL |
| manager_nivel.asm | get_pos_inicial_jugador_nivel_actual | Devuelve en `HL` la direccion de la posicion inicial del jugador para el nivel actual. | - | HL = direccion de spawn | A, HL |
| manager_nivel.asm | get_enemigos_nivel_actual | Devuelve en `HL` el inicio de la tabla de enemigos del nivel actual (registros KIND, X, Y, VX, VY, ATTR; acaba en `KIND_FIN_ENEMIGOS`). | - | HL = tabla de enemigos | A, HL |
| manager_entidad.asm | manager_entity_for_each | Llama a la rutina de `HL` una vez por cada entidad viva, con `DE` apuntando a la entidad. | HL = rutina | - | A, B, DE, HL |
| manager_entidad.asm | manager_entity_init_enemies | Crea las entidades de la tabla de enemigos del nivel actual, a partir de la segunda entidad. | - | - | A, B, DE, HL |
| manager_entidad.asm | ia_enemigo_update | Llama a la IA que corresponde al tipo (`E_KIND`) de la entidad. El jugador se salta. Se usa con `manager_entity_for_each`. | DE = entidad | - | A, HL (+ la IA llamada) |
| manager_entidad.asm | ia_escorpion | Escorpion: se mueve a izquierda y derecha por el suelo y gira al tocar pared. | DE = entidad | - | A, B, HL |
| manager_entidad.asm | ia_murcielago | Murcielago: se mueve como el escorpion pero en el aire, cambiando de frame cada `MURCIELAGO_ESPERA_FRAME` updates. | DE = entidad | - | A, B, HL |
| manager_entidad.asm | ia_pinchos | Pinchos: suben y bajan en ciclo (VX cuenta frames, VY la fase). | DE = entidad | - | A, B, HL |
| manager_entidad.asm | ia_momia / ia_estalactita / ia_serpiente | Por hacer (solo `ret`). | DE = entidad | - | - |
| manager_entidad.asm | entidad_comprobar_salida_horizontal | Limita una X nueva al interior de la pantalla, sin pisar las paredes laterales. | A = X nueva (OAM) | A = X limitada; C = 1 si se salia | A |
| manager_entidad.asm | entidad_comprobar_salida_vertical | Limita una Y nueva al interior de la pantalla, sin pisar techo ni suelo. | A = Y nueva (OAM) | A = Y limitada; C = 1 si se salia | A |
| manager_entidad.asm | entidad_cambiar_dir_movimiento_horizontal | Invierte la direccion izquierda/derecha de la entidad (VX y espejo del sprite). | HL = entidad | - | A, DE |
| manager_entidad.asm | entidad_cambiar_dir_movimiento_vertical | Invierte la direccion arriba/abajo de la entidad (VY y espejo del sprite). | HL = entidad | - | A, DE |
| sprite_helper.asm | sprite_espejo_x | Voltea el sprite de la entidad en el eje X. | HL = entidad | - | A, DE |
| sprite_helper.asm | sprite_espejo_y | Voltea el sprite de la entidad en el eje Y. | HL = entidad | - | A, DE |
| system_input.asm | sys_input_update | Lee el joypad y actualiza `joypad_pressed` (botones pulsados ahora, 1 = pulsado). Se llama una vez por frame en el bucle principal. | - | - | A, BC, HL |
| system_prerender.asm | system_jugador_update | Lee el input del jugador: direccion (izquierda/derecha) y peticion de salto con A recien pulsado (`jugador_solicita_salto`). No mueve al jugador. | - | - | A, BC |
| system_prerender.asm | system_prerender_pos_jugador | Copia `jugador_x` / `jugador_y` a la entidad del jugador, en coordenadas OAM. | - | - | A, HL |
| system_fisicas.asm | system_fisicas_update | Fisicas del jugador: velocidad horizontal segun la direccion, inicio del salto (con `SfxSalto`), gravedad con limite de caida y movimiento vertical. | - | - | A, B, DE, HL |
| system_colisiones.asm | system_colisiones_update | Si el jugador cae y cruza el suelo, lo deja encima, para la caida, permite saltar y suena `SfxAterrizar` si caia de verdad. | - | - | A, B, DE, HL |
| system_colisiones.asm | check_right_wall / check_left_wall | Comprueba si hay pared a la derecha / izquierda del jugador. | - | Z = 1 si hay pared | A, BC, DE, HL |
| system_colisiones.asm | get_tile_at_bc | Lee el tile del mapa en la columna `B`, fila `C` y comprueba si es pared. | B = columna, C = fila | Z = 1 si es pared | A, DE, HL |
| system_colisiones.asm | sys_collision_overlaps | Comprueba si dos entidades se solapan (distancia menor que `TAM_COLISION` en X e Y). | DE = entidad 1, HL = entidad 2 | C = 1 si se solapan | A, DE, HL |
| system_prerender.asm | system_prerender_init_entities | Inicializa el array `entity_array` a cero para preparar entidades vivas. | - | - | A, B, HL |
| system_prerender.asm | system_prerender_init_jugador | Crea la entidad del jugador a partir del spawn del nivel actual y rellena su estructura OAM. | - | - | A, B, DE, HL |
| system_prerender.asm | system_prerender_one | Si una entidad tiene el componente sprite activo, copia 4 bytes de su sprite a `shadow_oam` y avanza el cursor. | DE = entidad a procesar | - | A, B, DE, HL |
| system_prerender.asm | system_prerender_update | Reinicia `shadow_oam` y recorre todas las entidades vivas para preparar el dibujado del frame. | - | - | A, B, DE, HL |
| system_render.asm | system_render_load_map | Copia el tilemap del nivel actual desde ROM a VRAM, fila a fila, con espera de VBlank. | - | - | A, BC, DE, HL |
| system_render.asm | system_render_load_tiles | Copia los tiles graficos desde ROM a la zona de VRAM de tiles. | - | - | A, BC, DE, HL |
| system_render.asm | system_render_update | Copia `shadow_oam` a OAM real al final del frame. | - | - | A, B, DE, HL |
| system_render.asm | system_render_scroll | Actualiza el scroll del fondo con la posicion de la camara. | - | - | A, BC |
| hud.asm | camera_axis | Calcula la posicion de la camara en un eje y la limita al rango permitido. | A = posicion, B = offset, C = maximo | A = posicion de camara | A, BC |
| hud.asm | get_camera_pos | Devuelve la posicion de la camara segun la del jugador. | - | B = camara Y, C = camara X | A, BC |
| hud.asm | hud_show | Coloca la ventana del HUD y la activa. | - | - | A |
| hud.asm | init_hud | Enciende el HUD: lo limpia, escribe LEVEL + numero de nivel y dibuja los corazones. | - | - | A, BC, HL |
| hud.asm | hud_draw_hearts | Dibuja `VIDAS_JUGADOR` corazones: llenos los que quedan (`jugador_vidas`) y vacios el resto. | - | - | A, BC, HL |
| system_sonido.asm | sys_sound_init | Enciende el APU con volumen maximo y los 4 canales en los dos altavoces. Se llama una vez en `init_game`. | - | - | A |
| system_sonido.asm | sys_sound_play_sfx | Reproduce un efecto de `data/sfx.asm`: copia sus valores a los registros del canal. | HL = efecto (`SfxSalto`, ...) | - | A, B, DE, HL |
| system_musica.asm | sys_music_play | Empieza a sonar una cancion de `data/musica.asm` por el canal 2. | HL = cancion (`musica_titulo`, ...) | - | A |
| system_musica.asm | sys_music_stop | Para la musica y silencia el canal 2. Se llama en `init_game` (la RAM no empieza a 0). | - | - | A |
| system_musica.asm | sys_music_update | Avanza la musica un frame: al acabar una nota toca la siguiente; al final de la cancion vuelve a empezar o para. Se llama una vez por frame en el bucle principal. | - | - | A, DE, HL |
| system_pantalla.asm | sys_pantalla_dibujar | Dibuja una pantalla completa de 20x18 tiles desde la ROM al tilemap (`$9800`), con la pantalla apagada. Al encender, la ventana (HUD) queda apagada. | HL = pantalla en ROM (20x18 bytes, fila a fila) | - | A, BC, DE, HL |
| manager_escena.asm | manager_escena_cambiar | Cambia de escena: guarda su update en `escena_update` y ejecuta su init. Una escena es un bloque `DW init` / `DW update`. | HL = escena (`scene_menu`, `scene_ingame`, ...) | - | Todos (ejecuta el init) |
| manager_escena.asm | manager_escena_update | Ejecuta el update de la escena actual. Se llama una vez por frame desde el bucle principal. | - | - | Todos (ejecuta el update) |
| scene_menu.asm | scene_menu_init | Titulo: vacia la OAM sombra (sin sprites), pone `musica_titulo` y dibuja `pantalla_titulo`. | - | - | A, BC, DE, HL |
| scene_menu.asm | scene_menu_update | Titulo, cada frame: con START recien pulsado pone `nivel_actual` = 1 (partida nueva), suena `SfxMenuOk` y va a `scene_ingame`. | - | - | A, BC, DE, HL (+ lo que modifique scene_ingame_init) |
| scene_ingame.asm | scene_ingame_init | Partida: carga el mapa de `nivel_actual`, crea el jugador y los enemigos del nivel (parados hasta la primera pulsacion), pone `musica_partida` y enciende el HUD. `nivel_actual` lo pone quien empieza la partida (titulo o nivel completado). | - | - | A, BC, DE, HL |
| scene_ingame.asm | scene_ingame_update | Partida, cada frame: input del jugador, fisicas, scroll, colisiones, posicion del jugador, IA de los enemigos (desde la primera pulsacion) y preparar los sprites. | - | - | A, BC, DE, HL |
| manager_escena.asm | manager_escena_temporizada_init | Init comun de las pantallas que salen solas: vacia la OAM sombra, guarda la escena siguiente, pone `escena_contador` = `DURACION_PANTALLA` y dibuja la pantalla. | HL = pantalla en ROM, DE = escena siguiente | - | A, BC, DE, HL |
| manager_escena.asm | manager_escena_temporizada_update | Update comun de las pantallas que salen solas: resta 1 a `escena_contador` y al llegar a 0 cambia a `escena_siguiente`. | - | - | Todos (al acabar ejecuta el init de la siguiente) |
| scene_gameover.asm | scene_gameover_init | Game over: pantalla GAME OVER durante `DURACION_PANTALLA` frames, despues al titulo. Para usarla: `ld hl, scene_gameover` / `call manager_escena_cambiar`. | - | - | A, BC, DE, HL |
| scene_nivel.asm | scene_nivel_init | Nivel completado: si era el ultimo nivel va a la victoria; si no, muestra GREAT + numero, suena `SfxNivel`, incrementa `nivel_actual` y despues va a la partida. Para usarla: `ld hl, scene_nivel` / `call manager_escena_cambiar`. | `nivel_actual` = nivel superado | - | A, BC, DE, HL |
| scene_victoria.asm | scene_victoria_init | Victoria: pantalla SURVIVED con `musica_victoria` (suena una vez), despues al titulo. | - | - | A, BC, DE, HL |
|  |   |  |  |  |  | <!-- NO MODIFICAR ESTA FILA, USAR PARA COPIAR Y PEGAR ARRIBA-->