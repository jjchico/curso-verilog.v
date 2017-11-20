// Diseño:      sumador
// Archivo:     sumador_tb.v
// Descripción: Ejemplos de sumadores combinacionales en Verilog
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       23/05/2009

/*
    Lección 5-1: Circuitos aritméticos. Sumadores.

    Este archivo contiene un banco de prueba para sumadores.
*/

`timescale 1ns / 1ps

// Banco de pruebas para sumadores

`ifndef NP
    `define NP 20    // número de patrones a aplicar en el test
`endif
`ifndef SEED
    `define SEED 1    // semilla inicial para generar patrones aleatorios
`endif

module test();

    reg [7:0] a;           // número 'a'
    reg [7:0] b;           // número 'b'
    reg cin;               // acarreo de entrada
    wire [7:0] s;          // suma
    wire cout;             // accareo de salida
    integer np;            // variable auxiliar (número de patrones)
    integer seed = `SEED;  // variable auxiliar (semilla)

    // Circuito bajo test. Usar 'adder8_e', 'adder8_g' o 'adder8' para
    // simular las distintas versiones del sumador:
    //   adder8_e: descripción estrutural
    //   adder8_g: descripción estructural usando 'generate'
    //   adder8: descripción funcional con operandos aritméticos
    adder8_e uut(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));

    initial begin
        /* 'np' se empleará como contador del número de patrones de
         * test a aplicar. Su valor inicial se carga de la macro 'NP' */
        np = `NP;

        // Generamos formas de onda para visualización posterior
        $dumpfile("test.vcd");
        $dumpvars(0, test);

        $display("A  B  cin  s  cout");
        $monitor("%h %h %b    %h %b",
                   a, b, cin, s, cout);
    end

    /* Cada 20ns 'a', 'b' y 'cin' se asignan con valores aleatorios.
     * La simulación finaliza después de aplicar un número de patrones
     * igual a 'np'. Puede cambiarse el número de patrones definiendo un
     * valor diferente de 'NP'. Pueden probarse otras secuencias
     * pseudoaleatorias definiendo un valor diferente de 'SEED' */
    always begin
        #20
        a = $random(seed);
        b = $random(seed);
        cin = $random(seed);
        np = np - 1;
        if (np == 0)
            $finish;
    end
endmodule

/*
   EJERCICIOS

   3. Compila el banco de pruebas para el sumador con:

      $ iverilog sumador.v sumador_tb.v

      y comprueba su operación con:

      $ vvp a.out

      Observa la salida de texto y las formas de onda con gtkwave y comprueba
      que son correctas.

   4. Realiza simulaciones adicionales con distintos valores de NP y SEED. Ej:

      $ iverilog -DNP=40 -DSEED=2 sumador.v sumador_tb.v
      $ vpp a.out

   5. Modifica el banco de pruebas para simular adder8_g y adder8. Comprueba
      que el resultado es correcto.

   6. Añade un retraso de 1 a las salidas z y cout del módulo 'fa'. Compara
      las salidas de adder8_e o adder8_g con adder8 en este caso e interpreta
      los resultados. ¿Qué descripción es más realista, adder8_e o adder8?
*/
