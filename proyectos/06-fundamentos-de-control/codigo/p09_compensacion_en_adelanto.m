%% Práctica 9 · Compensación en adelanto
% Fundamentos de Control · GIERM (UMA) · curso 2025-26
% Soluciones de las tareas de la práctica (código extraído del Live Script).

%% Tarea 1
% Para diseñar el compensador se recomienda seguir los pasos anteriormente vistos:
% 1. Obtención de los polos dominantes deseados del sistema en bucle cerrado.
s = tf('s');
G = 1/(s^2 -2);
H = 1;
Gba = G*H;
Gbc = feedback(G,H);
pd = [-1+1*i ; -1-1*i]

%% Tarea 2
% 2. Comprobación de si un compesandor proporcional es suficiente.
figure
rlocus(Gba)
hold on
plot(real(pd),imag(pd),'bx');
hold off

%% Tarea 3
% 3. Obtención de la deficiencia de ángulo φ.
% Pista: usar la función angle() de Matlab. rad2deg() permite pasar de radianes a grados.
Gba
s = pd(1);
Gba_ev = 1/(s^2 -2)
phi_Gba_s = rad2deg(angle (Gba_ev))
phi_deseado = 180- phi_Gba_s

%% Tarea 4
% 4. Diseño del compensador: Determinación de α y T para compensar φ. Por ejemplo, elige el cero
% para que cancele un polo real negativo de la función de transferencia del sistema en bucle
% abierto.
zc = -sqrt(2)
T = -1/zc
phi_polo = rad2deg(angle(s-zc))-phi_deseado
pc = real (s) - (imag(s))/(tan (deg2rad(phi_polo)))
alpha = -1/(T*pc)

%% Tarea 5
% 5. Rematamos con la obtención de K_c a partir del lugar de las raíces modificado. Emplear la
% condición de magnitud:
% |K_c frac{(s_1 -z_c )}{(s_1 -p_c )} G(s_1 )H(s_1 )|=1 ⇒ K_c =|frac{(s_1 -p_c )}{(s_1 -z_c
% )}frac{1}{G(s_1 )H(s_1 )}|
kc = abs( ((s^2-2)*(s-pc)) / (s - zc) )
s = tf('s');
G_comp = zpk (zc, pc, kc)

%% Tarea 6
% Obtener los polos dominantes de la función de transferencia del sistema, incluyendo al
% compensador, en bucle cerrado. Comprobar si se corresponden con los deseados.
% Mostrar el nuevo lugar de las raíces e indicar con asteriscos los polos de bucle cerrado.
% Pista: usa plot.
Gba
G_compensador = (s+1.4142)/(s+3.4142)
Gcomp = kc*Gba*G_compensador
polos_bc = pole( feedback(Gcomp,1) )
figure
rlocus(Gcomp)
hold on
plot (real(polos_bc), imag(polos_bc), '*b')
