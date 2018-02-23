// Diseño:      azar
// Archivo:     azar.v
// Descripción: Demostración de azar
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       09/11/2009

/*
   Lección 3-2: Ejemplos combinacionales. Retrasos y azares.

   Un "azar" es un valor transitorio que puede presentar la salida de un
   circuito combinacional antes de que esta tome el valor definitivo. Los
   azares aparecen debido al retrado de propagación de los componentes
   digitales (puertas lógicas) y al hecho de que un circuito combinacional
   puede presentar varios caminos desde un puerto de entrada a uno de salida,
   cada uno con diferentes retrasos.

   La presencia de azares no significa que el circuito opere de forma
   incorrecta, ya que la salida al final tomará el valor correcto, pero puede
   ser un inconveniente en algunas aplicaciones, por lo que es interesante
   poder detectar su presencia e incluso rediseñar los circuitos para que
   no aparezcan.

   Para detectar la presencia de azares es necesario conocer la estructura
   interna del circuito y los retrasos de los componentes que lo forman.

   Este archivo contiene el diseño de la función:

      f(a,b) = ~a & b | a & b

   La implementación de esta función puede presentar un azar cuando b=1 y
   a cambia de 0 a 1 o de 1 a 0, ya que, si bien el valor final de f es
   uno tanto para a=0 como para a=1, su valor depende de términos diferentes.
   Si se consideran retrasos, un término puede hacerse 0 antes de que el otro
   sea 1, produciéndose el azar. En este ejemplo se describen dos circuitos
   que implementan dicha función, uno de ellos con una descripción funcional y
   otro mediante una descripción estructural mediante la conexión de puertas
   lógicas y considerando retrasos de propagación.

   El archivo azar_tb.v contiene el banco de pruebas para el test de este
   diseño.

   En este ejemplo también se introduce la definición de parámetros
   (parameter) dentro de un módulo y se trabaja un poco más con la definición
   de macros y su uso.
*/

`timescale 1ns / 1ps

//
// Descripción funcional
//
module hazard_f (
    input wire a,
    input wire b,
    output wire f
    );

    assign f = ~a & b | a & b;

endmodule // hazard_f

//
// Descripción estructural
//
module hazard_e #(
    // Retraso por defecto para las operaciones lógicas
    /* Dentro de un módulo se pueden definir "parámetros". Los parámetros
    * son constantes que pueden usarse dentro del módulo para facilitar el
    * diseño. A diferencia de las macros declaradas con "`define", los
    * parámetros son elementos del módulo en que se definen y no meras
    * directivas para el compilador. El valor definido para un parámetro
    * con "parameter" es un valor por defecto que puede redefinirse para
    * cada instancia del módulo. */
    parameter delay = 5
    )(
    input wire a,
    input wire b,
    output wire f
    );

    // Señales intermedias
    wire x, y, z;

    // Descripción estructural con puertas lógicas. Todas las puertas
    // tienen el mismo retraso, tomado del parámetro "delay".
    /*  Verilog permite indicar el retraso de la puerta usando la construcción
     * "#<delay_spec>" antes del nombre de la instancia. "<delay_spec>" puede
     * tener distintos formatos:
     *         x: un número. Indica el retraso en unidades de tiempo.
     *     (x,y): indica retrasos subida (salida cambia a 1) y de bajada
     *            (salida cambia a 0) diferenciados.
     *   (x,y,z): indica retraso de subida, bajada, y cambio a desconexión
     *            (alta impedancia) diferenciados.
     * A su vez, cada número, puede convertirse en una terna de valores
     * separados por ":" para indicar valores mínimo, típico y máximo del
     * retraso respectivamente. Ej: "#(1:2:3,2:4:5)". */
    not #delay inv(x, a);
    and #delay and1(y, a, b);
    and #delay and2(z, x, b);
    or #delay or1(f, y, z);

endmodule // hazard_e

/*
   (La lección continúa en el archivo azar_tb.v)
*/
