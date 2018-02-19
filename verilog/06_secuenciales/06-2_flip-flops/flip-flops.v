// Diseño:      flip-flops
// Archivo:     flip-flops.v
// Descripción: Ejemplos de flip-flops
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       19/06/2010

/*
   Lección 6-2: Flip-flops

   En esta lección se realizan descripciones de flip-flops SR, JK, D y T con
   entradas de puesta a cero y a uno asíncronas. Todos los FF están disparados
   por flanco de subida. Las entradas asíncronas son activas en nivel bajo.
*/

`timescale 1ns / 1ps

//
// Flip-flop SR
//

module srff (
    input wire ck,  // reloj
    input wire s,   // entrada 's'
    input wire r,   // entrada 'r'
    input wire cl,  // puesta a '1' asíncrona
    input wire pr,  // puesta a '0' asíncrona
    output reg q    // estado
    );

    always @(posedge ck, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else
            case ({s, r})
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= 1'bx;
            endcase
endmodule // srff

//
// Flip-flop JK
//

module jkff (
    input wire ck,  // reloj
    input wire j,   // entrada 'j'
    input wire k,   // entrada 'r'
    input wire cl,  // puesta a '1' asíncrona
    input wire pr,  // puesta a '0' asíncrona
    output reg q    // estado
    );

    always @(posedge ck, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else
            case ({j, k})
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= ~q;
            endcase
endmodule // jkff

//
// Flip-flop D
//

module dff (
    input wire ck,  // reloj
    input wire d,   // entrada 'd'
    input wire cl,  // puesta a '1' asíncrona
    input wire pr,  // puesta a '0' asíncrona
    output reg q    // estado
    );

    always @(posedge ck, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else
            q <= d;
endmodule // dff

//
// Flip-flop T
//

module tff (
    input wire ck,  // reloj
    input wire t,   // entrada 't'
    input wire cl,  // puesta a '1' asíncrona
    input wire pr,  // puesta a '0' asíncrona
    output reg q    // estado
    );

    always @(posedge ck, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else if (t)
            q <= ~q;
endmodule // tff

/*
   (continúa en flip-flops_tb.v)
*/
