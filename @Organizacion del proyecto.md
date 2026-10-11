<!-- Renderizar en VSCODE: Ctrl + Shift + V -->
# Organizacion del proyecto

Este documento es el acuerdo comun para trabajar en grupo en el juego de Game Boy. La idea es que cada persona pueda desarrollar una parte sin romper las demas y que todas las rutinas se puedan reutilizar, siguiendo un formato común.

- Separar datos, sistemas y escenas.
- Evitar copiar una rutina para cada objeto: una rutina procesa una entidad y el gestor recorre todas las entidades activas.
- Mantener los datos en `WRAM0`, el codigo y los recursos constantes en ROM, y escribir en VRAM solo durante VBlank.
- Usar constantes, estructuras y contratos en lugar de direcciones y numeros magicos.

## Estructura propuesta del proyecto

La siguiente estructura es temporal y apliable según veamos nuevas nuecesidadese
```text
v1_plataformero/
	src/
		header.asm          ; Cabecera de la ROM. Recoradr cambiar nombre en l.53
		main.asm            ; Punto de entrada y bucle principal
		constants.asm       ; Constantes globales del juego
		data/
			entities.asm    ; Estructuras y arrays de entidades en WRAM0
			level.asm       ; Datos del nivel y tilemaps
		managers/
			entity_manager.asm
		systems/
			input.asm
			fisicas.asm
			colisiones.asm
			render.asm
		scenes/
			game.asm        ; Inicializacion y actualizacion de la escena
```

El `Makefile` ya busca los archivos `.asm` dentro de `src`, incluidos los de subcarpetas. Si una carpeta nueva no se enlaza como esperamos, se comprueba primero que el archivo tenga extension `.asm` y que este dentro de `src`.

## Estructura para las funciones

Antes o despuede de hacer una función, dejar su contrato junto a la etiqueta. 

- Indicar siempre los registros de 📥entrada, 🔙salida y modificados (incluyendo las que se modifican si se hace un `call` dentro de la función). En caso de que no haya indicar que no hay.
- Los flags tambien forman parte del contrato: indicar, por ejemplo, `Z si la celda esta libre` o `A = 0 si no hay colision`.
- Las funciones globales terminan en `::`; las etiquetas internas usan `.`.
- Una función llamada con `call` debe terminar con `ret` o `jp`.

> [!NOTE]
> **Ejemplo:** 
> ```asm {.javascript .numberLines}
> ;; Comprobar si se puede desplazar hacia la donde se indica en `A`.
> ;; 📥INPUTS
> ;;	A  = desplazamiento que se quiere hacer
> ;; 	HL = direccion de la posicion actual
> ;; 🔙RETURNS/OUTPUTS: 
> ;;	Flag: Z se ha movido correctamen
> ;; 		 NZ se sale del mapa (en `A` se indica por donde se sale)
> ;;			A = 0 se la por debajo
> ;;		  	A = 1 se la por arriva
> ;;		  	A = 2 se la por la izquieda
> ;;		  	A = 3 se la por la derecha
> ;; ❌MODIFICA: AF, HL
> sys_funcion_nombre::
> 	  ;; <codigo de la funcion>
> 	  ;; ...
> ret
> ```

## Orden de actualizacion de una escena

1. Leer input.
2. Actualizar intenciones y movimiento.
3. Resolver colisiones.
4. Actualizar animaciones y estados.
5. Esperar VBlank.
6. Renderizar tilemap y sprites.

> [!NOTE]
> **Ejemplo:**
> ```asm {.javascript .numberLines}
> scene_game_init::
>     call man_entity_init
>     call sys_render_init
> ret
> 
> scene_game_update::
>     call sys_input_update
>     call sys_fisicas_update
>     call sys_colisiones_update
>     call sys_render_update
> ret
> ```

Orden recomendado por frame:



## Compilacion y comprobación.

Desde `v1_plataformero/` ejercurar intrucción a intrucción:

```bash
make
gbt_bgb game.gb
make clean
```

> [!NOTE]
> **Checklist antes de hacer push:**
> - [ ] `make` termina sin errores ni warnings nuevos.
> - [ ] La ROM arranca en BGB `gbt_bgb game.gb`.
> - [ ] La escena inicializa sus datos antes del primer update.
> - [ ] No se escribe en VRAM fuera de VBlank.
> - [ ] No hay bucles infinitos.
> - [ ] Las entidades inactivas no son procesadas (E_ACTIVE = 0).
> - [ ] Las funciones a las que se llamadas con `call` tienen `ret` o `jp`.
> - [ ] Hacer pruebas directamente en el juego de lo que se ha implementado.