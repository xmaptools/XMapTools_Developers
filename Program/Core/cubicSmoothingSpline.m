function g = cubicSmoothingSpline(x, y, w, p)
% Weighted cubic smoothing spline evaluated at the data points x.
% Minimizes: p*sum(w_i*(y_i-g(x_i))^2) + (1-p)*integral(g''(x)^2 dx)
% Same formulation/parameterization as MATLAB's fit(...,'smoothingspline',...).
% Reference: Green & Silverman (1994), "Nonparametric Regression and
% Generalized Linear Models", Ch. 2.
 
x = x(:); y = y(:); w = w(:);
n = numel(x);
 
if n < 3
    g = y; % not enough points for a cubic spline; return data as-is
    return;
end
 
h = diff(x);
if any(h <= 0)
    error('cubicSmoothingSpline:x', 'x must be strictly increasing with no duplicates.');
end
 
% R: (n-2)x(n-2) tridiagonal
R = zeros(n-2, n-2);
for i = 1:n-2
    R(i,i) = (h(i) + h(i+1)) / 3;
end
for i = 1:n-3
    R(i,i+1) = h(i+1) / 6;
    R(i+1,i) = h(i+1) / 6;
end
 
% Q: n x (n-2), second-difference operator
Q = zeros(n, n-2);
for i = 1:n-2
    Q(i,   i) =  1/h(i);
    Q(i+1, i) = -1/h(i) - 1/h(i+1);
    Q(i+2, i) =  1/h(i+1);
end
 
lambda = (1 - p) / p;
Winv = spdiags(1 ./ w, 0, n, n);
 
gamma = (R + lambda * (Q' * Winv * Q)) \ (Q' * y);
g = y - lambda * Winv * Q * gamma;
end