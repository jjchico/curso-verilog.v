// Diseño:      uregister
// Archivo:     register.v
// Descripción: Registro universal
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       11/06/2010

/*
   Lección 7-1: Registro universal.

   Los elementos de memoria (biestables) suelen usarse en grupos o vectores
   representando datos de varios bits, denominados "registros". Exite una
   variedad de operaciones útiles que pueden realizarse sobre registros como:
   - Carga de un dato (síncrona o asíncrona)
   - Puesta a cero (síncrona o asíncrona)
   - Puesta a uno (síncrona o asíncrona)
   - Desplazamiento a derecha o izquierda
   - Lectura en serir o paralelo

   En las operaciones de desplazamiento se lee un bit desde el exterior a
   través de una entrada serie, lo que permite cargar un nuevo dato en el
   registro mediante desplazamientos sucesivos (escritura serie).

   Los registros de desplazamiento pueden disponer de salidas para todos sus
   biestables (salidas en paralelo) o sólo para los biestables de los extremos
   permitiendo la lectura de todos los bits mediantes desplazamientos
   sucesivos (salida serie).

   En esta lección diseñaremos un registro sobre el que pueden realizarse
   diversas operaciones. Se mostrará además el uso del operador de combinación
   de señales ({}) para implementar operaciones de desplazamiento.
*/

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Registro Universal                                                   //
//////////////////////////////////////////////////////////////////////////
/*
   El registro es controlado por varias entrada de control que indican la
   operación a realizar con un cierto orden de prioridad. Las operaciones son:

    load shr shl    operación
    --------------------------
      0   0   0    Inhibición
      1   x   x    Carga de dato
      0   1   x    Desplazamiento a la derecha
      0   0   1    Desplazamiento a la izquierda

   Por otro lado, dispone de las siguientes entradas y salidas:
       ck: señal de reloj
       xr: entrada del bit más significativo en desplazamiento a la derecha
       xl: entrada del bit más significativo en desplazamiento a la izquierda
       x: entrada de dato para la carga de dato
       q: salida del dato almacenado
 */

module uregister(
    input ck,         // reloj
    input load,       // carga de dato en paralelo
    input shr,        // desplazamiento a la derecha
    input shl,        // desplazamiento a la izquierda
    input xr,         // entrada serie para shr
    input xl,         // entrada serie para shl
    input [W-1:0] x,  // entrada de dato para carga en paralelo
    output [W-1:0] q  // contenido del registro (estado)
    );

    // anchura del registro
    /* La anchura del registro está parametrizada con un valor por
     * defecto de 8 bits */
    parameter W = 8;

    reg [W-1:0] q;

    always @(posedge ck) begin
        if (load)
            q <= x;
        else begin
            if (shr)
                q <= {xr, q[W-1:1]};
            else if (shl)
                q <= {q[W-2:0], xl};
        end
    end
endmodule // uregister

//////////////////////////////////////////////////////////////////////////
// Registro Universal. Señal interna para el estado.                    //
//////////////////////////////////////////////////////////////////////////
/*
   En el registro anterior 'q' hace referencia tanto al puerto de salida del
   registro como a la variable de estado que almacena el valor. Aunque se usa
   el mismo identificador ambas cosas hacen referencia a conceptos distintos.
   En Verilog es posible hacer esta simplificación porque el simulador o
   compilador define automáticamente una señal interna para cada puerto de
   entrada o salilda con el mismo nombre del puerto y conectada al mismo.

   Para que esta distinción resulte más clara es habitual definir una señal
   interna independiente para representar el estado y hacer la asignación
   explícita a los puertos de salida con un asignamiento incondicional (assign).

   La siguiente implementación emplea este estilo para describir el mismo
   registro que antes, explicitando además el tipo de los puertos de entrada
   y salida.
*/

module uregister2(
    input wire ck,         // reloj
    input wire load,       // carga de dato en paralelo
    input wire shr,        // desplazamiento a la derecha
    input wire shl,        // desplazamiento a la izquierda
    input wire xr,         // entrada serie para shr
    input wire xl,         // entrada serie para shl
    input wire [W-1:0] x,  // entrada de dato para carga en paralelo
    output wire [W-1:0] q  // contenido del registro (estado)
    );

    // anchura del registro
    parameter W = 8;
    // Señal interna con el estado del registro
    reg [W-1:0] r;

    always @(posedge ck) begin
        if (load)
            r <= x;
        else begin
            if (shr)
                r <= {xr, r[W-1:1]};
            else if (shl)
                r <= {r[W-2:0], xl};
        end
    end

    /* Conectamos la señal interna al puerto de salida */
    assign q = r;

endmodule // uregister2

/*
   (continúa en register_tb.v)
*/
