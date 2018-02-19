// Diseño:      alarma
// Archivo:     alarma.v
// Descripción: Alarma sencilla para un automovil
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       09/11/2009

/*
   Lección 3-3: Ejemplos combinacionales. Alarma de automovil.

   Este archivo contiene una posible solución al siguiente problema:

   Diseñe un circuito de alarma de coche de dos puertas de tal forma que
   suene la alarma cuando:
     * Las puertas estén cerradas, el motor apagado y se abra el maletero.
     * El motor esté encendido, las puertas cerradas y el maletero abierto.
     * El freno de mano quitado, el motor encendido y algunas de las puertas
       abiertas.
   Añada una entrada que permita desactivar la alarma.

   El archivo alarma_tb.v contiene el banco de pruebas para el test de este
   diseño.

   En esta lección se practican, entre otros, los siguientes conceptos:

     - Asignaciones continuas implícitas
     - Lista de sensibilidad "@*"
     - Señales de múltiples bits (vectores)
     - Generación de patrones de test mediante un contador
*/

`timescale 1ns / 1ps

/* Definimos el módulo con una entrada para cada elemento que puede afectar
 * al estado de la alarma */
module alarma(
    input wire c,   // control de la alarma. 0-desconectada, 1-conectada
    input wire p1,  // primera puerta. 0-cerrada, 1-abierta
    input wire p2,  // segunda puerta
    input wire t,   // estado del motor. 0-apagado, 1-encendido
    input wire m,   // estado del maletero. 0-cerrado, 1-abierto
    input wire f,   // estado del freno de mano. 0-quitado, 1-puesto
    output reg a    // estado de la alarma. 0-no suena, 1-suena
                    /* Declaramos la salida como "reg" ya que se va a generar
                     * en un bloque 'always'. */
    );

    /* Definimos una señal auxiliar que indica cuando alguna de las puertas
     * está abierta. Esto facilita el procedimiento posterior. La
     * asignación se hace enn la misma definición, por lo que es una
     * asignación continua implícita (assign). */
    wire p = p1 | p2;    // p=0: todas las puertas cerradas
                // p=1: alguna puerta abierta

    /* La función se describe de forma procedimental en un bloque "always".
     * La construcción "@*" indica que se incluyan todas las variables
     * presentes en el bloque en la lista de sensibilidad con objeto de
     * obtener una implementación combinacional. De esta forma se evitan
     * errores en caso de olvidar incluir alguna variable. En este caso es
     * equivalente a "@(c,p,t,m,f)". */
    always @* begin
        a = 0;    // valor por defecto de a
        if (c)    // c=1. Alarma conectada
            if (!p && !t && m)     // primera condición
                a = 1;
            else if (t && !p && m) // segunda condición
                a = 1;
            else if (!f && t && p) // tercera condición
                a = 1;
        else      // c=0. Alarma desconectada
            a = 0;
    end

endmodule // alarma

/*
   La lección continúa en el archivo alarma_tb.v
*/
