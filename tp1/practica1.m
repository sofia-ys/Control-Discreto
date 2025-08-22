% datos del sistema
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
% Beq = 

% funcion de transferencia
s = tf("s");
H = (1/N) * (1/( ...
    (Ra/Ki) * Jeq *s^2 + (La/Ki) * Jeq * s^3 + Ke * s ...
    ));

P = pole(H);
[Z,gain] = zero(H)

% help zero