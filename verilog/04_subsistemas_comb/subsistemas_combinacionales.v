// Diseño:      subsistemas
// Archivo:     subsistemas_combinacionales.v
// Descripción: Ejemplos de subsistemas combinacionales en Verilog
// Autor:  Jorge Juan <jjchico@gmail.com>
// Fecha:  27/11/2009

/*
   Unidad 4: Subsistemas combinacionales

   Las herramientas de síntesis automática de circuitos digitales emplean
   algoritmos para inferir los elementos de circuito más adecuados
   (decodificadores, multiplexores, comparadores, etc.) a la hora de
   implementar la funcionalidad descrita en un lenguaje de descripción de
   hardware. Para que el proceso sea eficiente, el diseñador debe poner
   especial atención en hacer descripciones simples y compatibles con los
   algoritmos de síntesis. Las descripciones tienen estas características se
   denominan "descripciones sintetizables".

   Se pueden enumerar multitud de criterios y recomendaciones con objeto de que
   una descripción sea sintetizable, pero todos ellos pueden resumirse en la
   siguiente frase:

     Si el diseñador no es capaz de intuir cómo hacer la síntesis de una
     determinada descripción, la herramienta de síntesis, probablemente,
     tampoco.

   Durante el proceso de síntesis, las herramientas informan de los elementos
   que van a emplear para implementar una descripción.

   Esta unidad consta de tres lecciones:

   Lección 4-1 (subsistemas.v): contiene ejemplos de diseño de diferentes
   subsistemas y un banco de pruebas para cada uno de ellos.

   Lección 4-2 (bcd-7.v): contiene la especificación de un convertidor de
   código BCD a 7 segmentos, el cual debe diseñarse como ejercicio.

   Lección 4-3 (analisis.v): contiene un ejercicio en el que se debe describir
   y simular en Verilog un circuito suministrado como esquema.
*/

module subsistemas_combinacionales();

    initial
        $display("Subsistemas combinacionales.");

endmodule
