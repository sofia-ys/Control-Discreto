%% Limpiar
clear
clc
close all

%% Datos del sistema
format long
Rc = 2;
Lc = 0.04;
Mb = 0.5;
g = 9.8;
k = 8
y0 = 0.005;

%% a- Ecuación diferencial (Obtenida a mano y publicada en el informe)

%% b- Linealizar el sistema en el entorno del punto de equilibrio (idem a)
% Constantes auxiliares (salen de la linealización)
Ki = ((2*k)/y0)*sqrt((Mb*g)/k);
Kx = ((2*Mb*g)/(y0));

%% c- Funcion de transferencia 
s = tf("s");
H = (-Ki)/((Mb*s^2-Kx)*(Lc*s+Rc))

%% d- Polos, ceros y diagrama de bode.
P = pole(H); %Polos "continuos" 
[Z,gain] = zero(H)
figure
bode(H)
hold on
grid on

%% e- Periodo de muestreo y transferencia del filtro anti-alias para discretizar el sistema.
wbw_rad = bandwidth(H); 
fs_rad = 15*wbw_rad;
fs_Hz = fs_rad / (2*pi())
% Período de muestreo
T = 1 / fs_Hz;
% Filtro anti-alias: Pasa bajos
wc = fs_rad/2;
% Primer orden con función de transferencia:
H_filtro = (wc / (s + wc));

%% f- Discretizar el sistema y obtener ΘL(z)/En(z), suponiendo ZOH en la entrada
Hz = c2d(H,T,'zoh');

%% g- Diagrama de polos y ceros de la planta discreta.
figure
pzmap(Hz)
hold on
grid on
title('Polos y ceros de la planta discreta'); 
Pz = pole(Hz); %Polos "discretos" 
Pz_esperados = exp(P*T); % Es la formula que conecta s y z
% Comparar polos discretos esperados/teóricos y los reales
disp('Polos discretos reales:');
disp(Pz));
disp('Polos discretos esperados:');
disp(Pz_esperados);

%% h- Respuesta al impulso o escalón.
% Escalón
figure
% Continuo
step(H)
hold on
% Discreto
step(Hz)
legend('Continuo','Discreto');
ylabel('Altura (m)')
% Impulso
figure
% Continuo
impulse(H)
hold on
% Discreto
impulse(Hz)
legend('Continuo','Discreto');
ylabel('Altura (m)')

%% i- Armar una simulación de la planta discreta: Simulink

%% j- Armar una simulación de la planta continua linealizada, con los elementos necesarios para discretizarla: Simulink

%% k- Armar una simulación de la planta continua no lineal, con los elementos necesarios para discretizarla: Simulink
