<!-- Renderizar en VSCODE: Ctrl + Shift + V -->
# Organizacion del proyecto

Este documento es el acuerdo comun para trabajar en grupo en el juego de Game Boy. La idea es que cada persona pueda desarrollar una parte sin romper las demas y que todas las rutinas se puedan reutilizar, siguiendo un formato común.

- Separar datos, sistemas y escenas.
- Evitar copiar una rutina para cada objeto: una rutina procesa una entidad y el gestor recorre todas las entidades activas.
- Mantener los datos en `WRAM0`, el codigo y los recursos constantes en ROM, y escribir en VRAM solo durante VBlank.
- Usar constantes, estructuras y contratos en lugar de direcciones y numeros magicos.

## Estructura del proyecto

La estructura se puede ampliar/modificar según necesidades.
```text
v1_plataformero/
	src/
		utils.asm                  ; Inicializacion del hardware y rutinas comunes
		defs.asm                   ; Registros, constantes y offsets de entidades
		header.asm                 ; Cabecera de la ROM
		main.asm                   ; Inicializacion y bucle principal
		sprite_helper.asm          ; Voltear sprites (espejo X / Y)
		wram.asm                   ; Variables y buffers de trabajo en WRAM0
		funciones.md               ; Referencia de rutinas comunes
		data/
			gfx.asm                  ; Tiles y datos graficos constantes en ROM (incluye la fuente)
			gfx/                     ; Tiles en formato .2bpp (INCBIN desde gfx.asm)
			nivel1.asm ... nivel9.asm ; Niveles 1-9: mapa, spawn del jugador, enemigos fijos y enemigos segun el reloj
			nivel_test.asm           ; Nivel de pruebas (explica que significa cada campo de los enemigos)
			pantallas.asm            ; Constantes de las pantallas (donde va el numero del nivel, el menu del titulo...)
			pantalla_titulo.asm      ; Pantalla de titulo: sus tiles y su mapa (tambien START centrado)
			pantalla_nivel.asm       ; Pantalla de nivel completado (GREAT + numero)
			pantalla_gameover.asm    ; Pantalla de game over
			pantalla_victoria.asm    ; Pantalla de victoria
			sfx.asm                  ; Efectos de sonido en ROM
			musica.asm               ; Canciones en ROM (titulo, partida, victoria)
		managers/
			manager_entidad.asm      ; Gestion de las entidades y IA de los enemigos
			manager_escena.asm       ; Cambio de escenas y pantallas temporizadas
			manager_nivel.asm        ; Seleccion de datos del nivel actual
		scenes/
			scene_menu.asm           ; Titulo: START solo, o RESUME / RESTART si se perdio a mitad de partida
			scene_ingame.asm         ; Partida
			scene_pause.asm          ; Pausa (SELECT en la partida, START para seguir)
			scene_gameover.asm       ; Fin de partida (sale sola al titulo)
			scene_nivel.asm          ; Nivel completado (sale sola al nivel siguiente o a la victoria)
			scene_victoria.asm       ; Victoria (sale sola al titulo)
		systems/
			system_colisiones.asm   ; Colisiones con el mapa y golpes con enemigos y escudo
			system_comprar_fin_partida.asm ; Ir a game over al quedarse sin vidas
			system_fisicas.asm      ; Gravedad, velocidad y movimiento
			system_input.asm        ; Lectura del joypad
			system_pantalla.asm     ; Dibujar una pantalla completa desde la ROM
			system_prerender.asm    ; Preparacion de sprites en shadow_oam
			system_render.asm       ; Copias a VRAM/OAM durante VBlank y scroll
			system_reloj.asm        ; Reloj del nivel (30 s hacia atras)
			system_spawn.asm        ; Enemigos que aparecen segun el reloj
			system_sonido.asm       ; Encendido del APU y reproduccion de efectos
			system_musica.asm       ; Reproduccion de la musica por el canal 2
		ui/
			hud.asm                  ; HUD en partida (nivel, reloj y vidas)
			controles.asm            ; Instrucciones del nivel 1 (PRESS A TO JUMP...)
```

El `Makefile` ya busca los archivos `.asm` dentro de `src`, incluidos los de subcarpetas. Si una carpeta nueva no se enlaza como esperamos, se comprueba primero que el archivo tenga extension `.asm` y que este dentro de `src`.

## Estructura para las funciones

Dejar el contrato junto a cada etiqueta global, siguiendo este orden: descripcion breve, `I`, `O` y `M`.

