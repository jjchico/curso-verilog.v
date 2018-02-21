// Diseño:      memorias
// Archivo:     memorias.v
// Descripción: Descripción de memorias en Verilog
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       22/11/2017

/*
   Unidad 8: Memorias

   Las memorias son componentes fundamentales de los sistemas digitales complejos y de los procesadores. Hay dos tipos de memorias básicos: las memorias de sólo lectura (ROM -Read Only Memory-) y las memorias de lectura y escritura (RAM -Random Access Memory-). En ambos casos, se comportan como almacenes de datos y se manejan con dos tipos de buses: los buses de direcciones, que indica el dato al que se quiere acceder; y los buses de datos, que transportan el dato correspondiente.

   Las ROM tienen un contenido fijo que se define en el momento de diseñar el circuito y, una vez construído éste, sólo puden leerse. Las memorias RAM pueden leerse y escribirse tantas veces como se quiera. Para ello tienen señales de control adicionales que indican si se desea leer o escribir en la memoria y suelen tener buses de datos diferentes para el dato de entrada y el de salida. Las memorias RAM pierden el contenido almacenado al quitar la alimentación del circuito.

   En esta unidad se explica como describir memorias ROM y RAM en Verilog a través de tres circuitos de ejemplo:

   Lección 8-1 (rom_mul.v): multiplicador basado en ROM.

   Lección 8-2 (async_ram.v): memoria RAM asíncrona.

   Lección 8-3 (sync_ram.v): memorias RAM síncronas.

*/

module memorias ();

    initial
        $display("Memorias");
        $finish;

endmodule
