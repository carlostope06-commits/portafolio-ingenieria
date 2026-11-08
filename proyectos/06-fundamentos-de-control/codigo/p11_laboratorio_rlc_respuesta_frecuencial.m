%% Práctica 11 · Laboratorio: respuesta frecuencial del circuito RLC
% Fundamentos de Control · GIERM (UMA) · curso 2025-26
% Soluciones de las tareas de la práctica (código extraído del Live Script).

%% Tarea 1
% G(s)=frac{1}{LCs^2 +(R_{pot} +R_L )Cs+1}
% Asimismo, determine su expresión concreta para el valor de 2 KΩ de dicha resistencia.
R = 2000;
L = 33e-3;
C = 1e-9;
den = [L*C, R*C, 1];
num = 1;
H = tf(num, den)

%% Tarea 2
% 5.4. Análisis, mediante simulación, de la respuesta temporal del sistema
% Tarea 11: Simule, a partir del modelo obtenido en el apartado 2) y empleando el paquete MATLAB,
% la respresentación del diagrama de bode del sistema. Comparar los resultados con los obtenidos
% experimentalmente.
R = 3500;
L = 29e-3;
C = 1e-9;
s = tf('s');
H = 1 / (L*C*s^2 + R*C*s + 1)
