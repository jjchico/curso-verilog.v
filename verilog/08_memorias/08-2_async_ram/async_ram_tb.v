// Diseño:      async_ram
// Archivo:     async_ram.v
// Descripción: Memoria RAM asíncrona. Banco de pruebas.
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       16/02/2018

/*
   Lección 8-2. Memoria RAM asíncrona con línea de datos de entrada/salida.

   Este archivo contiene un banco de pruebas para verificar el módulo RAM en
   async_ram.v.
*/

`timescale 1ns / 1ps

// Banco de pruebas

module test ();

    reg [7:0] a;    // líneas de dirección
    tri [7:0] d;    // líneas de datos
    reg we;         // escritura (write enable)
    reg oe;         // lectura (output enable)

    reg [7:0] din;  // almacén temporal del dato de entrada

    // Circuito bajo test
    async_ram256x8 uut(.d(d), .a(a), .we(we), .oe(oe));

    // Asignación de las líneas de datos
    /* La señal "din" se emplea a lo largo del banco de pruebas para preparar
     * el dato que se debe asignar a la entrada de datos de la memoria en las
     * operaciones de escritura de datos. Este dato temporal sólo se asigna
     * a la entrada de datos cuando efectivamente se hace una operación de
     * escritura en la memoria (we=1). Nótese que las líneas de datos "d" de la
     * memoria no se pueden asignar en un procedimiento porque es una señal
     * de tipo tri/wire, que puede quedar sin asignar, mientras que las señales
     * asignadas en procedimientos sólo pueden ser de tipo variable (reg) y
     * siempre deben tener un valor (asignado o almacenado).
     */
    assign d = we == 1'b1 ? din : 8'bz;

    // Proceso de testado
    /* El proceso de testado lee las primeras direcciones de memoria y vuelca
     * su contenido de la memoria en el terminal. Luego escribe en el rango
     * de memoria 'h10 a 'h1f y vuelve a leer la memoria y mostrar su
     * contenido. */
    initial begin
        // leemos la memoria desde 'h00 hasta 'h2f
        we = 1'b0;
        oe = 1'b1;
        $display("Dirección\tContenido");
        for (a=0; a<'h30; a=a+1)
            #10 $display("%h\t%h", a, d);

        // escribimos datos entre 'h10 y 'h1f
        oe = 1'b0;
        for (a='h10; a<'h20; a=a+1) begin
            din = a * 2;
            #10 we = 1'b1;
            #10 we = 1'b0;
        end

        // volvemos a leer la memoria
        oe = 1'b1;
        $display("Dirección\tContenido");
        for (a=0; a<'h30; a=a+1)
            #10 $display("%h\t%h", a, d);
    end

endmodule // test

/*
   EJERCICIOS

   2. Compila el banco de pruebas para la RAM asíncrona con:

      $ iverilog async_ram.v async_ram_tb.v

      y comprueba su operación con:

      $ vvp a.out

      Comprueba la salida de texto. Observa como las posiciones de memoria no
      asignadas tiene valores desconocidos "x", y como esas posiciones han
      sido rellenadas más adelante mediante las operaciones de escritura.

   3. Modifique el diseño de la RAM para hacerlo parametrizable. Introduce los
      parámetros "AW" para la anchura de la señal de direcciones y "DW" para
      la anchura de la señal de datos, con valor predeterminado 8 para ambos.
      Compruba la correcta operación del diseño parametrizado con este mismo
      banco de pruebas.
*/
