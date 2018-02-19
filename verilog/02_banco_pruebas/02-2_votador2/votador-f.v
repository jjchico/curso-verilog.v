// Diseño:      votador
// Archivo:     votador-f.v
// Descripción: Simulación con banco de pruebas (test bench)
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       10-11-2009

/*
   Lección 2-2: Simulación con banco de pruebas

   En este archivo realizaremos el mismo circuito votador pero mediante una
   descripción funcional. Más adelante compararemos el resultado de simular
   esta descripción con la descripción procedimental en votador.v.

   En general, una descripción funcional es más cercana a la implementación
   final, es más facilmente sintetizable y permite una simulación más
   eficiente, pero requiere un trabajo previo por parte del diseñador, por lo
   que suele emplearse para casos sencillos o para aquellos problemas que de
   forma natural presentan una descripción funcional sencilla.
*/

// Definimos la escala de tiempo para el simulador
`timescale 1ns / 1ps

/* Llamamos a este módulo "votador_f" para distinguirlo de la versión
 * procedimental llamada "votador" */
module votador_f (
    output wire v,
    input wire a,
    input wire b,
    input wire c
    );

    /* Describimos la función mediante una estructura "assign". Incluimos un
     * retraso de 2ns para obtener resultados de simulación más realistas. A
     * la vista de la expresión es fácil observar que la salida del circuito
     * valdrá "1" cuando dos entradas cuales quiera sean "1". */
    assign #2 v = a&b | a&c | b&c;

endmodule    // votador_f

/*
   EJERCICIO

   1. Comprueba que el archivo no tiene errores copilándolo con:
    $ iverilog votador-f.v

   La lección sigue en el archivo votador-f_tb.v.
*/
