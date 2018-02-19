// Diseño:      Sumador-restador en Ca2
// Archivo:     sumsub.v
// Descripción: Sumador-restador en complemento a 2
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       27/05/2010

/*
   Lección 5-2. Sumador-restador

   En esta lección haremos dos descripciones alternativas de un
   sumador/restador empleando operadores aritméticos, de forma parecida a como
   se hizo para el sumador en la lección anterior.

   En esta lección se introduce un concepto muy importante: las señales con
   signo; y se emplea la construcción 'parameter' para producir un módulo
   que emplea datos de anchura arbitraria.
*/

//////////////////////////////////////////////////////////////////////////
// Sumador-restador 1                                                   //
//////////////////////////////////////////////////////////////////////////

/* La descripción del módulo sumador/restador es muy similar a la del sumador
 * visto en la lección anterior. El módulo incluye una entrada adicional 'op'
 * que determina el tipo de operación: 0-suma, 1-resta; y una salida de
 * desbordamiento ('ov').
 *
 * La anchura de los datos no está prefijada, sino que depende del parámetro
 * WIDTH. Este parámetro tiene un valor predeterminado de 8 indicado por
 * la directiva 'parameter', pero puede cambiarse a la hora de instanciar el
 * módulo, por lo que la misma descripción sirve para producir
 * sumadores/restadores de cualquier anchura de datos. En general, cuantas
 * más características de un módulo sean parametrizadas, mayor flexibilidad
 * y posibilidades de reutilización tendrá el módulo.
 *
 * Las entradas 'a' y 'b', y la salida 'f' se declaran de tipo 'signed' por lo
 * que el simulador y el sintetizador asumen que estas señales contienen
 * número con signo en representación 'complemento a dos'. La declaración
 * 'signed' afecta a la interpretación del diseño de varias formas.
 * Por ejemplo: visualización de datos ($display), operaciones de
 * desplazamiento o la extensión de bits.
 *
 * En este ejemplo, tanto la declaración de parámetros [#(...)]como de tipos
 * de las entradas se realiza en la definición del módulo y no en el cuerpo, al
 * estilo ANSI. */

module sumsub1 #(
    parameter WIDTH = 8
    )(
    input wire signed [WIDTH-1:0] a,  // primer operando
    input wire signed [WIDTH-1:0] b,  // segundo operando
    input wire op,                    // operación (0-suma, 1-resta)
    output reg signed [WIDTH-1:0] f,  // salida
    output reg ov                     // desbordamiento
    );

    /* Recordamos: f y ov se declaran como variables (tipo 'reg') porque
     * van a usarse en un procedimiento 'always' */

    always @* begin :sub
        /* Definimos una variable local al bloque para realizar la
         * suma con un bit adicional. La definición de varialbes
         * locales es posible sólo si se nombra el bloque ('sub') en
         * este caso */
        reg signed [WIDTH:0] s;

        /* Aquí, la construcción 'if' hubiera sido igual de efectiva
         * que el 'case' pero, en general, cuando la decisión depende
         * de una sola variable (en este caso 'op') 'case' resulta más
         * claro, especialmente cuando el número de posibles valores
         * de la variable es elevado */
        case (op)
        0:
            s = a + b;
        default:
            s = a - b;
        endcase

        // Salida de desbordamiento
        /* 's' contiene el valor correcto de la operación. La
         * extensión del signo se realiza automáticamente ya que los
         * tipos son 'signed'. El desbordamiento puede detectarse si
         * comparamos el bit de signo del resultado correcto con el
         * del resultado sin extensión (s[WIDTH-1:0]) */
        if (s[WIDTH] != s[WIDTH-1])
            ov = 1;
        else
            ov = 0;

        // Salida
        f = s[WIDTH-1:0];
    end

endmodule // sumsub1

//////////////////////////////////////////////////////////////////////////
// Sumador-restador 2                                                   //
//////////////////////////////////////////////////////////////////////////

/* En la descripción de sumsub1 se emplean variables con signo y se realizan
 * las operaciones 'a + b' o 'a - b' según corresponda. Según la inteligencia
 * de la herramienta de síntesis utilizada, esto puede producir un diseño
 * con un único bloque sumador/restador o un diseño con un sumador y un
 * restador independites, que tiene mayor coste. Esta descripción alternativa
 * se emplean tipos sin signo, el cual es controlado directamente por el
 * diseñador. En caso de resta, el operando 'b' se complementa antes de
 * realizar la operación que será siempre de suma. Esta descripción (de más
 * bajo nivel) requiere más esfuerzo por parte del diseñador y es más difícil
 * de comprender y depurar, pero puede producir mejores resultados de síntesis.
 * En general, el diseñador puede consultar la documentación de la
 * herramienta de síntesis a utilizar en caso de que quiera hacer una
 * descripción óptima para la misma. */

module sumsub2 #(
    parameter WIDTH = 8
    )(
    input wire [WIDTH-1:0] a,  // primer operando
    input wire [WIDTH-1:0] b,  // segundo operando
    input wire op,             // operación (0-suma, 1-resta)
    output reg [WIDTH-1:0] f,  // salida
    output reg ov              // desbordamiento
    );

    always @* begin :sub
        /* Variable temporal para calcular el segundo operando */
        reg [WIDTH-1:0] c;

        /* Empleamos el operador condicional para calcular 'c', que
         * es un sustituto muy compacto de 'if'. En caso de resta 'c'
         * es el complemento a 1 (Ca1) de 'b' */
        c = op == 0? b: ~b;

        /* Calculamos el resultado. Si se trata de una resta, 'a' se
         * sumará con el complemento a 2 (Ca2 = Ca1 + 1) de 'b'
         * produciendo como resultado 'a - b' representado en Ca2. */
        f = a + c + op;

        // Salida de desbordamiento
        /* Sólo se produce desbordamiento cuando se suman número del
         * mismo signo, y sólo si el signo aparente del resultado
         * difiere del de los operandos */
        ov = ~a[WIDTH-1] & ~c[WIDTH-1] & f[WIDTH-1] |
             a[WIDTH-1] & c[WIDTH-1] & ~f[WIDTH-1];
    end

endmodule // sumsub2

/*
   EJERCICIOS

   1. Compila la lección con:

      $ iverilog sumsub.v

      Comprueba que no hay errores de sintaxis

   (continúa en sumsub_tb.v)
*/
