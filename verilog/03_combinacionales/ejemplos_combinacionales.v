// Diseño:      ejemplos
// Archivo:     ejemplos_combinacionales.v
// Descripción: Varios ejemplos combinacionales en Verilog
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       09/11/2009

/*
   Unidad 3: Ejemplos combinacionales

   En esta unidad veremos algunos ejemplos de resolución de problemas y
   aplicaciones de Verilog con circuitos combinacionales. Con los ejemplos
   se introducirán algunos conceptos nuevos de Verilog y algunas alternativas
   a las formas de descripción y realización de bancos de pruebas vistos en
   lecciones anteriores.

   Lección 3-1 (florencio.v): implementación mediante un procedimiento (always)
   de una función combinacional compleja. La obtención de una descripción
   funcional es mucho menos intuitiva, por lo que se muestra la utilidad de
   los lenguajes de descripción de hardware para facilitar el proceso de
   diseño.

   Lección 3-2 (azar.v): diseño y simulación de un circuito simple con azares.
   Permite comprobar cómo la introducción de retrasos puede producir
   resultados transitorios no esperados en los circuitos combinacionales.

   Lección 3-3 (alarma.v): diseño de un sencillo sistema de alarma para un
   automovil.
*/

module ejemplos_combinacionales ();

    initial
        $display("Ejemplos combinacionales.");

endmodule
