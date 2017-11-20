// Diseño:      funcion
// Archivo:     funcion.v
// Descripción: Funciones combinacionales y simulación
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       05-11-2009

/*
   Lección 2: Funciones combinacionales y simulación

   En esta lección veremos cómo describir un circuito combinacional que realiza
   una determinada función lógica, cómo simular su comportamiento y cómo ver
   los resultados de la simulación. A la vez se introducen algunos conceptos
   fundamentales sobre tipos de señales, expresiones, operadores y retrasos.
*/

/* En Verilog no hay una unidad prefijada para el tiempo. Con `timescale
 * definimos una unidad dada para el tiempo (1ns en este caso) y una precisión
 * en su representación (1ps en este caso). De esta forma será más fácil
 * interpretar los resultados. `timescale es una directiva del simulador, lo
 * cual se indica porque comienza por un apóstrofe invertido. */
`timescale 1ns / 1ps

/* Nuestro primer diseño tiene un único módulo y no tienes puertos (conexiones
 * con el exterior). Todas las señales se definen internamente.
 * En el módulo se modela la función lógica f = ab' + a'b, esto es, la
 * operación OR exclusiva. */
module funcion ();

    /* A continuación definimos las señales que vamos a emplear. Las señales
     * son equivalentes a las variables en los lenguajes de programación,
     * pero aquí representan conexiones eléctricas y elementos de
     * circuito. */

    /* a y b son señales de tipo 'variable' y se declaran con 'reg'. Se
     * inician al valor cero. Este tipo de señales se comportan de forma
     * muy pareceida a las variables: pueden tomar un valor ahora y más
     * tarde podemos asignar otro valor. Las usaremos como las variables o
     * entradas de nuestra función. */
    reg a = 0, b = 0;

    /* f es una señal de tipo 'red de conexión' (wire). A este tipo de
     * señales sólo se les puede asignar una vez mediante una expresión. La
     * usaremos para definir nuestra función. */
    wire f;

    /* Aquí construimos la función. Simplemente asignamos la expresión
     * deseada con operadores lógicos. Las señales de tipo wire se asignan
     * con una construcción "assign" que indica una asignación continua
     * (permanente).  En Verilog algunos operadores lógicos son:
     *   & - AND
     *   | - OR
     *   ~ - NOT (complemento)
     *   ^ - OR exclusivo (no usado aquí) */
    assign f = a & ~b | ~a & b;

    /* El resto del código tiene como objeto poder comprobar nuestro
     * circuito, esto es, dar valores a "a" y "b" y comprobar que se calcula
     * el valor adecuado en f. Para asignar "a" y "b" usamos construcciones
     * "always" que sirven para definir procedimientos. Veremos más sobre
     * esto en la próxima lección. */

    /* En este procedimiento se asigna a "a" su valor complementado, esto
     * es, se conmuta su valor. La asignación se realiza con un retraso de
     * 10ns.  Como los procedimientos "always" se repiten indefinidamente,
     * "a" cambiará de valor cada 10ns produciendo una señal
     * periódica de 20ns de perido. */
    always
        #10 a = ~a;

    /* Con "b" hacemos lo mismo, pero con un periodo doble, de forma que se
     * generen todas las posibles combinaciones de valores de "a" y "b". */
    always
        #20 b = ~b;

    /* Los procedimientos "initial" son similares a los "always" pero sólo
     * se ejecutan una vez al iniciarse la simulación. Son ideales para
     * definir acciones que controlen el estado inicial del circuito y el
     * propio proceso de simulación. */
    initial begin
        /* $monitor es una función del sistema, como $display, y actúa
         * de forma parecida: muestra una cadena de texto cada vez que
         * hay un cambio en alguna de las variables indicadas. En la
         * cadena de texto, "%b" se sustituye por el valor de la próxima
         * variable en formato binario. */
        $monitor("a=%b, b=%b, f=%b", a, b, f);

        /* $dumpvars es otra función del sistema que indica al
         * simulador que debe generar un archivo de formas de onda para
         * su visualización posterior. El "0" significa que queremos
         * incluir todas las señales del módulo indicado "funcion".
         * $dumpfile define el nombre del archivo en el que
         * queremos guardar las ondas. */
        $dumpfile("funcion.vcd"); $dumpvars(0, funcion);

        /* $finish es otra función del sistema que hace que se detenga
         * el proceso de simulación. Esto ocurre 100 unidades de tiempo
         * después de haber comenzado (100ns). De esta forma evitamos
         * que el simulador siga funcionando indefinidamente. */
        #100 $finish;
    end

endmodule    // funcion

/*
   EJERCICIO

   1. Compila el diseño con:

    $ iverilog funcion.v

   2. Ejecuta la simulación con:

    $ vvp a.out

   Observa los resultados generados con $monitor donde se puede ofservar el
   valor de f para cada valor de a y b. Es posible que el valor correcto de f
   no aparezca justo en el momento en que cambian a o b ya que el simulador
   puede considerar que el cambio en f ocurre con un cierto retraso.

   3. Visualiza las ondas generadas mediante $dumpvars con gtkwave (el "&"
      final en el comando es para dejar libre el terminal):

    $ gtkwave funcion.vcd &

   Observa que los periodos de "a" y "b" son correctos así como el valor de "f"
   generado.

   4. Para obtener un resultado más realista incluye un retraso de 5ns en la
      asignación de "f":

    assign #5 f = a & ~b | ~a & b;

   Cambia también la llamada a $monitor para que incluya el tiempo de
   simulación en que se produce cada cambio (la función del sistema $time
   devuelve el tiempo actual de simulación):

    $monitor("t=%t, a=%b, b=%b, f=%b", $time, a, b, f);

   Repite los puntos 1 a 3 y observa las diferencias.

   (Consejo: en vez de borrar el código anterior, déjalo comentado para poder
   volver a él rápidamente)

   5. Implementa y simula las siguientes funciones en Verilog incluyendo
      retraso:
    a) f(a, b) = ab + a'b'
    b) f(a, b, c) = (a+b+c')(a+b'+c)(a'+b+c)
*/
