// Diseño:      arbitrador
// Archivo:     arbiter.v
// Descripción: Arbitrador. Ejemplo de máquina de estados
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       04/06/2010

/*
   Lección 6-5: Máquinas de estados finitos. Arbitrador

   En esta lección se realizan dos descripciones de un circuito arbitrador
   sencillo, una como máquina de Mealy y otra como máquina de Moore.

   Un arbitrador controla un conjunto de componentes. El arbitrador tiene
   una entrada de petición (request) y una salida de concesión (grant) por cada
   componente que controla. Ante la activación de una o varias entradas de
   petición el arbitrador debe activar una sola salida de concesión con objeto
   de que sólo un componente acceda en un instante dado a un supuesto
   recurso compartido.

   El objetivo de esta lección es ilustrar como, para algunas aplicaciones, es
   más conveniente un tipo de máquina (Mealy o Moore) frente a otro. En este
   sentido, las máquinas de Moore proporcionan una operación más fiable al
   producir salidas en instantes mejor definidos.
*/

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Arbitrador (Mealy)                                                   //
//////////////////////////////////////////////////////////////////////////

/*
 * La tabla de estados siguiente describe el comportamiento del arbitrador.
 * Si ambas entradas de petición se activan a la vez se concede el recurso al
 * componente 1, otorgándole así mayor prioridad.
 *
 *         Entradas (r1 r2)
 * Estado  00     01     10     11
 *       ----------------------------
 *  S0  | S0,00  S2,01  S1,10  S1,10 |    S0: no hay peticiones
 *  S1  | S0,00  S2,01  S1,10  S1,10 |    S1: recurso concedido al componente 1
 *  S2  | S0,00  S2,01  S1,10  S2,01 |    S2: recurso concedido al componente 2
 *       ----------------------------
 *         Próximo estado, g1 g2
 */
 module arbiter1(
     input wire ck, // reloj
    input wire r1,  // petición 1
     input wire r2, // petición 2
     output reg g1, // concesión 1
     output reg g2  // concesión 2
     );

     // Codificación de estados
     parameter [1:0]
         S0 = 2'b00,
         S1 = 2'b01,
         S2 = 2'b10;

    // Variables de estado y próximo estado
    reg [1:0] state, next_state;

    // Proceso de cambio de estado (secuencial)
    always @(posedge ck)
        state <= next_state;

    // Cálculo del nuevo estado (combinacional)
    always @* begin
        next_state = 2'bxx;
        case (state)
        S0: begin
            if (r1)
                next_state = S1;
            else if (r2)
                      next_state = S2;
            else
                next_state = S0;
        end
        S1: begin
              if (r1)
                  next_state = S1;
              else if (r2)
                  next_state = S2;
              else
                  next_state = S0;
        end
        S2: begin
            if (r2)
                next_state = S2;
            else if (r1)
                next_state = S1;
            else
                next_state = S0;
        end
        default:
            next_state = S0;
        endcase
    end

    // Cálculo de la salida
    always @(state, r1, r2) begin
        g1 = 0; g2 = 0;
        case (state)
        S0: begin
            g1 = r1;
            g2 = r2;
        end
        S1: begin
            g1 = r1;
            g2 = ~r1 & r2;
        end
        S2: begin
            g1 = r1 & ~r2;
            g2 = r2;
        end
        endcase
    end
endmodule // arbiter1

//////////////////////////////////////////////////////////////////////////
// Arbitrador (Moore)                                                   //
//////////////////////////////////////////////////////////////////////////

/*
 * La descripción como máquina de Moore es muy similar a la Mealy y es
 * conceptualmente más fácil de entender ya que en este caso la salida está
 * claramente asociada al estado.
 *
 *         Entradas (r1 r2)
 * Estado  00   01   10   11   Salidas (g1 g2)
 *        -------------------
 *   S0  | S0   S2   S1   S1 | 00    S0: no hay peticiones
 *   S1  | S0   S2   S1   S1 | 01    S1: recurso concedido al componente 1
 *   S2  | S0   S2   S1   S2 | 10    S2: recurso concedido al componente 2
 *        -------------------
 *           Próximo estado
 */
 module arbiter2(
     input wire ck, // reloj
    input wire r1,  // petición 1
     input wire r2, // petición 2
     output reg g1, // concesión 1
     output reg g2  // concesión 2
     );

     // Codificación de estados
     parameter [1:0]
         S0 = 2'b00,
         S1 = 2'b01,
         S2 = 2'b10;

    // Variables de estado y próximo estado
    reg [1:0] state, next_state;

    // Proceso de cambio de estado (secuencial)
    always @(posedge ck)
        state <= next_state;

    // Cálculo del nuevo estado (combinacional)
    always @* begin
        next_state = 2'bxx;
        case (state)
        S0: begin
            if (r1)
                next_state = S1;
            else if (r2)
                    next_state = S2;
            else
                next_state = S0;
        end
        S1: begin
            if (r1)
                next_state = S1;
            else if (r2)
                next_state = S2;
            else
                next_state = S0;
        end
        S2: begin
            if (r2)
                next_state = S2;
            else if (r1)
                next_state = S1;
            else
                next_state = S0;
        end
        default:
            next_state = S0;
        endcase
    end

    // Cálculo de la salida
    always @* begin
        g1 = 0; g2 = 0;

        if (state == S1)
            g1 = 1;
        if (state == S2)
            g2 = 1;
    end
endmodule // arbiter2

/*
   (continúa en arbiter_tb.v)
*/
