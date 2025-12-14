%% Limpiar
clear
clc
close all
format long
%% a- Detallar las ecuaciones diferenciales lineales y la transferencia del 
% sistema continuo TFp(s) y discreto suponiendo un ZOH a la entrada de la 
% planta TFp(z) encontradas en el TP01.
%%% SE ENCUENTRAN ESCRITAS EN EL INFORME

%% b- Obtener la representación por Variable de Estado del sistema SISO a 
% partir de la función de transferencia continua TFp(s). Ídem a partir de 
% la representación discreta TFp(z). Especificar claramente los valores de 
% las matrices [A, B, C, D], y [G, H, Cd, Dd].

%%% Continua:
num_p1_s=[0 0 0 1.000000000000000e-03];
den_p1_s=[4.214000000000000 30.114041999999998 0.600300000000000 0];
% Armado "a mano" (Ejemplo: pág 30/56 PDF tema 10 parte 1)
% Constante normalización
ctenorm=den_p1_s(1);
num_p1_s=num_p1_s/ctenorm;
den_p1_s=den_p1_s/ctenorm;

A=[0 1 0;0 0 1;0 -den_p1_s(1,3) -den_p1_s(1,2)];
B=[0;0;num_p1_s(1,end)];
C=[1 0 0];
D=0;

disp('b- Continua')
disp('Matriz A:');
disp(A)
disp('Matriz B:');
disp(B)
disp('Matriz C:');
disp(C)
disp('Matriz D:');
disp(D)

%%% Discreta:
num_p1_z = [0 1.587098114499472e-5 2.404465224969516e-5 6.336036425624988e-7];
den_p1_z = [1 -1.978426373061843 0.978785811198180 -3.594381363373757e-4];
T_p1 = 1.109817844007972;

% Armado "a mano" (Forma canónica controlable. Ejemplo: pág 14/60 PDF tema 10 parte 2)
G=[0 1 0;0 0 1;-den_p1_z(1,end) -den_p1_z(1,end-1) -den_p1_z(1,end-2)];
H=[0;0;1];
Cd_h=[num_p1_z(1,end) num_p1_z(1,end-1) num_p1_z(1,end-2)]; %b0=0
Dd_h=0;

disp('b- Discreta')
disp('Matriz G:');
disp(G)
disp('Matriz H:');
disp(H)
disp('Matriz Cd:');
disp(Cd_h)
disp('Matriz Dd:');
disp(Dd_h)

%% c- Obtener la representación por Variable de Estado del sistema continuo
% donde los estados coincidan con variables físicas del sistema. Las 
% entradas y salidas del sistema siguen siendo las de la transferencia 
% SISO. Obtener la representación de este modelo, discretizado. Especificar
% claramente los valores de las matrices [A, B, C, D], y [G, H, Cd, Dd].
%%% Las ecuaciones y variables para obtener las matrices se encuentran en
%%% el informe. Acá se parte de las matrices en continuo.

%%% Continuo
A = [0   1         0;
     0  -0.00333   0.1661;
     0  -0.7143   -7.1428];
B = [0;
     0;
     1.4286];
C = [0.001   0   0];
D = 0;

disp('c- Continua')
disp('Matriz A:');
disp(A)
disp('Matriz B:');
disp(B)
disp('Matriz C:');
disp(C)
disp('Matriz D:');
disp(D)

% Se crea el objeto de sistema de espacio de estados en tiempo continuo.
% Con ss, se agrupa las cuatro matrices en una sola variable.
sys_c_c = ss(A, B, C, D); %Continuo

%%% Discreto
% Se usa c2d para convertir el sistema continuo a discreto con ZOH
sys_d_c = c2d(sys_c_c, T_p1, 'zoh'); %Discreto

% Se muestran en pantalla los resutlados:
Ad = sys_d_c.A;
Bd = sys_d_c.B;
Cd = sys_d_c.C;
Dd = sys_d_c.D;

disp('c- Discreta')
fprintf('Sistema en Tiempo Discreto con T = %.4f\n',T_p1);
disp('Matriz Ad:');
disp(Ad);
disp('Matriz Bd:');
disp(Bd);
disp('Matriz Cd:');
disp(Cd); 
disp('Matriz Dd:');
disp(Dd);

%% d- Comparar en una simulación los tres modelos continuos (Transferencia,
% Variable de estado desde transferencia y Variable de estado con variables
% reales). Saque conclusiones de la comparación.
%%% EN SIMULINK

%% e- Comparar en una simulación los tres modelos discretos (Transferencia,
% Variable de estado desde transferencia y Variable de estado con variables
% reales). Saque conclusiones de la comparación.
%%% EN SIMULINK