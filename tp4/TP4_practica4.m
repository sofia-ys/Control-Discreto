%% Limpiar
clear
clc
close all
%% a- Seleccionar un modelo en VE de estado del sistema.
% Indicado y explicado en informe

%% b- Diseñar un controlador por realimentación de estado, que tenga acción
% integral, y cumpla las especificaciones establecidas en la sección
% "Especificaciones".

%%%%% -------- DEL TRABAJO ANTERIOR
% Continuo
format short
Rc = 2;
Lc = 0.04;
Mb = 0.5;
g = 9.8;
k = 8;
y0 = 0.005;
Ki = ((2*k)/y0)*sqrt((Mb*g)/k);
Kx = ((2*Mb*g)/(y0));

A = [0 1 0;
     Kx/Mb 0 -Ki/Mb;
     0 0 -Rc/Lc];
B = [0;
     0;
     1/Lc];
C = [1 0 0];
D = 0;

% Se crea el objeto de sistema de espacio de estados en tiempo continuo.
% Con ss, se agrupa las cuatro matrices en una sola variable.
sys_c_c = ss(A, B, C, D); %Continuo

%%% Discreta
% Se usa c2d para convertir el sistema continuo a discreto con ZOH
T_p4 = 0.014301923836314;
sys_d_c = c2d(sys_c_c, T_p4, 'zoh'); %Discreto

% Se muestran en pantalla los resutlados:
Ad = sys_d_c.A;
Bd = sys_d_c.B;
Cd = sys_d_c.C;
Dd = sys_d_c.D;
%%%%% -------- DEL TRABAJO ANTERIOR

% Especificaciones
SP_cl = 0.1; % veces
ts_cl = (4/50)*0.8 % segundos

% Cálculo de polos dominantes
Famort_cl = -log(SP_cl) / sqrt( pi^2 + log(SP_cl)^2 )
Real_cl = 4/ts_cl
Wn_cl = Real_cl/Famort_cl
Imag_cl = Wn_cl*sqrt(1-Famort_cl^2)
PolDom_cl = [ -Real_cl+j*Imag_cl, -Real_cl-j*Imag_cl]
PolDomZ_cl = exp(PolDom_cl*T_p4)

PolNoDomZ_cl = [0 0.001]

Gp = [ Ad, zeros(3,1); -Cd , 1 ]
Hp = [ Bd;0]
Cp = [ Cd, 0; -Cd, 1 ]
Dp = [ 0;0 ]

Ka = place(Gp,Hp,[PolDomZ_cl,PolNoDomZ_cl])

SolveMat = [eye(3), Cd'; zeros(1,3), -1]
Ki2_Ki1 = SolveMat \ Ka'
Ki2 = (Ki2_Ki1(1:3))'
Ki1 = (Ki2_Ki1(4))'

%% c- Simular en Simulink el conjunto sistema discreto con controlador.
%  Verificar que se cumplen las especificaciones.
%%% SIMULINK

%% d- Diseñar un observador del estado del sistema, considerando que se 
% utilizará con el controlador diseñado en los puntos anteriores.

ts_obs = ts_cl / 5
Real_Obs = 4/ts_obs
PolObs = -Real_Obs.*[1,1.5,2]
PolObsZ = exp(PolObs*T_p4)

Ke1 = place(Ad',Cd',PolObsZ)'

%% e- Simular en Simulink el conjunto sistema discreto con observador (no 
% es necesario que este el controlador incorporado). Verificar que el 
% estado del observador converge al estado del sistema.
% I. Cuando las condiciones iniciales del sistema y el observador son 
% distintas.
% II. Al aplicar una entrada al sistema.
%%% SIMULINK

%% f- Simular en Simulink el sistema discreto controlado con el controlador
% y observador diseñados, pero el controlador utiliza la estimación de 
% estado del observador para calcular el esfuerzo de control. Evalúe el 
% comportamiento del sistema.
% I. Cuando las condiciones iniciales de observador y sistema coinciden.
% II. Cuando las condiciones iniciales de observador y sistema son 
% distintas.
%%% SIMULINK

%% g- Simular en Simulink el sistema continuo con los elementos para 
% discretizarlo, controlado con el controlador y observador diseñados, pero
% el controlador utiliza la estimación de estado del observador para 
% calcular el esfuerzo de control.
%%% SIMULINK