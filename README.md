# Proyecto1-IA-Alfa-Beta
Juego 4 en línea con IA (Alfa-Beta)

## Descripción del sistema

El presente proyecto se desarrolla con el fin de poner en práctica conceptos e ideas de la Inteligencia Artificial. Usando para ello el algoritmo minimax junto a su agregado: la poda Alfa-Beta ("Poda alfa-beta", 2020). Alfa-Beta es un método o técnica usada en este tipo de algoritmo con la cual se busca reducir el número de nodos (pertenecientes al árbol creado por el algoritmo minimax) que se deben de evaluar. Se hace así, debido a que la evaluación, conocida como evaluación estática que se aplica en estos algoritmos, generalmente es un proceso que requiere de gran poder computacional.
Esta evaluación estática se crea con el fin de darle un peso a los nodos del árbol, de esta manera se puede aplicar el algoritmo alfa-beta. Es importante considerar que esta evaluación se realiza mediante heurísticas, ya que realmente no existe algo que nos diga exactamente cuánto es el valor de un nodo X del árbol. Por lo que hay que poner especial atención en esta evaluación, ya que es la que dictará cuán bueno es un nodo X en comparación a otros, y una mala heurística ("Significado de Heurística", 2017), nos podría
llevar a procesos o elecciones de decisiones deficientes. Por lo que para poner en práctica estos conceptos se desarrollará un agente inteligente capaz de jugar al juego conocido como “4 en Línea” de forma satisfactoria contra un humano. Para esto hay que saber cómo es el juego: Básicamente el mismo consiste en que hay 2 jugadores y una “rejilla o matriz” en la cual los jugadores pueden “insertar” fichas (Se identifica al jugador dueño de la ficha mediante un color u otro método de identificación; para este proyecto se decidió que un número 2 sea la IA y el 1 un jugador) y que usualmente es de 6 filas y 7 columnas. Los jugadores deberán de elegir cuál de los 2 empieza a colocar piezas de primero. Así, tendrán que ir insertando fichas por la parte superior de la rejilla, la cual caerá hasta encontrar el siguiente lugar vacío en la columna seleccionada. Claramente no se trata de
colocar solamente fichas al azar, los jugadores tratarán de ir formando líneas de 4 fichas seguidas de su mismo color(número), ya que esto supondría un gane; a la vez que intentan reducir al máximo las oportunidades de su oponente de ganar.

## Conclusiones
Se logra observar basado en los experimentos, que las hipótesis planteadas si se cumplen. Y además de que minmax y su función EVAL sí logran un comportamiento inteligente a la hora de tomar decisiones.
Este proyecto fué bastante interesante y productivo para nosotros, nos ayudó a entender mucho acerca de los agentes, de cómo estos se desarrollan y funcionan y también aprender acerca de la programación funcional.
Minmax con poda es un algoritmo excelente que tiene muchas aplicaciones en el mundo de los videojuegos. Aunque no se mostró una interfaz gráfica agradable para el disfrute del juego, este puede ser ejecutado y ser funcional.

