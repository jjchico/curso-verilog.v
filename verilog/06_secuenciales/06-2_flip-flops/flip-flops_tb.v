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

    reg ck = 0;     // reloj
    reg j = 0;      // entrada puesta a 1
    reg k = 0;      // entrada puesta a 0
    reg d = 0;
    wire s;
    wire r;
    wire t;
    reg cl = 1;
    reg pr = 1;
    wire qsr, qjk, qd, qt;    // salidas de cada tipo de biestable

    // Instanciación de biestables
    srff uut_srff(ck, s, r, cl, pr, qsr);
    jkff uut_jkff(ck, j, k, cl, pr, qjk);
    dff uut_dff(ck, d, cl, pr, qd);
    tff uut_tff(ck, t, cl, pr, qt);

    // Algunas entradas son compartidas
    assign s = j;
    assign r = k;
    assign t = d;

    // Control de la simulación
    initial begin
        // Generamos formas de onda para visualización posterior
        $dumpfile("flip-flops_tb.vcd");
        $dumpvars(0, test);

        #180 $finish;
    end

    // Clear y preset
    initial fork
        #5    cl = 0;
        #20   cl = 1;
        #140  pr = 0;
        #160  pr = 1;
    join

    // Entradas JK y SR
    initial fork
        #20    j = 1;
        #40    j = 0;
        #60    k = 1;
        #80    k = 0;
        #100   j = 1;
        #100   k = 1;
        #160   j = 0;
        #160   k = 0;
    join

    // Entradas D y T
    initial fork
        #20    d = 1;
        #40    d = 0;
        #80    d = 1;
        #140   d = 0;
    join

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

      $ gtkwave flip-flops_tb.vcd

   3. Modifica el diseño para simular:
      - Un biestable SR asíncrono con entradas activas en nivel bajo.
      - Un biestable SR activo en nivel bajo
      - Un biestable SR maestro-esclavo activo en nivel bajo
      - Un biestable SR activo en flanco de subida

   4. Realice una descripción de biestables JK, D y T activos en flanco de
      bajada y escriba un banco de pruebas adecuado para su comprobación.
*/
