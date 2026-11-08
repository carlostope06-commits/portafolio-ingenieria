%% Práctica 8.2 · Control proporcional en el lugar de las raíces
% Fundamentos de Control · GIERM (UMA) · curso 2025-26
% Soluciones de las tareas de la práctica (código extraído del Live Script).

%% Tarea 1
% La sobreoscilación es menor o igual al 20%, el tiempo de pico es menor o igual que 3 segundos y
% el error en régimen permanente ante entrada rampa unitaria es menor o igual que 0.25.
% En caso afirmativo, calcular el rango de valores del parámetro del controlador proporcional que
% lo hace posible. Considerar para ello procedimientos basados en el empleo del lugar de las
% raíces del sistema.
s=tf('s');
G=6/(s*(s+2.5))
rltool(G)
%la condición 1 se cumple 0<k<1.27
%la condición 2 se cumple k>0.41
%la condición 3 se cumple k>0.25
%4 El sistema es de tipo 1, así que el error ante rampa es 1/Kv:
syms k s
G=(6*k)/(s*(s+2.5))
Kv=limit(s*G,s,0)        % Kv = 2.4k
e=1/Kv                   % e <= 0.25  ->  k >= 1.667
%la condición 4 se cumple para k>=1.667
%la condición 5 se cumple 0.41<k<1.27
%la condición 6 se cumple para k>=1.667
%la condición 7 no se cumple nunca: la condición 1 exige k<1.27 y la 4 k>=1.667

%% Tarea 2
% La sobreoscilación es menor o igual al 15% y el tiempo de pico es menor o igual que 0.75
% segundo.
% El tiempo de pico es menor o igual que 0.75 segundo y el error en régimen permanente ante
% entrada rampa unitaria es menor o igual que 0.5.
s=tf('s');
G=15/(s*(s+3))
rltool(G)
%la condición 1 se cumple 0<k<0.55231
%la condición 2 se cumple k>1.32
%la condición 3 no se cumple nunca
%4 Sistema de tipo 1: error ante rampa = 1/Kv
syms k s
G=(15*k)/(s*(s+3))
Kv=limit(s*G,s,0)        % Kv = 5k
e=1/Kv                   % e <= 0.5  ->  k >= 0.4
%la condición 4 se cumple para k>=0.4
%la condición 5 no se cumple nunca
%la condición 6 se cumple para k>1.32

%% Tarea 3
% La sobreoscilación es menor o igual al 15% y el tiempo de pico es menor o igual que 2 segundos.
% El tiempo de pico es menor o igual que 2 segundos y el error en régimen permanente ante entrada
% rampa unitaria es menor o igual que 0.5.
s=tf('s');
G=4/(s*(s+2)*(s+3))
H=tf(2)
rltool()
%la condición 1 se cumple 0<k<0.64254
%Estabilidad (Routh con s^3+5s^2+6s+8k): 0<k<3.75
%la condición 2 no se cumple nunca: haría falta k>15.542 y el sistema es
%inestable a partir de k=3.75
%la condición 3 se cumple 1.3904<k<3.75
%la condicion 4 se cumple si 0.26<k<0.56654 (para k más pequeño el polo
%real dominante está demasiado cerca del origen)
%la condición 5: el lazo GH = 8k/(s(s+2)(s+3)) es de tipo 1, Kv = 8k/6 y
%el error ante rampa es 1/Kv <= 0.5  ->  k >= 1.5
%la condición 6 no se cumple nunca
%la condición 7 se cumple para 1.5<=k<3.75

%% Tarea 4
% El tiempo de establecimiento (criterio del 2%) es menor o igual que 2 segundos y el error en
% régimen permanente ante entrada escalón unitario es menor o igual que 0.25.
% La sobreoscilación es menor o igual al 15%, el tiempo de pico es menor o igual que 0.75
% segundo, el tiempo de establecimiento (criterio del 2%) es menor o igual que 2 segundos y el
% error en régimen permanente ante entrada escalón unitario es menor o igual que 0.25.
s=tf('s');
G=450/((s+1)*(s+15)*(s+30))
%rltool(G)
%la condición 1 se cumple 0<k<7.3772
%Estabilidad (Routh con s^3+46s^2+495s+450(1+k)): 0<k<49.6
%la condición 2 se cumple 3.47<k<49.6 (wd >= pi/0.75 = 4.19 rad/s)
%la condicion 3 se cumple si 0.81<k<29.852
%4
syms k s
G=k*450/((s+1)*(s+15)*(s+30))
N0=450*k
D0=15*30
e=D0/(D0+N0)
den=0.25*(450*k+450)
450-225/2
k=2*ans/225
%la condición 4 se cumple para k>3
%la condición 5 se cumple 3.47<k<7.3772
%la condicion 6 se cumple si 3<k<29.852
%la condición 7 se cumple 3.47<k<7.3772
