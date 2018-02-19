// Diseño:      block
// Archivo:     block.v
// Descripción: Asignación con y sin bloqueo
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       05/06/2010

/*
   Lección 6-3: Asignaciones con bloqueo y sin bloqueo.

   Un concepto muy importante a la hora de describir circuitos en Verilog es
   la diferencia entre las asignaciones con bloqueo (representadas por '=') y
   las asignaciones sin bloqueo (representadas por '<=') que pueden aparecer
   dentro de los procesos ('always' o 'initial'). La diferencia radica en la
   forma en que el simulador trata cada asignamiento y en la forma en que las
   herramientas de síntesis interpretan la funcionalidad que queremos
   describir.

   Asignaciones con bloqueo

   En las asignaciones con bloqueo ('=') se evalúa la parte derecha de la
   expresión y se asigna el valor a la parte izquierda antes de pasar a la
   siguiente expresión. Esta asignación es equivalente a la asignación de
   variables en el software. El orden de las asignaciones importa, por lo que
   el código:

   q1 = 0; q2 = 1;
   q1 = q2;
   q2 = q1;

   tendrá como resultado q1 = q2 = 1, mientras que el código:

   q1 = 0; q2 = 1;
   q2 = q1;
   q1 = q1;

   tendrá como resultado q1 = q2 = 0.

   Las asignaciones con bloqueo se emplean para describir comportamiento
   combinacional dentro de descripciones procedimentales, donde una variable
   puede ser asignada varias veces e interesa el valor final que obtenga.

   Asignaciones sin bloqueo

   En las asignaciones sin bloqueo ('<=') se evalúa la parte derecha de la
   expresión y el valor obtenido se guarda para su uso posterior, pero no se
   asigna a la parte izquierda de la expresión hasta que no se han evaluado
   todas las expresiones sin bloqueo en el procedimiento. De este modo, el
   orden en que son evaluadas estas asignaciones es irrelevante, de forma que
   el código:

   q1 = 0; q2 = 1;
   q1 <= q2;
   q2 <= q1;

   tendrá el mismo resultado que el código:

   q1 = 0; q2 = 1;
   q2 <= q1;
   q1 <= q1;

   esto es, q1 = 1, q2 = 0

   Las asignaciones sin bloqueo representan bien el comporatamiento de
   elementos secuenciales: la parte derecha de la expresión representa el
   próximo estado, que no se hará efectivo hasta que se produzca el evento que
   hace que se evalúe el procedimiento (típicamente una condición 'posedge'
   o 'negedge').

   Como regla general se debe usar '=' para asignar variables que representan
   funciones combinacionales, y se debe usar '<=' para asignar variables que
   puedan almacenar un valor.

   En esta lección veremos dos versiones de un circuito con dos elementos
   de memoria (q1 y q2) cuyo objetivo es conmutar el contenido de estos
   elementos con cada flanco positivo de la señal de reloj. El circuito tiene
   una señal de carga 'load' y otra de dato 'd' que permite cargar un valor
   en 'q1' desde el exterior con objeto de poder inicializar el dispositivo
   a un estado conocido.

   En la primera descripción (swap1) se emplean asignaciones con bloqueo y el
   resultado no es el esperado, mientras que en la segunda descripción (swap2)
   se emplean asignaciones sin bloqueo para resolver el problema.
*/

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Conmutador 1 (usando asignaciones bloqueantes)                       //
//////////////////////////////////////////////////////////////////////////

module swap1 (
    input wire ck,      // reloj
    input wire load,    // señal de control de carga
    input wire d,       // dato a cargar en q1
    output reg q1,      // elemento 1
    output reg q2       // elemento 2
    );

    always @(posedge ck)
        if (load) begin // modo de carga
            q1 = d;
            /* a partir de aquí, q1 vale d */
            q2 = q1;
            /* a partir de aquí, q2 también vale d:
             * el valor de d se asigna tanto a q1 como a q2 */
        end else begin  // modo de conmutación
            q1 = q2;
            /* a partir de aquí q1 toma el valor de q2 */
            q2 = q1;
            /* q2 toma el valor de q1 que es el que ya tenía q2:
             * q1 y q2 toman el mismo valor igual al que ya
             * tenía q2 */
        end
endmodule // swap1

//////////////////////////////////////////////////////////////////////////
// Conmutador 2 (usando asignaciones no bloqueantes)                    //
//////////////////////////////////////////////////////////////////////////

module swap2 (
    input wire ck,      // reloj
    input wire load,    // señal de control de carga
    input wire d,       // dato a cargar en q1
    output reg q1,      // elemento 1
    output reg q2       // elemento 2
    );

    always @(posedge ck)
        if (load) begin // modo de carga
            q1 <= d;
            /* el valor de d se reserva para ser asignado a q1,
             * pero q1 conserva por el momento su valor original */
            q2 <= q1;
            /* el valor original de q1 se reserva para ser
             * asignado a q2 */
        end else begin  // modo de conmutación
            /* finalmente, si se cumple la condición anterior, las variables
            * se asignan con los valores reservados:
            *   q1 toma el valor de d
            *   q2 toma el valor que tenía q1 antes de ser asignado */
            q1 <= q2;    /* se reserva el valor de q2 para ser
                          * asignado a q1 */
            q2 <= q1;    /* se reserva el valor de q1 para ser
                          * asignado a q2 */
        end
        /* q1 se asigna con el valor inicial de q2 y viceversa: los
         * contenidos de q1 y q2 se intercambian. */
endmodule // swap2

/*
   (continúa en block_tb.v)
*/
