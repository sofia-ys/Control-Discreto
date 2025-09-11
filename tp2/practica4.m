%% Limpiar
clear
clc
close all
%% a- Proponer controladores discretos que tenga como máximo dos polos y dos ceros que cumpla las siguientes especificaciones
% (tiene que ser un controlador por cada sub-item):
% I. Sobrepico = 20%.
% II. Sin sobrepico
numerador_p4 = [0 -0.053757107926144 -0.188445613408471 -0.037448542682446]
denominador_p4 = [1 -3.345989984317626 2.397411576664517 -0.489145057782015]
T_p4 = 0.014301923836314;
Gz_p4 = tf(numerador_p4, denominador_p4, T_p4);
% Lanzar la Herramienta
controlSystemDesigner(Gz_p4);
%[r,p,c]=residue(num,den) %vemos si lo usamos
%% b- Hallar el diagrama de Bode (en plano W) de la planta discreta y del conjunto controlador + planta discreta. Determinar la variación
% en el margen de ganancia y fase. ¿Estos márgenes, mejoran o empeoran?

% Asumiendo que ya tienes Gz_p1 (planta) y Cz_p1 (tu controlador diseñado)

% 1. Definir el sistema de lazo abierto L(z) = C(z) * G(z)
Lz_p1 = Cz_p1 * Gz_p1;

% 2. Opciones para el diagrama de Bode para visualizar el plano W
% La frecuencia en el plano W (v) se relaciona con la frecuencia real (w) por v = (2/T)*tan(w*T/2)
opts = bodeoptions;
opts.FreqUnits = 'Hz'; % o 'rad/s'

% 3. Graficar Bode de la planta sola y del sistema compensado
figure;
hold on;
bodeplot(Gz_p1, opts);
bodeplot(Lz_p1, opts);
legend('Planta Original', 'Planta + Controlador');
grid on;
hold off;

% 4. Calcular los márgenes de ganancia y fase
[Gm_planta, Pm_planta] = margin(Gz_p1);
[Gm_compensado, Pm_compensado] = margin(Lz_p1);

fprintf('Planta Original: Margen de Ganancia = %f dB, Margen de Fase = %f deg\n', 20*log10(Gm_planta), Pm_planta);
fprintf('Sistema Compensado: Margen de Ganancia = %f dB, Margen de Fase = %f deg\n', 20*log10(Gm_compensado), Pm_compensado);

% 5. Conclusión: ¿Mejoran o empeoran?
% Generalmente, un controlador bien diseñado AUMENTA los márgenes de fase y ganancia.
% Un mayor margen de fase implica mejor amortiguamiento y robustez a retardos.
% Un mayor margen de ganancia implica mayor tolerancia a errores en la ganancia del modelo.
% Debes comparar los valores y concluir si tu controlador mejoró la robustez del sistema. [cite: 13]

%% c- Verificar el comportamiento del sistema a lazo cerrado en una simulación usando la planta discreta. Obtener la salida del sistema
% y el esfuerzo de control.

% Asumiendo que tienes Gz_p1 y Cz_p1

% 1. Calcular la función de transferencia de lazo cerrado
% Y(z)/R(z) = (C(z)G(z)) / (1 + C(z)G(z))
Tz_p1 = feedback(Lz_p1, 1);

% 2. Calcular la función de transferencia del esfuerzo de control
% U(z)/R(z) = C(z) / (1 + C(z)G(z))
Uz_p1 = feedback(Cz_p1, Gz_p1);

% 3. Simular la respuesta a un escalón unitario
figure;
subplot(2,1,1);
step(Tz_p1);
title('Salida del Sistema Discreto (Y)');
grid on;

subplot(2,1,2);
step(Uz_p1);
title('Esfuerzo de Control Discreto (U)');
grid on;

% 4. Verificación
% Mide el sobrepico y el valor final de la gráfica de salida para confirmar
% que cumples las especificaciones de diseño.
stepinfo(Tz_p1)

%% d- Verificar el comportamiento del sistema a lazo cerrado en una simulación, usando la planta continua linealizada y los elementos
% necesarios para discretizarla. Obtener la salida del sistema (tanto discreto como continuo) y el esfuerzo de control.

%% e- Si la planta es no lineal, verificar el comportamiento del sistema a lazo cerrado en una simulación, usando la planta continua
% no lineal y los elementos necesarios para discretizarla. Obtener la salida del sistema (tanto discreto como continuo) y el esfuerzo
% de control. Se aconseja tener cuidado con los valores de la referencia, y con el hecho que su controlador fue pensado para la planta 
% linealizada. 

%% f- Predecir el error estacionario a la rampa (P1) Verificarlo en una simulación lineal.

% Asumiendo Lz_p1 = Cz_p1 * Gz_p1

% 1. Calcular Kv
% (z-1)*L(z) se puede obtener multiplicando por (z-1)/z y luego evaluando en z=1
% Esto es conceptual. En la práctica, es más fácil si defines L(z) simbólicamente o
% extraes los polos y ceros.
% Manera más simple: si el sistema es tipo 1, Lz_p1 = L'(z)/(z-1).
% El límite es L'(1).

% Manera programática:
dc_gain_of_velocity_loop = dcgain( (z-1)*Lz_p1/T ); % dcgain evalúa en z=1
Kv = dc_gain_of_velocity_loop;
ess_rampa_teorico = 1/Kv;

fprintf('El error teórico a la rampa es: %f\n', ess_rampa_teorico);

% 2. Verificación por simulación
% Necesitamos simular con una entrada de rampa
time = 0:T:10; % Vector de tiempo
rampa = time; % Entrada de rampa

figure;
lsim(Tz_p1, rampa, time); % Simula la salida Y(t)
hold on;
plot(time, rampa, '--'); % Dibuja la referencia
legend('Salida del sistema', 'Referencia (Rampa)');
title('Respuesta a la Rampa');
grid on;

% Para ver el error:
error_simulado = rampa - lsim(Tz_p1, rampa, time);
plot(time, error_simulado);
legend('Error (Referencia - Salida)');
title('Error en el tiempo');
grid on;
% El valor al que se estabiliza la curva de error debe ser ess_rampa_teorico

%% g- Se requiere utilizar un ADC de 10 bits para digitalizar la salida de la planta.
% I. Proponga un rango de entrada del ADC y calcule el paso de cuantización.
% II. Pruebe en una simulación los efectos de agregar el ADC.

