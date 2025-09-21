%% Limpiar
clear
clc
close all
%% a- Proponer controladores PID discretos que cumpla las siguientes especificaciones (tiene que ser un controlador por cada sub-item):
% I. Error estacionario al escalón nulo y sobrepico = 20%
% II. Error estacionario al escalón nulo y sin sobrepico.

% Se carga la función de transferencia discreta 
numerador_p1 = [0 1.587098114499472e-5 2.404465224969516e-5 6.336036425624988e-7];
denominador_p1 = [1 -1.978426373061843 0.978785811198180 -3.594381363373757e-4];
T_p1 = 1.109817844007972;
Gz_p1 = tf(numerador_p1, denominador_p1, T_p1);

% Se lanza la herramienta
% controlSystemDesigner(Gz_p1);

% Se elige un tiempo suficientemente grande como para reflejar que el
% sistema efectivamente alcanza el estado estacionario.
Tfinal = 20000;
% Compensador I
Cz_p1_1 = pid(9.22, 0.01, 0, T_p1/10, 'Ts', T_p1); %Kp Ki Kd
% Compensador II
Cz_p1_2 = pid(3.1, 0, 0, T_p1/10, 'Ts', T_p1); %Kp Ki Kd
% Salida I
Tz_p1_1 = feedback(series(Cz_p1_1,Gz_p1),1);
% Salida II
Tz_p1_2 = feedback(series(Cz_p1_2,Gz_p1),1);

% Gráficos e información
[y1,t1] = step(Tz_p1_1,Tfinal);
[y2,t2] = step(Tz_p1_2,Tfinal);
figure
hold on
step(Tz_p1_1);
title('Respuesta al escalón 20% sobrepico')
info_1 = stepinfo(y1,t1)
figure
hold on
step(Tz_p1_2);
title('Respuesta al escalón 0% sobrepico')
info_2 = stepinfo(y2,t2)

% Error de estado estacionario al escalón
ess_1 = 1 - y1(end);
ess_2 = 1 - y2(end);
fprintf('EEE 1: %.10f\n',ess_1);
fprintf('EEE 2: %.10f\n',ess_2);
%% b- Hallar el diagrama de Bode (en plano W) de la planta discreta y del conjunto controlador
% + planta discreta. Determinar la variación en el margen de ganancia y fase. ¿Estos
% márgenes, mejoran o empeoran?

% Planta original convertida a W
Gs_p1=d2c(Gz_p1, 'tustin');
% Planta compensada I convertida a W
Ts_p1_1=d2c(Tz_p1_1, 'tustin');
% Planta compensada II convertida a W
Ts_p1_2=d2c(Tz_p1_2, 'tustin');
% Si bien en ventana del workspace o línea de comando aparece como "s" en
% realidad está en variable w!

%Gráficos Bode
figure
hold on
bodeplot(Gs_p1);
bodeplot(series(Cz_p1_1, Gz_p1));
legend('Planta Original', 'Planta + Controlador I');
title('Bode: Planta original y compensador I')
figure 
hold on
bodeplot(Gs_p1);
bodeplot(series(Cz_p1_2, Gz_p1));
legend('Planta Original', 'Planta + Controlador');
title('Bode: Planta original y compensador II')
grid on

% Se calculan los márgenes de ganancia y fase
[Gm_planta, Pm_planta] = margin(Gs_p1);
[Gm_compensado_1, Pm_compensado_1] = margin(series(Cz_p1_1, Gz_p1));
[Gm_compensado_2, Pm_compensado_2] = margin(series(Cz_p1_2, Gz_p1));
isstable(Tz_p1_1);
isstable(Tz_p1_2);
 
fprintf('Planta Original: Margen de Ganancia = %f dB, Margen de Fase = %f deg\n', 20*log10(Gm_planta), Pm_planta);
fprintf('Sistema Compensado I : Margen de Ganancia = %f dB, Margen de Fase = %f deg\n', 20*log10(Gm_compensado_1), Pm_compensado_1);
fprintf('Sistema Compensado II: Margen de Ganancia = %f dB, Margen de Fase = %f deg\n', 20*log10(Gm_compensado_2), Pm_compensado_2);

%% c- Verificar el comportamiento del sistema a lazo cerrado en una simulación usando la
% planta discreta. Obtener la salida del sistema y el esfuerzo de control.
% SIMULINK: Necesito C(z) y G(z)
% G(z) es dato de antes: Gz_p1
% C(z) es Cz_p1_1 y Cz_p1_2. Se expanden para ver los coeficientes y
% copiarlo más fácil en SIMULINK
Cz_p1_1_expand=tf(Cz_p1_1);
Cz_p1_2_expand=tf(Cz_p1_2);
%% d- Verificar el comportamiento del sistema a lazo cerrado en una simulación, usando la
% planta continua linealizada y los elementos necesarios para discretizarla. Obtener la
% salida del sistema (tanto discreto como continuo) y el esfuerzo de control
% SIMULINK: A lo anterior, le sumo G(s) (ya se conoce del TP1)
%% e- Si la planta es no lineal...NO APLICA A ESTE PROBLEMA
%% f- Predecir el error estacionario a la rampa (P1 y P2) o al escalón (P3). Verificarlo en una
% simulación lineal.

% Lo que no aparezca acá fué deducido a mano o de la teoría de sistemas de
% control
% Con compensador I error a la rampa 0
% Con compensador II error a la rampa finito
z0=1; % Polo z=1
divisor = [1 -z0]; % Polinomio: (z - z0)
[cociente, resto] = deconv(denominador_p1, divisor);
err=(sum(cociente)*T_p1)/(3.1*sum(numerador_p1)); %Se dedujo a mano
fprintf('Error a la rampa con compensador II: %.5f\n',err);
%% g- Se requiere utilizar un ADC de 10 bits para digitalizar la salida de la planta.
% I. Proponga un rango de entrada del ADC y calcule el paso de cuantización.
% II. Pruebe en una simulación los efectos de agregar el ADC.
% En función de las respuestas al escalón --> SIMULINK
