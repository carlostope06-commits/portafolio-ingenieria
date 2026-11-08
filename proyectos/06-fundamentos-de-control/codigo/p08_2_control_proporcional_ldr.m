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
%4
syms k s
G=(6*k)/(s*(s+2.5))
N=6*k
D=s*(s+2.5)
N0=6*k
D0=0
e=D0/(D0+N0)
% el error es siempre menor que eso, valga lo que valga k
%la condición 5 se cumple 0.41<k<1.27
%la condición 6 se cumple para k>0.25
%%la condición 7 se cumple 0.41<k<1.27

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
%4
syms k s
G=(15*k)/(s*(s+3))
N0=15*k
D0=0
e=0
%se cumple siempre sea cual sea el valor de k
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
%la condición 2 se cumple k>15.542
%la condición 3 se cumple k>1.3904
%la condicion 4 se cumple si k<0.56654
%la condición 5 se cumple siempre ya que el error en régimen permanente es
%0
%la condición 6 no se cumple nunca
%la condición 7 se cumple para k>1.3904

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
%la condición 2 no puede cumplirse porque el sistema se vuelve inestable
%la condicion 3 se cumple si 0<k<29.852
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
%la condición 5 no puede cumplirse nunca
%la condicion 6 se cumple si 3<k<29.852
% la condición 7 no puede cumplirse nunca
