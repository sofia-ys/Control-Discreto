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
%controlSystemDesigner(Gz_p1);
%Kp Ki Kd
Tfinal = 200;
%item 1
Cz_p1_1 = pid(10.68, 0.01, 0, T_p1/10, 'Ts', T_p1);  
% item 2
Cz_p1_2 = pid(4.3, 0, 0, 'Ts', T_p1);
%Cz_p1_propuesto = pid(2, 0.05, 2, 'Ts', T_p1);
%a=stepinfo(C)
Tz_p1_1 = feedback(series(Cz_p1_1,Gz_p1),1);
[y1,t1] = step(Tz_p1_1);
step(Tz_p1_1);
info_1 = stepinfo(y1,t1);
Tz_p1_2 = feedback(series(Cz_p1_2,Gz_p1),1);
[y2,t2] = step(Tz_p1_2);
step(Tz_p1_2);
info_2 = stepinfo(y2,t2)
%stepinfo(Tz_p1)
ess_1 = 1 - y1(end);
ess_2 = 1 - y2(end);
%step(Tz_p1);
fprintf('EEE 1 (porcentaje): %.10f\n',ess_1*100);
fprintf('EEE 2 (porcentaje): %.10f\n',ess_2*100);
%grid on; 
%stepinfo(Tz_p1)
%b=stepinfo(CL)
%hold on
%margin(series(C,Gz_p1))
%%
% Asumiendo que ya tienes Tz_p1 (sistema a lazo cerrado) y el período T

% 1. Definir el tiempo de simulación
% t_final = 150; % Un tiempo suficientemente largo para llegar al estado estacionario
% t = 0:T_p1:t_final;
% 
% % 2. Crear la señal de entrada rampa
% r = t; % Rampa de pendiente 1
% 
% % 3. Simular la respuesta del sistema a lazo cerrado a la rampa
% y = lsim(Tz_p1, r, t);
% 
% % 4. Calcular y graficar el error
% error = r' - y; % Ojo con las dimensiones de los vectores
% 
% figure;
% plot(t, r, 'b--', t, y, 'r-');
% legend('Entrada (Rampa)', 'Salida del Sistema');
% title('Respuesta del Sistema a una Rampa');
% grid on;
% hold on
% plot(t, error);
% %title('Error del Sistema frente a una Rampa');
% legend('Error del Sistema frente a una Rampa')
% xlabel('Tiempo (s)');
% ylabel('Error');
% grid on;
% 
% % 5. Verificar el valor final del error
% error_estacionario_simulado = error(end);
% % disp(['Error estacionario predicho: ', num2str(ess_calculado)]); % ess_calculado es tu resultado teórico
% disp(['Error estacionario verificado en simulación: ', num2str(error_estacionario_simulado)]);
