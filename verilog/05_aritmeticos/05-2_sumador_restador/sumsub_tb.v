// Diseño:      Sumador-restador en Ca2
// Archivo:     sumsub_tb.v
// Descripción: Banco de pruebas para sumador-restador en complemento a 2
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       27/05/2010

/*
    Lección 5-2: Sumador-restador

    Este archivo contiene un banco de prueba para los módulos 'sumsub1' y
    'sumsub2'.
*/

`timescale 1ns / 1ps

// Banco de pruebas para sumador-restador. Este banco de pruebas aplica un
// número configurable de entradas aleatorias.

// Macros para parametrizar la simulación. Valores por defecto.
//   NP: número de patrones de simulación
//   SEED: semilla inicial para generación número aleatorios
//   OP: tipo de operación (OP=0 -> suma, OP=1 -> resta)

`ifndef NP
    `define NP 20
`endif
`ifndef SEED
    `define SEED 1
`endif
`ifndef OP
    `define OP 0
`endif

module test ();

    reg signed [7:0] a;    // entrada 'a'
    reg signed [7:0] b;    // entrada 'b'
    reg op = `OP;          // tipo de operación (0-suma, 1-resta)
    wire signed [7:0] f;   // salida
    wire ov;               // desbordamiento
    integer np;            // variable auxiliar (número de patrones)
    integer seed = `SEED;  // variable auxiliar (semilla)

    // Circuito bajo test
    /* Los módulos 'sumsub1' y 'sumsub2' son de anchura parametrizable.
     * Aquí se instancia una unidad de 8 bits. Sustituir 'sumsub1' por
     * 'sumsub2' para simular la implementación alternativa */
    sumsub1 #(.WIDTH(8)) uut(.a(a), .b(b), .op(op), .f(f), .ov(ov));

    initial begin
        /* 'np' se empleará como contador del número de patrones de
         * test a aplicar. Su valor inicial se carga de la macro 'NP' */
        np = `NP;

        // Generamos formas de onda para visualización posterior
        $dumpfile("test.vcd");
        $dumpvars(0, test);

        // Imprime cabeceras y monitoriza señales
        if (op == 0)
            $display("Operacion: SUMA");
        else
            $display("Operacion: RESTA");
        $display("   A    B     f  ov");
        $monitor("%d %d  %d  %b",
                   a, b, f, ov);
    end

    // Proceso de generación de entradas al circuito bajo test
    /* Cada 20ns 'a', 'b' y 'cin' se asignan con valores aleatorios.
     * La simulación finaliza después de aplicar un número de patrones
     * igual a 'np'. Puede cambiarse el número de patrones definiendo un
     * valor diferente de 'NP'. Pueden probarse otras secuencias
     * pseudoaleatorias definiendo un valor diferente de 'SEED' */
    always begin
        #20
        a = $random(seed);
        b = $random(seed);
        np = np - 1;
        if (np == 0)
            $finish;
    end
endmodule

/*
   EJERCICIOS

   2. Compila el banco de pruebas para el sumador/restador con:

      $ iverilog sumsub.v sumsub_tb.v

      y comprueba su operación con:

      $ vvp a.out

      Observa la salida de texto y las formas de onda con gtkwave y comprueba
      que son correctas.

      Comprueba también la operación de resta compilando el diseño con:

      $ iverilog -DOP=1 sumsub.v sumsub_tb.v

   3. Realiza simulaciones adicionales con distintos valores de OP, NP y SEED.
      Ej:

      $ iverilog -DOP=1 -DNP=40 -DSEED=2 sumsub.v sumsub_tb.v
      $ vpp a.out

   4. Modifica el banco de pruebas para simular el módulo 'sumsub2' y repite
      los apartados anteriores.

   5. Modifique el banco de pruebas para que permita simular un módulo 'sumsub1'
      de un número arbitrario de bits, definido mediante una macro 'WIDTH', de
      modo que pueda simularse un sumador-restadro de 16 bits con:

      $ iverilog -DWIDTH=16 sumsub.v sumsub_tb.v
*/
