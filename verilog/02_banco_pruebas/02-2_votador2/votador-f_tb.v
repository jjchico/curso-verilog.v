// Diseño:      votador
// Archivo:     votador_tb-2.v
// Descripción: Simulación con banco de pruebas (test bench)
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       10-11-2009

/*
   Lección 2-2: Simulación con banco de pruebas

   En este archivo se define un banco de pruebas para simular y comparar
   los resultados de dos implementaciones de un circuito votador: el módulo
   "votador" corresponde a una descripción procedimental mientras que el
   módulo "votador_f" se ha realizado mediante una descripción funcional con
   asignamiento continuo.

   En este banco de pruebas se instancian ambos módulos y se generan las
   mismas señales de excitación para ambos.
*/

// Definimos la escala de tiempo para el simulador
`timescale 1ns / 1ps

module test2();

    // Declaramos variables internas
    //   entradas: a, b y c
    //   salidas: v, v_f
    reg a, b, c;
    wire v, v_f;

    // Instanciamos las unidades bajo test (uut)
    /* En este ejemplo se instancia una UUT para cada una de las
     * del circuito votador */
    votador uut (.v(v), .a(a), .b(b), .c(c));
    votador_f uutf (.v(v_f), .a(a), .b(b), .c(c));

    /* El resto del banco de pruebas es idéntico al empleado en
     * votador_tb.v. */
    initial begin
        // Inicializamos las entradas
        a = 0;
        b = 0;
        c = 0;

        // Generamos formas de onda para visualización posterior
        $dumpfile("votador-f_tb.vcd");
        $dumpvars(0, test2);

        // Finalizamos la simulación en t=100
        #100 $finish;
    end

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

   2. Compila el diseño completo (módulos votador y banco de pruebas con el
      siguiente comando:

    $ iverilog ../02-1_votador1/votador.v votador-f.v votador-f_tb.v

   3. Simule el diseño con:

    $ vvp a.out

   4. Compruebe el resultado de simulación con gtkwave:

    $ gtkwave votador-f_tb.vcd &

   5. Observe que ambos circuitos (v y v_f) hacen la operación correcta,
      esto es, que la señal "v" vale "1" sólo cuando dos o más de las
      entradas valen "1". De no ser así, compruebe los diseños originales
      en los archivos "votador.v" y "votador-f.v", haga las correcciones
      necesarias y vuelva a compilar y simular el diseño hasta que la
      operación sea la correcta.

      Nota: puede releer los nuevos resultados de la simulación en gtkwave
      con la opción "File->Reload Waveform" o pulsando "Mayúsc+Ctrl+R".

   6. Diseñe un circuito votador de 5 entradas (a,b,c,d,e) de forma que su
      salida v sea 1 si 3 o más de las entradas valen 1. Diseñe un banco de
      pruebas en un archivo independiente para comprobar la correcta operación
      del circuito en todos los casos. Haga la comprobación generando los
      resultados tanto en formato texto ($monitor) como en formas de onda.
*/
