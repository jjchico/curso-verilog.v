// Diseño:      biestables
// Archivo:     biestables.v
// Descripción: Ejemplos de biestables
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       31/05/2010

/*
   Lección 6-1: Biestables

   Los biestables son elementos de memoria simples que pueden almacenar un
   bit (0 ó 1) y son la base de los circuitos secuenciales. El valor almacenado
   se puede cambiar mediante las entradas de excitación del biestable. En la
   mayoría de los casos prácticos el cambio de estado es controlado por una
   señal especial (señal de reloj).

   En esta lección se realizan descripciones de biestables SR con distintos
   tipos de disparo (formas de actuación de la señal de reloj) con objeto de
   comparar sus comportamientos.
*/

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Biestable SR asíncrono                                               //
//////////////////////////////////////////////////////////////////////////
/*
   Este tipo de biestable no dispone de señal de reloj. Cuando se activa la
   señal S (s = 1) el estado del biestable cambia a '1', y cuando se activa la
   señal R (r = 1) el estado cambia a '0'. Cuando ninguna entrada está activa
   el biestable conserva su valor. La operación del biestable SR con ambas
   entradas activas no está definida y lo representamos aquí como el paso
   a un estado desconocido ('x').
 */

module sra(
    input s,    // puesta a '1'
    input r,    // puesta a '0'
    output q    // estado (valor almacenado)
    );

    /* Las variables (tipo 'reg') son el único tipo de señal que pueden
     * retener su valor y por tanto deben usarse para describir
     * comportamiento secuencial (con memoria) */
    reg q;

    always @(s, r)
        case ({s, r})
        /* La asignación de elementos de memoria debe realizarse
         * mediante el operador de asignación no bloqueante ('<=').
         * Las diferencias entre el operador '=' y el '<=' se explican
         * en la lección 6-3. */
        2'b01: q <= 1'b0;
        2'b10: q <= 1'b1;
        2'b11: q <= 1'bx;

        /* El comportamiento secuencial del circuito se deriva de que
         * la señal 'q' no se asigna en todos los casos. Cuando 's' y
         * 'r' son ambos cero no se asigna ningún valor a 'q' por lo que
         * conserva su valor anterior, modelando el comportamiento de
         * un elemento de memoria. */

        endcase
endmodule // sra

//////////////////////////////////////////////////////////////////////////
// Biestable SR nivel alto                                              //
//////////////////////////////////////////////////////////////////////////
/*
   La diferencia de este biestable es que el cambio de estado está controlado
   por la señal de reloj 'ck'. El cambio de estado sólo se produce si ck=1
   (nivel alto)

   Los biestables controlados por una señal de reloj se denominan en general
   "biestables síncronos".
*/

module srl(
    input ck,   // reloj
    input s,    // puesta a '1'
    input r,    // puesta a '0'
    output q    // estado
    );

    reg q;

    always @(ck, s, r)
        case ({ck, s, r})
        3'b101: q <= 1'b0;
        3'b110: q <= 1'b1;
        3'b111: q <= 1'bx;
        endcase
endmodule // srl

//////////////////////////////////////////////////////////////////////////
// Biestable SR maestro-esclavo                                         //
//////////////////////////////////////////////////////////////////////////
/*
   Este tipo de biestables se construye conectando en cadena dos biestables
   disparados por niveles diferentes de la señal de reloj. Con ck=1, el primer
   biestable (maestro/master) carga un nuevo estado mientras que el segundo
   (esclavo/slave) retiene el estado anterior. Cuando ck=0, el maestro retiene
   el estado almacenado y se transfiere al esclavo. El efecto es similar al
   del biestable disparado por nivel, salvo que el nuevo estado sólo aparece
   a la salida tras el flanco de bajada de la señal de reloj. */

module srms(
    input ck,
    input s,
    input r,
    output q
    );

    wire qm, qm_neg, ck_neg;

    srl master(.ck(ck), .s(s), .r(r), .q(qm));
    /* Las entradas del esclavo se conectan de forma que copien el estado
     * del maestro. */
    srl slave(.ck(ck_neg), .s(qm), .r(qm_neg), .q(q));

    /* Generamos la salida complementada del maestro y la señal de reloj
     * invertida para el esclavo. */
    assign qm_neg = ~qm;
    assign ck_neg = ~ck;

endmodule // srms

//////////////////////////////////////////////////////////////////////////
// Biestable SR flanco de bajada                                        //
//////////////////////////////////////////////////////////////////////////
/*
   Los biestables disparados por flanco cambián de estado en función de las
   entradas presentes en el momento del cambio de la señal de reloj, bien sea
   de 0 a 1 (flanco de subida) o de 1 a 0 (flanco de bajada). Proporcionan un
   mejor control de los cambios de estado por lo que se usan preferentemente
   en los circuitos secuenciales.
*/

module srff(
    input ck,   // reloj
    input s,    // puesta a '1'
    input r,    // puesta a '0'
    output q    // estado
    );

    reg q;

    /* La condición de disparo por flanco se indica mediante las directivas
     * 'posedge' y 'negedge' en las listas de sensibilidad de los
     * procesos. En este caso, el proceso será evaluado únicamente en los
     * cambios de 1 a 0 de la señal de reloj y no ante cualquier cambio.
     * Los cambios o valores de las entradas de control en otros instantes
     * no afectan porque no se han incluído en la lista de sensibilidad. */
    always @(negedge ck)
        case ({s, r})
        2'b01: q <= 1'b0;
        2'b10: q <= 1'b1;
        2'b11: q <= 1'bx;
        endcase
endmodule // srff

/*
   (continúa en biestables_tb.v)
*/
