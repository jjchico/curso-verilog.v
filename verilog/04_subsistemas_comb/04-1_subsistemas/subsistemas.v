// Diseño:      subsistemas
// Archivo:     subsistema.v
// Descripción: Ejemplos de subsistemas combinacionales en Verilog
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       27/11/2009

/*
   Lección 4-1: Subsistemas combinacionales

   Las herramientas de síntesis automática de circuitos digitales emplean
   algoritmos para inferir los elementos de circuito más adecuados
   (decodificadores, multiplexores, comparadores, etc.) a la hora de
   implementar la funcionalidad descrita en un lenguaje de descripción de
   hardware. Para que el proceso sea eficiente, el diseñador debe poner
   especial atención en hacer descripciones simples y compatibles con los
   algoritmos de síntesis. Las descripciones tienen estas características se
   denominan "descripciones sintetizables".

   Se pueden enumerar multitud de criterios y recomendaciones con objeto de que
   una descripción sea sintetizable, pero todos ellos pueden resumirse en la
   siguiente frase:

     "Si el diseñador no es capaz de intuir cómo hacer la síntesis de una
     determinada descripción, la herramienta de síntesis, probablemente,
     tampoco".

   Durante el proceso de síntesis, las herramientas informan de los elementos
   que van a emplear para implementar una descripción.

   Esta lección consta de tres partes separadas en tres archivos diferentes que
   deben seguirse en el orden indicado:

   subsistemas.v (este archivo): contiene ejemplos de diseño de diferentes
   subsistemas y un banco de pruebas para cada uno de ellos.

   bcd-7.v: contiene la especificación de un convertidor de código BCD a 7
   segmentos, el cual debe diseñarse como ejercicio.

   analisis.v: contiene un ejercicio en el que se debe describir y simular en
   Verilog un circuito suministrado como esquema.
*/

//////////////////////////////////////////////////////////////////////////
// Decodificador 3:8                                                    //
//////////////////////////////////////////////////////////////////////////

module dec8 (
    input wire en,          // habilitación (enable) activo en bajo
    input wire [2:0] i,     // entradas
    output reg [7:0] o      // salidas
    /* Recuerda: para cada puerto de entrada o salida, el compilador define
    * una señal tipo 'wire' del mismo nombre. El tipo de señal puede
    * cambiarse declarándola explícitamente. Aquí se declara 'o' como reg
    * ya que va a emplearse como variable en un proceso 'always'. */
    );

    always @(en, i) begin
        if (en == 1)
            o = 8'h00;    // decodificador deshabilitado
        else begin
            case (i)
            /* Empleamos formato hexadecimal para "i" y binario
             * para "o" para facilitar la interpretación del
             * código. "_" es un separador opcional que facilita
             * la lectura de literales largos */
            3'h0:    o = 8'b0000_0001;
            3'h1:    o = 8'b0000_0010;
            3'h2:    o = 8'b0000_0100;
            3'h3:    o = 8'b0000_1000;
            3'h4:    o = 8'b0001_0000;
            3'h5:    o = 8'b0010_0000;
            3'h6:    o = 8'b0100_0000;
            /* Es una buena costumbre usar "default" para el
             * último caso, aunque sea conocido, de esta forma
             * nos aseguramos de considerar todos los casos */
            default: o = 8'b10000000;
            endcase
        end
    end
endmodule // dec8

//////////////////////////////////////////////////////////////////////////
// Multiplexor 8:1                                                      //
//////////////////////////////////////////////////////////////////////////

module mux8_1 (
    input wire [2:0] sel,   // entradas de selección
    input wire [7:0] in,    // entradas de datos
    output reg out          // salida
    );

    always @(sel, in)
        /* La forma más directa de describir un multiplexor es mediante
         * un bloque 'case'. */
        case (sel)
        3'h0:    out = in[0];
        3'h1:    out = in[1];
        3'h2:    out = in[2];
        3'h3:    out = in[3];
        3'h4:    out = in[4];
        3'h5:    out = in[5];
        3'h6:    out = in[6];
        default: out = in[7];
        endcase
endmodule // mux8_1

//////////////////////////////////////////////////////////////////////////
// Codificador de prioridad binario                                     //
//////////////////////////////////////////////////////////////////////////

