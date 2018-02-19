// Diseño:      sumador
// Archivo:     sumador.v
// Descripción: Ejemplos de sumadores combinacionales en Verilog
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       27/11/2009

/*
   Lección 5-1. Sumadores

   El sumador es el elemento básico de las unidades aritméticas. Un circuito
   sumador puede expresarse en Verilog de forma muy sencilla empleando
   operadores aritméticos. Más tarde, una herramienta de síntesis adecuada
   producirá un circuito sumador optimizado para la tecnología de
   implementación. No obstante, un sumador puede describirse a más bajo nivel
   como interconexión de sumadores completos (full adder -FA-).

   En esta lección comenzaremos con la descripción de un sumador comleto que
   servirá de base para dos descripciones estructurales equivalentes de un
   sumador de 8 bits. Luego se realizará una descripción de otro sumador
   equivalente empleando operaciones aritméticas. La operación de todos ellos
   y algunas variantes se comprueba por simulación en los ejercicios propuestos.
*/

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Sumador completo (FA)                                                //
//////////////////////////////////////////////////////////////////////////

/* Un sumador completo (FA) es un sumador de tres bits cuyo resultado se
 * genera en un bit de suma y un bit de acarreo según la siguiente tabla
 * de verdad
 *   x y cin z cout
 *   0 0 0   0 0
 *   0 0 1   1 0
 *   0 1 0   1 0
 *   0 1 1   0 1
 *   1 0 0   1 0
 *   1 0 1   0 1
 *   1 1 0   0 1
 *   1 1 1   1 1
 * Las expresiones lógica para las salidas z y cout pueden deducirse fácilmente
 * observando que z vale 1 si y sólo si la paridad de las entradas es impar, y
 * cout vale 1 si y sólo si cuales quierea dos de las entradas vale 1. */
module fa (
    input wire x,       // primer operando
    input wire y,       // segundo operando
    input wire cin,     // acarreo de entrada
    output wire z,      // salida de suma
    output wire cout    // acarreo de salida
    );

    assign  z = x ^ y ^ cin;
    assign  cout = x & y | x & cin | y & cin;
endmodule // fa

//////////////////////////////////////////////////////////////////////////
// Sumador 8 bits con FA                                                //
//////////////////////////////////////////////////////////////////////////

module adder8_e (
    input wire [7:0] a,     // primer operando
    input wire [7:0] b,     // segundo operando
    input wire cin,         // acarreo de entrada
    output wire [7:0] s,    // salida de suma
    output wire cout        // acarreo de salida
    );

    /* Este sumador se construye mediante la conexión en cascada de 8
     * sumadore completos (FA). Cada FA genera un bit del resultado. 'c'
     * es una señal auxiliar para la conexión del acarreo de salida de una
     * etapa con el acarreo de salida de la etapa siguiente */
    wire [7:1] c;

    /* El acarreo de entrada del primer FA es el acarreo de entrada del
     * módulo sumador */
    fa fa0 (a[0], b[0], cin, s[0], c[1]);
    fa fa1 (a[1], b[1], c[1], s[1], c[2]);
    fa fa2 (a[2], b[2], c[2], s[2], c[3]);
    fa fa3 (a[3], b[3], c[3], s[3], c[4]);
    fa fa4 (a[4], b[4], c[4], s[4], c[5]);
    fa fa5 (a[5], b[5], c[5], s[5], c[6]);
    fa fa6 (a[6], b[6], c[6], s[6], c[7]);
    /* El acarreo de salida del último FA es el acarreo de salida del
     * módulo sumador */
    fa fa7 (a[7], b[7], c[7], s[7], cout);

endmodule // adder8_e

//////////////////////////////////////////////////////////////////////////
// Sumador 8 bits con FA usando "generate"                              //
//////////////////////////////////////////////////////////////////////////

/* Esta es una descripción equivalente a adder8_e que emplea la construcción
 * 'generate' */
module adder8_g (
    input wire [7:0] a,     // primer operando
    input wire [7:0] b,     // segundo operando
    input wire cin,         // acarreo de entrada
    output wire [7:0] s,    // salida de suma
    output wire cout        // acarreo de salida
    );

    /* En este caso, los acarreos intermedios se definen desde 0 a 8 para
     * que todas las instancias FA puedan expresarse en función de un mismo
     * índice. El primer acarreo (C[0]) corresponde al acarreo de entrada
     * y el último (c[8]) al acarreo de salida del módulo sumador */
    wire [8:0] c;
    assign c[0] = cin;
    assign cout = c[8];

    /* La construcción 'generate' facilita la generación de código en
     * fúnción de una variable o índice, simplificando la descripción de
     * estructuras repetitivas. La variable que controla la generación de
     * código es un entero y debe declararse con 'genvar' dentro o fuera
     * del bloque'generate'. Dentro de un bloque 'generate' pueden usarse
     * tres tipos de estructuras de control: 'if', 'case' y 'for', que no
     * deben confundirse con los equivalentes de las descripciones
     * procedimentales. Es importante observar que los bloque 'generate' se
     * expanden durante la elaboración del diseño y antes de la síntesis,
     * por lo que los valores de las variables declaradas con 'genvar'
     * deben estar determinados en el momento de la elaboración. En nuestro
     * ejemplo, los módulos adder8_e y adder8_g producen diseños idénticos
     * tras la elaboración inicial. */
    generate
        /* Declaramos la variable de la que depende 'generate' */
        genvar i;
        /* Bucle for asociado al bloque 'generate'. Aunque similar,
         * conceptualmente es diferente al bucle 'for' de una
         * descripción procedimental como la de la construcción
         * 'always'. */
        for (i=0; i < 8; i=i+1)
            /* Se genera una instancia para cada valor de i */
            fa fa_ins (a[i], b[i], c[i], s[i], c[i+1]);
    endgenerate

endmodule // adder8_g

//////////////////////////////////////////////////////////////////////////
// Sumador de 8 bits con operadores aritméticos                         //
//////////////////////////////////////////////////////////////////////////

module adder8 (
    input wire [7:0] a,     // primer operando
    input wire [7:0] b,     // segundo operando
    input wire cin,         // acarreo de entrada
    output wire [7:0] s,    // salida de suma
    output wire cout        // acarreo de salida
    );

    assign {cout, s} = a + b;

endmodule // adder8

/*

   EJERCICIOS

   1. Compila la lección con:

      $ iverilog sumador.v

      Comprueba que no hay errores de sintáxis

   2. Escribe un banco de pruebas el módulo 'fa' en un archivo 'fa_tb.v' de
      forma que compruebe su correcto funcionamiento para todos los valores
      de entrada. Puedes usar 'sumador_tb.v' como referencia. Compila el diseño
      con:

      $ iverilog sumador.v fa_tb.v

      y comprueba su operación con:

      $ vvp a.out

   (continúa en sumador_tb.v)
*/
