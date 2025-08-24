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
Beq = Bm + (Bl/N^2);

%% a- Ecuación diferencial (lo tenemos hecho a mano)

%% b- Funcion de transferencia (AHORA SI ESTÁ BIEN)
s = tf("s");
H = (1/N) * (1/( ...
    (Ra/Ki) * Jeq *s^2 + (La/Ki) * Jeq * s^3 + Ke * s + (Ra/Ki) * Beq * s + (La/Ki) * Beq * s^2...
    ));

%% c- Polos, ceros y diagrama de bode.

P = pole(H); %serían los polos continuos
[Z,gain] = zero(H);
figure
bode(H)
hold on
grid on

% help zero

%% d- Periodo de muestreo y transferencia del filtro anti-alias para discretizar el sistema.
% Idealmente: fs>=2*fmax (Nyquist)
% Regla: Elegir f entre 10*wbw y 20wbw (por ejemplo, 15)
% wbw_rad = bandwidth(H); %%% SI TIRA NAN ES PORQUE TIENE GANANCIA INFINITA!
%%% bandwidth() de MATLAB devuelve NaN xq el sistema tiene un polo en s=0. Este polo hace que la ganancia a frecuencia cero (DC) sea infinita
%%% Necesitamos una métrica diferente pero conceptualmente similar para caracterizar la "velocidad" de nuestro sistema.
%%% Frecuencia de Cruce de Ganancia
%%% Es la frecuencia en la cual la magnitud del sistema en el diagrama de Bode es exactamente 1 (o = a 0dB)
%%% Esta frecuencia nos dice "el punto a partir del cual el sistema atenúa las señales en lugar de amplificarlas"
% fs_rad = 15*wbw_rad;
% fs_Hz = fs_rad / (2*pi());
% Período de muestreo
% T = 1 / fs_Hz;
% Usamos la función margin(), que nos da esta frecuencia directamente.
[Gm, Pm, Wcg, Wcp] = margin(H); % Wcg es la frecuencia que buscamos (en rad/s)
% Repito lo anterior pero con w_gc
fs_rad = 15 * Wcg; % Frecuencia de muestreo en rad/s
fs_Hz = fs_rad / (2*pi);
T = 1 / fs_Hz;

% Filtro anti-alias
% Tipo de filtro: Es siempre un filtro pasa-bajos.
% Sea la frecuencia de corte wc Es la mitad de la frecuencia de muestreo.
wc = fs_rad/2;
% El filtro anti-alias más simple es uno de primer orden, cuya función de transferencia es:
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
