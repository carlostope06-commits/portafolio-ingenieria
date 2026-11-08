%% Práctica 5 · Laboratorio: respuesta temporal de un circuito RLC de segundo orden
% Fundamentos de Control · GIERM (UMA) · curso 2025-26
% Soluciones de las tareas de la práctica (código extraído del Live Script).

%% Tarea 1
% A continuación, determine, como una función de la resistencia del potenciómetro, la expresión
% particular de la misma que correspondería a los valores característicos que se dan de los
% componentes del circuito.
% Asimismo, determine su expresión concreta para los valores extremos (0 y 100KΩ) de dicha
% resistencia.
s = tf('s');
G1 = 1/(33*10^-3*10^-9*s^2+1000*10^-9*s+1)
G2 = 1/((33*10^-3*10^-9*s^2+(1000+100000)*10^-9*s+1))

%% Tarea 2
% Tarea 3: A partir de la función de transferencia genérica obtenida en la tarea anterior,
% obtener el valor genérico de la ganancia estática, la frecuencia natural y el factor de
% amortiguamiento del sistema como funciones de la resistencia R, el coeficiente de autoinducción
% L de la bobina y la capacidad C del condensador.
syms L C R s
G = 1/(L*C*s^2+R*C*s+1)
k = 1;
wn = sqrt(1/(C*L))
chi = R/(2*L*wn)

%% Tarea 3
% Asimismo, obtenga, como una función de la resistencia del potenciómetro, la expresión
% particular de cada uno de estos parámetros que correspondería a los valores característicos que
% se dan de los componentes del circuito.
wn = sqrt(1/(10^-9*33*10^-3))
K = 1;
chi = (1000+R)/(2*33*10^-3*wn)

%% Tarea 4
% La sobreoscilación.
% Tarea 12: Con la placa desconectada, mida el valor de la resistencia del potenciómetro en las
% posiciones consideradas en los apartados 11), 10) y 9).
%Apartado 9 = 87
%Apartado 10 = 101.4k
%Apartado 11 = 7.63k

%% Tarea 5
% 5.3. Identificación del sistema
% Tarea 13: A partir de la información obtenida en el apartado 9), determine la función de
% transferencia del sistema considerado para la posición extrema del potenciómetro en la cual el
% sistema tiene un comportamiento subamortiguado [3].
s = tf('s');
G = 1/(33*10^-3*10^-9*s^2+(1000+87)*10^-9*s+1)

%% Tarea 6
% 5.4. Análisis, mediante simulación, de la respuesta temporal del sistema
% Tarea 14: Simule, a partir del modelo obtenido en el apartado 2) y empleando el paquete MATLAB,
% la respuesta ante una señal de entrada escalón unitario que el circuito considerado presentaría
% para el caso particular en el que la resistencia del potenciómetro tuviera el valor extremo (0
% ó 100KΩ) para el que, según los cálculos realizados en el apartado 4), el comportamiento del
% sistema sería clasif
step(G)

%% Tarea 7
% El tiempo de establecimiento (según el criterio del 5%).
% La sobreoscilación.
%tiempo de subida = 9.6 us
%tiempo de pico = 19.23 us
%tiempo de establecimiento = 0.18 ms
%tiempo de sobreoscilación = 0.72 , es decir, el 28%

%% Tarea 8
% Tarea 16: Simule, a partir del modelo obtenido en el apartado 2) y empleando el paquete MATLAB,
% la respuesta ante una señal de entrada escalón unitario que el circuito considerado presentaría
% para el caso particular en el que la resistencia del potenciómetro tuviera el valor extremo (0
% ó 100KΩ) para el que, según los cálculos realizados en el apartado 4), el comportamiento del
% sistema sería clasif
s = tf('s');
G = 1/(33*10^-3*10^-9*s^2+(1000+101400)*10^-9*s+1)
step(G)

%% Tarea 9
% El tiempo de establecimiento (según el criterio del 5%).
% La sobreoscilación.
%Constante de tiempo = 0.11 ms
%tiempo de establecimiento = 0.32 ms
%Sobreoscilación = 0.

