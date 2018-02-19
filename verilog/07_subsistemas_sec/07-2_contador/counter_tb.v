// Diseño:      Registro universal
// Archivo:     register_tb.v
// Descripción: Registro universal
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       11/06/2010

/*
   Lección 7-2: Contador reversible.

   Este archivo contiene un banco de pruebas para el contador diseñado en
   counter.v.

   En este archivo se introduce el uso de la directiva "repeat" y el control
   temporal (@) para el control de señales en bancos de pruebas.
*/

`timescale 1ns / 1ps

// Banco de pruebas

module test ();

    reg ck = 0;     // reloj
    reg cl = 0;     // puesta a cero
    reg en = 0;     // habilitación
    reg ud = 0;     // cuenta hacia arriba (0) o abajo (1)
    wire [3:0] q;   // estado de cuenta
    wire c;         // señal de fin de cuenta

    counter #(4) uut(.ck(ck), .cl(cl), .en(en), .ud(ud), .q(q), .c(c));

    // Salidas y control de la simulación
    initial    begin
        // Generamos formas de onda para visualización posterior
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, test);

        /* En esta ocasión no generamos salidas en formato texto */
    end

    // Señal de reloj periódica
    /* El reloj cambia con un perior de 20ns */
    always
        #10 ck = ~ck;

    // Entradas
    initial begin
        @(negedge ck)
        cl = 1;                // puesta a cero
        @(negedge ck)
        cl = 0;                // contamos hacia arriba
        en = 1;                // durante 20 ciclos
        repeat(20) @(negedge ck);
        ud = 1;                // contamos hacia abajo 8 ciclos
        repeat(8) @(negedge ck);
        en = 0;                // puesta a cero
        cl = 1;
        @(negedge ck);
        cl = 0;
        repeat(2) @(negedge ck);
        $finish;
    end

endmodule // test


/*
   EJERCICIOS

   1. Compila y simula los ejemplos con:

      $ iverilog counter.v counter_tb.v
      $ vvp a.out

   2. Visualiza los resultados y comprueba la salida con:

      $ gtkwave counter_tb.vcd

   3. Modifica el diseño para incorporar una señal 'load' que carge un estado
      de cuenta de una entrada 'x'. La operación de carga debe terner más
      prioridad que las operaciones de cuenta pero menos que la puesta a cero.

   4. Modifique el diseño original para obtener un contador módulo 10 (de 0 a 9).
      Debes poner cuidado con las señales de fin de cuenta.
*/
