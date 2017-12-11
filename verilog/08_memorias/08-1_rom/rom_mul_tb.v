// Diseño:      rom_mul
// Archivo:     rom_mul_tb.v
// Descripción: Multiplicador BCD basado en ROM
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       22/11/2017

/*
   Lección 8-1. Multiplicador basado en ROM.

   Este archivo contiene un banco de pruebas para verificar el multiplicador
   basado en ROM en rom_mul.v.
*/

`timescale 1ns / 1ps

// Banco de pruebas: Comprueba todas las posibles multiplicaciones e indica
// si hay algún error.

module test();

    reg [3:0] x, y;   // datos de entrada
    wire [7:0] z;     // salida BCD
    reg [7:0] zd;     // salida decimal
    reg [7:0] ze;     // valor esperado
    reg err = 0;      // indicador de error

    // Circuito bajo test
    rommul_bcd uut(.x(x), .y(y), .z(z));

    // proceso de testado
    /* La mayoría de los bancos de prueba de unidades anteriores se limitaban
     * a mostrar al usuario los resultados de todos o un conjunto de casos para
     * que el usuario comprobara su validez. En la práctica, cuando el número
     * de posibles valores de entrada es grande, un banco de pruebas es mucho
     * más útil cuando comprueba automáticamente los resultados e informa al
     * usuario en caso de error. En este caso, se usa esta estrategia,
     * comparando el valor obtenido del circuito con el valor esperado calculado
     * por el banco de pruebas (mediante una operación aritmética).
     * Los bancos de prueba "automáticos" son más complejos de programar, pero
     * necesarios en la mayoría de diseños que no son triviales.
     */
    initial begin
        for (x=0; x<10; x=x+1)
            for (y=0; y<10; y=y+1) begin
                #10;    // Dejamos tiempo para que el simulador calcule
                        // el resultado
                zd = z[7:4]*10 + z[3:0];  // convertimos el resultado a decimal
                ze = x * y;               // calculamos el valor esperado
                if (zd != ze) begin
                    $display("ERROR: %d * %d = %d <%b> (esperado %d)",
                             x, y, zd, z, ze);
                    err = 1'b1;
                end
            end
        if (err)
            $display("El circuito tiene errores. Revise el diseño.");
        else
            $display("No se han detectado errores.");
    end

endmodule // test


/*
   EJERCICIOS

   2. Compila el banco de pruebas para el multiplicador basado en ROM con:

      $ iverilog rom_mul.v rom_mul_tb.v

      y comprueba su operación con:

      $ vvp a.out

      Observa la salida de texto. Corrige los errores detectados por el banco
      de pruebas y repite la simulación hasta que la simulación no de errores.

   3. Modifique el diseño del multiplicador (puede trabajar sobre una copia del
      archivo rom_mul.v) para convertirlo en un multiplicador decimal de
      números de 4 bits. Las entradas ahora serán números de 0 a 15 y la salida
      es el resultado decimal codificado en binario natural. Modifique el banco
      de pruebas de la forma apropiada y úselo para comprobar el diseño.
*/
