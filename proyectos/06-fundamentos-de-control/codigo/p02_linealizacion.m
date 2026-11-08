%% Práctica 2.2 · Linealización de sistemas no lineales
% Fundamentos de Control · GIERM (UMA) · curso 2025-26
% Soluciones de las tareas de la práctica (código extraído del Live Script).

%% Tarea 1
% donde x_1 representa la población de predadores y x_2 la de presas. Considera que la salida del
% sistema es y=x_1. Se pide:
% 1. Calcular todos los puntos de equilibrio, tanto analíticamente como empleando cálculo
% simbólico en Matlab.
%Analiticamente:
% x1(x2-1) = 0 ; x2(1-x1) = 0
%  (0,0) y (1,1)

syms x1 x2

[x1e, x2e] = solve([-x1 + x1*x2 == 0, x2 - x1*x2 == 0], [x1, x2]);

disp(x1e);
disp(x2e);

%% Tarea 2
% 2. Linealizar las ecuaciones de estado alrededor de cada punto de equilibrio.
syms x1 x2
M = [-x1 + x1*x2; x2 - x1*x2];
J = jacobian(M, [x1, x2]);
disp(J);
% Punto de equilibrio x1e=0, x2e=0
A1 = double(subs(J, [x1, x2], [0, 0]))
B = [0; 0];
C = [1, 0];
D = 0;
% Punto de equilibrio x1e=1, x2e=1
A2 = double(subs(J, [x1, x2], [1, 1]))

%% Tarea 3
% Segundo punto de equilibrio:
% 3. Estudiar la estabilidad de los puntos de equilibrio.
polos_P1 = eig(A1)
polos_P2 = eig(A2)

%% Tarea 4
% 4. Comparar sobre el plano de estados la simulación de los procesos no lineal y linealizados
% cuando se parte de x_1 =2 y x_2 =1. Realizar las simulaciones en el intervalo de tiempo
% t=[0,10].
tiempo = [0 10];
x0 = [2; 1];
Peq.ref = [1; 1];
% Sistema no linealizado (Pista: Utiliza ode23)
f_nolineal = @(t,x) [-x(1) + x(1)*x(2); x(2) - x(1)*x(2)];
[tnl, xnl] = ode23(f_nolineal, tiempo, x0);

%% Tarea 5
% 2. Obtener el punto de equilibrio del sistema, tanto a mano como con cálculo simbólico,
% suponiendo que se va a aplicar una fuerza constante de 10N (u_e =10).
% 3. Linealizar las ecuaciones de estado, tanto a mano como empleando cálculo simbólico.
syms x1e x2 u x1e
f1 = x2;
f2 = u - 2*x1e^2;
g = x1e;
A = jacobian([f1; f2], [x1e, x2])
B = jacobian([f1; f2], u)
C = jacobian(g, [x1e, x2])
D = jacobian(g, u)

%% Tarea 6
% 4. Comprobar la estabilidad del sistema en los dos puntos de equilibrio, y definir las matrices
% A, B, C y D con las que trabajar.
% Para el primer punto de equilibrio, x1e = sqrt(5), x2e = 0;

x1e_1 = sqrt(5);
A1 = [0 1; -4*x1e_1 0];
poles_pe1 = eig(A1)

%% Tarea 7
% 5. Simular la respuesta del sistema linealizado, suponiendo que parte de un desplazamiento
% inicial de 1m y el reposo (esto es, .x_0 =[ x_{10} ,x_{20} ] =[ 1,0] ). Realizar la simulación
% para el intervalo de tiempo t=[ 0,10] tomando 400 puntos intermedios.
% Pista: usa linspace y lsim.
N = 400;
X0 = [1 0];
Tf = 10;
delta_u = zeros(1, N);
t = linspace(0, Tf, N);
delta_x0 = X0 - [x1e x2e];
G = ss(eval(A), double(B), C, D);
[delta_y, t, delta_x] = lsim(G, delta_u, t, double(delta_x0));
X_lin = delta_x + [x1e x2e];
ye = double(x1e);
Y_lin = delta_y + ye;
plot([0 10], [10 10]); hold on
plot([0 10], [sqrt(5) sqrt(5)]);
plot(t, Y_lin);
plot(t, X_lin(:, 2));
hold off
legend('f(t) = 10N', 'x1e = sqrt(5)', 'x1 = Desplazamiento de la masa', 'x2 =Velocidad de desplazamiento')
24

%% Tarea 8
% 6. Comparar sobre el plano de estados la simulación de los procesos no lineal y linealizados.
% Pista: usa ode23 para simular el sistema original.
% Simulación del sistema original
U = ue;
dxdt = @(t, x) [x(2) ; U-(2*x(1)^2)];
[tout, Xorig] = ode23(dxdt, [0 Tf], X0);
Yorig = Xorig(:, 1);
