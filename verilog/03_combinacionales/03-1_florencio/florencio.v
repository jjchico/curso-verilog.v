// Diseño:      florencio
// Archivo:     florencio.v
// Descripción: Resolución de problema social mediante Verilog
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       09/11/2009

/*
   Lección 3-1: Ejemplos combinacionales

   Este archivo contiene la descripción de un circuito y su banco de pruebas
   para la resolución del siguiente problema:

   Florencio va a ir a una fiesta esta noche, pero no solo. Tiene cuatro
   nombres en su agenda: Ana, Bea, Carmen y Diana. Puede invitar a más de
   una chica pero no a las cuatro. Para no romper corazones, ha
   establecido las siguientes normas:
    - Si invita a Bea, debe invitar también a Carmen.
    - Si invita a Ana y a Carmen, deberá también invitar a Bea o a Diana.
    - Si invita a Carmen o a Diana, o no invita a Ana, deberá invitar
      también a Bea.
   Antes de llamarlas por teléfono, quiere utilizar un circuito que le indique
   cuándo una elección no es correcta. Ayúdele a diseñar el circuito mediante
   Verilog.
*/

`timescale 1ns/1ps

module florencio(
    output f,   // salida: 1-elección correcta, 0-elección incorrecta
    input a,    // invita a Ana: 0-no invita, 1-sí invita
    input b,    // invita a Bea
    input c,    // invita a Carmen
    input d     // invita a Diana
    );

    reg f;

    always @(a, b, c, d)
    begin
        f = 1;  // asignación correcta salvo que se incumpla
                // alguna condición
        if (a && b && c && d)
            f = 0;        // no puede invitar a las cuatro
        if (!a && !b && !c && !d)
            f = 0;        // tiene que invitar a alguna
        if (b && !c)
            f = 0;        // ha invitado a Bea pero no a Carmen
        if (a && c)
            if (!b && !d)
                f = 0;    // ha invitado a A. y a C.
                          // pero no a B. o D.
        if ((c || d || !a) && !b)
            f = 0;        // debería haver invitado a Bea
    end
endmodule // florencio

/* `define es una directiva del compilador equivalente al "#define" del
 * preprocesador en "C". Permite definir macros que serán sustituidas en el
 * código allá donde se encuentren. `ifdef es otra directiva del compilador que
 * permite incluir código condicional en función de que una macro esté definida
 * o no. En este ejemplo se usa para incluir el código correspondiente al banco
 * de pruebas en caso de que se defina la macro "TEST". La definición de esta
 * macro puede hacerse en el mismo archivo mediante `define o en la invocación
 * del compilador. */

// Descomenta la siguiente línea para incluir banco de pruebas por defecto
// `define TEST 1

`ifdef TEST

// Banco de pruebas

/* Definimos el tiempo base para los patrones de test mediante otra macro.
 * Esto simplifica posibles modificaciones posteriores. Los nombres de macros
 * suelen definirse en mayúsculas, aunque el lenguaje no impone ninguna
 * restricción en este aspecto. Recuerda que Verilog, al igual que C, es
 * sensible a la capitalización. */
`define BTIME 10

module test();

    reg a = 0, b = 0, c = 0, d = 0;
    wire f;

    florencio uut(f, a, b, c, d);

    initial begin
        // Generamos la tabla de verdad de la función
        $display("d c b a | f");
        $monitor("%b %b %b %b | %b", d, c, b, a, f);

        // Descomenta las siguientes líneas para generar formas de onda
        // $dumpfile("florencio.vcd");
        // $dumpvars(0, test);

        /* Fijamos el tiempo de simulación en función de BTIME. con 16
         * veces BTIME recorremos todos los casos de entrada. Verilog,
         * al igual que los lenguajes de programación, dispone
         * de operadores aritméticos además de los operadores
         * lógicos: suma (+), resta (-), multiplicación (*) y
         * división (/). */
        #(16 * `BTIME) $finish;
    end

    always
        #(`BTIME) a = ~a;
    always
        #(2 * `BTIME) b = ~b;
    always
        #(4 * `BTIME) c = ~c;
    always
        #(8 * `BTIME) d = ~d;
endmodule // test
`endif

/*
EJERCICIO

1. Compila el diseño incluyendo el banco de pruebas. Para ello indica al
   compilador que defina la macro TEST en la línea de comandos. La opción
   "-DTEST" define la macro TEST con el valor 1.

   $ iverilog -DTEST florencio.v

2. Simula el diseño con el comando siguiente y comprueba que se obtiene el
   resultado esperado, esto es, que la salida no viola ninguna de las
   condiciones requeridas en el enunciado del problema.

   $ vvp a.out

3. Modifica el banco de pruebas para que se generen formas de onda.
   Comprueba el resultado visualizando las ondas con "gtkwave".

   $ gtkwave florencio.vcd &

4. Modifica el banco de pruebas para que la generación de formas de onda
   sea opcional en función de la definición de una macro "WAVES", de forma que
   la compilación con el comando

   $ iverilog -DTEST -DWAVES florencio.v

   produzca un archivo de formas de onda.
*/
