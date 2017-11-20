// Diseño:      subsistemas
// Archivo:     bcd-7.v
// Descripción: Ejemplos de subsistemas combinacionales en Verilog
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       27/11/2009

/*
   Lección 4-2: Convertidor de BCD a 7 segmentos.

   EJERCICIO

   Tomando este archivo como base, diseña un convertidor de códigos de BCD
   a 7 segmentos con entrada de habilitación activa en nivel alto. Diseña
   así mismo un banco de pruebas adecuado para su comprobación.
*/

module bcd7(
    input e,        // entrada de habilitación
    input [3:0] x,  // entrada BCD
    output [1:7] y  // salida 7-segmentos
    );

    /* Espacio para el diseño del módulo */

endmodule // bcd-7