%% Tarea 10
% Tarea 18: Repita los apartados 17) y 16) para el caso particular en el que la resistencia del
% potenciómetro tuviera el valor para el que, según los cálculos realizados en el apartado 4), el
% comportamiento del sistema sería clasificable como críticamente amortiguado.
s = tf('s');
G = 1/(33*10^-3*10^-9*s^2+(1000+11500)*10^-9*s+1)
step(G)
%La constante de tiempo es 13.8 us
%El tiempo de establecimiento es de 32 us
%La sobreoscilación es 0

%% Tarea 11
% 5.5. Comparación de los resultados obtenidos
% Tarea 19: Compare el valor extremo de la resistencia del potenciómetro determinado en los
% apartados 4) y 12) para el cual el comportamiento del sistema es clasificable como
% subamortiguado.
%En el caso del 4), se halla que el valor de la resistencia se debe
%entre 0 y 11500. En el otro caso, el de el 12), se halla que debe situarse
%en torno a 80 ohmios.

%% Tarea 12
% El tiempo de establecimiento (según el criterio del 5%).
% La sobreoscilación.
%En el tiempo de salida, la medida es 10 us y el calculado es 9.6 us
%El tiempo de pico medido es de 18 us y el calculado 19.23
%El tiempo de establecimiento medido es 0.16 ms y el calculado 18 ms
%La sobreoscilación medida es 32% y la calculada 28%

%% Tarea 13
% Asimismo, compare el valor obtenido en los apartados 3) y 9) para la ganancia estática del
% sistema.
%Las ganancias de ambos apartados son iguales: 1 (V/V)

%% Tarea 14
% Tarea 21: Compare el valor extremo de la resistencia del potenciómetro determinado en los
% apartados 4) y 12) para el cual el comportamiento del sistema es clasificable como
% sobreamortiguado.
%En el caso del primer apartado se puso de condición que la resistencia
%fuera mayor a 11500. En el caso del segundo apartado se observa que la
%resistencia es de 101400

%% Tarea 15
% El tiempo de establecimiento (según el criterio del 5%).
% La sobreoscilación.
%La constante de tiempo medida es 108 us y la calculada 110 us
%El tiempo de establecimiento medido es 564 us y la calculada es 320 us
%La sobreoscilación es 0

%% Tarea 16
% Asimismo, compare el valor obtenido en los apartados 3) y 10) para la ganancia estática del
% sistema.
%Tanto en el primer apartado como en el segundo la ganancia es de
%1 (V/V)

%% Tarea 17
% Tarea 23: Compare el valor de la resistencia del potenciómetro determinado en los apartados 4)
% y 12) para el cual el comportamiento del sistema es clasificable como críticamente amortiguado
%En el primer apartado la resistencia total ha de ser 2*sqrt(L/C) = 11.5k, es
%decir, 10.5k en el potenciómetro (restando R_L = 1k). En el laboratorio el
%crítico se obtiene con 7.63k: el circuito real tiene unos 2.6k de
%resistencia adicional (generador y pérdidas de la bobina) que el modelo
%nominal no incluye

%% Tarea 18
% El tiempo de establecimiento (según el criterio del 5%).
% La sobreoscilación.
%La constante de tiempo medida es 10.8 us y calculada 110 us
%El tiempo de establecimiento medido es 21.6 us y calculado 320 us
%La sobreoscilaciónes 0

%% Tarea 19
% Asimismo, compare el valor obtenido en los apartados 3) y 11) para la ganancia estática del
% sistema.
%Tanto en el primer apartado como en el segundo, la ganancia es de
%1 (V/V)

%% Tarea 20
% Tarea 25: Para el valor extremo de la resistencia del potenciómetro para el cual el sistema
% presenta un comportamiento clasificable como subamortiguado, compare la función de
% transferencia obtenida en los apartados 2) y 13).
%En ambos casos la función es aprecida y se diferencian en que el en el
%primer apartado, la resistencia es de 0 y en el segundo de 87.
