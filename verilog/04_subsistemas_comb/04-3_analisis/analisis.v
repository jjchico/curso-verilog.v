// Diseño:      subsistemas
// Archivo:     analisis.v
// Descripción: Ejemplos de subsistemas combinacionales en Verilog
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       27/11/2009

/*
   Lección 4-3: Análisis de un subsistema combinacional.

   EJERCICIO

   Diseña el circuito de la figura en Verilog y simúlalo para obtener la
   tabla de verdad de la función f(x,y,z) que implementa. Para ello utiliza la
   estructura de código que se proporciona. Escribe el banco de pruebas en un
   archivo aparte "analisis_tb.v".

       +---------+       +---+
       |DEC2:4  0|o------| & |
       |         |       |   |o------+
   y---|1       1|o------|   |    +--+-+
       |         |       +---+    |  E  \
   z---|0       2|o---------------|0     \__ f
       |         |                |      /
       |        3|o---------------|1    /
       +---------+                +--+-+
                                     |
                                     x
*/

module dec4 (
    input  wire [1:0] in,
    output reg  [3:0] out
    );

    /* Implementación del decodificador */

endmodule // dec4

module mux2 (
    input  wire [1:0] in,
    input  wire       sel,
    input  wire       en,
    output reg        out
    );

    /* Implementación del multiplexor */

endmodule // mux2

module sistema (
    input  wire x,
    input  wire y,
    input  wire z,
    output wire f
    );

    /* Declaración de señales */

    dec4 dec4_1(/* conexión de señales */);
    nand nand_1(/* conexión de señales */);
    mux2 mux2_1(/* conexión de señales */);

endmodule // sistema