- En `I:` (INPUT) indicar solo los registros y flags que recibe la funcion.
- En `O:` (OUTPUT), solo los registros y flags que devuelve. 
	- Si no hay INPUT/OUTPUT relevantes o no hay, escribir `-`.
- En `M:` (MODIFY) indicar los registros que pueden quedar modificados, incluyendo los que cambien las rutinas llamadas.
- No indicar lo que hace la funcion en `I:`/`O:`, dejarlo en la descripción.
- Las funciones globales terminan en `::`; las etiquetas internas usan `.`.
- Una función llamada con `call` debe terminar con `ret` o `jp`.

> [!NOTE]
> **Ejemplo:** 
> ```asm {.javascript .numberLines}
> nombre_funcion::
> 	  ;; Describe el comportamiento y los efectos en memoria
> 	  ;; I: HL = origen; Z = condicion de entrada
> 	  ;; O: A = resultado; C = indica si hubo desbordamiento
> 	  ;; M: A, HL
> 
> 	  ;; <<<codigo>>>
> ret
> ```

## Orden previsto de actualizacion de una escena

1. Leer input.
2. Actualizar intenciones y movimiento.
3. Resolver colisiones.
4. Actualizar animaciones y estados.
5. Preparar los sprites en `shadow_oam` fuera de VBlank.
6. Esperar VBlank dentro del render y copiar `shadow_oam` a OAM.

El mapa y los tiles son estaticos: se cargan al inicializar el juego/nivel, no cada fotograma. El render se encarga de copiar cada fotograma de OAM, que solo se modifica el tilemap durante un cambio o carga de nivel.

> [!NOTE]
> **Ejemplo posible:**
> ```asm {.javascript .numberLines}
> scene_ingame_init::
>     call system_prerender_init_entities
>     call system_prerender_init_jugador
> ret
> 
> scene_ingame_update::
>     call system_input_update
>     call system_fisicas_update
>     call system_colisiones_update
>     call system_prerender_update
>     call system_render_update
> ret
> ```

Lo que es comun a todas las escenas se llama desde el bucle principal de `main.asm`, no desde cada escena. En cada frame, por orden:

1. `sys_input_update`: leer el joypad.
2. `system_actualizar_reloj`: contar el tiempo del nivel (solo si el reloj esta encendido).
3. `manager_escena_update`: el update de la escena actual.
4. `sys_music_update`: avanzar la musica.
5. `system_render_update`: copiar `shadow_oam` a la OAM en VBlank.
6. `comprobar_jugador_vivo`: si no quedan vidas, ir a game over.

## Escenas

Cada escena es un bloque en ROM `DW init` / `DW update`. Para cambiar: `ld hl, scene_X` / `jp manager_escena_cambiar` (o `call` si despues hay que seguir haciendo cosas).

```text
titulo --START--> partida --reloj a 0--> nivel completado (GREAT n, 3 s) --> partida (nivel siguiente)
                     |                        '--si era el ultimo--> victoria (3 s) --> titulo (START)
                     |--SELECT--> pausa --START--> partida
                     '--sin vidas--> game over (3 s) --> titulo (RESUME / RESTART)
```

- Las pantallas de 3 s (nivel completado, game over, victoria) usan `manager_escena_temporizada_init` / `_update`.
- Las pantallas cargan sus propios tiles encima de los del juego: `scene_ingame_init` vuelve a cargar los del juego lo primero.
- `hay_partida` = 1 despues de perder: el titulo ofrece RESUME (sigue en `nivel_actual`) y RESTART (nivel 1).




## Compilacion y comprobación.

Desde `v1_plataformero/` ejecutar intrucción a intrucción:

```bash
make
gbt_bgb survive.gb
make clean
```

> [!NOTE]
> **Checklist antes de hacer push:**
> - [ ] `make` termina sin errores ni warnings nuevos.
> - [ ] La ROM arranca en BGB `gbt_bgb survive.gb`.
> - [ ] La escena inicializa sus datos antes del primer update.
> - [ ] No se escribe en VRAM fuera de VBlank.
> - [ ] No hay bucles infinitos.
> - [ ] Las entidades inactivas no son procesadas (`CMP = 0` o `ALIVE` desactivado).
> - [ ] Las funciones a las que se llamadas con `call` tienen `ret` o `jp`.
> - [ ] Hacer pruebas directamente en el juego de lo que se ha implementado.
> - [ ] Si se ha cambiado el nivel de inicio para probar (`ld a, 1` de RESTART en `scene_menu.asm`), volver a dejarlo en 1.
> - [ ] Subir solo el codigo: `git add src` (no `git add .`, que subiria los documentos `@*.md`).
> - [ ] `git pull` antes de `git push`.
