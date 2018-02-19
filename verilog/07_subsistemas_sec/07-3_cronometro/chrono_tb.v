// Diseño:      chrono
// Archivo:     chrono_tb.v
// Descripción: Cronómetro digital
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       14/06/2010

/*
   Lección 7-3: Cronómetro digital.

   Este archivo contiene un banco de pruebas para el módulo 'chrono'. El
   aspecto más difícil de este banco de pruebas radica en que, para una
   frecuencia del reloj del sistema elevada, el cronómetro se incrementa sólo
   cuando han transcurrido un elevado número de ciclos de reloj. Por tanto,
   observar los instantes de interés en la simulación requieren una cierta
   planificación del control del tiempo de simulación. Para ello emplearemos
   profusamente el control temporal con '@' y la directiva 'repeat'.
*/

`timescale 1 ns / 1 ps

// Frecuencia del reloj del sistema en Hz.
/* Macro que define la frecuencia del reloj del sistema generado en el banco
 * de pruebas. Esta frecuencia se pasará al módulo 'chrono' como parámetro de
 * ajuste del divisor de frecuencia. Para simulación se emplea 1KHz con objeto
 * de reducir el tiempo de simulación. */
`define SYSFREQ 1000

// Banco de pruebas

module test ();

    reg ck = 0;     // reloj
    reg cl = 0;     // puesta a cero (activo en alto)
    reg start = 0;  // habilitación (activo en alto)
    wire [3:0] c0;  // centésimas de segundo
    wire [3:0] c1;  // décimas de segundo
    wire [3:0] s0;  // unidades de segundo
    wire [3:0] s1;  // decenas de segundo

    // Circuito bajo test
    /* Instanciamos el cronómetro ajustado a una frecuencia de reloj del
     * sistema SYSFREQ */
    chrono1 #(`SYSFREQ) uut(.ck(ck), .cl(cl), .start(start),
                .c0(c0), .c1(c1), .s0(s0), .s1(s1));

    // Salidas y control de la simulación
    initial begin
        // Generamos formas de onda para visualización posterior
        $dumpfile("chrono_tb.vcd");
        $dumpvars(0, test);

        // Generamos salida en formato texto
        $display("cl start  SS.CC");
        $monitor("%b  %b      %h%h.%h%h",
                   cl, start, s1, s0, c1, c0);
    end

    // Señal de reloj periódica
    /* Generamos una señal de reloj de frecuencia 'SYSFREQ' teniendo en
     * cuenta que la unidad de tiempo del simulador es ns (fijada por la
     * directiva 'timescale' más arriba) y que 'SYSFREQ' está en Hz */
    always
        #(1e9 / `SYSFREQ / 2) ck = ~ck;

    // Entradas
    /* Sincronizamos los cambios de las entradas de control con los flancos
     * de bajada del reloj. Las entradas hacen una puesta a cero inicial,
     * una cuenta durante unos segundos, una parada y una puesta a cero
     * durante la cuenta. */
    initial begin
        @(negedge ck)
        cl = 1;                    // puesta a cero
        @(negedge ck)
        cl = 0;                    // contamos
        start = 1;
        /* Esperamos 7 segundos */
        repeat(7 * `SYSFREQ) @(negedge ck);
        start = 0;                // paramos
        /* Esperamos 2 segundos */
        repeat(2 * `SYSFREQ) @(negedge ck);
        start = 1;                // continuamos
        repeat(6 * `SYSFREQ) @(negedge ck);
        cl = 1;                // puesta a cero sin parar
        repeat(1 * `SYSFREQ) @(negedge ck);
        cl = 0;
        repeat(3 * `SYSFREQ) @(negedge ck);
        $finish;
    end

endmodule // test

/*
   EJERCICIOS

   1. Compila y simula los ejemplos con:

      $ iverilog chrono.v chrono_tb.v
      $ vvp a.out -lxt

      El simulador generará un archivo 'chrono_tb.lxt' con las formas de onda
      resultado de la simulación. El formato lxt (generado gracias a la
      opción '-lxt' de 'vvp') es más eficiente que el vcd cuando se trata de
      simulaciones que generan muchos datos.

   2. Visualiza e interpreta los resultados con:

      $ gtkwave chrono_tb.lxt

   3. Modifica el valor de la macro SYSFREQ a un valor mayor (100000 o 1000000)
      y vuelve a ejecutar la simulación. Observa el tiempo que tarda en
      ejecutarse la simulación y el tamaño del archivo de datos generado.
      Visualiza los resultados y observa la diferencia con diferentes valores
      de SYSFREQ.

   4. Estudia el diseño del módulo 'crono2' en el archivo 'crono2.v'. Usa el
      banco de pruebas para ver si funciona igual que 'crono1'. ¿Qué ventajas
      y/o inconvenientes tiene 'crono2' sobre 'crono1'?

   4. Realiza un diseño 'chrono3' con el mismo comportamiento que 'chrono1' pero
      empleando una descripción estructural con las siguientes directrices:

      - El módulo chrono2 debe tener exactamente las mismas entradas y
        salidas que chrono (se puede simular con el mismo banco de pruebas)

      - Describe estos elementos en módulos independientes: divisor de
        frecuencia, contador de centésimas, contador de décimas, contador de
        unidades y contador de decenas. Define las entradas y salidas de estos
        módulos de forma conveniente.

      - Construye el módulo chrono2 como interconexión de los módulos
        anteriores, junto con la lógica adicional que sea necesaria.

    5. Simula el módulo chrono3 con el mismo banco de pruebas que chrono1 y
       comprueba que sus operaciones son idénticas.
*/
