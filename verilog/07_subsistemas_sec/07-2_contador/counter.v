// Diseño:      counter
// Archivo:     counter.v
// Descripción: Contador reversible
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       11/06/2010

/*
   Lección 7-2: Contador reversible

   Los contadores realizan principalmente la función de contar: en cada ciclo
   de reloj pasan al estado de cuenta siguiente (contador ascendente) o
   anterior (contador descendente). Los estados de cuenta suelen codificarse
   en binario, aunque existen otras posibilidades: gray, etc.

   Un contador independiente comparte funciones generales de los registros
   como la puesta a cero o la carga de estado de cuenta, por lo que puede
   verse como un tipo particular de registro y su descripción en Verilog
   es análoga.

   En esta lección describiremos un contador reversible (puede contar de forma
   ascendente o descendente) con puesta a cero síncrona.
*/

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Contador reversible                                                  //
//////////////////////////////////////////////////////////////////////////
/*
   Las operaciones en función de las entras de control ck, en y ud son:

      cl  en  ud    operación
    --------------------------
      1   x   x      Puesta a cero síncrona
      0   0   x      Inhibición
      0   1   0      Cuenta ascendente
      0   1   1      Cuenta descendente

   Por otro lado, dispone de las siguientes entradas y salidas:
       ck: señal de reloj
       c: fin de cuenta. Activa en último estado de cuenta.
 */

module counter(
    input ck,          // reloj
    input cl,          // puesta a cero
    input en,          // habilitación
    input ud,          // cuenta hacia arriba (0) o abajo (1)
    output [W-1:0] q,  // estado de cuenta
    output c           // señal de fin de cuenta
    );

    // Anchura del contador
    /* La anchura del contador está parametrizada con 8 bits por defecto */
    parameter W = 8;

    /* Definimos una señal interna para el estado del contador */
    reg [W-1:0] count;
    reg c;

    // Proceso de control del estado del contador
    always @(posedge ck) begin
        if (cl)             // puesta a cero
            count <= 0;
        else if (en)
            if (ud == 0)    // cuenta ascendente
                count = count + 1;
            else            // cuenta descendente
                count = count - 1;
    end

    // Proceso de cálculo de la señal de fin de cuenta
    /* La señal se activará para 2^W-1 si la cuenta es ascendente y para
     * 0 si la cuenta es descendente */
    always @* begin
        if (ud == 0)
            c = &count;     /* todos los bits de 'count' a '1' */
        else
            c = ~(|count);  /* todos los bits de 'count' a '0' */
    end

    /* Asignamos el estado del contador a la salida */
    assign q = count;

endmodule // counter

/*
   (continúa en counter_tb.v)
*/
