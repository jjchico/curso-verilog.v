// Diseño:      async_ram
// Archivo:     async_ram.v
// Descripción: Memoria RAM asíncrona.
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       16/02/2018

/*
   Lección 8-2. Memoria RAM asíncrona con línea de datos de entrada/salida.

   Este archivo muestra un ejemplo clásico de memoria RAM. El módulo tiene
   un conjunto de líneas de dirección (a) y un conjunto de líneas de datos (d)
   que se emplean tanto para el dato de entrada como de salida: las líneas de
   datos son bidireccionales. La escritura de un nuevo dato en la memoria se
   controla con las señal "we" (write enable) y la lectura de un dato con
   la señal "oe" (output enable). Tan pronto se activan las señales de control
   se produce la escritura o lectura, por eso el compotamiento de la memoria
   es asíncrono: no depende de una señal de reloj.

   Las memorias RAM asíncronas y con líneas de datos bidireccionales fueron
   muy populares por su facilidad de uso y por ahorrar conexiones externas
   cuando se implementaban en un chip. En diseños digitales modernos su uso
   está desanconsejado por varios motivos principales:

   * Las memorias síncronas son más rápidas en general porque permiten incluir
     etapas de "pipeline".

   * Las plataformas actuales de desarrollo de circuitos digitales (como las
     FPGA) están optimizadas para implementar memorias síncronas. Describir
     memorias asíncronas supone emplear lógica genérica que resultan en
     implementaciones mucho menos eficientes.

   * Las señales de entrada/salida suponen emplear buffer de tres estados con
     nodos que pueden quedar en alta impledancia, haciendo los circuitos más
     complejos y propensos a sufrir fallow por interferencias radioeléctricas
     y otros fenómenos.

   * En la mayoría de los diseños actuales, las memorias son elementos internos
     del "chip" por lo que ahorrar en número de puertos de entrada/salida no
     suele suponer ninguna ventaja.

   No obtante, en esta lección se muestra cómo describir una memoria RAM de
   este tipo con objeto de introducir los conceptos básicos de diseño de
   memorias RAM y el uso de señales tri-estado.
 */

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Memoria RAM 256x8 asíncrona                                          //
//////////////////////////////////////////////////////////////////////////

module async_ram256x8 (
    input wire [7:0] a,     // líneas de dirección
    inout tri [7:0] d,      // líneas de datos (entrada/salida)
    input wire we,          // escritura (write enable)
    input wire oe           // lectura (output enable)
    );
    /* Las señales tipo "tri" son idénticas a "wire". Se suele emplear "tri"
     * para señales que puden ser asignadas desde múltiples lugares o que
     * pueden quedar sin asignar o en "alta impedancia", como es el caso de
     * señales de entrada/salida (en este ejemplo). */

    // Contenido de la memoria
    /* Una memoria RAM se representa en Verilog mediante un "array" de
     * vectores. Cada vector corresponde a un dato almacenado y el índice
     * array se usa como dirección del dato. La memoria RAM conserva el valor
     * por lo que la señal debe ser de tipo "reg". */
    reg [7:0] mem [0:255];

    // Carga del contenido inicial
    /* En Verilog es posible cargar el contenido inicial de un array mediante la
     * las funciónes del sistema "$readmemb()" y "$readmemh()". Estas funciones
     * esperan encontrar un archivo de texto con los datos a cargar separados
     * en líneas. $readmemb() interpretará los datos en binario y $readmemh()
     * en hexadecimal. El archivo de datos puede tener comentarios e
     * indicadores de dirección. Los elementos del array no asignados en el
     * archivo de datos quedarán como valores desconocidos ("x"). Véase
     * archivo "mem.list" como ejemplo. */
    initial
        $readmemh("mem.list", mem);

    // Operación de escritura
    /* La escritura en la memoria se produce en cualquier momento siempre que
     * esté activa la seña "we". */
    always @(*)
        if (we == 1'b1)
            mem[a] <= d;

    // Operación de lectura
    /* La lectura de la memoria se activa con la señal "oe" y siempre que no
     * se esté haciendo una operación de escritura. En el caso de que no se
     * active la operación de lectura, la señal se asigna con el valor "z"
     * lo cual significa que queda sin asignar. Una señal a la que no se
     * asigna ningún valor se dice que está en "alta impledancia". En una
     * implementación práctica, las señales en alta impedancia están debilmente
     * conectadas a la fuente de alimentación y son subceptibles de sufrir
     * alteraciones por interferencias internas o externas al circuito. */
    assign d = (oe && !we) ? mem[a] : 8'bz;

endmodule // async_ram256x8

/*
   EJERCICIOS

   1. Compila la lección con:

      $ iverilog async_ram.v

      Comprueba que no hay errores de sintaxis.

   (continúa en async_ram_tb.v)
*/
