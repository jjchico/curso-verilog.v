// Diseño:      Detector de secuencia
// Archivo:     secuencia.v
// Descripción: Detector de secuencia con solapamiento.
//              Versiones Mealy y Moore.
// Autor:       Jorge Juan <jjchico@gmail.com>
// Fecha:       09/06/2010

/*
   Lección 6-4: Máquinas de estados finitos. Detector de secuencia.

   Las máquinas de estados finitos producen en cada instante una salida (z) que
   depende del estado de la máquina (q) y de la entrada aplicada en ese
   instante (x). Así mismo, se calcula un próximo estado (Q) que será alcanzado
   en un instante posterior. Cuando la función de salida depende directamente
   de la entrada la máquina se denomina de Mealy, mientras que cuando la
   función de salida sólo depende del estado actual se denomina de Moore.

   Las máquinas de estado se representan de forma conveniente mediante
   diagramas de estados y tablas de estados, con los que se supone que el
   alumno está familiarizado.

   Las máquinas de estado se implementan mediante circuitos digitales
   empleando biestables para almacenar el estado de la máquina y circuitos
   combinacionales para construir las funciones de salida y próximo estado.
   Por motivos prácticos, el instante de cambio de estado de la máquina viene
   fijado por la presencia de un flanco (de subida o bajada) en una señal de
   control especial (señal de reloj -ck-). Este tipo de circuitos se denominan
   "Circuitos Secuenciales Síncronos".

                        (Mealy)
            ,-- -- -- -- -- -- -- -- -- -- --
            |   _______          _______     |    _______
            |  |       |        |       |    |   |       |
      x ----·->|       |   Q    |       |    `-->|       |
            q  | C.C.  |------->| Biest.|  q     | C.C.  |-----> z
          ,--->|       |        |       |----·-->|       |
          |    |       |   ck-->|       |    |   |       |
          |    |_______|        |_______|    |   |_______|
          `----------------------------------´

   La forma más conveniente de describir en Verilog una máquina de estado es
   creando un bloque (habitualmente un proceso) independiente para cada parte
   de la máquina:

   - Un proceso combinacional para el cálculo del próximo estado.
   - Un proceso combinacional para el cálculo de la salida.
   - Un proceso secuencial muy simple que convierte el próximo estado calculado
     en el estado actual cada vez que se produce un flanco activo de la señal
     de reloj. Este proceso también pude forzar un estado inicial en función
     de una señal de iniciación o 'reset'.

   En esta lección construiremos un circuito secuencial con una entrada 'x' y
   una salida 'z' cuyo objetivo es detectar la aparición de una determinada
   secuencia de bits en 'x', de forma que 'z' se activará (valor '1') cuando
   por la entrada 'x' se haya obsrvado la secuencia '1001' en los últimos bits.
   El detector de secuencia considera el posible solapamiento de las
   secuencias, esto es, el último bit '1' de una secuencia correcta también se
   considera el primer bit '1' de una posible secuencia correcta posterior.

   Por ejemplo:
        x: 00100111000011101001001001010011...
        z: 00000100000000000001001001000010...
*/

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Detector de secuencia (Mealy)                                        //
//////////////////////////////////////////////////////////////////////////

