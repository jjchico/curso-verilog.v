// Diseño:      descripciones
// Archivo:     descripciones.v
// Descripción: Tipos de descripciones en Verilog
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       05-11-2009 (versión original)

/*
   Lección 3: Tipos de descripciones en Verilog

   En esta lección veremos las tres formas de describir un circuito en Verilog.
   Estas son:

   - Descripción funcional: el comportamiento del circuito se describe
     mediante expresiones lógicas, tal como vimos en la lección 2.

   - Descripción procedimiental: se emplea un procedimiento con estructuras de
     control (if-else, while, case, etc.) de forma similar a los lenguajes de
     programación.

   - Descripción estructural: consiste en especificar la interconexión de
     componentes previamente diseñados (módulos) o de primitivas lógicas (AND,
     OR, NOT, etc.).

   De todas ellas, la descripción procedimental es la de más alto nivel y la
   que permite describir circuitos más facilmente. La funcional es equivalente
   al empleo de expresiones lógicas y se emplea en asignaciones permanetes
   (assign) y en procedimientos en combinación con una descripción
   procedimental. La descripción estructural es la más cercana a una
   implementación real del circuito. Se suele emplear para definir la forma
   de interconexión de grandes módulos del sistema, empleando para cada módulo
   una forma de descripción más adecuada.

   En esta lección realizaremos tres versiones de la función
     f = a & ~b | ~a & b
   empleando los tres tipos de descripciones.
*/

/* Como en la lección anterior, fijamos la escala de tiempos */
`timescale 1ns / 1ps

/* Empleamos un único módulo sin conexiones externas ya que tanto la
 * funcionalidad del circuito como las señales empleadas para su simulación
 * se generan en su interior. */
module descripciones ();

    /* Usaremos a y b como variables de la función a implementar. Las
     * iniciamos a cero y las haremos variar durante la simulación. */
    reg a = 0, b = 0;

    // Descripción funcional
    /* f_func es el resultado de la implementación funcional. Se realiza
     * una asignación continua como en el "assign" de la lección anterior,
     * salvo que aquí la asignación se hace durante la misma declaración y
     * el "assign" queda implícito. */
    wire f_func = a & ~b | ~a & b;

    /* f_proc corresponde a la implementación procedimental de la función.
     * Las señales empleadas en los procedimientos son de tipo "reg" ya que
     * no tienen por qué ser asignadas de forma contínua. */
    reg f_proc;

    // Descripción procedimental
    /* Una descripción procedimental se produce siempre en un bloque
     * "always".  El bloque se evalúa sólo cuando hay un cambio en alguna
     * de las señales indicadas en su lista de sensibilidad. Las señales en
     * la lista de sensibilidad se listan separadas por 'or' o ','. En
     * nuestro caso, la función se evalúa ante un cambio en cualquiera de
     * las entradas, como es propio de un circuito combinacional. */
    always @(a, b)
    /* Cuando un bloque o directiva contiene más de una expresión o
     * sentencia, éstas se agrupan con begin-end. en este caso no es
     * necesario porque el bloque "always" sólo contiene una sentencia
     * "if-else" pero se incluye por claridad */
    begin
        /* Una sentencia "if-else" permite hacer asignaciones
         * condicionales.  en la condición se emplean operadores
         * relacionales, por ejemplo:
         *  == - igual
         *  != - no igual
         *  && - ambos ciertos
         *  || - cualquiera cierto */
        if (a == 0)
            f_proc = b;
        /* En la descripción de circuitos combinacionales deben
         * contemplarse todos los posibles valores de las señales. De
         * no ser así, las señales no asignadas conservan su valor
         * anterior y se convierten en elementos de memoria, que no son
         * combinacionales. */
        else
            f_proc = ~b;
    end

    // Descripción estructural
    /* La descripción estructural consiste en especificar una lista de
     * elementos de circuito y cómo van conectados. Estos elementos son
     * módulos definidos por el usuario o primitivas lógicas
     * correspondientes a puertas lógicas y otros elementos básicos: and,
     * or, xor, nand, nor, xnor, not, buf, etc. Para nuestro diseño
     * (f=ab'+a'b) usaremos sólo algunas primitivas lógicas (not, and y or)
     */

    // Salida de la descripción estructural.
    /* Las salidas de los módulos o primitivas deben ser de tipo "wire" */
    wire f_est;
    // Señales para la interconexión de los elementos.
    wire not_a, not_b, and1_out, and2_out;

    /* Al "instanciar" una primitiva lógica o un módulo se debe indicar:
     * tipo de módulo o primitiva, retraso (opcional), nombre de la
     * instancia, lista de señales. Las señales se conectan a cada puerto
     * del módulo o primitiva en el orden en el que se definieron en el
     * mismo. En las primitivas, el primer puerto es siempre la salida. En
     * nuestro ejemplo incluimos retrasos para obtener una simulación más
     * realista. */
    not not1 (not_a, a);
    not not2 (not_b, b);
    and and1 (and1_out, a, not_b);
    and and2 (and2_out, not_a, b);
    or  or1  (f_est, and1_out, and2_out);

    /* El resto del módulo sirve para generar las señales de test y
     * controlar la simulación */

    // Generamos señales periódicas en las entradas a y b
    always
        #10 a = ~a;
    always
        #20 b = ~b;

    // Iniciación y control de la simulación
    initial
    begin
        // Generamos formas de onda de todas las señales
        $dumpfile("descripciones.vcd");
        $dumpvars(0, descripciones);

        // Mostramos los cambios de cada señal de entrada o salida
        // Los argumentos de "$timeformat" son:
        //   -9: usamos 10^(-9) como unidades (nanosegundos)
        //    0: número de cifras decimales (ninguna)
        //   ns: sufino a incluir detrás del número
        //    5: número máximo de cifras a imprimir
        $timeformat(-9, 0, "ns", 5);
        $display("t\ta\tb\tf_func\tf_proc\tf_est");
        $monitor("%t\t%b\t%b\t%b\t%b\t%b", $stime, a, b, f_func, f_proc, f_est);

        // Finalizamos la simulación a los 100ns
        #100 $finish;
    end

    /* Concurrencia: es importante comprender que en un lenguaje de
     * descripción de hardware como Verilog, cada procedimiento (always o
     * initial), asignación continua (assign) o instancia de módulo o
     * primitiva opera de forma concurrente con todas las demás
     * construcciones. Esto significa que podemos alterar el orden en que
     * hemos definido cada uno de estos elementos en nuestro archivo
     * Verilog sin que cambie la operación del circuito modelado. Esta
     * naturaleza concurrente de los LDH viene dada por los elemenos que
     * represeantan: elementos de circuitos que operan de forma
     * independiente y concurrente con el resto de elementos. Los únicos
     * elementos que se evalúan de forma secuencial (como en el software)
     * son los que se encuentran dentro de procedimientos (always o
     * initial). */

endmodule // descripciones

/*
   EJERCICIO

   1. Compila el diseño con:

     $ iverilog descripciones.v

   2. Ejecuta la simulación con:

     $ vvp a.out

      Observa los resultados generados con $monitor para las tres
      descripciones.

   3. Visualiza las ondas generadas mediante $dumpvars con gtkwave (el "&"
      final en el comando es para dejar libre el terminal):

     $ gtkwave descripciones.vcd &

      Comprueba la correcta operación de las tres implementaciones.
*/
