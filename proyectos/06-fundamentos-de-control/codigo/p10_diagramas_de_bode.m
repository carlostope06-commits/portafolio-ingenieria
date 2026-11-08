%% Práctica 10 · Diagramas de Bode, márgenes y estabilidad
% Fundamentos de Control · GIERM (UMA) · curso 2025-26
% Soluciones de las tareas de la práctica (código extraído del Live Script).

%% Tarea 1
% Tarea 1: Obtener el diagrama de Bode de un sistema cuya función de transferencia es:
% G(s)=frac{10(s+3)}{s(s+2)(s^2 +s+2)}
s = tf('s');
G = (10*(s+3))/(s*(s+2)*(s^2+s+2));
bode (G)

%% Tarea 2
% Calcular, a partir del diagrama de Bode de bucle abierto del sistema realimentado, la ganancia
% necesaria de un controlador proporcional para que el mismo sea estable.
% Verificar el resultado anterior con la ayuda de: a) el lugar de las raíces de dicho sistema
% considerado anteriormente y b) la respuesta que el sistema compensado proporcionalmente
% presenta ante entrada escalón unitario.
s = tf('s');
G = (10*(s+3))/(s*(s+2)*(s^2+s+2));
% 1
[Mf, Gan] = margin(G)
figure;
margin(G)
% 2
kc = margin (G)
rlocus(G, kc)
% todos los ceros y los polos se encuentran en la parte negativa del eje
% real, por ello el sistema se estabiliza en el infinito
Gbckc = feedback(kc*G,1);
step(Gbckc)
%3
% la ganacia crítica es kc = 0.1316, luego el sistema será críticamente
% estable con ganancia < kc
bode (G)
% como cumple que la diferencia de fase es 2 , que coincide con
% P - Z = 3-1 = 2, el sistema es inestable

Gbc = feedback(G,1);
step (Gbc)
rlocus (Gbc)

%% Tarea 3
% Tarea 3: Dibujar el diagrama de bode del sistema y analizar la estabilidad de un sistema con
% realimentación unitaria y función de transferencia de lazo abierto:
% G(s)=frac{(s+5)(s+3)}{(s+1)(s^2 +s+4)s}
G = ((s+5)*(s+3))/((s+1)*(s^2 +s+4)*s);
bode(G)
Gbc = feedback(G,1);
% analizo la estabilidad haciendo el lugar de las raices del sistema
% si hay polos en la parte positiva del eje real será inestable
rlocus(Gbc)
% en bucle cerrado siempre que es inestable el sistema
% estudio el sistema en bucle abierto
rlocus (G)
step (Gbc)

%% Tarea 4
% G(s)=frac{{K(s+1)}^2 }{s^3 }
% Calcular el margen de fase y de ganancia y analizar la estabilidad del sistema con respecto a
% la ganancia K.
syms k
s = tf('s');
G_k1 = (s+1)^2/s^3
margin(G_k1)
kc = margin (G_k1)
rlocus(G_k1)

%% Tarea 5
% El diagrama de bode de lazo abierto del sistema realimentado dado.
% El margen de fase y el margen de ganancia del mismo.
G = (100*(s+2))/(s*(s^2+6.4*s+64))
bode(G)
[Mf, Mg] = margin(G)
margin(G)

%% Tarea 6
% Obtener los márgenes de ganancia y de fase para los valores de K=10, K=27 y K=50. Analiza la
% estabilidad del sistema para cada valor de K.
% Calcular la respuesta al escalón unitario para los tres valores de K del apartado anterior.
% Compruebe la estabilidad analizada en el apartado anterior.
G = 1/(s*(s^2+3*s+9))
G_10 = 10*G;
G_27 = 27*G;
G_50 = 50*G;
kc = margin (G)
% Analizo la estabilidad para los distintod valores de K:
% K = 10
[Mg,Mf,Wcf,Wcg] = margin(G_10)
% como los márgenes son positivos el sistema es estable con K = 10
rlocus(G_10)
% K = 27
[Mg,Mf,Wcf,Wcg] = margin(G_27)
% el sistema es criticamente inestable porque Mf = 0
rlocus(G_27)
% K =50
[Mg,Mf,Wcf,Wcg] = margin(G_50)
% es sistema es inestable porque los márgenes son negativos
rlocus(G_50)
% 2
Gbc_10 = feedback(G_10,1);
step(Gbc_10)
title('Escalon unitario Gbc con K = 10')
Gbc_27 = feedback(G_27,1);
step(Gbc_27)
title('Escalon unitario Gbc con K = 27')
Gbc_50 = feedback(G_50,1);
step(Gbc_50)
title('Escalon unitario Gbc con K = 50')
