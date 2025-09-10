%% Limpiar
clear
clc
close all
%% a- Proponer controladores PID discretos que cumpla las siguientes especificaciones (tiene que ser un controlador por cada sub-item):
% I. Error estacionario al escalón nulo y sobrepico = 20%
% II. Error estacionario al escalón nulo y sin sobrepico.
% Cargar la función de transferencia discreta de P1 (Motor CC)
numerador_p1 = [0 1.587098114499472e-5 2.404465224969516e-5 6.336036425624988e-7]
denominador_p1 = [1 -1.978426373061843 0.978785811198180 -3.594381363373757e-04]
T_p1 = 1.109817844007972;
Gz_p1 = tf(numerador_p1, denominador_p1, T_p1);
% Lanzar la Herramienta
controlSystemDesigner(Gz_p1);
%[r,p,c]=residue(num,den) %vemos si lo usamos


