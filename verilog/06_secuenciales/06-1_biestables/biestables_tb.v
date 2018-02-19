// Diseño:      biestables
// Archivo:     biestables_tb.v
// Descripción: Ejemplos de biestables
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       31/05/2010

/*
   Lección 6-1: Biestables

   Banco de pruebas para biestables.v. En este archivo se describe un banco de
   pruebas que permite comparar el comportamiento de los diversos biestables
   SR descritos, permitiendo observar las diferencias entre los distintos tipos
   de condiciones de disparo.
*/

`timescale 1ns / 1ps

// Banco de pruebas

module test ();

    reg ck = 0;             // reloj
    reg s = 0;              // entrada puesta a 1
    reg r = 0;              // entrada puesta a 0
    wire qa, ql, qms, qff;  // salidas de cada tipo de biestable

    // Instanciación de biestables
    /* Biestable asíncrono */
    sra uut_sra(.s(s), .r(r), .q(qa));
    /* Biestable disparado por nivel alto */
    srl uut_srl(.ck(ck), .s(s), .r(r), .q(ql));
    /* Biestable maestro-esclavo */
    srms uut_srms(.ck(ck), .s(s), .r(r), .q(qms));
    /* Biestable disparado por flanco de bajada */
    srff uut_srff(.ck(ck), .s(s), .r(r), .q(qff));

    // Salidas y control de la simulación
    initial begin
        // Generamos formas de onda para visualización posterior
        $dumpfile("test.vcd");
        $dumpvars(0, test);

        // Generamos salida en formato texto
        $display("      time  ck s r   qa  ql  qms qff");
        $monitor("%d  %b  %b %b   %b   %b   %b   %b",
                   $stime, ck, s, r, qa, ql, qms, qff);

        // Entradas de control
        /* Realizamos cambios en 's' y 'r' para producir distintos
         * cambios de estado. Los retrasos son relativos a la
         * asignación anterior. A la derecha se indica el tiempo
         * absoluto de cada cambio de señal. */
        #8  r = 1;    // t = 8
        #17 r = 0;    // t = 25
        #9  s = 1;    // t = 34
        #2  s = 0;    // t = 36
        #8  r = 1;    // t = 44
        #2  r = 0;    // t = 46
        #6  s = 1;    // t = 52

        // Finalizamos la simulación
        #20 $finish;
    end

    // Señal de reloj periódica
    /* El reloj cambia con un perior de 20ns */
    always
        #10 ck = ~ck;

endmodule // test


/*
   EJERCICIOS

   1. Compila y simula los ejemplos con:

      $ iverilog biestables.v biestables_tb.v
      $ vvp a.out

   2. Visualiza los resultados y compara las salidas de cada tipo de biestable
      con:

      $ gtkwave test.vcd

   3. Modifica el diseño para simular:
      - Un biestable SR asíncrono con entradas activas en nivel bajo.
      - Un biestable SR activo en nivel bajo
      - Un biestable SR maestro-esclavo activo en nivel bajo
      - Un biestable SR activo en flanco de subida

   4. Realice una descripción de biestables JK, D y T activos en flanco de
      bajada y escriba un banco de pruebas adecuado para su comprobación.
*/
