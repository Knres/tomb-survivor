<!-- Renderizar en VSCODE: Ctrl + Shift + V -->
# Documento funciones

En este documento se pondra todas las funciones, memorias y contantes del videojugo. (intentar mantener el formato o almenos dejarlo pegado para facilitar la busqueda mediante `Ctrl + F`)

Si es para buscar un nomrbe en espefico buscar en `Ctrl + F` "| nombre/etiqueta/etc |"

## Memoria
Las memorias reservadas se ubicaran dentro del archcivo **`wram.asm`**, en casos necesarios se definiran fuera de este archivo pero se dejara comentado su existencia.

**Aqui solo se registraran las que se han definido como globale `etiqueta::`(dos ::)**

| Etiqueta | Tamaño | ¿Para qué es? |
| -------- | ------ | ------------- |
| `entity_array` | `ENTITY_ARRAY_SIZE` (32 bytes) | Array de 4 entidades de 8 bytes (`CMP`, `Y`, `X`, `TILE`, `ATTR`, `VY`, `VX`, `KIND`). |
| `shadow_oam` | `SHADOW_OAM_SIZE` (16 bytes) | Copia de los datos `Y`, `X`, `TILE`, `ATTR` de hasta 2 sprites, preparada antes de VBlank. |
| `shadow_cursor` | 2 bytes | Puntero al siguiente slot disponible en `shadow_oam`. |
| `jugador_x` | 1 byte | Posicion horizontal del jugador en pixeles. |
| `jugador_y` | 1 byte | Posicion vertical del jugador en pixeles. |
| `jugador_direccion_movimiento` | 1 byte | Direccion/intencion de movimiento del jugador. |
| `nivel_actual` | 1 byte | Numero del nivel seleccionado. |
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
| `TILE_JUGADOR` | `$03` | Indice del tile del jugador. |
| `LEVEL_MAP_WIDTH` | 20 | Ancho logico del mapa del nivel, en tiles. |
| `LEVEL_MAP_HEIGHT` | 16 | Alto del area de juego, en tiles. |
| `LEVEL_HUD_ORIGIN_X` | 0 | Columna inicial prevista del HUD, en tiles. |
| `LEVEL_HUD_ORIGIN_Y` | 16 | Fila inicial prevista del HUD, en tiles. |
| `LEVEL_HUD_HEIGHT` | 2 | Alto previsto del HUD, en tiles. |
| `LEVEL_FLOOR_Y` | 16 | Coordenada logica del suelo, en tiles. |
| `WINDOW_X_OFFSET` | 7 | Ajuste de WX definido por el hardware Game Boy. |
| `WINDOW_START_X` | expresion | Posicion horizontal inicial de ventana en pixeles. |
| `WINDOW_START_Y` | expresion | Posicion vertical inicial de ventana en pixeles. |
| `HUD_START_POS_X` | alias | Alias de `WINDOW_START_X`, en pixeles. |
| `HUD_START_POS_Y` | alias | Alias de `WINDOW_START_Y`, en pixeles. |
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
| `KIND_ENEMIGO_BIT` | 1 | Bit de tipo enemigo. |
| `KIND_JUGADOR` | mascara | Mascara para identificar al jugador. |
| `KIND_ENEMIGO` | mascara | Mascara para identificar enemigos. |
| `E_DIR_HORIZONTAL` | 0 | Tipo de trayectoria horizontal de enemigo. |
| `E_DIR_VERTICAL` | 1 | Tipo de trayectoria vertical de enemigo. |
| `E_MOVE_NONE` | 0 | Sin direccion inicial de movimiento. |
| `E_MOVE_LEFT` | 1 | Movimiento hacia la izquierda. |
| `E_MOVE_RIGHT` | 2 | Movimiento hacia la derecha. |
| `E_MOVE_DOWN` | 3 | Movimiento hacia abajo. |
| `E_MOVE_UP` | 4 | Movimiento hacia arriba. |
| `VX_JUGADOR` | 5 px | Velocidad horizontal configurada del jugador. |
| `VY_JUGADOR` | 5 px | Velocidad vertical configurada del jugador. |
| `MAX_ENTITIES` | 4 | Capacidad actual del array de entidades. |
| `OAM_ENTRY_SIZE` | 4 | Bytes por sprite en OAM. |
| `SHADOW_OAM_SIZE` | `MAX_ENTITIES * OAM_ENTRY_SIZE` | Bytes reservados para OAM sombra. |
| `ENTITY_SIZE` | 8 | Bytes por entidad en `entity_array`. |
| `ENTITY_ARRAY_SIZE` | `MAX_ENTITIES * ENTITY_SIZE` | Bytes reservados para el array. |
| `INITIAL_TILE_BYTES` | `tile_data_end - tile_data` | Tamano de los graficos de tiles en ROM. |
| `ESTADO_INICIAL` | 0 | Estado inicial del gestor/flujo. |
| `ESTADO_UNO` | 1 | Estado uno. |
| `ESTADO_DOS` | 2 | Estado dos. |
| `ESTADO_ERROR` | `$FF` | Estado de error. |
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
    ;; M: A
    ;; ...
