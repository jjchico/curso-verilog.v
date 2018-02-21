# curso-verilog.v

## INTRODUCCIÓN

¡Hola!

Este es un curso básico de Verilog escrito en Verilog. Mientras otros cursos
contienen ejemplos, éste curso es más bien una colección de ejemplos que
contienen un curso. Cada archivo Verilog (extensión `.v`) constituye un ejemplo
de codificación en Verilog junto con los comentarios y descripciones breves de
los conceptos que incorpora.

El curso se divide en varias unidades que contienen lecciones. La estructura es
la típica de un curso de introducción a los circuitos digitales. Algunos
conceptos fundamentales sobre circuitos digitales se explican brevemene, pero se
asume que el usuario tiene conocimientos previos de circuitos digitales o bien
los está adquiriendo mientras realiza este curso.

Aunque este curso se centra en el lenguaje Verilog y no contempla la fase de
implementación, los ejemplos se han realizado con intención de que sean
sintetizables. Actualmente es fácil y asequible implementar diseños digitales
en dispositivos FPGA empleando herramientas libres como
[Icestorm](https://github.com/cliffordwolf/icestorm),
[Apio](https://github.com/FPGAwars/apio) o
[Icestudio](https://github.com/FPGAwars/icestudio)

## CÓMO EMPEZAR

Para seguir el curso basta con clonar o descargar y descomprimir este
repositorio y acceder a la carpeta *verilog* que contiene. Dentro de esta
carpeta están las carpetas numeradas  de cada unidad y lección. Simplemente abre
los archivos de código Verilog por orden y sigue las instrucciones en los
comentarios que contienen.

## HERRAMIENTAS NECESARIAS

Para sacar el máximo partido de este curso, el alumno debe compilar y simular
los diseños que se proponen. En este curso se emplea [Icarus Verilog][1] para la
simulación y [Gtkwave][2] como visor de ondas y las lecciones incluyen
instrucciones específicas sobre como simular y ver los resultados de los
ejemplos con estos programas. No obstante, cualquier combinación de herramientas
que permita editar archivos de texto plano en formato UNIX y simular archivos
Verilog es adecuada para editar y simular los ejemplos del curso. En este curso
se asume que los programas necesarios están instalados y que el alumno es capaz
de ejecutarlos desde una línea de comandos de su sistema. A continuación se
comentan algunas alternativas.

### Entorno básico en sistemas UNIX/Linux

Tanto Icarus Verilog como Gtkwave están disponibles en los repositorios de las
principales distribuciones de Linux, por lo que es una plataforma idónea para
seguir este curso. El editor de texto del sistema u otro más avanzado de su
elección pueden usarse para editar el código. En sistemas tipo Debian como
Ubuntu, los programas necesarios pueden instalarse desde un terminal con:

    $ sudo apt install iverilog gtkwave

### Entorno básico en otros sistemas operativos

Existen versiones de Icarus Verilog y Gtkwave [otros sistemas operativos][3]. El
autor desconoce si estas versiones están actualizadas o si son mantenidas
activamente. Para editar el código Verilog puede usarse cualquier editor de
texto plano compatible con texto UNIX y codificación UTF8. Los usuarios de
Microsoft Windows(TM) probablemente prefieran emplear un editor de texto plano
avanzado como [Notepad++][4] en vez del editor incluído con el sistema.

### Entorno integrado multiplataforma: apio-ide

Gracias al excelente proyecto [FPGAWars](https://github.com/FPGAwars) disponemos
del entorno libre y multiplataforma [apio-ide][5]. Este entorno está basado en
el editor [Atom](https://github.com/atom/atom) e incluye soporte para instalar
las herramientas necesarias (Icarus Verilog y Gtkwave) en todas las plataformas
soportadas, por lo que es una buena alternativa en sistemas donde no sea fácil
instalar las herramientas nativamente. El proyecto permite también implementar
los diseños realizados en varios tipos de FPGAs y placas de desarrollo
soportadas, teniendo así un entorno de desarrollo completo.

### Otros entornos

El alumno puede usar cualquier otro entorno de diseño de circuitos que soporte
Verilog, como los entornos proporcionados por los distintos fabricantes de
FPGAs. Con estos entornos el alumno podrá realizar la implementación de los
diseños en los dispositivos del fabricante correspondiente.

Existen entornos de diseño en web con soporte para Verilog que permiten
desarrollar y simular diseños, como
[EDAplayground](https://www.edaplayground.com/)
que resultan muy convenientes para pequeños proyectos sin necesidad de instalar
nada en el ordenador.

[1]: http://www.icarus.com/eda/verilog/
[2]: http://gtkwave.sourceforge.net/
[3]: http://bleyer.org/icarus/
[4]: http://notepad-plus-plus.org/
[5]: https://github.com/FPGAwars/apio-ide

## CONTENIDOS

### Unidad 1. Fundamentos de lenguajes de descripción de hardware

  * Lección 1-1. Introducción a los lenguajes de descripción de hardware
  * Lección 1-2. Descripción de funciones combinacionales y simulación
  * Lección 1-3. Tipos de descripciones en Verilog

### Unidad 2. Bancos de prueba

  * Lección 2-1. Simulación con banco de pruebas
  * Lección 2-2. Comparación de descripciones con el mismo banco de pruebas

### Unidad 3. Ejemplos combinacionales

  * Lección 3-1. Descripción procedimental de una función compleja
  * Lección 3-2. Demostración de un circuito con azares
  * Lección 3-3. Diseño de una alarma sencilla para un automóvil

### Unidad 4. Subsistemas combinacionales

  * Lección 4-1. Ejemplos de descripciones de subsistemas combinacionales
  * Lección 4-2. Diseño de un convertidor BCD-7 segmentos (ejercicio)
  * Lección 4-3. Análisis de un circuito con subsistemas (ejercicio)

### Unidad 5. Circuitos aritméticos

  * Lección 5-1. Diseño de sumadores
  * Lección 5-2. Diseño de sumadores/restadores
  * Lección 5-3. Diseño de una Unidad Lógico-Aritmética

### Unidad 6. Circuitos secuenciales

  * Lección 6-1. Descripción de biestables
  * Lección 6-2. Comparación de biestables
  * Lección 6-3. Asignaciones con y sin bloqueo
  * Lección 6-4. Descripción de máquinas secuenciales. Detector de secuencia
  * Lección 6-5. Diseño de un arbitrador

### Unidad 7. Registros y contadores

  * Lección 7-1. Diseño de un registro universal
  * Lección 7-2. Diseño de un contador con varias operaciones
  * Lección 7-3. Diseño de un cronómetro (ejercicio)

### Unidad 8. Memorias.

  * Lección 8-1. Diseño de un multiplicador basado en ROM
  * Lección 8-2. Memoria RAM asíncrona
  * Lección 8-3. Memorias RAM síncronas

## CONVENIOS

  * Los archivos usan indentación de 4 espacios para una mejor estructuración
    del código. Con esta configuración todos los archivos se componen de líneas
    de 80 carácteres como máximo, por lo que son fácilmente legibles y editables
    en un terminal estándar de 80 columnas.

  * En el código se emplean dos tipos de comentarios con funciones
    diferenciadas. Los comentarios de tipo `//...` se emplean para aclaraciones
    breves que se consideran útiles para entender mejor el código. Los
    comentarios de tipo `/*...*/` contienen explicaciones más largas propias del
    curso. Este segundo tipo de comentario puede eliminarse de los archivos
    fuente para producir sólo los ejemplos sin explicaciones adicionales para,
    por ejemplo, reutilizar el código para proyectos propios. El siguiente
    ejemplo muestra como eliminar los comentarios adicionales de un archivo de
    forma fácil:

        $ awk '/\/\*/,/\*\// {next};{print}' alarma.v > clean/alarma.v

  * Este curso emplea el estándar Verilog-2001 (IEEE 1634-2001). Cualquier simulador actual soporta al menos esta versión.

  * El código, generalmente, emplea construcciones al estilo ANSI (similar a
    ANSI-C) introducida por el estándar Verilog-2001.

## EJEMPLOS ADICIONALES

Puedes encontrar ejemplos y diseños prácticos de Verilog adicionales en el
proyecto [verilog-examples](https://github.com/jjchico/verilog-examples).

## CONTRIBUCIONES

Las contribuciones al proyecto son bienvenidas en cualquier formato: informes
de errores, solicitudes de intgegración (_pull requests_), etc.

## LICENCIA

Este archivo es parte de curso_verilog.v. curso_verilog.v es software libre:
puede redistribuirlo y/o modificarlo bajo los términos de la Licencia General
Pública de GNU publicada por la Fundación de Software Libre, tanto su versión 3
como, opcionalmente, cualquier otra versión posterior.
Véase <http://www.gnu.org/licenses/>.                           

This file is part of curso_verilog.v. curso_verilog.v is free software: you can
redistribute it and/or modify it under the terms of the GNU General Public
License as published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.
See <http://www.gnu.org/licenses/>.                                        

2009-2018 Jorge Juan-Chico <jjchico@gmail.com>
