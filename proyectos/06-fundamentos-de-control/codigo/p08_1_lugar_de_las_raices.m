%% Práctica 8.1 · El lugar de las raíces
% Fundamentos de Control · GIERM (UMA) · curso 2025-26
% Soluciones de las tareas de la práctica (código extraído del Live Script).

%% Tarea 1
% El lugar de las raíces, ¿tendrá componente imaginaria?
% Usa rlocus para verificar visualmente tus respuestas.
%tiene dos ramas
%Sí, una de ellas porque no hay un polo que no tiene un cero al que tender
G= tf([2 3],[1 2 5]);
pole(G)
zero(G)

%no la va a tener porque las raíces tienen parte real negativa
%sí la tiene, puesto que los polos tienen componente imaginaria
rlocus(G)
grid on
disp(polos);
disp('Ceros del sistema:');
disp(ceros);

%% Tarea 2
% El lugar de las raíces, ¿tendrá componente imaginaria?
% Usa rlocus para verificar visualmente tus respuestas.
%Va a tener dos ramas
%si, uno de los polos irá al infinito
%sí va a tener puesto que hay un polo positivo
% no la va a tener
s=tf('s');
G=(s+1)/((s+1)*(s-1));
pole(G)
zero(G)
rlocus(G)

%% Tarea 3
% El lugar de las raíces, ¿tendrá componente imaginaria?
% Usa rlocus para verificar visualmente tus respuestas.
%va a tener 3 ramas
%ninguna va al infinito porque hay tres polos y tres ceros
%no, todos están en el izquierdo
%si, porque va a haber puntos de ruptura para que cada polo llegue a un
%cero
s=tf('s');
G=((s+7)*(s+5)*(s+2))/((s+4)*(s+3)*(s+1))
pole(G)
zero(G)
rlocus(G)

%% Tarea 4
% Tarea 4: Obtener los polos del lugar de las raíces que se corresponden con una ganancia K que
% toma valores en el rango K=[ 1,20] con incrementos de 2 para el siguiente sistema:
% G_4 (s)=frac{(s-4)(s-2)}{(s-1)(s-3)}
K=(1:2:20);
s=tf('s');
G=((s-4)*(s-2))/((s-1)*(s-3));
rlocus(G,K)

%% Tarea 5
% G_5 (s)=frac{2s+5}{s^2 +3s+4}
% Obtener cual sería la posición del polo, el coeficiente de amortiguamiento y la sobreoscilación
% para una ganancía K=2. Comprueba visualmente que dichos resultados concuerdan con la respuesta
% del sistema ante una entrada escalón unitario. ¿Qué sucede?
s=tf('s');
G5=(2*s+5)/(s^2+3*s+4);
Gbc=feedback(2*G5,1)     % bucle cerrado con K = 2: (4s+10)/(s^2+7s+14)
damp(Gbc)
step(Gbc)
%Los polos en bucle cerrado son -3.5 ± 1.32i, con zeta = 0.935, así que por
%los polos se esperaría una sobreoscilación prácticamente nula (0.02 %).
%Sin embargo, la respuesta al escalón tiene una sobreoscilación de casi el
%6 % (pico 0.755 frente a un valor final de 10/14 = 0.714). Esto sucede
%porque el bucle cerrado tiene un cero en -2.5, más cerca del eje imaginario
%que los polos, y ese cero acelera la respuesta y provoca el sobrepico. Las
%fórmulas de segundo orden solo valen si no hay ceros cercanos.