/*
 * La siguiente tabla de estados representa el funcionamiento del detector de
 * secuencia.
 *
 *        Entrada (x)
 * Estado   0     1
 *        -----------
 *   A   | A,0   B,0 |        A: esperando primer bit
 *   B   | C,0   B,0 |        B: primer bit correcto (1)
 *   C   | D,0   B,0 |        C: segundo bit correcto (0)
 *   D   | A,0   B,1 |        D: tercer bit correcto (0)
 *        -----------
 *      Próximo estado, z
 *
 * La detección de la secuencia correcta se produce en el estado D: si se han
 * recibido 3 bits correctos y el cuarto es un 1 se activa la salida (z=1) y se
 * pasa al estado B, porque el último 1 puede ser considerado el primer bit
 * correcto de una secuencia posterior (solapamiento). En caso contrario, la
 * secuencia es incorrecta y volvemos a A.
 */
 module seq_mealy(
     /* El circuito dispone de una entrada 'reset' que fuerza el estado del
      * sistema a un estado conocido (A). La señal 'reset' suele aparecer en
      * la mayoría de las máquinas de estado para resolver el problema de
      * determinar el estado inicial que, en general, es desconocido */
     input wire ck,     // reloj
     input wire reset,  // reset
    input wire x,       // entrada
     output reg z       // salida
     );

     // Codificación de estados
     /* El estado se alamacena en una variable (tipo reg) definida más
      * adelante. La variable de estado es un vector de bits con un código
      * asignado a cada estado. Aquí se definen parámetros con el nombre
      * de cada estado a los que se asigna el código elegido, de esta forma
      * es posible cambiar la cofificación de los estados fácilmente sin
      * alterar el resto del diseño. Existen muchos criterios para asignar
      * códigos a los estados. Aquí se ha elegido una alternativa
      * "altamente codificada": se ha empleado el número mínimo de bits,
      * pero existen muchas otras alternativas como usar código "one-hot"
      * (un bit por cada estado). Las herramientas de síntesis automática
      * pueden detectar las variables de estado y reasignar la codificación
      * de estados para conseguir una implementación más óptima en
      * velocidad de operación, consumo de energía, ahorro de componentes,
      * etc. */
     parameter [1:0]
         A = 2'b00,
         B = 2'b01,
         C = 2'b11,
         D = 2'b10;

    // Variables de estado y próximo estado
    /* 'state' almacenará el estado actual mientras que 'next_state' se
     * usará para calcular el próximo estado. */
    reg [1:0] state, next_state;

    /* Como hemos mencionado, la descripción más clara de una máquina de
     * estados se compone de tres procesos: uno secuencial para el cambio
     * de estado y dos combinacionales para el cálculo del próximo estado
     * y de la salida respectivamente. A continuación se describen estos
     * tres procesos. */

    // Proceso de cambio de estado (secuencial)
    /* Este proceso, el único secuencial, es muy simple: si se activa la
     * señal 'reset' se cambia al estado A, en caso contrario, el próximo
     * estado calculado en 'next_state' se convierte en el estado actual.
     * La lista de sensibilida hace que el cambio de estado se produzca
     * cada flanco de subida del reloj o bien cuando se activa la señal
     * 'reset' (en caso de iniciación). */
    always @(posedge ck, posedge reset)
        if (reset)
            state <= A;
        else
            state <= next_state;

    // Proceso de cálculo del nuevo estado (combinacional)
    /* El cálculo del nuevo estado es una simple transcripción de la tabla
     * de estados de más arriba. Cada caso de la construcción 'case'
     * representa una fila de la tabla de estados (un estado actual). En
     * cada caso, el próximo estado se calcula en función de las entradas.
     * Empleando la instrucción 'if' como en este caso, la traducción de
     * la tabla de estados es especialmente directa. */
    always @* begin
        /* El próximo estado debe asignarse en todos los casos, si no
         * es así aparecera como desconocido (x) y será más fácil
         * detectar el posible error en la simulación */
        next_state = 2'bxx;
        case (state)
        A:
            if (x == 0)
                next_state = A;
            else
                next_state = B;
        B:
            if (x == 0)
                next_state = C;
            else
                next_state = B;
        C:
            if (x == 0)
                next_state = D;
            else
                next_state = B;
        D:
            if (x == 0)
                next_state = A;
            else
                next_state = B;
        endcase
    end

    // Proceso de cálculo de la salida (combinacional)
    /* La salida es una función del estado y de la entrada (máquina de
     * Mealy. Puede emplearse cualquier estructura combinacional para
     * describirla. En este caso basta observar que la salida sólo vale '1'
     * cuando estamos en el estado D y la entrada x vale '1'. */
    always @* begin
        if (state == D && x == 1)
            z = 1;
        else
            z = 0;
    end
endmodule // seq_mealy

//////////////////////////////////////////////////////////////////////////
// Detector de secuencia (Moore)                                        //
//////////////////////////////////////////////////////////////////////////

/*
 * La tabla de estados de la máquina de Moore equivalente es muy similar
 * salvo por que incluye un nuevo estado, el E, que tiene asociada salida '1'
 * cuando se ha recibido la secuencia completa de forma correcta.
 *
 *        Entrada (x)
 * Estado   0    1    Salida (z)
 *        ----------
 *   A   |  A    B  |   0        A: esperando primer bit
 *   B   |  C    B  |   0        B: primer bit correcto (1)
 *   C   |  D    B  |   0        C: segundo bit correcto (0)
 *   D   |  A    E  |   0        D: tercer bit correcto (0)
 *   E   |  C    B  |   1        E: secuencia correcta
 *        ----------
 *      Próximo estado
 */
 module seq_moore(
     input wire ck,     // reloj
     input wire reset,  // reset
    input wire x,       // entrada
     output reg z       // salida
     );

     // Codificación de estados
     /* En este caso se ha optado por una codificación "one-hot" que
      * emplea un biestable por cada estado. Esta codificación emplea más
      * elementos de memoria pero produce ecuaciones más simples y
      * eficientes y es la que suelen emplear las herramientas de síntesis
      * en ausencia de restricciones en el número de biestables. */
     parameter [4:0]
         A = 5'b00001,
         B = 5'b00010,
         C = 5'b00100,
         D = 5'b01000,
         E = 5'b10000;

    // Variables de estado y próximo estado
    reg [4:0] state, next_state;

    // Proceso de cambio de estado (secuencial)
    /* El proceso de cambio de estado es idéntico al de la variante
     * Mealy */
    always @(posedge ck, posedge reset)
        if (reset)
            state <= A;
        else
            state <= next_state;

    // Proceso de cálculo del nuevo estado (combinacional)
    /* El proceso de cambio de estado es prácticamente idéntico al del
     * caso Mealy salvo porque incluye el nuevo estado E. */
    always @* begin
        next_state = 2'bxx;
        case (state)
        A:
            if (x == 0)
                next_state = A;
            else
                next_state = B;
        B:
            if (x == 0)
                next_state = C;
            else
                next_state = B;
        C:
            if (x == 0)
                next_state = D;
            else
                next_state = B;
        D:
            if (x == 0)
                next_state = A;
            else
                next_state = E;
        E:
            if (x == 0)
                next_state = C;
            else
                next_state = B;
        endcase
    end

    // Proceso de cálculo de la salida (combinacional)
    /* En este caso la salida está asociada únicamente al estado, lo que
     * simplifica el cálculo de la salida, que se activa sólo en caso de
     * estar en el estado E. */
    always @* begin
        if (state == E)
            z = 1;
        else
            z = 0;
    end
endmodule // seq_moore

/*
   (continúa en secuencia_tb.v)
*/
