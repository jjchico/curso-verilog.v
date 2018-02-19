// Diseño:      Detector de secuencia
// Archivo:     secuencia_tb.v
// Descripción: Detector de secuencia con solapamiento.
//              Versiones Mealy y Moore.
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       09/06/2010

/*
   Lección 6-4: Máquinas de estados finitos. Detector de secuencia.

   Banco de pruebas para módulos en secuencia.v. El banco de pruebas
   proporciona una secuencia idéntica a las implementaciones Mealy y Moore
   del detector de secuencia con objeto de poder comparar la salida generada
   por cada tipo de máquina.
*/

`timescale 1ns / 1ps

// Banco de pruebas

module test ();

    reg ck = 0;     // reloj
    reg reset = 0;  // reset
    reg x = 0;      // entrada
    wire z_mealy;   // salida Mealy
    wire z_moore;   // salida Moore

    /* El vector 'in' contiene una secuencia de 32 bits que se suministrará
     * a la entrada. 'n' es el número de bits de la secuencia que se
     * aplicarán e 'i' actúa como índice. */
    reg [0:31] in = 32'b00100111_00001110_10010010_01010011;
    integer n = 32;
    integer i = 0;

    // Instanciación de módulos
    seq_mealy uut_mealy (ck, reset, x, z_mealy);
    seq_moore uut_moore (ck, reset, x, z_moore);

    // Generación de ondas
    initial begin
        $dumpfile("secuencia_tb.vcd");
        $dumpvars(0, test);
    end

    // Generador de reloj y secuencia de entrada
    always begin
        #10
        /* Con el flanco no activo del reloj se actualiza la
         * entrada, tomada del vector 'in' */
        ck = 0;
        x = in[i];

        #10
        /* Tras el flanco activo se actualiza el índice 'i' y
         * se comprueba si se ha llegado al final de la
         * secuencia. */
        ck = 1;
        i = i + 1;
        if (i == n)
            $finish;
    end

    // Reset
    /* Un proceso independite controla la señal 'reset'. Se realiza una
     * iniciación al principio de la simulación y otra durante la
     * operación del sistema. */
    initial begin
        #5   reset = 1;
        #15  reset = 0;
        #450 reset = 1;
        #20  reset = 0;
    end
endmodule

/*
   EJERCICIOS

   1. Simula el diseño con:

      $ iverilog secuencia.v secuencia_tb.v

      y visualiza los resultados con:

      $ gtkwave secuencia_tb.vcd

      Represente las señales de entrada y salida y los estados internos de
      las máquinas de Mealy y Moore.

   2. Responde y reflexiona sobre las siguientes cuestiones:

      a) ¿Son idénticas las salidas de la máquina de Mealy y Moore?
      b) ¿Es correcta la operación de la máquina de Mealy?
      c) ¿Es correcta la operación de la máquina de Moore?
      d) Explica las diferencias que se aprecian en las salidas de ambas
         máquinas.

   3. Cambia la secuencia de entrada en 'in' y comprueba la operación de
      ambas máquinas con la nueva secuencia.

   4. ¿Qué pasaría si se borra (se comenta) el bloque que controla la señal
      'reset'? Deduce el resultado y luego simúlalo para comprobarlo. ¿Has
      acertado?
*/
