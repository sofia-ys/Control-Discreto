%% Limpiar
clear
clc
close all

%% Datos del sistema
format long
Ra = 5;
La = 0.7;
Ki = 0.5;
Ke = 0.5;
Jm = 3;
Bm = 0.01;
N = 1000;
Jl = 10000;
Bl = 30;
Jeq = Jm + (Jl/N^2);
Beq = Bm + (Bl/N^2);

%% a- Ecuación diferencial (Hecho a mano)

%% b- Funcion de transferencia 
s = tf("s");
H = (1/N) * (1/( ...
    (Ra/Ki) * Jeq *s^2 + (La/Ki) * Jeq * s^3 + Ke * s + (Ra/Ki) * Beq * s + (La/Ki) * Beq * s^2));

%% c- Polos, ceros y diagrama de bode.

P = pole(H); %Polos "continuos"
[Z,gain] = zero(H);
figure
bode(H)
hold on
grid on

%% d- Periodo de muestreo y transferencia del filtro anti-alias para discretizar el sistema.
[Gm, Pm, Wcg, Wcp] = margin(H); % Wcg es la frecuencia buscada (en rad/s)
fs_rad = 15 * Wcg; % Frecuencia de muestreo en rad/s
fs_Hz = fs_rad / (2*pi);
T = 1 / fs_Hz;

% Filtro anti-alias: Pasa bajos
wc = fs_rad/2;
% De primer orden con ésta transferencia:
H_filtro = (wc / (s + wc));

%% e- Discretizar el sistema y obtener ΘL(z)/En(z), suponiendo ZOH en la entrada 
Hz = c2d(H,T,'zoh');

%% f- Diagrama de polos y ceros de la planta discreta.
figure
pzmap(Hz)
hold on
grid on
title('Polos y ceros de la planta discreta'); 

Pz = pole(Hz); %estos serían los polos discretos
Pz_esperados = exp(P*T); % Es la formula que me "conecta" s y z

% Comparar polos discretos esperados/teóricos y los reales
disp('Polos discretos reales:');
disp(Pz));

disp('Polos discretos esperados:');
disp(Pz_esperados);

%% g- Respuesta al impulso o escalón.
% Usar y justificar con lo que tenga más sentido
% Escalón
figure
% Continuo
step(H)
hold on
% Discreto
step(Hz)
legend('Continuo','Discreto');
ylabel('Posición Angular (rad)');
% Impulso
figure
% Continuo
impulse(H)
hold on
% Discreto
impulse(Hz)
legend('Continuo','Discreto');
ylabel('Posición Angular (rad)');
%% h- Armar una simulación de la planta discreta: Simulink
%% i- Armar una simulación de la planta continua linealizada, con los elementos necesarios para discretizarla: Simulink
