%% Limpiar
clear
clc
close all
%% a- Proponer controladores discretos que tenga como máximo dos polos y dos ceros que cumpla las siguientes especificaciones
% (tiene que ser un controlador por cada sub-item):
% I. Sobrepico = 20%.
% II. Sin sobrepico

% Se arma la G(z)
numerador_p4 = [0 -0.053757107926144 -0.188445613408471 -0.037448542682446];
denominador_p4 = [1 -3.345989984317626 2.397411576664517 -0.489145057782015];
T_p4 = 0.014301923836314;
Gz_p4 = tf(numerador_p4, denominador_p4, T_p4);

% Se lanza la herramienta
% controlSystemDesigner(Gz_p1);

% Compensador I
z_c1=[0.5 0.5]; % Ceros del compensador
p_c1=[0.3 -0.7]; % Polos del compensador
K1=-7.541; % Ganancia
Cz_p4_1 = zpk(z_c1,p_c1,K1,T_p4);

% Compensador II
z_c2=[0.5 0.5]; % Ceros del compensador
p_c2=[0 -0.7]; % Polos del compensador
K2=-10.7; % Ganancia
Cz_p4_2 = zpk(z_c2,p_c2,K2,T_p4);

% Salida I
Tz_p4_1 = feedback(series(Cz_p4_1,Gz_p4),1);
% Salida II
Tz_p4_2 = feedback(series(Cz_p4_2,Gz_p4),1);

% Se analizan los polos de lazo cerrado
polos_lc_final_1 = pole(Tz_p4_1);
polos_lc_final_2 = pole(Tz_p4_2);
magnitud_polos_final_1 = abs(polos_lc_final_1)
magnitud_polos_final_2 = abs(polos_lc_final_2)

% Se verifica si el sistema en lazo cerrado es estable
if isstable(Tz_p4_1)
    fprintf('El controlador I estabiliza el sistema en lazo cerrado.\n');
else
    fprintf('El controlador I no estabiliza el sistema.\n');
end

if isstable(Tz_p4_2)
    fprintf('El controlador II estabiliza el sistema en lazo cerrado.\n');
else
    fprintf('El controlador II no estabiliza el sistema.\n');
end

% Gráficos e información
figure
hold on
step(Tz_p4_1);
title('Respuesta al escalón 20% sobrepico')
stepinfo(Tz_p4_1)
figure
hold on
step(Tz_p4_2);
title('Respuesta al escalón 0% sobrepico')
stepinfo(Tz_p4_2)

%% b- Hallar el diagrama de Bode (en plano W) de la planta discreta y del conjunto controlador + planta discreta. Determinar la variación
% en el margen de ganancia y fase. ¿Estos márgenes, mejoran o empeoran?
% Opciones para el diagrama de Bode para visualizar el plano W
% La frecuencia en el plano W (v) se relaciona con la frecuencia real (w) por v = (2/T)*tan(w*T/2)

% Planta original convertida a W
Gs_p4=d2c(Gz_p4, 'tustin');
% Planta compensada I convertida a W
Ts_p4_1=d2c(Tz_p4_1, 'tustin');
% Planta compensada II convertida a W
Ts_p4_2=d2c(Tz_p4_2, 'tustin');

%Gráficos Bode
figure
hold on
bodeplot(Gs_p4);
bodeplot(series(Cz_p4_1, Gz_p4));
legend('Planta Original', 'Planta + Controlador I');
title('Bode: Planta original y compensador I')
figure 
hold on
bodeplot(Gs_p4);
bodeplot(series(Cz_p4_2, Gz_p4));
legend('Planta Original', 'Planta + Controlador');
title('Bode: Planta original y compensador II')

% Se calculan los márgenes de ganancia y fase
[Gm_planta, Pm_planta] = margin(Gs_p4);
[Gm_compensado_1, Pm_compensado_1] = margin(series(Cz_p4_1, Gz_p4));
[Gm_compensado_2, Pm_compensado_2] = margin(series(Cz_p4_2, Gz_p4));
isstable(Tz_p4_1);
isstable(Tz_p4_2);

fprintf('Planta Original: Margen de Ganancia = %f dB, Margen de Fase = %f deg\n', 20*log10(Gm_planta), Pm_planta);
fprintf('Sistema Compensado I : Margen de Ganancia = %f dB, Margen de Fase = %f deg\n', 20*log10(Gm_compensado_1), Pm_compensado_1);
fprintf('Sistema Compensado II: Margen de Ganancia = %f dB, Margen de Fase = %f deg\n', 20*log10(Gm_compensado_2), Pm_compensado_2);
%% c- Verificar el comportamiento del sistema a lazo cerrado en una simulación usando la
% planta discreta. Obtener la salida del sistema y el esfuerzo de control.
% SIMULINK: Necesito C(z) y G(z)
% G(z) es dato de antes: Gz_p4
% C(z) es Cz_p4_1 y Cz_p4_2. Se expanden para ver los coeficientes y
% copiarlo más fácil en SIMULINK
Cz_p4_1_expand=tf(Cz_p4_1);
Cz_p4_2_expand=tf(Cz_p4_2);
%% d- Verificar el comportamiento del sistema a lazo cerrado en una simulación, usando la
% planta continua linealizada y los elementos necesarios para discretizarla. Obtener la
% salida del sistema (tanto discreto como continuo) y el esfuerzo de control
% SIMULINK: A lo anterior, le sumo G(s)
%% e- Si la planta es no lineal, verificar el comportamiento del sistema a lazo cerrado en una
% simulación, usando la planta continua no lineal y los elementos necesarios para
% discretizarla. Obtener la salida del sistema (tanto discreto como continuo) y el esfuerzo
% de control. Se aconseja tener cuidado con los valores de la referencia, y con el hecho
% que su controlador fue pensado para la planta linealizada.
%% f- Predecir el error estacionario a la rampa (P1y P2) o al escalón (P3). Verificarlo en una
% simulación lineal: NO APLICA
%% g- Se requiere utilizar un ADC de 10 bits para digitalizar la salida de la planta.
% I. Proponga un rango de entrada del ADC y calcule el paso de cuantización.
% II. Pruebe en una simulación los efectos de agregar el ADC.
% EN FUNCIÓN DE LOS RESULTADOS DE LOS GRÁFICOS SE ELIGE RANGO PASO Y
% DESPUÉS SIMULINK
