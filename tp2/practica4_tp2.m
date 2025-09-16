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
%step(Gz_p4,4*T_p4)
% [y, t] = dstep(Gz_p4, 21);   % 21 muestras (de 0 a 20)
% y = squeeze(y);              % acomodar formato de salida
% Lanzar la Herramienta
%controlSystemDesigner(Gz_p4);
%[r,p,c]=residue(num,den) %vemos si lo usamos

%%% Primero se verifica que el sistema inestable puede ser controlado 
%%% (BUSCAR DESPUÉS BIEN PARA JUSTIFICAR EN EL INFORME)
% [A,B,C,D] = tf2ss(numerador_p4, denominador_p4);
% co = ctrb(A,B);
% rank(co);
% 
% if rank(co) == size(A,1)
%     fprintf('El sistema es controlable\n')
% elseif rank(co) < size(A,1)
%     fprintf('El sistema no es controlable\n')
% end
%%%

% Se arma la C(z) y se define el sistema de lazo abierto L(z) = C(z) * G(z)
z_c=[0.5 0.5]; % Ceros del compensador
p_c=[0.3 -0.7]; % Polos del compensador
K=-7.541; % Ganancia
% VOY A TENER QUE PENSAR OTRO PARA EL SOBREPICO NULO (cambiar la gnanacia
% solo no me garantiza lo pedido (para los mismos polos...)

Cz_p4 = zpk(z_c,p_c,K,T_p4);
%controlSystemDesigner(Gz_p4, Cz_p4)
Lz_p4 = Cz_p4 * Gz_p4;

% figure;
% rlocus(Lz_p4);
% title('LGR con Compensador de Adelanto Doble');
% zgrid; % Dibuja el círculo unitario y líneas de amortiguamiento

% Lazo cerrado
Tz_p4 = feedback(Lz_p4, 1);

% Se analizan los polos de lazo cerrado
polos_lc_final = pole(Tz_p4);
magnitud_polos_final = abs(polos_lc_final)
step(Tz_p4);

% Verifica si el sistema en lazo cerrado es estable
if isstable(Tz_p4)
    fprintf('El controlador estabiliza el sistema en lazo cerrado.\n');
else
    fprintf('El controlador no estabiliza el sistema.\n');
end

stepinfo(Tz_p4)

% Se puede ver los polos de lazo cerrado. Todos deben estar DENTRO del círculo unitario.
% figure;
% pzmap(Tz_p4);
% title('Polos y Ceros del Sistema en Lazo Cerrado');
% zgrid; % Dibuja el círculo unitario

%% b- Hallar el diagrama de Bode (en plano W) de la planta discreta y del conjunto controlador + planta discreta. Determinar la variación
% en el margen de ganancia y fase. ¿Estos márgenes, mejoran o empeoran?
% Opciones para el diagrama de Bode para visualizar el plano W
% La frecuencia en el plano W (v) se relaciona con la frecuencia real (w) por v = (2/T)*tan(w*T/2)
% opts = bodeoptions;
% opts.FreqUnits = 'Hz'; % o 'rad/s'
% 
% % Se grafica Bode de la planta sola y del sistema compensado.
% figure;
% hold on;
% Gs_p4=d2c(Gz_p4, 'tustin'); 
% bodeplot(Gs_p4);
% Ls_p4=d2c(Lz_p4, 'tustin');
% bodeplot(Ls_p4);
%Ts_p4=d2c(Tz_p4, 'tustin');
% %bodeplot(Gz_p4, opts);
% %bodeplot(Lz_p4, opts);
% legend('Planta Original', 'Planta + Controlador');
% grid on;
% hold off;
% 
% % Se calculan los márgenes de ganancia y fase
% [Gm_planta, Pm_planta] = margin(Gz_p4);
% [Gm_compensado, Pm_compensado] = margin(Lz_p4);
% 
% fprintf('Planta Original: Margen de Ganancia = %f dB, Margen de Fase = %f deg\n', 20*log10(Gm_planta), Pm_planta);
% fprintf('Sistema Compensado: Margen de Ganancia = %f dB, Margen de Fase = %f deg\n', 20*log10(Gm_compensado), Pm_compensado);
% 
% %% c- Verificar el comportamiento del sistema a lazo cerrado en una simulación usando la planta discreta. Obtener la salida del sistema
% % y el esfuerzo de control.
% 
% % Se calcula la función de transferencia de lazo cerrado
% % T(z) = Y(z)/R(z) = (C(z)G(z)) / (1 + C(z)G(z)) (ya lo tenemos)
% % Se calcula la función de transferencia del esfuerzo de control
% % U(z)/R(z) = C(z) / (1 + C(z)G(z))
% Uz_p4 = feedback(Cz_p4, Gz_p4);
% 
% % Respuesta al escalón unitario
% figure;
% subplot(2,1,1);
% step(Tz_p4);
% title('Salida del Sistema Discreto (T)');
% grid on;
% 
% subplot(2,1,2);
% step(Uz_p4); 
% title('Esfuerzo de Control Discreto (U)');
% grid on;
% 
% % Verificación
% % Se mide el sobrepico y el valor final de la salida para confirmar que se
% % cumple las especificaciones de diseño.
% c=stepinfo(Tz_p4);
%% d- Verificar el comportamiento del sistema a lazo cerrado en una simulación, usando la planta continua linealizada y los elementos
% % necesarios para discretizarla. Obtener la salida del sistema (tanto discreto como continuo) y el esfuerzo de control.
% SIMULINK?
%Tz_p4_expand=tf(Tz_p4);
%Ts_p4_expand=tf(Ts_p4);
% % MIO: Me encantó che...quedo lindo respuesta al escalón con el sobrepico
% visible y después se estabiliza
%% e- Si la planta es no lineal, verificar el comportamiento del sistema a lazo cerrado en una simulación, usando la planta continua
% no lineal y los elementos necesarios para discretizarla. Obtener la salida del sistema (tanto discreto como continuo) y el esfuerzo
% de control. Se aconseja tener cuidado con los valores de la referencia, y con el hecho que su controlador fue pensado para la planta 
% linealizada. 
% SIMULINK?
Cz_p4_expand=tf(Cz_p4);
Cs_p4=d2c(Cz_p4, 'tustin');
Cs_p4_expand=tf(Cs_p4);
%% f- Predecir el error estacionario a la rampa (P1) Verificarlo en una simulación lineal.

% Asumiendo Lz_p1 = Cz_p1 * Gz_p1
 
% Se Calcula Kv
% (z-1)*L(z) se puede obtener multiplicando por (z-1)/z y luego evaluando en z=1
% Esto es conceptual. En la práctica, es más fácil si se define L(z) simbólicamente o
% se extraen los polos y ceros.
% Más simple: si el sistema es tipo 1, Lz_p1 = L'(z)/(z-1).
% El límite es L'(1).

% Manera programática:
% dc_gain_of_velocity_loop = dcgain( (z-1)*Lz_p4/T ); % dcgain evalúa en z=1
% Kv = dc_gain_of_velocity_loop;
% ess_rampa_teorico = 1/Kv;
 
% fprintf('El error teórico a la rampa es: %f\n', ess_rampa_teorico);
 
% Verificación por simulación
% Se necesita simular con una entrada de rampa
% time = 0:T:10; % Vector de tiempo %%%CLARAMENTE SE USARÁ OTRO TIEMPO ME
% INAGINO..
% rampa = time; % Entrada de rampa
% 
% figure;
% lsim(Tz_p4, rampa, time); % Simula la salida Y(t)
% hold on;
% plot(time, rampa, '--'); % Dibuja la referencia
% legend('Salida del sistema', 'Referencia (Rampa)');
% title('Respuesta a la Rampa');
% grid on;
% 
% Para ver el error:
% error_simulado = rampa - lsim(Tz_p4, rampa, time);
% plot(time, error_simulado);
% legend('Error (Referencia - Salida)');
% title('Error en el tiempo');
% grid on;
% El valor al que se estabiliza la curva de error debe ser ess_rampa_teorico
% 
%% g- Se requiere utilizar un ADC de 10 bits para digitalizar la salida de la planta.
% I. Proponga un rango de entrada del ADC y calcule el paso de cuantización.
% II. Pruebe en una simulación los efectos de agregar el ADC.
%%% SIMULINK?
%% Anexo
