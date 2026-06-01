# El Hincha Invasor

**El Hincha Invasor** es un jueguito arcade 2D top-down que armamos en Godot 4. El juego es simple: sos un hincha termo en pleno Mundial y tu único objetivo es colarte a la cancha. Para eso, tenés que cruzar un mapa gigante de abajo hacia arriba pasando por tres zonas (La Calle, La Grada y El Terreno de Juego) esquivando autos, policías y de seguridad. Un toque estilo Frogger, pero más caótico.

## Brainstorming y el bug de la "Avalancha"

Cuando estábamos tirando ideas, dijimos "che, elegir el país no puede ser solo un cambio de remera". Queríamos que cada uno tuviera una habilidad especial con cooldown para zafar de perder. Así quedaron:
* **Argentina:** Avalancha (Dash de 2 casilleros).
* **Brasil:** Amague (Intangible por 2 segundos).
* **Japón:** Limpieza (Escudo pasivo de un uso).
* **Inglaterra:** Empujón (Rompe el obstáculo de adelante).
* **Alemania:** Máquina (Ralentiza todo a la mitad).

**La anécdota del desarrollo:** Cuando nos pusimos a testear, nos dimos cuenta de que la habilidad de Argentina rompía todo. Resulta que si usabas el dash de la "Avalancha" pegado al borde de la pantalla, el chabón calculaba los casilleros tan literal que saltaba para afuera de los límites de la cámara y de la grilla. Se iba al vacío mismo y te quedabas trabado ahí. Le tuvimos que meter un clamp urgente al movimiento porque el jugador se nos escapaba del juego.

## El problema de las animaciones

El problema más grande que tuvimos (y que nos hizo renegar bastante) fue hacer andar las animaciones de muerte (atropellado y arrestado). 

Al principio, cuando chocabas con un auto o un guadia, el juego te tiraba el Game Over tan rápido que la escena se reiniciaba al instante y la animación nunca se veía. Además, teníamos los sprites en loop por defecto en el editor, así que el código se quedaba esperando que la animación termine, pero como loopeaba, el juego se congelaba. 

¿Cómo lo arreglamos? Tuvimos que meterle mano fuerte al script del jugador. Básicamente hicimos que al chocar bloquee todo input, mate al nodo Tween de una (tween.kill()) para que el personaje clave los frenos, y le clavamos un await para que el código obligue al juego a esperar a que termine el sprite de muerte antes de instanciar el cartel de Game Over. Ah, y obvio, le sacamos el loop a mano en el editor.

## Lo que nos quedó pendiente

Por cuestiones de tiempo y para llegar vivos a la entrega, nos quedó pendiente meterle más laburo al arte. La idea original era tener un montón de animaciones distintas, hacer los sprites de las camisetas de todos los países jugables y agregar más variedad visual en general. Al final no llegamos a dibujar y animar todo eso, así que decidimos priorizar que el juego ande bien, que el código sea sólido y que cumpla con la consigna, en lugar de volvernos locos haciendo pixel art a las apuradas.

## Cómo probarlo

1. Clonar este repo.
2. Abrir Godot 4.
3. Importar el project.godot.
4. Mandarle F5 y jugar.
