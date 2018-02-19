// Diseño:      alarma
// Archivo:     alarma_tb.v
// Descripción: Alarma sencilla para un automovil
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       09/11/2009

/*
   Lección 3-3: Ejemplos combinacionales. Alarma de automovil.

   Este archivo contiene un banco de pruebas para el módulo alarma.
*/

`timescale 1ns / 1ps

// Tiempo base para facilitar la definición de patrones de test
`define BTIME 10

module test ();

    // Entradas
    /* Para facilitar la generación de entradas usaremos una señal múltiple
     * (un vector) de 6 bits en vez de seis señales independientes. El
     * rango puede indicarse con "[0:5]" o bien con "[5:0]". Esto determina
     * si el bit de más a la derecha corresponde al primer índice (formato
     * little endian) o al último índice (formato big endian). En este
     * ejemplo usamos el formato little endian, que es el habitual para
     * referirse a números. */
    reg [5:0] x;

    // Salidas
    wire a;

    // Instancia de la unidad bajo test (UUT)
    /* Nótese el uso del vector "x" y como se referencia a cada uno de sus
     * bits. Las conexiones de la instancia se realizan de forma implícita
     * por lo que las señales se conectan en el orden en que fueron
     * definidas en el módulo, esto es, (c, p1, p2, t, m, f, a). */
    alarma uut (x[5], x[4], x[3], x[2], x[1], x[0], a);

    /* El siguiente proceso "initial" inicia los patrones de test e incluye
     * las directivas de simulación */
    initial begin
        // Iniciamos las entradas
        x = 6'b000000;
        /* Iniciamos x a cero de la forma correcta al tratarse de un
         * vector. El formato completo para expresar números en Verilog
         * es:
         *   <número de bits>'<base><valor>
         * donde <base> puede ser, entre otros:
         *   b: binario
         *   o: octal
         *   h: hexadecimal
         *   d: decimal
         * Si se omite <base> se considera decimal y si se omite el
         * número de bits se consideran al menos 32.
         * Alternativamente, x puede iniciarse como:
         *   x = 6'h00        // hexadecimal
         *   x = 'b000000    // binario, se omite el número de bits
         *   x = 0        // se omite la base y el número de
         *            // bits. Se asume el valor cero decimal
         *            // y el número suficiente de bits para
         *            // asignar x a cero.
         */

        // Genera formas de onda
        $dumpfile("alarma_tb.vcd");
        $dumpvars(0,test);

        // Finalizamos la simulación
        /* Fijamos el final de la simulación en función de BTIME. El
         * valor 64*`BTIME es suficiente para que las entradas recorran
         * todos los posibles casos */
        #(64*`BTIME) $finish;
    end

    // Generamos patrones de entrada
    /* Para conseguir que las entradas recorran todos los posibles valores
     * basta con incrementar x */
    always
        #(`BTIME) x = x + 1;

endmodule // test

/*
   EJERCICIIO

   1. Compila la lección con:

      $ iverilog alarma.v alarma_tb.v

   2. Simula el diseño con:

      $ vvp a.out

   3. Observa la formas de onda resultado de la simulación con:

      $ gtkwave alarma_tb.vcd &

      Para interpretar mejor el resultado, selecciona las señales del módulo
      "uut" (unidad bajo test) en el orden: c, p1, p2, t, m, f, a. Comprueba
      que la salida "a" tiene un valor correcto que corresponda con el
      enunciado del problema.

   4. Revisa el enunciado del problema y observa que la primera y la segunda
      condición pueden simplificarse en una única condición más simple.
      Propón un enunciado simplificado diseña una versión alternativa del
      módulo alarma basada en ese enunciado. Puedes hacerlo en un archivo
      "alarma2.v".

   5. Simula la versión alternativa con el mismo banco de pruebas y compara
      el resultado con el del módulo original. Puedes hacerlo, por ejemplo,
      renombrando el archivo test.vcd original y cargando ambos archivo en
      gtkwave.
*/
