%% Práctica 12 · Diseño de controladores PI y PID por asignación de polos
% Fundamentos de Control · GIERM (UMA) · curso 2025-26
% Soluciones de las tareas de la práctica (código extraído del Live Script).

%% Tarea 1
% Comprar la respuesta del sistema en bucle cerrado sin y con controlador ante entrada escalón
% unitario.
% Dibujar el nuevo lugar de las raíces del sistema realimentado señalando la ubicación de los
% polos de lazo cerrado. ¿Coincide esta ubicación con la de los polos deseados?
% 1
syms s K T
G = 0.1/(s+0.0375); H = 1;
Gc = K*((s + 1/T)/s);
ec = simplify(1 + H*Gc*G,'Steps',2,"All",true)
ec = ec(3);
[num,dem] = numden(ec);
num = simplify(num/(80*T),'Steps',20)
num = vpa(num)
pd = [ -0.0375+0.0509i ; -0.0375-0.0509i];
ec = simplify((s-pd(1))*(s-pd(2)),'Steps',10,"All",true)
[K,T] = solve(0.1*K +0.0375 == 3/40 , (0.1*K)/T == (199853/50000000) , [K,T])
K = eval(K)
T = eval(T)
s = tf('s');
Gc = K*((s + 1/T)/s)

%% Tarea 2
% Mostrar la salida del sistema en bucle cerrado con y sin controlador ante entrada escalón
% unitario.
% Dibujar el nuevo lugar de las raíces del sistema realimentado señalando la ubicación de los
% polos de lazo cerrado. ¿Coincide esta ubicación con la de los polos deseados?
% 1
syms Kp Ti Td s
G = 2/(s^2 + 2*s +2); H = 1;
Gc = (Kp*(1+Ti*s+Ti*Td*s^2))/(Ti*s);
pd = [-7.4159 ; -2.6509 + 3.8044i ; -2.6509 - 3.8044i];
ec = simplify(1+G*Gc*H, 'Steps',20,'All',true)
ec = ec(3)
[N,D] = numden(ec);
N = simplify(N/Ti,'Steps',20,'All',true)
N = N(2)
ecp = expand((s-pd(1))*(s-pd(2))*(s-pd(3)))
c = real(coeffs(ecp, s, 'All'))     % [1  12.7177  60.8183  159.4473]
sol = solve(2 + 2*Kp*Td == c(2), 2 + 2*Kp == c(3), (2*Kp)/Ti == c(4), [Kp,Ti,Td]);
Kp = double(sol.Kp)
Ti = double(sol.Ti)
Td = double(sol.Td)
s = tf('s');
Gc = (Kp*(1+Ti*s+Ti*Td*s^2))/(Ti*s)
% Kp = 29.41, Ti = 0.369 s, Td = 0.182 s
Gbc = feedback(Gc*2/(s^2+2*s+2), 1);
pole(Gbc)                            % -7.4159 y -2.6509 ± 3.8044i
step(feedback(2/(s^2+2*s+2),1), Gbc), legend('Sin controlador','Con PID')
