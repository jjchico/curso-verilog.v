// Diseño:      azar
// Archivo:     azar_tb.v
// Descripción: Demostración de azar
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       09/11/2009 (versión original)

/*
   Lección 3-2: Ejemplos combinacionales. Retrasos y azares.

   Este archivo contiene el banco de pruebas para los circuitos diseñado en el
   archivo azar.v.
*/

`timescale 1ns / 1ps

// Retraso aplicado al circuito bajo test
`ifndef DELAY
    `define DELAY 2
`endif
/* `ifndef es similar a `ifdef pero incluye el código en caso de que la macro
 * no haya sido definida. Aquí lo usamos para definir la macro "DELAY" en caso
 * de que no haya sido definida previamente. */
// Tiempo base para facilitar la definición de patrones de test
`define BTIME 16

/* En este ejemplo se usan macros para parametrizar el proceso de simulación.
 * DELAY es el retraso de las puertas que forman el circuito que estamos
 * probando. BTIME es el tiempo que permanecerán constantes las entradas
 * de prueba. BTIME se define en función de DELAY para que siempre tenga un
 * valor suficientemete grande para que permita la propagación de las señales
 * a través de todos los elementos del circuito. De esta forma, pueden
 * realizarse simulaciones para varios valores del retraso sin más que cambiar
 * el valor de la macro DELAY. Se ha usado "`ifndef" para hacer que prevalezca
 * un posible valor de DELAY definido previamente. */

module test ();

    // Entradas
    reg a;
    reg b;

    // Salidas
    wire f1, f2;

    // Variable auxiliar para simulación
    /* "n" se empleará como contador para contar el número de veces que
     * hacemos cambiar la señal "a". Lo usaremos como ayuda en la generación
     * de los patrones de test más abajo. Lo iniciamos a cero. El tipo
     * "integer" es equivalente a un "reg" de 32 bits. Este tipo es útil
     * para representar números enteros (de ahí su nombre) o variables
     * enteras,  como en nuestro caso. Similar al "int" del lenguaje C. */
    integer n = 0;
    /* Definición alternativa de "n" */
    /* reg [31:0] n = 0; */

    // Instancia de la unidad bajo test (UUT)
    /* Como en unidades anteriores, instanciamos (colocamos) el circuito a
     * probar definido en azar.v. La construcción "#(...)" permite redefinir
     * el valor de los parámetros definidos en el módulo "azar". Los
     * parámetros se redefinen en el mismo orden en que fueron declarados
     * en el código del módulo. Aquí lo empleamos para redefinir el retraso
     * al valor deseado contenido en la macro DELAY. */
    hazard_f uut1 (.a(a), .b(b), .f(f1));
    hazard_e #(`DELAY) uut2 (.a(a), .b(b), .f(f2));

    /* El siguiente proceso "initial" inicia los patrones de test e incluye
     * las directivas de simulación */
    initial begin
        // Iniciamos las entradas
        a = 0;
        b = 0;

        // Genera formas de onda
        $dumpfile("azar_tb.vcd");
        $dumpvars(0,test);

        // Finalizamos la simulación
        /* Fijamos el final de la simulación en función de BTIME. El
         * valor 7*`BTIME es suficiente para que las entradas recorran
         * todos los posibles casos */
        #(7*`BTIME) $finish;
    end

    /* Los procesos always siguientes hacen que tanto "a" como "b" cambien
     * de 0 a 1 y de 1 a 0 cuando la otra variable tiene todos los posibles
     * valores. De esta forma es posible detectar cualquier azar que pueda
     * producirse. */
    // "a" cambia entre 0 y 1. Con "n" contamos el número de cambios.
    always
    begin
        #(`BTIME) a = ~a;
        n = n + 1;
    end
    // "b" cambia tras un cambio de "a" con un retraso BTIME/2, salvo
    // cuando "a" ha cambiado 3 veces. Así se recorren todos los casos de
    // entrada.
    always @(a)
        if (n != 3)
            #(`BTIME/2) b = ~b;

endmodule // test

/*
   EJERCICIO

   1. Compila la lección con:

      $ iverilog azar_tb.v azar.v

   2. Simula el diseño con:

      $ vvp a.out

   3. Observa la formas de onda resultado de la simulación con:

      $ gtkwave azar_tb.vcd &

      Analiza las formas de onda y localiza el posible azar.

   4. Compila el diseño indicando un valor diferente para el retraso. Por
      ejemplo:

      $ iverilog -DDELAY=1 azar_tb.v azar.v

      Simula y observa las formas de onda con diferentes valores del retraso.
      ¿Qué ocurre si se realiza la simulación con retraso 0? ¿Por qué?

   5. Incluya un proceso "always" en el banco de pruebas que detecte la
      aparición de un azar durante la simulación, mostrando un mensaje y el
      instante de tiempo en que se ha detectado el azar. Ejemplo:

        "Azar en t=... para a=..., b=..., f=..."

      Pista: active el proceso "always" cada vez que cambie el valor de f2 y
      compruebe si el valor que toma es el definitivo, esto es, igual al de
      f1, o es un valor transitorio (azar).
*/
