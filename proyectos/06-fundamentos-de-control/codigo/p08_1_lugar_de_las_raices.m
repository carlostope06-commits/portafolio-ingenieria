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
G5=tf([4 10],[1 3 4]);
%la posición sería -3, su coeficiente de amortiguamiento es 1 y la
%sobreoscilación 0
step(G5)
