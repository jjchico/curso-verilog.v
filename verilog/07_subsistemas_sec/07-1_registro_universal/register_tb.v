// Diseño:      uregister
// Archivo:     register_tb.v
// Descripción: Registro universal
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       11/06/2010

/*
   Lección 7-1: Registro universal.

   Este archivo contiene un banco de pruebas para verificar las diferentes
   operaciones del registro universal en register.v.
*/

`timescale 1ns / 1ps

// Banco de pruebas

module test();

    reg ck = 0;     // reloj
    reg load = 0;   // carga de dato en paralelo
    reg shr = 0;    // desplazamiento a la derecha
    reg shl = 0;    // desplazamiento a la izquierda
    reg xr = 0;     // entrada serie para shr
    reg xl = 0;     // entrada serie para shl
    reg [7:0] x;    // entrada de dato para carga en paralelo
    wire [7:0] q;   // salida del registro

    // Instanciación de la unidad bajo test
    /* Instanciamos un registro de 8 bits. Recordamos que la anchura del
     * registro está parametrizada. */
    uregister #(8) uut (.ck(ck), .load(load), .shr(shr), .shl(shl),
                   .xr(xr), .xl(xl), .x(x), .q(q));

    // Salidas y control de la simulación
    initial    begin
        // Generamos formas de onda para visualización posterior
        $dumpfile("register_tb.vcd");
        $dumpvars(0, test);

        /* En esta ocasión no generamos salida de texto */
    end

    // Señal de reloj periódica
    /* El reloj cambia con un perior de 20ns */
    always
        #10 ck = ~ck;

    // Entradas
    /* Las operaciones síncronas del registro actúa en flanco de subida
     * por lo que cambiamos las entradas en el flanco de bajada del reloj
     * para evitar ambiguedades. Usamos "@(negedge ck)" y "repeat" para
     * localizar los flancos de bajada del reloj que nos interesan */
    initial begin
        @(negedge ck)            /* preparamos la carga de un dato     */
        x = 8'b00110101;
        load = 1;
        @(negedge ck)            /* en el siguiente ciclo desactivamos */
        load = 0;                /* la señal de carga                  */
        @(negedge ck)            /* activamos la operación shr y la    */
        shr = 1;                 /* dejamos actuar durante 4 ciclos    */
        repeat(4) @(negedge ck);
        xr = 1;                  /* seguimos con shr ahora con xr=1    */
        repeat(4) @(negedge ck);
        x = 8'b01010001;         /* preparamos una nueva carga y       */
        load = 1;                /* desactivamos shr                   */
        shr = 0;
        @(negedge ck)
        load = 0;                /* desactivamos la operación de carga */
        @(negedge ck)
        shl = 1;                 /* activamos la operación shl primero */
        repeat(4) @(negedge ck); /* con xl=0 y luego con xl=1          */
        xl = 1;
        repeat(4) @(negedge ck);
        shl = 0;                 /* esperamos dos ciclos más sin hacer */
        repeat(2) @(negedge ck); /* ninguna operación                  */
        $finish;
    end

endmodule // test


/*
   EJERCICIOS

   1. Compila y simula los ejemplos con:

      $ iverilog register.v register_tb.v
      $ vvp a.out

   2. Visualiza los resultados y comprueba la salida con:

      $ gtkwave register_tb.vcd

   3. Modifique el banco de pruebas para simular el módulo uregister2.
      Compruebe los resultados con la simulación de uregister1.

   4. Modifica el diseño para que la entrada de carga en paralelo tenga un
      comportamiento asíncrono.

   5. Modifica el diseño para incluir una entrada de puesta a cero asíncrona.
*/
