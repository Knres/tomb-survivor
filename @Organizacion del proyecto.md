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
			nivel1.asm               ; Nivel 1: mapa, spawn del jugador y enemigos
			nivel2.asm               ; Nivel 2: mapa, spawn del jugador y enemigos
			pantallas.asm            ; Pantallas de titulo, game over, nivel completado y victoria
			sfx.asm                  ; Efectos de sonido en ROM
			musica.asm               ; Canciones en ROM (titulo, partida, victoria)
		managers/
			manager_entidad.asm      ; Gestion de las entidades y IA de los enemigos
			manager_escena.asm       ; Cambio de escenas y pantallas temporizadas
			manager_nivel.asm        ; Seleccion de datos del nivel actual
		scenes/
			scene_menu.asm           ; Titulo (START empieza la partida)
			scene_ingame.asm         ; Partida
			scene_gameover.asm       ; Fin de partida (sale sola al titulo)
			scene_nivel.asm          ; Nivel completado (sale sola al nivel siguiente o a la victoria)
			scene_victoria.asm       ; Victoria (sale sola al titulo)
		systems/
			system_colisiones.asm   ; Deteccion y resolucion de colisiones
			system_fisicas.asm      ; Gravedad, velocidad y movimiento
			system_input.asm        ; Lectura del joypad
			system_pantalla.asm     ; Dibujar una pantalla completa desde la ROM
			system_prerender.asm    ; Preparacion de sprites en shadow_oam
			system_render.asm       ; Copias a VRAM/OAM durante VBlank y scroll
			system_sonido.asm       ; Encendido del APU y reproduccion de efectos
			system_musica.asm       ; Reproduccion de la musica por el canal 2
		ui/
			hud.asm                  ; HUD en partida (nivel y vidas)
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

Lo que es comun a todas las escenas (leer el joypad, avanzar la musica y copiar los sprites a la OAM) se llama desde el bucle principal de `main.asm`, no desde cada escena.




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
