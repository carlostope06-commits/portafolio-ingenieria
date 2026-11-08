%% Práctica 4.1 · Simulación de sistemas (respuesta temporal)
% Fundamentos de Control · GIERM (UMA) · curso 2025-26
% Soluciones de las tareas de la práctica (código extraído del Live Script).

%% Tarea 1
% Tarea 1: Analice, de forma cualitativa (estabilidad, ganancia, etc.), cual sería la respuesta
% esperable, ante una señal de entrada escalón unitario, de los sistemas cuya función de
% transferencia se indica y verifíquelo empleando el comando step.
% G_1 (s)=frac{2}{(s+2)} (un polo en el semiplano izquierdo)
s = tf('s');
G1 = 2/(s+2);
step(G1)

%% Tarea 2
% G_2 (s)=frac{3}{(s-5)} (un polo en el semiplano derecho)
s = tf('s');
G2 = 3/(s-5);
step(G2)

%% Tarea 3
% G_3 (s)=frac{1}{(s+2)(s+5)} (dos polos reales en el semiplano izquierdo)
s = tf('s');
G3 = 1/((s+2)*(s+5));
step(G3)

%% Tarea 4
% G_4 (s)=frac{29}{(s+2+5j)(s+2-5j)} (dos polos complejos en el semiplano izquierdo)
s = tf('s');
G4 = 29/((s+2+5*j)*(s+2-5*j));
step(G4)

%% Tarea 5
% G_5 (s)=frac{3}{(s-1+10j)(s-1-10j)}
s = tf('s');
G5 = 3/((s-1+10*j)*(s-1-10*j));
step(G5)

%% Tarea 6
% Tarea 2: Para el sistema cuya función de transferencia es G_4 (s), indicar qué influencia
% tendría, en su respuesta temporal ante una señal de entrada escalón unitario, el añadido de un
% polo real situado en el semiplano izquierdo complejo. ¿Cómo afectaría la ubicación de dicho
% polo con respecto a la que tienen los polos de la función de transferencia original? Obtenga y
% compare las respuestas que p
% Respuesta a la pregunta aquí:
G4=zpk([],[-2-5*j -2+5*j],29); % Sin polo
G4_1=zpk([],[-2-5*j -2+5*j -1],29*1); % Polo = -1
G4_3=zpk([],[-2-5*j -2+5*j -3],29*3); % Polo = -3
G4_20=zpk([],[-2-5*j -2+5*j -20],29*20); % Polo = -20
step(G4,G4_1,G4_3,G4_20)

%% Tarea 7
% Tarea 3: Para el sistema cuya función de transferencia es G_{ 4} (s), indicar qué influencia
% tendría, en su respuesta temporal ante una señal de entrada escalón unitario, el añadido de un
% cero real situado en el semiplano izquierdo complejo. ¿Cómo afectaría la ubicación de dicho
% cero con respecto a la que tienen los polos de la función de transferencia original? Obtenga y
% compare las respuestas qu
G4=zpk([],[-2-5*j -2+5*j],29);
G4_1=zpk([-1],[-2-5*j -2+5*j],29/1); % Cero en -1
G4_3=zpk([-3],[-2-5*j -2+5*j],29/3); % Cero en -3
G4_20=zpk([-20],[-2-5*j -2+5*j ],29/20); % Cero en -20
step(G4,G4_1,G4_3,G4_20)

%% Tarea 8
% Tarea 4: La función de transferencia G_6 (s) dada representa el modelo de una planta que es
% regulada, en bucle cerrado y con realimentación negativa y unitaria, mediante un controlador
% cuya función de transferencia, G_c (s), es igualmente dada. Obtenga la respuesta temporal que
% este sistema realimentado presentaría ante una señal de entrada escalón unitario para los
% siguientes valores de la gananc
% Pista: Muestra los resultados para K=1 y K=4 en una gráfica, y para K=8.4 y K=15 en otra
% distinta.
Gc = tf([1 1], [1 5 0]);
G6 = tf([20], [1 12 21 5]);
G1 = feedback(series(Gc,G6),1);
G_4 = feedback(series(4*Gc,G6),1);
G_8 = feedback(series(8.4*Gc,G6),1);
G_15 = feedback (series(15*Gc,G6),1);
step(G1, G_4)
step(G_8)
step(G_15)

%% Tarea 9
% Si en vez de simular la respuesta del sistema ante entrada escalón unitario, queremos simularla
% ante un escalón de una amplitud arbitraria, bastaría con multiplicar el modelo del sistema por
% dicha amplitud. Por ejemplo, la siguiente celda de código realiza una simulación ante escalón
% de amplitud 5:
% Tarea 5: Se pide obtener la respuesta ante entrada escalón de amplitud 3 desde t=0s hasta t=5s
% de la planta definida por la función de transferencia G(s)=frac{2(s+1)}{(s+2+1i)(s+2-1i)}, y
% graficarla en color magenta y utilizando un estilo de línea de guiones.
G = zpk(-1, [-2-1*i -2+1*i], 2)
tep(3*G, 0:0.1:5, 'm--')

%% Tarea 10
% impulse( sys , t ): simula la respuesta ante entrada impulso del sistema my entradas de
% distinta amplitud, también están disponibles para impulse.
% Tarea 6: Esta tarea propone la obtención de la respuesta ante impulso unitario del sistema
% G(s)=frac{2}{s^2 +0. 3s+2} hasta el instante de tiempo t=50s.
G = tf(2, [1 0.3 2]);
impulse(G, 50)

%% Tarea 11
% Tarea 7: Se pide simular la respuesta del sistema G(s)=frac{1}{s^2 +2s+2} ante entrada rampa
% unitaria hasta el instante t=10s, graficando en la misma ventana tanto la entrada en color azul
% como la respuesta del sistema en color rojo y punteada. Muestra en una leyenda con qué
% información se corresponde cada línea.
% Pista: help legend puede serte de ayuda.
s = tf('s');
G=tf(1,[1 2 2]);
t=1:10;
y=step(G/s,t);
plot(t,t,'b',t,y,'r:')
legend ('u(t)','c(t)')

%% Tarea 12
% G_{{circuito}} (s)=frac{2000}{s^2 +20s+2000}
% Se pide graficar la respuesta del sistema durante 8 segundos ante una entrada escalón de
% amplitud 5 voltios, recreando un escenario donde se alimenta al circuito desde el instante t=2s
% hasta t=4s.
G = tf(2000, [1 20 2000]);
u = zeros(size(t)); % Inicialmente toda la señal es 0
u(t >= 2 & t <= 4) = 5; %La solucion usa la alimentacion desde 2 hasta 5, pero el
enunciado pide hasta 4
y = lsim(G, u, t);
plot(t, u, t, y); legend('u(t)', 'c(t)')
