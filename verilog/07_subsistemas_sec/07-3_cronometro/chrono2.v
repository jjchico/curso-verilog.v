// Diseño:      chrono
// Archivo:     chrono2.v
// Descripción: Cronómetro digital. Versión 2
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       14/06/2010

/*
   Lección 7-3: Cronómetro digital.

   Este archivo contiene un diseño alternativo al módulo crono1 empleando
   un sólo proceso para calcular el nuevo valor de todas las cifras.
*/

`timescale 1 ns / 1 ps

//////////////////////////////////////////////////////////////////////////
// Cronómetro                                                           //
//////////////////////////////////////////////////////////////////////////

module chrono2(
    input ck,            // reloj
    input cl,            // puesta a cero (activo en alto)
    input start,         // habilitación (activo en alto)
    output reg [3:0] c0, // centésimas de segundo
    output reg [3:0] c1, // décimas de segundo
    output reg [3:0] s0, // unidades de segundo
    output reg [3:0] s1  // decenas de segundo
    );

    // Frecuencia del reloj del sistema en Hz
    parameter FREQ = 50000000;

    // Ajuste del divisor de frecuencia. Milisegundos
    localparam FDIV = FREQ/100;

    /* Contador usado por el divisor de frecuencia. Con 24 bits es posible
     * emplear relojes externos de hast 1,6GHz */
    reg [23:0] dcount;    // Contador del divisor de frecuencia


    //// Divisor de frecuencia ////
    always @(posedge ck) begin
        if (start == 0 || cl == 1 || dcount == 0)
            dcount <= FDIV - 1;
        else
            dcount <= dcount - 1;
    end

    /* Señal de habilitación generada cuando el divisor llega a cero */
    assign cnt = ~|dcount;

    //// Cronómetro ////
    /* Con cada flanco, un solo proceso calcula el nuevo valor de todas las
     * cifras del contador. Se empieza por las centésimas de segundo. Si
     * no están en su valor máximo, se incrementan. Si están en el valor
     * máximo, se ponen a cero y se incrementa el dígito siguiente, y así
     * sucesivamente. */
    always @(posedge ck) begin
        if (cl) begin
            /* Si se activa cl hacemos una puesta a cero */
            c0 <= 0;
            c1 <= 0;
            s0 <= 0;
            s1 <= 0;
        end else if (cnt) begin
            /* Si se activa cnt hay que incrementar la cuenta */
            if (c0 < 9) // incremento normal
                c0 <= c0 + 1;
            else begin  // puesta a cero y comprobamos siguiente cifra
                c0 <= 0;
                if (c1 < 9) // incremento normal
                    c1 <= c1 + 1;
                else begin  // puesta a cero y comprobamos siguiente cifra
                    c1 <= 0;
                    if (s0 < 9) // incremento normal
                        s0 <= s0 + 1;
                    else begin  // puesta a cero y comprobamos siguiente cifra
                        s0 <= 0;
                        if (s1 < 5) // incremento normal
                            s1 = s1 + 1;
                        else        // puesta a cero
                            s1 <= 0;
                    end
                end
            end
        end
    end

endmodule // chrono2
