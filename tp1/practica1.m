%% datos del sistema
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
% Beq = Bm + (Bl/N^2);

%% a- Ecuación diferencial (lo tenemos hecho a mano)

%% b- Funcion de transferencia (AHORA SI ESTÁ BIEN)
s = tf("s");
H = (1/N) * (1/( ...
    (Ra/Ki) * Jeq *s^2 + (La/Ki) * Jeq * s^3 + Ke * s + (Ra/Ki) * Beq * s + (La/Ki) * Beq * s^2...
    ));

%% c- Polos, ceros y diagrama de bode.

P = pole(H);
[Z,gain] = zero(H)
figure
bode(H)
hold on
grid on

% help zero

%% d- Periodo de muestreo y transferencia del filtro anti-alias para discretizar el sistema.
% Idealmente: fs>=2*fmax (Nyquist)
% Regla: Elegir f entre 10*wbw y 20wbw (por ejemplo, 15)
wbw_rad = bandwidth(H); %%% SI TIRA NAN ES PORQUE TIENE GANANCIA INFINITA!
fs_rad = 15*wbw_rad;
fs_Hz = fs_rad / (2*pi())
% Período de muestreo
T = 1 / fs_Hz;

% Filtro anti-alias
% Tipo de filtro: Es siempre un filtro pasa-bajos.
% Sea la frecuencia de corte wc Es la mitad de la frecuencia de muestreo.
wc = fs_rad/2;
% El filtro anti-alias más simple es uno de primer orden, cuya función de transferencia es:
H_filtro = (s / (s + wc));

%% e- Discretizar el sistema y obtener ΘL(z)/En(z), suponiendo ZOH en la entrada 
Hz = c2d(H,T,'zoh');
%% f- Diagrama de polos y ceros de la planta discreta.
figure
pzmap(Hz)
hold on
grid on
title('Polos y ceros de la planta discreta'); %%%Ver que se puede hacer para verificar eso
%% g- Respuesta al impulso o escalón.
% Escalón
figure
% Continuo
step(H)
hold on
% Discreto
step(Hz)
legend('Continuo','Discreto');
% Impulso
figure
% Continuo
impulse(H)
hold on
% Discreto
impulse(Hz)
legend('Continuo','Discreto');
%% h- Armar una simulación de la planta discreta: Simulink
%% i- Armar una simulación de la planta continua linealizada, con los elementos necesarios para discretizarla: Simulink