module cod8 (
    input wire [7:0] in,    // entradas
    output reg [2:0] out,   // salida condificada
    output reg e            // salida de error (1-ninguna entrada activa)
    );

    always @(in) begin
        /* 'e' valdrá cero salvo que alguna condición posterior
         * cambie su valor */
        e = 0;
        /* 'case' también es una buena forma de describir el
         * codificador porque la decisión se toma en función de una
         * única señal (in). 'casex' es como 'case' pero trata valores
         * desconocidos ('x') como inespecificaciones, lo que permite
         * expresar de forma muy compacta las comparaciones. */
        casex (in)
        8'b1xxxxxxx: out = 3'h7;
        8'b01xxxxxx: out = 3'h6;
        8'b001xxxxx: out = 3'h5;
        8'b0001xxxx: out = 3'h4;
        8'b00001xxx: out = 3'h3;
        8'b000001xx: out = 3'h2;
        8'b0000001x: out = 3'h1;
        8'b00000001: out = 3'h0;
        default: begin    // ninguna entrada activa
            out = 3'h0;
            e = 1;
        end
        endcase
    end
endmodule // cod8

//////////////////////////////////////////////////////////////////////////
// Comparador de 4 bits                                                 //
//////////////////////////////////////////////////////////////////////////

module comp4 (
    input wire [3:0] a, // número a
    input wire [3:0] b, // número b
    input wire g0,      // entradas para conexión en cascada
    input wire e0,      // y salidas de la comparación
    input wire l0,      //   si a > b => (g,e,l) = (1,0,0)
    output reg g,       //   si a < b => (g,e,l) = (0,0,1)
    output reg e,       //   si a = b => (g,e,l) = (g0,e0,l0)
    output reg l
);

    /* Obsérvese cómo se ha empleado el operador de concatenación '{...}'
     * que combina varios vectores para formar un vector mayor. Aquí se ha
     * empleado para hacer más claras y compactas las asignaciones de
     * valores a 'g', 'e' y 'l'. */
    always @(a, b, g0, e0, l0) begin
        if (a > b)
            {g,e,l} = 3'b100;
        else if (a < b)
            {g,e,l} = 3'b001;
        else
            {g,e,l} = {g0,e0,l0};
    end
endmodule

/*
 * BANCOS DE PRUEBA
 *
 * Este archivo contiene un banco de pruebas para cada módulo diseñado. La
 * ejecución de cada banco de pruebas se controla mediante la definición de
 * macros en el momento de la compilación (opción -D o similar del compilador).
 * Las macros empleadas son:
 *    TEST_DEC: decodificador
 *    TEST_MUX: multiplexor
 *    TEST_COD: codificador de prioridad
 *    TEST_COMP: comparador
 */

// Banco de pruebas para dec8

`ifdef TEST_DEC

module test ();

    reg [3:0] count;    // contador para facilitar el test
    wire enable;        // habilitación
    wire [2:0] in;      // entrada del decodificador
    wire [7:0] out;     // salida del decodificador

    dec8 uut(.en(enable), .i(in), .o(out));

    /* Empleamos el registro auxiliar 'count' para facilitar la generación
     * de todos los posibles valores de entrada al contador. Un bit de
     * 'count' se asigna a la entrada de habilitación y el resto a las
     * entradas de datos. */
    assign enable = count[3];
    assign in = count[2:0];

    initial begin
        // Iniciamos las entradas
        count = 0;

        // Generamos la salida
        $display("en in  out");
        $monitor("%b  %h   %b", enable, in, out);

        // Finalizamos la simulación
        #160 $finish;
    end

    /* Para generar todos los posibles valores de entrada basta con
     * ir incrementando el valor de 'count' cada cierto tiempo. */
    always
        #10 count = count + 1;
endmodule // test

// Banco de pruebas para mux8_1

`elsif TEST_MUX

module test ();

    reg [2:0] sel;                // entrada de selección
    wire [7:0] in = 8'b01010101;  // entrada de datos con valor fijo
    wire out;                     // salida del multiplexor

    mux8_1 uut(.sel(sel), .in(in), .out(out));

    initial begin
        sel = 0;

        $display("sel out");
        $monitor("%h   %b", sel, out);

        #80 $finish;
    end

    /* Para comprobar el multiplexor vamos seleccionando todas las
     * entradas una a una y comprobamos que la salida es correcta. */
    always
        #10 sel = sel + 1;

endmodule // test

// Banco de pruebas para cod8

