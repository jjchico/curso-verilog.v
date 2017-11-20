// Diseño:      Unidad Aritmético-Lógica (ALU) sencilla
// Archivo:     sumsub_tb.v
// Descripción: Banco de pruebas para Unidad Aritmético-Lógica (ALU)
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       27/05/2010

/*
   Lección 5-3. Unidad aritmético-lógica

   Este archivo contiene un banco de pruebas para el módulo 'alu'.
*/

`timescale 1ns / 1ps

// Este banco de pruebas aplica un número configurable de entradas aleatorias
// al módulo 'alu'.

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

module test();

    reg signed [7:0] a;    // entrada 'a'
    reg signed [7:0] b;    // entrada 'b'
    reg [2:0] op = `OP;    // tipo de operación
    wire signed [7:0] f;   // salida
    wire ov;               // salida de desbordamiento
    integer np;            // variable auxiliar (número de patrones)
    integer seed = `SEED;  // variable auxiliar (semilla)

    // Circuito bajo test
    /* El módulo 'alu' es de anchura parametrizable. Aquí se instancia
     * una unidad de 8 bits */
    alu #(.WIDTH(8)) uut(.a(a), .b(b), .op(op), .f(f), .ov(ov));

    initial begin
        /* 'np' se empleará como contador del número de patrones de
         * test a aplicar. Su valor inicial se carga de la macro 'NP' */
        np = `NP;

        // Generamos formas de onda para visualización posterior
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, test);

        // Imprime cabeceras y monitoriza señales
        $write("Operacion: %d ", op);
        case (op)
           0: $display("SUMA");
           1: $display("RESTA");
           2: $display("INCREMENTO");
           3: $display("DECREMENTO");
           4: $display("AND");
           5: $display("OR");
           6: $display("XOR");
           default: $display("NOT");
        endcase

        $display("       A                B",
                 "                 F         ov");
        $monitor("%b (%d)  %b (%d)   %b (%d)  %b",
                   a, a, b, b, f, f, ov);
    end

    // Proceso de generación de entradas al circuito bajo test
    /* Cada 20ns 'a' y 'b' se asignan con valores aleatorios.
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

   2. Compila el banco de pruebas para la ALU con:

      $ iverilog alu.v alu_tb.v

      y comprueba su operación con:

      $ vvp a.out

      Observa la salida de texto y las formas de onda con gtkwave y comprueba
      que son correctas.

      Comprueba el resto de operaciones definiendo OP (entre 0 y 7). Ej.:

      $ iverilog -DOP=1 alu.v alu_tb.v

      (NOTA: para comprobar el correcto funcionamiento del desbordamiento en
      las operaciones de incremento y decremento quizá tenga que aumentar el
      número de patrones a simular difiniendo 'NP' para obtener suficientes
      resultados).

   3. Realiza simulaciones adicionales con distintos valores de OP, NP y SEED.
      Ej:

      $ iverilog -DOP=1 -DNP=40 -DSEED=2 alu.v alu_tb.v
      $ vpp a.out

   4. Diseñe una unidad aritmética similar a la de la lección que realice las
      siguientes operaciones (no realiza operaciones lógicas):

      op[2:0]    Operación       f
      --------------------------------
      000        Suma            a + b
      001        Resta           a - b
      010        Incremento 1    a + 1
      011        Decremento 1    a - 1
      100        Incremento 2    a + 2
      101        Decremento 2    a - 2
      110        Incremento 4    a + 4
      111        Decremento 4    a - 4
*/
