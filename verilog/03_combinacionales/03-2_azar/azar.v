// Diseño:      azar
// Archivo:     azar.v
// Descripción: Demostración de azar
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       09/11/2009

/*
   Lección 3-2: Ejemplos combinacionales. Demostración de azar.

   Este archivo contiene el diseño de la función:

      f(a,b) = ~a & b | a & b

   La implementación de esta función puede presentar un azar cuando b=1 y
   a cambia de 0 a 1 o de 1 a 0, ya que, si bien el valor final de f es
   uno tanto para a=0 como para a=1, su valor depende de términos diferentes.
   Si se consideran retrasos, un término puede hacerse 0 antes de que el otro
   sea 1, produciéndose el azar.

   El archivo azar_tb.v contiene el banco de pruebas para el test de este
   diseño.

   En este ejemplo también se introduce la definición de parámetros
   (parameter) dentro de un módulo y se trabaja un poco más con la definición
   de macros y su uso.
*/

`timescale 1ns / 1ps

module azar(
    input a,
    input b,
    output f
    );

    // Retraso por defecto para las operaciones lógicas
    /* Dentro de un módulo se pueden definir "parámetros". Los parámetros
     * son constantes que pueden usarse dentro del módulo para facilitar el
     * diseño. A diferencia de las macros declaradas con "`define", los
     * parámetros son elementos del módulo en que se definen y no meras
     * directivas para el compilador. El valor definido para un parámetro
     * con "parameter" es un valor por defecto que puede redefinirse para
     * cada instancia del módulo. */
    parameter delay = 5;

    // Señales intermedias
    wire x, y, z;

    /* Modelamos la función definiendo señales intermedias y asignando
     * valores continuos. De esta forma podemos especificar el retraso para
     * cada operación consiguiendo un modelo más realista del circuito que
     * implementa la función requerida. En este ejemplo se asigna el mismo
     * retraso a cada operación fundamental. */
    assign #delay x = ~a;
    assign #delay y = a & b;
    assign #delay z = x & b;
    assign #delay f = y | z;

endmodule    // azar

/*
   (La lección continúa en el archivo azar_tb.v)
*/