`elsif TEST_COD

module test ();

    reg  [23:0] data;  // señal auxiliar para test
    wire [7:0] in;     // entrada del codificador
    wire [2:0] out;    // salida del codificador
    wire e;            // salida de error (1-ninguna entrada a 1)

    /* La entrada al codificador se toma de los 8 bits más significativos
     * de 'data' */
    assign in = data[23:16];
    cod8 uut(.in(in), .out(out), .e(e));

    initial begin
        /* 'data' se emplea para contener los datos a aplicar como
         * entrada al codificador. Los datos se aplican sucesivamente
         * desplazando el contenido de 'data' a la izquierda. El valor
         * inicial de 'data' permite observar el funcionamiento del
         * codificador cuando se activa una sola entrada o cuando se
         * activan varias con objeto de comprobar que la prioridad
         * funciona correctamente. Por claridad el valor inicial se
         * expresa en binario. Los '_' son separadores opcionales que
         * facilitan la lectura de literales con muchas cifras. */
        data = 24'b00000001_00000000_11111111;

        $display("in       out e");
        $monitor("%b %h   %b", in, out, e);

        #240 $finish;
    end

    /* Desplazamos 'data' a la izquierda cada cierto tiempo para aplicar
     * los diferentes valores de entrada. Observe el operador de
     * desplazamiento '<<'. */
    always
        #10 data = data << 1;    // desplaza un bit a la izquierda
endmodule // test

// Banco de pruebas para comp4

`elsif TEST_COMP

`ifndef NP
    `define NP 20    // número de patrones a aplicar en el test
`endif
`ifndef SEED
    `define SEED 1   // semilla inicial para generar patrones aleatorios
`endif

module test ();

    reg g0, e0, l0;        // entradas en cascada
    reg [3:0] a;           // número 'a'
    reg [3:0] b;           // número 'b'
    wire g, e, l;          // resultado de la comparación
    integer np;            // variable auxiliar (número de patrones)
    integer seed = `SEED;  // variable auxiliar (semilla)

    comp4 uut(.a(a), .b(b), .g0(g0), .e0(e0), .l0(l0), .g(g), .e(e), .l(l));

    initial begin
        /* 'np' se empleará como contador del número de patrones de
         * test a aplicar. Su valor inicial se carga de la macro 'NP' */
        np = `NP;
        /* Las entradas en cascada se fijan al valor '010' */
        {g0,e0,l0} = 3'b010;

        $display("A B  g0e0l0  g e l");
        $monitor("%h %h  %b %b %b   %b %b %b",
                   a, b, g0, e0, l0, g, e, l);
    end

    /* Cada 10ns 'a' y 'b' se asignan con valores aleatorios. El contador
     * 'np' se decrementa para finalizar la simulación después de un
     * cierto número de patrones aplicados. Puede cambiarse el número
     * de patrones definiendo un valor diferente de 'NP'. Pueden probarse
     * otras secuencias pseudoaleatorias definiendo un valor diferente de
     * 'SEED' */
    always begin
        #10
        a = $random(seed);
        b = $random(seed);
        np = np - 1;
        if (np == 0)
            $finish;
    end
endmodule

`else

// Banco de pruebas informativo. Muestra opciones de compilación.

module info ();

    initial begin
        $display("Seleccione un banco de pruebas definiendo una ",
          "de las siguientes macros:");
        $display("  TEST_DEC: decodificador");
        $display("  TEST_MUX: multiplexor");
        $display("  TEST_COD: codificador de prioridad");
        $display("  TEST_COMP: comparador de magnitudes");
        $display("    SEED: semilla para patrones aleatorios ",
          "(opcional)");
        $display("    NP: numero de patrones a aplicar (opcional)");
        $display("Ejemplos:");
        $display("  iverilog -DTEST_DEC subsistemas.v");
        $display("  iverilog -DTEST_COMP -DNP=200 subsistemas.v");
        $finish;
    end
endmodule

`endif

/*
   EJERCICIOS

   1. Compruebe cada módulo definido en este archivo ejecutando sus
      correspondientes bancos de prueba.

   2. Basándose en el comparador de 4 bits de ejemplo (comp4) diseñe un
      comparador (comp8) y su banco de pruebas de modo que:
      - El comparador opere sobre números de 8 bits.
      - No tenga entradas en cascada.
      - Su banco de pruebas muestre los número 'a' y 'b' en decimal.
      - El banco de pruebas simule 100 patrones por defecto.
      Realice el diseño en archivos aparte y compruebe su correcto
      funcionamiento.
*/
