// Diseño:      ram
// Archivo:     ram.v
// Descripción: Memorias RAM síncronas. Banco de pruebas
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       16/02/2018

/*
   Lección 8-3. Memorias RAM síncronas.

   Este archivo contiene un banco de pruebas para verificar los módulos en
   ram.v.
*/

// Este banco de pruebas simula las memorias ram32x8_rf y ram32x8_wf en
// paralelo con objeto de comparar su comportamiento. Cada memoria parte con
// un contenido inicial diferente cargado desde los archivos mem1.list y
// mem2.list. El procecimiento de testado es el siguiente:
//
//   * Se lee el contenido de ambas memorias: comprobación de la operación en
//     modo lectura.
//   * Se escriben números aleatorios en ambas memorias: comprobación de la
//     operación de escritura. Debe observarse como, tras el flanco de reloj,
//     ram32x8_rf da a la salida el contenido anterior de la celda escrita,
//     mientras que ram32x8_wf muestra el nuevo dato escrito.
//   * Se vuelve a leer el contenido completo de las memorias: comprobación de
//     la operación de escritura anterior. Ambas memorias deben tener el mismo
//     contenido.

`timescale 1ns / 1ps

`ifndef TCYCLE
    `define TCYCLE 20  // periodo de la señal de reloj
`endif

`ifndef SEED
    `define SEED 1    // semilla inicial para generador de números aleatorios
`endif

// Banco de pruebas

module test ();

    reg clk;            // señal de reloj
    wire [4:0] a;       // líneas de dirección
    reg [7:0] din;      // líneas de datos de entrada
    wire we;            // escritura (write enable)
    wire [7:0] dout1;   // salida de datos pre-escritura
    wire [7:0] dout2;   // salida de datos post-escritura

    reg [5:0] cont;         // variable auxiliar para controlar a y we
    integer seed = `SEED;   // variable auxiliar (semilla)

    // Circuitos bajo test
    ram32x8_rf ram1(.clk(clk), .a(a), .din(din), .we(we), .dout(dout1));
    ram32x8_wf ram2(.clk(clk), .a(a), .din(din), .we(we), .dout(dout2));

    // Generación de direcciones y habilitación de escritura
    /* Permite recorrer todas las direcciones de las memorias con we=0 y we=1 */
    assign a = cont[4:0];
    assign we = cont[5];

    // Proceso de testado
    initial begin
        // Generación de formas de onda
        $dumpfile("sync_ram_tb.vcd");
        $dumpvars(0, test);

        // Carga de datos iniciales en las memorias
        /* Las memoria también pueden inicializarse desde el banco de pruebas
         * o, en general, desde un módulo superior. Observa cómo se indica
         * la ruta en la jerarquía del diseño hasta la variable a inicializar:
         * "instancia.variable" */
        $readmemb("mem1.list", ram1.mem);
        $readmemb("mem2.list", ram2.mem);

        // Cabecera para listado de resultados
        $display("we | a din | dout1 dout2");

        // Valores iniciales de las señales de control de simulación
        clk = 1'b0;
        cont = 0;       // comenzamos con we=0 y a=0
        din = $random(seed);    // dato aleatorio inicial en din

        // Fin de la simulación
        /* Recorremos 3 veces las 32 direcciones: lectura-escritura-lectura */
        #(3*32*`TCYCLE) $finish;

    end

    // Generador de señal de reloj
    always
        #(`TCYCLE/2) clk = ~clk;

    // Registro de las señales tras el flanco de reloj.
    always @(posedge clk)
        #1  // esperamos para que se estabilicen todas las señales
        $display(" %b | %h %h | %h %h", we, a, din, dout1, dout2);

    // Generamos nuevas entradas tras el flanco activo del reloj
    always @(posedge clk) begin
        #2  // esperamos a que se impriman los resultados
        cont = cont + 1;
        din = $random(seed);
    end

endmodule // test

/*
   EJERCICIOS

   2. Compila el banco de pruebas para las RAM síncronas con:

      $ iverilog sync_ram.v sync_ram_tb.v

      y comprueba su operación con:

      $ vvp a.out

      Comprueba la salida de texto. Observa como se imprime el contenido de
      ambas memorias durante las primeras líneas con we=0 (salidas dout1 y
      dout2). Cuando we cambia a 1 se produce la escritura en ambas memorias.
      Observa como ram32x8_rf genera el valor antiguo durante la lectura
      (dout1) mientras que ram32x8_wf genera el nuevo valor almacenado (dout2).
      Durante las últimas líneas con we=0 se vuelven a leer ambas memorias
      mostrando que ambas memorias han almacenado los mismos valores.

   3. Muestre las formas de onda generadas por la simulación con:

      $ gtkwave sync_ram_tb.vcd

      Visualice las señales clk, we, din, dout1 y dout2, y observe los
      instantes en que cambian y su relación con el modo de operación de cada
      memoria.

   4. Un comportamiento típico de las RAM síncronas es que no se produce la
      lectura de la memoria durante la operación de escritura. Modifique la
      descripción de las memorias para que tengan este comportamiento y vuelva
      a simularlas usando este mismo banco de pruebas.
      ¿Se observa alguna diferencia en el resultado?
      ¿Sique siendo diferente el comportamiento de ambas memorias?
*/
