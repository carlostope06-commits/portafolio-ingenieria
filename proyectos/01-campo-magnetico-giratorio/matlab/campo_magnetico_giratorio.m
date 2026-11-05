% TAREA NO PRESENCIAL GRUPO B

% Parametros
Imax = 12.5;               % Amplitud máxima
f = 50;                    % Frecuencia
fang = 2*pi*f;             % Frecuencia angular
T = 1/f;                   % Periodo
t = linspace(0, T, 120);   %Vector tiempo que simule un periodo completo

% Generamos las 3 corrientes sinusoidales que componen el sistema trifásico
ia = Imax * sin(fang * t);
ib = Imax * sin(fang * t - 2*pi/3);
ic = Imax * sin(fang * t - 4*pi/3);

% Ventana Gráfica principal
figure('Color', 'white', 'Position', [50, 50, 1200, 600]);

% Grafica de las corrientes
subplot(1, 2, 1);                                             %Dividimos la grafica en 1 fial y 2 columnas, seleccionando la primera.
plot(t, ia, 'b', t, ib, 'm', t, ic, 'g', 'LineWidth', 1.5);   % Graficamos las 3 corrientes en funcion del tiempo
grid on;
xlabel('TIEMPO');
ylabel('CORRIENTE');
legend('ia', 'ib', 'ic');

% Vector de induccion magnetica
subplot(1, 2, 2);                      %Seleccionamos la segunda región
axis([-25 25 -25 25]);                 % fijamos limites ejes x e y
grid on;
title(['Vector de Induccion Magnetica']);

hold on;
h_vec = quiver(0, 0, 0, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5); %Definimos un vector modificable que vaya actualizandose segun el tiempo

% Desfase de 120º de las fases
compx = [1, cos(2*pi/3), cos(4*pi/3)];
compy = [0, sin(2*pi/3), sin(4*pi/3)];

filename = 'CampoMagneticoGiratorio.gif';

for k = 1:length(t)  % iniciamos un bucle para calcular en cada instante de tiempo que pase el vector de induccion magnetica
                     % el vector lo obtenemos sumando vectorialmente los valores instantaneos de las 3 fases

    VEC_x = ia(k) * compx(1) + ib(k) * compx(2) + ic(k) * compx(3);
    VEC_y = ia(k) * compy(1) + ib(k) * compy(2) + ic(k) * compy(3); % obtenemos las componentes en los ejes sumando las proyecciones de las fases

    % Actualizar vector en la grafica
    set(h_vec, 'UData', VEC_x, 'VData', VEC_y);
    drawnow;

    % Captura de fotogramas para guardar en GIF
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);

    if k == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.02);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.02);
    end
end

% ANALISIS DE RESULTADOS

% El vector de obtiene aplicando el principio de superposicion. Cada corriente genera un campo magnetico en su respectiva direccion
% Sumando las componentes de los campos en cada instante de tiempo podemos obtener el vector de inducción

% El giro del vector podemos justificarlo gracias al teorema de Ferraris. La combinacion del desfase espacial de 120º de las bobinas
% y el desfase temporal de 120 º de las corrientes provoca que su suma vectorial genere un vector cuyo angulo varía constantemente

% El vector magnético gira a lo que se denomina velocidad de sincronismo, igual a la frecuencia angular del sistema trifásico
% Esto significa que, en una máquina de un par de polos, el campo magnético rotativo completa una vuelta por cada ciclo

% Dado que la velocidad de giro depende directamente de la frecuencia eléctrica, modificarla provocaría un cambio en la velocidad angular del vector
% Si se aumenta la frecuencia el campo magnético girará más rápido y si se disminuye girará más lento

% Invertir la secuencia de fases invertiría el sentido de giro
