// Diseño:      Unidad Aritmético-Lógica (ALU) sencilla
// Archivo:     alu.v
// Descripción: Unidad Aritmético-Lógica (ALU) sencilla
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       27/05/2010

/*
   Lección 5-3. Unidad aritmético-lógica

   En esta lección ampliaremos el sumador-restador diseñado en la lección 5-2
   para consguir una unidadr aritmetico-lógica sencilla, a la vez que se
   introducen o se repasan diversos operadores lógicos y aritméticos.
*/

//////////////////////////////////////////////////////////////////////////
// Unidad aritmético-logica (ALU)                                       //
//////////////////////////////////////////////////////////////////////////

/* La descripción de la ALU es similar a la del sumador/restador visto en la
 * lección anterior. La entrada de selección de operación se extiende para
 * indicar nuevas operaciones según la siguiente tabla:
 *   op[2:0]    Operación    f
 *       000    Suma         a + b
 *       001    Resta        a - b
 *       010    Incremento   a + 1
 *       011    Decremento   a - 1
 *       100    AND          a & b
 *       101    OR           a | b
 *       110    XOR          a ^ b
 *       111    NOT          ~a
 *
 * La anchura de los datos no está prefijada, sino que depende del parámetro
 * WIDTH. Este parámetro tiene un valor predeterminado de 8 indicado por
 * la directiva 'parameter', pero puede cambiarse a la hora de instanciar el
 * módulo, por lo que la misma descripción sirve para producir ALUs de
 * cualquier anchura de datos.
 *
 * La ALU opera con datos en complementdo a dos, por lo que se usan variables
 * de tipo 'signed'. La ALU no dispone de acarreo de entrada (cin), pero sí
 * dispone de salida de desbordamiento (ov) además de la salida de acarreo de
 * salida. La salida 'ov' valdrá 1 cuando el resultado en 'f' no sea correcto
 * debido a desboradamiento (el resultado ocupa más bits que la anchura de
 * dato de la ALU).*/

module alu(
    input signed [WIDTH-1:0] a,   // primer operando
    input signed [WIDTH-1:0] b,   // segundo operando
    input [2:0] op,               // operación (0-suma, 1-resta)
    output signed [WIDTH-1:0] f,  // salida
    output ov                     // salida de desbordamiento (overflow)
    );

    parameter WIDTH = 8;

    reg f, ov;

    always @*
    begin
        /* Nos aseguramos que a cout y ov siempre se asigne un valor */
        ov = 0;

        if (op[2] == 0)    // Operaciones aritméticas
        begin :arith
            reg signed [WIDTH:0] s;
            /* La construcción 'case' es ideal para distinguir
             * entre los múltiples valores de 'op' */
            case (op[1:0])

              /* En primer lugar calculamos el resultado en 'f' con
               * el posible bit adicional en 'cout'. El
               * desbordamiento se produce cuando los operandos
               * son del mismo signo y el resultado es de un signo
               * diferente */
              2'b00:
                s = a + b;    // suma
              2'b01:
                s = a - b;    // resta
              2'b10:
                s = a + 1;    // incremento
              2'b11:
                s = a - 1;    // decremento
            endcase

            // Cálculo del desbordamiento
            ov = (s[WIDTH] == s[WIDTH-1])? 0: 1;

            // Salida
            f = s[WIDTH-1:0];
        end
        else    // Operaciones lógicas
        begin
            case (op[1:0])
              2'b00:
                f = a & b;    // AND
              2'b01:
                f = a | b;    // OR
              2'b10:
                f = a ^ b;    // XOR
              2'b11:
                /* '~' es el operador 'complemento' que invierte
                 * todos los bits del operando */
                f = ~a;       // NOT
            endcase
        end
    end // always

endmodule // alu

/*
   EJERCICIOS

   1. Compila la lección con:

      $ iverilog sumsub.v

      Comprueba que no hay errores de sintaxis

   (continúa en sumsub_tb.v)
*/
