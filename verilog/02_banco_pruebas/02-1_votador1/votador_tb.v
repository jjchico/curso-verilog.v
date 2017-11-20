// Diseño:      votador
// Archivo:     votador_tb.v
// Descripción: Simulación con banco de pruebas (test bench)
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       10-11-2009

/*
   Lección 2-1: Simulación con banco de pruebas

   Este archivo contiene el módulo "test" que es un banco de pruebas para
   comprobar el correcto funcionamiento del módulo "votador". El banco de
   pruebas contiene tres elementos principales:

   - El circuito a testar: normalmente una instancia del circuito a testar
     diseñado como módulo en algún otro archivo.

   - Directivas para la generación de las señales a aplicar a las entradas
     del circuito a testar.

   - Directivas para visualizar la salida del circuito durante la simulación
     con objeto de comprobar su correcto funcionamiento.
*/

// Definimos la escala de tiempo para el simulador
`timescale 1ns / 1ps

/* El banco de pruebas no tiene señales externas. Es un circuito autónomo. */
module test();

    // Declaramos variables internas
    //   entradas: a, b y c
    //   salida: v
    reg a, b, c;
    wire v;

    // Instanciamos la unidad bajo test (uut)
    /* La UUT es nuestro circuito votador. La instancia se conecta a las
     * señales previamente definidas que, en este caso, tienen el mismo
     * nombre que en la definición del módulo votador. Se ha hecho una
     * conexión explícita: ".a" es la entrada a en la definición del módulo
     * "votador" y "a" es la señal de conexión definida en el banco de
     * pruebas.  Alternativamente podría haberse usado una conexión
     * implícita situando las señales en la instancia en el mismo orden que
     * en la definición del módulo:
     *        votador uut (v, a, b, c);
     */
    votador uut (.v(v), .a(a), .b(b), .c(c));

    /* En este bloque initial se inicializan las señales que usaremos como
     * entradas a la UUT y se incluyen las directivas de simulación */
    initial begin
        // Inicializamos las entradas
        a = 0;
        b = 0;
        c = 0;

        // Generamos formas de onda para visualización posterior
        $dumpfile("votador_tb.vcd");
        $dumpvars(0, test);

        // Finalizamos la simulación en t=100
        #100 $finish;
    end

    /* Las directivas siguientes generan las señales o patrones de entrada
     * que se aplicarán a la UUT para su testado */
    // a, b, c recorren todos los casos
    always
        #5 a = ~a;
    always
        #10 b = ~b;
    always
        #20 c = ~c;

endmodule // test

/*
   EJERCICIO

   2. Compila el diseño completo (módulo votador y banco de pruebas con el
      siguiente comando:

        $ iverilog votador.v votador_tb.v

      Nótese que votador_tb.v emplea el módulo "votador" definido en
      votador.v. El compilador detecta automáticamente que este módulo está
      definido en el archivo votador.v y genera un código compilado del
      diseño completo en el archivo de salida a.out.

   3. Simule el diseño con:

     $ vvp a.out

   4. Compruebe el resultado de simulación con gtkwave:

     $ gtkwave votador_tb.vcd &

   5. Observe que el circuito hace la operación correcta, esto es, que la
      señal "v" vale "1" sólo cuando dos o más de las entradas valen "1". De
      no ser así, compruebe el diseño original en el archivo "votador.v", haga
      las correcciones necesarias y vuelva a compilar y simular el diseño
      hasta que la operación sea la correcta.

      Nota: puede releer los nuevos resultados de la simulación en gtkwave
      con la opción "File->Reload Waveform" o pulsando "Mayúsc+Ctrl+R".
*/
