// Diseño:      ram
// Archivo:     ram.v
// Descripción: Memorias RAM síncronas.
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       16/02/2018

/*
   Lección 8-3. Memorias RAM síncronas.

   En este archivo se describen dos memorias RAM síncronas con líneas de datos
   separadas para el dato de entrada y el de salida. Son ejemplos de diseños
   recomendados de memorias RAM. La operación síncrona permite un mejor control
   de las operaciones de escritura y lectura, a la vez que la introducción de
   las memorias en etapas de "pipeline". Las líneas de datos separadas evitan
   tener nodos en alta impedancia y permiten leer y escribir datos en la
   memoria en el mismo ciclo de reloj.

   En los ejemplos de más abajo, la lectura de las memorias es incondicional:
   la lectura se produce siempre con el flanco activo del reloj, incluso cuando
   se realiza una operación de escritura. En este caso, cada memoria tiene un
   comportamiento ligeramente diferente:

   * Lectura-pre-escritura (read-first): la salida toma el valor anterior
     almacenado.

   * Lectura-post-escritura (write-first): la salida toma el mismo valor que
     se está almacenando.

   Se pueden describir otros comportamientos según las necesidades del diseño
   como entradas de habilitación general de la memoria, etc.

   Los dispositivos FPGA actuales suelen incluir bloques de RAM síncrona (Block
   RAM o BRAM) que pueden ser empleados por las herramientas de síntesis para
   implementar las memorias RAM síncronas de forma eficiente. Para saber qué
   tipos de diseños de RAM síncronas son implementables mediante BRAM en una
   plataforma determinada es necesario consultar la documentación de la misma.
 */

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// RAM 32x8 lectura-pre-escritura (read-first)                          //
//////////////////////////////////////////////////////////////////////////

module ram32x8_rf (
    input wire clk,         // señal de reloj
    input wire [4:0] a,     // líneas de dirección
    input wire we,          // escritura (write enable)
    input wire [7:0] din,   // líneas de datos (entrada)
    output reg [7:0] dout   // líneas de datos (salida)
    );

    // Contenido de la memoria
    reg [7:0] mem [0:31];

    // Operaciones de escritura y lectura
    always @(posedge clk) begin
        if (we == 1'b1)
            mem[a] <= din;
        dout <= mem[a];
    end
endmodule // ram32x8_pre

//////////////////////////////////////////////////////////////////////////
// RAM 32x8 lectura-post-escritura (write-first)                        //
//////////////////////////////////////////////////////////////////////////

module ram32x8_wf (
    input wire clk,         // señal de reloj
    input wire [4:0] a,     // líneas de dirección
    input wire we,          // escritura (write enable)
    input wire [7:0] din,   // líneas de datos (entrada)
    output wire [7:0] dout  // líneas de datos (salida)
    );

    // Contenido de la memoria
    reg [7:0] mem [0:31];

    // Entrada de dirección registrada
    reg [5:0] read_a;

    // Operación de escritura y registro de dirección
    always @(posedge clk) begin
        if (we == 1'b1)
            mem[a] <= din;
        /* Almacenamos la dirección que se está leyendo/escribiendo */
        read_a <= a;
    end

    // Lectura
    /* La lectura se produce de forma combinacional sobre la dirección
     * en la que se ha producido la escritura, por lo que el dato de salida,
     * tras el flanco de reloj, será el mismo que se ha almacenadado, si se
     * ha producido una operación de escritura. */
    assign dout = mem[read_a];

endmodule // ram32x8_post

/*
   EJERCICIOS

   1. Compila la lección con:

      $ iverilog sync_ram.v

      Comprueba que no hay errores de sintaxis.

   (continúa en sync_ram1_tb.v)
*/
