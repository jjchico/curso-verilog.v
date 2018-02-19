// Diseño:      votador
// Archivo:     votador.v
// Descripción: Simulación con banco de pruebas (test bench)
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       10-11-2009

/*
   Lección 2-1: Simulación con banco de pruebas

   En esta lección veremos cómo separar la descripción de un módulo de circuito
   del proceso para simularlo.

   El proceso de síntesis lógica automática consiste básicamente en aplicar
   herramientas informáticas que traducen descripciones funcionales y/o
   procedimentales en descripciones completamente estructurales compuestas por
   componentes sencillos previamente diseñados, lo que permite pasar
   directamente a la implementación o fabricación del circuito. Para que una
   descripción funcional y/o procedimental pueda ser sintetizada automáticamente
   debe cumplir una serie de restricciones, esto es, ser lo bastante simple como
   para que su síntesis pueda automatizarse. Un código de este tipo se llama
   sintetizable. En este curso, todo el código se ha realizado con la intención
   de que pueda ser sintetizado por cualquier herramienta de síntesis estándar.
   La documentación del software de síntesis y del fabricante de la tecnología
   empleada suele contener información valiosa sobre la mejor forma de realizar
   una descripción en Verilog de forma que se asegure o mejore el posterior
   proceso de síntesis.

   En las lecciones anteriores hemos realizado ejemplos empleando un único
   módulo que contenía tanto la descripción del circuito como directivas para
   generar señales de test y observar el resultado de la simulación del
   circuito. El conjunto de direcitvas que tienen como objeto la simulación y
   comprobación de la correcta operación del circuito recibe el nombre de "banco
   de pruebas" ("test bench" en inglés).

   En general no es buena idea definir un diseño y su banco de pruebas en un
   mismo módulo ya que esto dificulta e incluso imposibilita el empleo del
   diseño compo parte de un diseño más complejo, así como la síntesis automática
   del diseño. El banco de pruebas es útil durante la fase de diseño, pero es
   algo que normalmente no es útil sintetizar, no queremos sintetizar y, a
   menudo, no es posible sintetizar, ya que se compone de directivas que no
   tienen sentido en el proceso de síntesis como "$monitor" o "$dumpvars".

   La forma de proceder consiste en definir el circuito completo o sus partes en
   módulos independientes y el banco de pruebas en un módulo aparte. Estos
   módulos pueden definirse en un mismo archivo o en archivos diferentes, que es
   lo habitual.

   Este archivo contiene el diseño de un circuito votador que usaremos como
   ejemplo, mientras que el archivo votador_tb.v contiene el banco de pruebas
   para la comprobación de este diseño con las explicaciones pertinentes.

   Un circuito votador implementa la función mayoría. Su salida es el valor
   mayoritario de sus entradas. En nuestro ejemplo el circuito tiene tres
   entradas, por lo que la salida valdrá uno si dos o más de las entradas valen
   uno, y valdrá cero si dos o más de sus entradas valen cero. Los circuitos
   votadores tienen aplicación en sistemas redundantes, donde es necesario
   decidir cual es el valor correcto más probable de entre las salidas de varios
   sistemas idénticos que pueden presentar fallos de operación.
*/

// Definimos la escala de tiempo para el simulador
`timescale 1ns / 1ps

/* En este módulo definimos las señales de entra y salida que serán visibles
 * desde el exterior. De esta forma podremos usar el módulo como componente
 * en otros diseños y en un banco de pruebas. */
module votador (
    output reg v,
    input wire a,
    input wire b,
    input wire c
    );

    /* Describimos el circuito mediante un procedimiento usando una
     * estructura "case". "case" es más simple que "if-else" si todas las
     * condiciones dependen de una única variable. La condición "default"
     * es opcional pero nos asegura que tendremos en cuenta todos los
     * casos. */
    always @(a, b, c)
        case(a)     // hacemos una cosa u otra en función de lo que
                    // valga a
        1:          // hacemos esto si a=0
            v = b | c;
        default:    // hacemos esto si a=1 (a!=0)
            v = b & c;
        endcase

endmodule // votador

/*
   EJERCICIO

   1. Comprueba que el archivo no tiene errores copilándolo con:

      $ iverilog votador.v

   La lección sigue en el archivo votador_tb.v.
*/