ret
```

### Ya ordenadas
<!-- 
Utilizar " <br> " para salto de linea en la tabla
-->
| Ubicación | Nombre | Descripcion | Input | Output | Modifica |
| --- | --- | ----------- | --- | --- | --- |
| NO MOD. | NO QUITAR | ESTO_ES_PARA_ALARGAR_LA_DESCRIPCION_PARA_QUE_SEA_MÁS_LEGIBLE | ALARGAR_UN_POCO_ESTA_SECCION | ALARGAR_UN_POCO_ESTA_SECCION | ALARGAR_ESTA_SECCION |
| aux.asm | init_game | Inicializa el arranque del juego: scroll, paletas, LCD, OAM y carga de tiles del mapa base. | - | - | A, B, DE, HL |
| aux.asm | init_scroll | Pone el fondo en la posicion inicial del scroll (0,0). | - | - | A, HL |
| aux.asm | init_hud | Inicializa la ventana/HUD en la posicion definida por el proyecto. | - | - | A |
| aux.asm | init_window | Configura `rWX` y `rWY` y activa la ventana del LCD. | - | - | A |
| aux.asm | activar_lcd_window | Activa el bit de ventana del registro `rLCDC`. | - | - | A |
| aux.asm | desactivar_lcd_window | Desactiva el bit de ventana del registro `rLCDC` sin tocar el resto de bits. | - | - | A |
| aux.asm | init_palet | Carga la configuracion inicial de las paletas de fondo y sprites. | - | - | A |
| aux.asm | init_lcd | Escribe la configuracion completa del registro `rLCDC`. | - | - | A |
| aux.asm | init_oam | Limpia OAM con la rutina de espera a VBlank. | - | - | A, B, HL |
| aux.asm | wait_vblank | Espera a que la linea LCD alcance `VBLANK_START`. | - | - | A, HL |
| aux.asm | memcpy8 | Copia `B` bytes desde `HL` a `DE` usando incremento de punteros. | HL = origen, DE = destino, B = n | - | A, B, DE, HL |
| aux.asm | memcpy8_bc | Copia `BC` bytes desde `HL` a `DE` usando `BC` como contador. | HL = origen, DE = destino, BC = n | - | A, BC, DE, HL |
| aux.asm | memset8 | Rellena la zona apuntada por `HL` con el valor de `A` durante `B` bytes. | HL = destino, A = valor, B = n | - | A, B, HL |
| aux.asm | call_hl | Salta a la direccion apuntada por `HL` y vuelve con `ret` al salir de la subrutina. | HL = direccion | - | PC |
| manager_nivel.asm | get_mapa_nivel_actual | Devuelve en `HL` la direccion del mapa del nivel actual seleccionado por `nivel_actual`. | - | HL = direccion del mapa | A, HL |
| manager_nivel.asm | get_pos_inicial_jugador_nivel_actual | Devuelve en `HL` la direccion de la posicion inicial del jugador para el nivel actual. | - | HL = direccion de spawn | A, HL |
| system_prerender.asm | system_prerender_init_entities | Inicializa el array `entity_array` a cero para preparar entidades vivas. | - | - | A, B, HL |
| system_prerender.asm | system_prerender_init_jugador | Crea la entidad del jugador a partir del spawn del nivel actual y rellena su estructura OAM. | - | - | A, B, DE, HL |
| system_prerender.asm | system_prerender_one | Si una entidad tiene el componente sprite activo, copia 4 bytes de su sprite a `shadow_oam` y avanza el cursor. | DE = entidad a procesar | - | A, B, DE, HL |
| system_prerender.asm | system_prerender_update | Reinicia `shadow_oam` y recorre todas las entidades vivas para preparar el dibujado del frame. | - | - | A, B, DE, HL |
| system_render.asm | system_render_load_map | Copia el tilemap del nivel actual desde ROM a VRAM, fila a fila, con espera de VBlank. | - | - | A, BC, DE, HL |
| system_render.asm | system_render_load_tiles | Copia los tiles graficos desde ROM a la zona de VRAM de tiles. | - | - | A, B, DE, HL |
| system_render.asm | system_render_update | Copia `shadow_oam` a OAM real al final del frame. | - | - | A, B, DE, HL |
|  |   |  |  |  |  | <!-- NO MODIFICAR ESTA FILA, USAR PARA COPIAR Y PEGAR ARRIBA-->