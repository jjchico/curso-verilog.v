// Diseño:      rom_mul
// Archivo:     rom_mul.v
// Descripción: Multiplicador BCD basado en ROM
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       22/11/2017

/*
   Lección 8-1. Multiplicador BCD basado en ROM.

   Una aplicación frecuente de las memorias ROM es almacenar datos
   precalculados. De esta forma se evita la complicación de diseñar un circuito
   de cálculo específico y se consigue que el cálculo sea más rápido, al estar
   el dato ya disponible en la ROM. No obstante, esta solución sólo es aplicable
   a datos de pocos bits ya que, de lo contratio, el número de datos a almacenar
   puede resultar excesivo.

   En este ejemplo se usa una ROM de 256 posiciones (8 bits de datos) para
   construir un multiplicador de cifras decimales (BCD). En cada dirección de la
   ROM se almacena el resultado (en BCD) de multiplicar multiplicar las dos
   cifras BCD representadas en la dirección. Por ejemplo, la dirección 01111000
   almacenará el dato 01011100:

        0111 x 1000 = 0101 1100
           7 x    8 =    5    6

   La representación hexadecimal de Verilog es especialmente conveniente cuando
   se quieren especificar número almacenados en BCD ya que, por ejemplo, la
   representación BCD del número 56 es la misma que la del dato hexadecimal
   'h56. */

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Multiplicador BCD basado en ROM                                      //
//////////////////////////////////////////////////////////////////////////

// ROM 256x8
module rom256x8 (
    input wire [7:0] a, // bus de direcciones
    output reg [7:0] d  // bus de datos
    );

    // Diseño ROM y contenido
    /* La forma más directa de diseñar una ROM en Verilog es mediante una
     * estructura 'case' en la que se asigna una sola variable, ya que se
     * corresponde perfectamente con la operación de la ROM: según el valor de
     * la entrada de dirección, se asigna a la variable de salida el contenido
     * de la ROM. Las herramientas de síntesis no tendrán problemas en
     * identificar esta estructura y hacer una impletanción eficiente de la ROM. */
    always @(*)
        case (a)
        8'h00: d = 8'h00;
        8'h01: d = 8'h00;
        8'h02: d = 8'h00;
        8'h03: d = 8'h00;
        8'h04: d = 8'h00;
        8'h05: d = 8'h00;
        8'h06: d = 8'h00;
        8'h07: d = 8'h00;
        8'h08: d = 8'h00;
        8'h09: d = 8'h00;
        8'h10: d = 8'h00;
        8'h11: d = 8'h01;
        8'h12: d = 8'h02;
        8'h13: d = 8'h03;
        8'h14: d = 8'h04;
        8'h15: d = 8'h05;
        8'h16: d = 8'h06;
        8'h17: d = 8'h07;
        8'h18: d = 8'h08;
        8'h19: d = 8'h09;
        8'h20: d = 8'h00;
        8'h21: d = 8'h02;
        8'h22: d = 8'h04;
        8'h23: d = 8'h06;
        8'h24: d = 8'h08;
        8'h25: d = 8'h10;
        8'h26: d = 8'h12;
        8'h27: d = 8'h14;
        8'h28: d = 8'h16;
        8'h29: d = 8'h18;
        8'h30: d = 8'h00;
        8'h31: d = 8'h03;
        8'h32: d = 8'h00;
        8'h33: d = 8'h09;
        8'h34: d = 8'h12;
        8'h35: d = 8'h15;
        8'h36: d = 8'h18;
        8'h37: d = 8'h21;
        8'h38: d = 8'h24;
        8'h39: d = 8'h27;
        8'h40: d = 8'h00;
        8'h41: d = 8'h04;
        8'h42: d = 8'h08;
        8'h43: d = 8'h12;
        8'h44: d = 8'h16;
        8'h45: d = 8'h20;
        8'h46: d = 8'h24;
        8'h47: d = 8'h28;
        8'h48: d = 8'h32;
        8'h49: d = 8'h36;
        8'h50: d = 8'h00;
        8'h51: d = 8'h05;
        8'h52: d = 8'h10;
        8'h53: d = 8'h15;
        8'h54: d = 8'h20;
        8'h55: d = 8'h25;
        8'h56: d = 8'h30;
        8'h57: d = 8'h55;
        8'h58: d = 8'h40;
        8'h59: d = 8'h45;
        8'h60: d = 8'h00;
        8'h61: d = 8'h06;
        8'h62: d = 8'h12;
        8'h63: d = 8'h18;
        8'h64: d = 8'h24;
        8'h65: d = 8'h30;
        8'h66: d = 8'h36;
        8'h67: d = 8'h42;
        8'h68: d = 8'h48;
        8'h69: d = 8'h63;
        8'h70: d = 8'h00;
        8'h71: d = 8'h07;
        8'h72: d = 8'h14;
        8'h73: d = 8'h21;
        8'h74: d = 8'h28;
        8'h75: d = 8'h35;
        8'h76: d = 8'h42;
        8'h77: d = 8'h49;
        8'h78: d = 8'h56;
        8'h79: d = 8'h73;
        8'h80: d = 8'h00;
        8'h81: d = 8'h08;
        8'h82: d = 8'h16;
        8'h83: d = 8'h24;
        8'h84: d = 8'h32;
        8'h85: d = 8'h40;
        8'h86: d = 8'h48;
        8'h87: d = 8'h56;
        8'h88: d = 8'h64;
        8'h89: d = 8'h72;
        8'h90: d = 8'h00;
        8'h91: d = 8'h09;
        8'h92: d = 8'h18;
        8'h93: d = 8'h27;
        8'h94: d = 8'h36;
        8'h95: d = 8'h45;
        8'h96: d = 8'h54;
        8'h97: d = 8'h63;
        8'h98: d = 8'h72;
        8'h99: d = 8'h81;
        default: d = 8'hff;
        endcase
endmodule // rom256x8

// Multiplicador BCD de datos de 4 bits
module rommul_bcd (
    input wire [3:0] x,    // primer operando
    input wire [3:0] y,    // segundo operando
    output wire [7:0] z    // salida
    );

    // Multiplicador
    /* Los resultados están precalculados en la ROM por lo que para hacer el
     * multiplicador basta con hacer las conexiones adecuadas a la misma */
    rom256x8 rom (.a({x, y}), .d(z));

endmodule // rommul_bcd

/*
   EJERCICIOS

   1. Compila la lección con:

      $ iverilog rom_mul.v

      Comprueba que no hay errores de sintaxis

   (continúa en rom_mul_tb.v)
*/
