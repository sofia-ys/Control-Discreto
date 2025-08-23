%% Datos del sistema
Rc = 2;
Lc = 0.04;
Mb = 0.5;
g = 9.8;
k = 8
y0 = 0.005;

%% a- Ecuación diferencial (lo tenemos hecho a mano)
%% b- Linealizar el sistema en el entorno del punto de equilibrio (idem a)
% Constantes auxiliares (surjen de la linealización)
Ki = ((2*k)/y0)*sqrt((Mb*g)/k);
Kx = ((2*Mb*g)/(y0));

%% c- Funcion de transferencia 
s = tf("s");
H = (-Ki)/((Mb*s^2-Kx)*(Lc*s+Rc))

%% d- Polos, ceros y diagrama de bode.

P = pole(H);
[Z,gain] = zero(H)
figure
bode(H)
hold on
grid on

% help zero

%% e- Periodo de muestreo y transferencia del filtro anti-alias para discretizar el sistema.
%%% CONFIRMAR QUE PUEDE APLICARSE DE IGUAL MANERA A ESTE PROBLEMA (supongo que si)
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

%% f- Discretizar el sistema y obtener ΘL(z)/En(z), suponiendo ZOH en la entrada
Hz = c2d(H,T,'zoh');
%% g- Diagrama de polos y ceros de la planta discreta.
figure
pzmap(Hz)
hold on
grid on
title('Polos y ceros de la planta discreta'); %%%Ver que se puede hacer para verificar eso
%% h- Respuesta al impulso o escalón.
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
%% i- Armar una simulación de la planta discreta: Simulink
%% j- Armar una simulación de la planta continua linealizada, con los elementos necesarios para discretizarla: Simulink
%% k- Armar una simulación de la planta continua no lineal, con los elementos necesarios para discretizarla: Simulink

