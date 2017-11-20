// Diseño:      block
// Archivo:     block_tb.v
// Descripción: Asignación con y sin bloqueo
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       05/06/2010

/*
   Lección 6-3: Asignaciones con bloqueo y sin bloqueo.

   Banco de pruebas para módulos en block.v. En este diseño se instancian los
   módulos swap1 y swap2 para comparar su operación. El módulo swap2 emplea
   asignaciones no bloqueantes y debe dar el resultado esperado, al contrario
   que el módulo swap1 que emplea asignaciones bloqueantes para asignar
   elementos secuenciales.
*/

`timescale 1ns / 1ps

// Banco de pruebas

module test();

    reg ck = 0;     // reloj
    reg load = 0;   // entrada de carga
    reg d = 0;      // entrada de dato
    wire y1, y2;    // salidas swap1
    wire z1, z2;    // salidas swap2

    swap1 uut_s1(.ck(ck), .load(load), .d(d), .q1(y1), .q2(y2));
    swap2 uut_s2(.ck(ck), .load(load), .d(d), .q1(z1), .q2(z2));

    // Señal de reloj
    /* En el modo de conmutación los biestables de cada módulo deben
     * conmutar su estado con cada flanco activo del reloj */
    always
        #10 ck = ~ck;

     // Salidas y control de la simulación
    initial    begin
        // Generamos formas de onda para visualización posterior
        $dumpfile("block_tb.vcd");
        $dumpvars(0, test);

        // Entradas
        #0
            /* Iniciamos ambos biestables de cada módulo a cero
             * haciendo d=0 y activando la señal de carga (load)
             * durante dos ciclos de reloj */
            load = 1;
            d = 0;
        #40
            /* Cargamos '1' en el primer biestable */
            d = 1;
        #20
            /* Pasamos a mode de conmutación con un biestable a
             * '0' y otro a '1' */
            load = 0;

        // Finalizamos la simulación
        #120 $finish;
    end
endmodule // test


/*
   EJERCICIOS

   1. Compila y simula los ejemplos con:

      $ iverilog block.v
      $ vpp a.out

   2. Visualiza los resultados y compara las salidas de cada conmutador con:

      $ gtkwave block_tb.vcd

   3. Explica por qué motivo las salidas del primer conmutador (y1, y2) son
      diferentes a las del segundo (z1, z2).
*/
