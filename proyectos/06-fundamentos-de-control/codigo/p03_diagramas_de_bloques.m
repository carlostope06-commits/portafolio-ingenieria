%% Práctica 3.3 · Diagramas de bloques
% Fundamentos de Control · GIERM (UMA) · curso 2025-26
% Soluciones de las tareas de la práctica (código extraído del Live Script).

%% Tarea 1
% Tarea 1: Definir los siguientes modelos H_1 (s) y H_2 (s) y realizar su conexión en serie
% usando ambos métodos, mediante el comando series y mediante la multiplicación, comprobando que
% se obtiene el mismo resultado:
% H_1 (s)=frac{2s+1}{s^2 +5s+3} H_2 (s)=frac{1}{s+5}
H1 = tf([2 1], [1 5 3]);
H2 = tf([1], [1 5]);
H3 = series(H1, H2)

%% Tarea 2
% Tarea 2: Definir los siguientes modelos y realizar su conexión en paralelo usando tanto
% parallel como aritméticamente, comprobando que se obtiene el mismo resultado:
% H_1 (s)=frac{2s+1}{s^2 +5s+3} H_2 (s)=frac{1}{s+5}
H1 = tf([2 1], [1 5 3]);
H2 = tf([1], [1 5]);
H3 = parallel(H1,H2)

%% Tarea 3
% {H1}=frac{s+5}{(s+3)(s+2)} {H2}=frac{3(s+1)}{s+5}
% Pista: Cuando se obtienen funciones de transferencia fruto de un comando distinto de zpk o tf,
% o usando aritmética de bloques, puede que la función de transferencia resultante tenga factores
% comunes en su numerador y denominador (esto es, ceros y polos con el mismo valor). Para
% simplificarlos podéis hacer uso del comando minreal en la forma siguiente: Sysn = minreal(Sys).
% Usa el comando help para
H1=zpk([-5],[-3 -2],1);
H2=zpk([-1],[-5],3);
H=minreal(feedback(H1,H2))

%% Tarea 4
% Mediante las funciones append y connect
% G_1 (s)=frac{s^2 +5s+2}{s^3 +3s^2 +3s+1} H_1 (s)=1; G_2 (s)=frac{7s^2 +s+2}{s^3 +s^2 +1} H_2
% (s)=frac{1}{s+1}; G_3 (s)=frac{s+1}{s^2 +5s} H_3 (s)=frac{s+2}{s^2 +4s+5}
% G1
G1 = tf([1 5 2], [1 3 3 1]);
H1 = 1;

sys1_tf = feedback(G1, H1)

I = 1; F= 1;
sys1_ap = append(I, G1, H1, F);

q=[2 1 -3; 3 2 0; 4 2 0];
sysb_ss=connect(sys1_ap,q,1,4);
sysb_tf=tf(sysb_ss)

%% Tarea 5
% Mediante las funciones append y connect.
% Pista: Como puede verse, junto a cada diagrama de bloques se muestra la correspondiente
% solución.
G0 = 1;
G1 = tf([1],[1 0]);
G2 = tf([10], [1 5]);
G3 = tf(1, [1 2]);
sysba = append(G0, G1, G2, G3);
q = [2 1 -4; 3 2 0; 4 3 0];
sysb_ss = connect(sysba, q, 1, 3);
sysb_tf = tf(sysb_ss)

%% Tarea 6
% Tarea 6:
G0=1;
G1=3;
G2=tf(1,[1 2]);
G3=tf(3,[1 4]);
G4=4;
G5 = 1
sysba=append(I,G1,G2,G3,G4, G5);
q=[2 1 -4; 3 2 -3; 4 3 0; 5 3 0; 6 4 5 ];
sys_ss=connect(sysba,q,1,6);
sys_tf=tf(sys_ss)

%% Tarea 7
% Tarea 7:
G0=1;
G1=1;
G2=tf([3 0],[1 1]);
G3=8;
G4=tf([1 0],[1 1 10]);
G5=tf(2,[1 2]);
G6=1;
G7=1;
sysba=append(G0,G1,G2,G3,G4,G5,G6,G7);
q=[2 1 -7; 3 1 0; 4 2 -6; 5 4 -3; 6 4 -3; 7 5 0; 8 5 0];
sys_ss=connect(sysba,q,1,8);
sys_tf=tf(sys_ss)

%% Tarea 8
% Tarea 8:
G0=1;
G1=1;
G2=tf(1,[1 1]);
G3=tf(1,[1 0]);
G4=1;
G5=tf(1,[1 0]);
G6=1;
sysba=append(G0,G1,G2,G3,G4,G5,G6);
q=[2 1 -6; 3 2 -3; 4 3 -5; 5 4 -6; 6 5 -6; 7 6 0];
sys_ss=connect(sysba,q,1,7);
sys_tf=tf(sys_ss)

%% Tarea 9
% Tarea 9:
G1=1;
G2=3;
G3=tf([1 0],[1 1]);
G4=2;
G5=tf(25,[1 1]);
G6=30;
G7=tf(1,[1 0]);
G8=tf(1,[1 0]);
G9=6;
G10=1;
sysba=append(G1,G2,G3,G4,G5,G6,G7,G8,G9,G10);
q=[2 1 -9;3 2 -5; 4 3 -8; 5 4 0; 6 4 0; 7 6 0; 8 7 0;9 7 0;10 7 0];
sys_ss=connect(sysba,q,1,10);
sys_tf=tf(sys_ss)
