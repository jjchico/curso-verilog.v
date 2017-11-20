// Diseño:       hola
// Archivo:      hola.v
// Descripción:  Introducción al curso
// Autor:        Jorge Juan <jjchico@gmail.com>
// Fecha:        05-11-2009

/*
   Lección 1: Introducción a Verilog

   En esta lección haremos un diseño básico en Verilog y veremos como compilar
   y simular el diseño. Se introducen también algunos aspectos generales sobre
   el curso, sobre Verilog y sobre los lenguajes de descripción de hardware
   en general.

   Por cierto, este texto que estás leyendo es un comenario en Verilog. Los
   comentarios en Verilog son como en C y C++: entre barras y asteriscos para
   varias líneas o comenzado con doble barra para una sola línea.

   Verilog es un lenguaje de descripción de circuitos electrónicos. Es parecido
   al lenguaje de programación C, pero en Verilog se modela el comportamiento
   de un circuito electrónico y no el de un programa de ordenador.

   Las descripciones en Verilog (o en otros lenguajes de descripción de
   hardware -LDH- como VHDL) sirven principalmente para dos cosas: para simular
   el comportamiento de un circuito electrónico antes de proceder a su
   implementación, y, si el código es adecuado, para que una herramienta
   de síntesis automática genere una implementación del circuito.

   El uso de los LDH supone una herramienta fundamental hoy día para el diseño
   de circuitos digitales permitiendo el diseño, simulación e implementación
   de circuitos complejos de forma rápida y eficiente.

   Para más información sobre Verilog y los lenguajes de descripción de
   hardware puedes consultar la wikipedia (wikipedia.org).

   Este curso asume que el alumno tiene disponible un manual de referencia
   del lenguaje Verilog para consultar los detalles sobre sintaxis del
   lenguaje y sus diferentes construcciones. En el momento de escribir este
   curso se puede acceder dos excelentes referencias del lenguaje escritas por
   Stuart Sutherland en:

   Online Verilog-1995 Quick Reference Guide
   Verilog® HDL Quick Reference Guide based on the Verilog-2001 standard
   http://www.sutherland-hdl.com/reference-guides.php

   Existen numerosos libros de texto sobre Verilog y multitud de recursos en
   Internet. En el momento de escribir este curso se puede encontrar un
   excelente tutorial con ejemplos y otros recursos en:

   http://www.asic-world.com/verilog/
*/

/*
   Ahora vamos con el primer ejemplo, el típico "¡Hola, mundo!". Toda
   descripción en Verilog está dentro de un módulo. En el módulo se indica el
   nombre del módulo y las señales de entrada y salida que tiene. Es una
   representación de la vista externa del módulo (circuito) que se está
   diseñando. Nuestro primer módulo es tan simple que no tiene ni entradas ni
   salidas.
*/

module hola ();

    /* Dentro de un módulo pueden incluirse distintos tipos de descripciones.
     * Para nuestro ejemplo usaremos un bloque "initial" que contiene un
     * conjunto de instrucciones que se ejecutaran en serie, como en cualquier
     * lenguaje de programación. */

    initial begin

        $display("¡Hola, mundo!");

        /* $display es equivalente al "print" en otros lenguajes.
         * Simplemente muestra un texto por el terminal.  $display no
         * representa ninguna función de un circuito electrónico sino
         * que es una función del sistema, en este caso para mostrar
         * texto. Hay otras funciones del sistema y todas comienzan por
         * "$".  Como en C, cada directiva acaba con ";"
         *
         * Y esto es todo por hoy. Finalizamos el bloque "initial" y
         * nuestro módulo indicando con un comentario de qué módulo se
         * trataba. */

    end
endmodule // hola

/*
   EJERCICIO

   Para simular este módulo con Icarus, abre un terminal, sitúate en la
   carpeta que contiene el archivo "hola.v" y ejecuta:

     $ iverilog hola.v

   (No tienes que escribir el "$", significa que estás en la línea de comandos)

   Esto hará que Icarus compile el diseño y genere mensajes de error si los
   hay. El resultado de la compilación está en un archivo de nombre "a.out".
   Para simular el diseño se emplea otra utilidad de Icarus:

     $ vvp a.out

   Esto ejecutará una simulación del diseño y deber ver en el terminal la
   frase "¡Hola, mundo!".

   ¡Enhorabuena! ¡Has realizado tu primer diseño en Verilog y probablemnte no
   será el último!
*/
