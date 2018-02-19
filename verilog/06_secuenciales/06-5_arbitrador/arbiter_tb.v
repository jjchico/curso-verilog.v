// Diseño:      arbitrador
// Archivo:     arbiter_tb.v
// Descripción: Arbitrador. Ejemplo de máquina de estados
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       04/06/2010

/*
   Lección 6-5: Máquinas de estados finitos. Arbitrador

   Banco de pruebas para módulos en arbiter.v.
*/

`timescale 1ns / 1ps

// Banco de pruebas

module test ();

    reg ck = 0; // reloj
    reg r1 = 0; // petición 1
    reg r2 = 0; // petición 2
    wire g1;    // concesión 1
    wire g2;    // concesión 2

    arbiter1 uut(ck, r1, r2, g1, g2);

    // Generación de ondas y control de fin de simulación
    initial begin
        $dumpfile("arbiter_tb.vcd");
        $dumpvars(0, test);

        #180 $finish;
    end

    // Señal de reloj
    always
        #10 ck = ~ck;

    // Peticiones del dispositivo 1
    /* Las señales de petición de cada dispositivo se generan por
     * separado. En este caso se han empleado bloque "fork-join" en vez
     * de "begin-end". En los bloques "fork-join", cada elemento se
     * ejecuta de forma concurrente de forma parecida a lo que ocurriría
     * usando asignaciones no bloqueantes. Esto permite, en este caso, usar
     * tiempos absolutos en las asignaciones. Los bloque "fork-join" no
     * son sintetizables en general, por lo que su utilidad se limita
     * a la realización de bancos de prueba como este. */
    initial fork
        #20    r1 = 1;
        #40    r1 = 0;
        #100    r1 = 1;
        #120    r1 = 0;
    join

    // Peticiones de dispositivo 2
    initial fork
        #60    r2 = 1;
        #80    r2 = 0;
        #100    r2 = 1;
        #140    r2 = 0;
    join
endmodule

/*
   EJERCICIOS

   1. Simula el diseño y comprueba su operación. Para ello visualiza las
      entradas y salidas del módulo y su estado interno ('state').

   2. Detecta el error en el cálculo de la salida del módulo 'arbiter1',
      corrígelo y vuelve a simular el diseño para comprobar.

   3. Sustituya en el banco de pruebas el módulo 'arbiter1' por 'arbiter2',
      simúlalo y observa el resultado. ¿Es correcto?

   4. Compare los resultados de los módulos 'arbiter1' y 'arbiter2':

      a) ¿Son idénticos?

      b) ¿Son equivalentes?

      c) Reflexiona sobre que implementación te parece más adecuada para
         este diseño, Mealy (arbiter1) o Moore (arbiter2).
*/
