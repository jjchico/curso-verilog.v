// Diseño:      chrono
// Archivo:     chrono1.v
// Descripción: Cronómetro digital
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       14/06/2010

/*
   Lección 7-3: Cronómetro digital.

   En esta lección haremos un diseño algo más complejo: un cronómetro digital
   con centésimas y segundos con funciones de inicio y parada de la cuenta
   y de puesta a cero.

   Cuando los sistemas son algo complejos es necesario hacer una organización
   inicial del problema que ayude a realizar la descripción. En este sentido
   suele ser útil separar el problema en bloques más o menos independientes y
   describirlos por separado para luego conectarlos entre si. Esto requiere
   en general describir cada bloque en un módulo Verilog independiente para
   luego unir todo el sistema mediante una descripción estructural.

   En este ejemplo usaremos un único módulo, pero aún así pensaremos en varios
   bloques a la hora de realizar la descripción. Así, la descripción del
   sistema se organiza en base a los siguientes puntos:

   - La señal de reloj del sistema (ck) tendrá en general una frecuencia mayor
     a 100Hz por lo que necesitaremos un divisor de frecuencia que habilite
     la cuenta sólo cuando haya tanscurrido un número suficiente de ciclos del
     reloj del sistema. Para poder adaptar el diseño a diversas condiciones, la
     frecuencia del reloj del sistema será un parámetro configurable a partir
     del cual el divisor de frecuencia generará la señal de habilitación al
     ritmo adecuado.

   - El sistema se compone básicamente de cuatro contadores:
     * C0: centésismas de segundo (de 0 a 9)
     * C1: décimas de segundo (de 0 a 5)
     * S0: unidades de segundo (de 0 a 9)
     * S1: decenas de segundo (de 0 a 5)

   - Cada contador se describirá por separado (en su propio proceso). Cada
     contador se incrementará cuando la cuenta sea habilitada por el divisor
     de frecuencia y sólo si los contadores menos significativos han llegado
     al último estado de cuenta.

   - Se generará una señal de fin de cuenta para cada contador para que pueda
     ser empleada por los contadores más significativos.

   - Cada contador se pondrá a cero cuando se active una señal general de
     puesta a cero (cl).

   - Una señal 'start' controlará el inicio y la parada de la cuenta actuando
     sobre el divisor de frecuencia.
*/

`timescale 1 ns / 1 ps

//////////////////////////////////////////////////////////////////////////
// Cronómetro                                                           //
//////////////////////////////////////////////////////////////////////////

module chrono1 #(
    // Frecuencia del reloj del sistema en Hz
    /* FDIV, calculado a partir de FREQ, será usado por el divisor
    * de frecuencia para ajustar el ritmo de cuenta a centésimas de
    * segundo. Por defecto 50MHz. */
    parameter FREQ = 50000000
    )(
    input wire ck,          // reloj
    input wire cl,          // puesta a cero (activo en alto)
    input wire start,       // habilitación (activo en alto)
    output reg [3:0] c0,    // centésimas de segundo
    output reg [3:0] c1,    // décimas de segundo
    output reg [3:0] s0,    // unidades de segundo
    output reg [3:0] s1     // decenas de segundo
    );

    // Ajuste del divisor de frecuencia. Milisegundos
    /* Los parámetros locales (localparm) sólo tienen validez dentro del
     * módulo en que se definen y no pueden redefinirse al instanciar el
     * componente, salvo con una expresión como en este ejemplo. */
    localparam FDIV = FREQ/100;

    /* Contador usado por el divisor de frecuencia. Con 24 bits es posible
     * emplear relojes externos de hasta 1,6GHz */
    reg [23:0] dcount;    // Contador del divisor de frecuencia

    /* Señales internas de fin de cuenta para cada contador */
    wire c0end;
    wire c1end;
    wire s0end;

    //// Divisor de frecuencia ////
    /* El divisor de frecuencia no es más que un contador descendente que
     * activa una señal de habilitación de cuenta el resto de contadores
     * cada vez que llega a cero. Al llegar a cero es iniciado a FDIV-1,
     * lo que hace que active la señal de habilitación general 'cnt' una
     * vez cada centésima de segundo. Una parada de la cuenta (start) o
     * una puesta a cero del cronómetro (cl) hace que el divisor de
     * frecuencia se detenga y reinicie, deteniendo todo el cronómetro. */
    always @(posedge ck) begin
        if (start == 0 || cl == 1 || dcount == 0)
            dcount <= FDIV - 1;
        else
            dcount <= dcount - 1;
    end

    /* Señal de habilitación generada cuando el divisor llega a cero */
    assign cnt = ~|dcount;

    //// Contador de centésimas (C0) ////
    /* Cada contador se trata por separado y genera una señal de fin de
     * cuenta que será usada por los contadores siguientes */
    always @(posedge ck) begin
        if (cl)
            /* Si se activa cl hacemos una puesta a cero */
            c0 <= 0;
        else if (cnt) begin
            /* Si se activa cnt hay que incrementar la cuenta */
            if (c0end)
                /* Si estábamos en el último estado de cuenta
                 * pasamos al estado 0 (c0end más abajo) */
                c0 <= 0;
            else
                /* Si no hemos llegado al último estado de
                 * cuenta, incrementamos */
                c0 <= c0 + 1;
        end
    end

    /* Generamos la señal de fin de cuenta del contador de centésimas */
    assign c0end = (c0 == 9)? 1:0;

    //// Contador de décimas (C1) ////
    /* El resto de contadores son muy similares, cambiando ligeramente las
     * condiciones que disparan la operación de cuenta */
    always @(posedge ck) begin
        if (cl)
            c1 <= 0;
        else if (cnt & c0end) begin
            /* Contamos solo si se ha habilitado la cuenta (cnt) y
             * el contador anterior (C0) está en su último estado
             * de cuanta. Luego incrementamos C1 como hicimos para
             * C0, teniendo en cuenta el fin de cuenta. */
            if (c1end)
                c1 <= 0;
            else
                c1 <= c1 + 1;
        end
    end

    /* Señal de fin de cuenta de C1 */
    assign c1end = (c1 == 9)? 1:0;

    //// Contador de unidades (S0) ////
    always @(posedge ck) begin
        if (cl)
            s0 <= 0;
        else if (cnt & c1end & c0end) begin
            /* Sólo si hay habilitación y todos los contadores
             * anteriores en fin de cuenta */
            if (s0end)
                s0 <= 0;
            else
                s0 <= s0 + 1;
        end
    end

    /* Señal de fin de cuenta de S0 */
    assign s0end = (s0 == 9)? 1:0;

    //// Contador de decenas (S1) ////
    always @(posedge ck) begin
        if (cl)
            s1 <= 0;
        else if (cnt & s0end & c1end & c0end) begin
            if (s1end)
                s1 <= 0;
            else
                s1 <= s1 + 1;
        end
    end

    assign s1end = (s1 == 5)? 1:0;

endmodule // chrono1

/*
   (continúa en chrono_tb.v)
*/
