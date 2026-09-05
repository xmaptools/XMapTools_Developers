function [x, fval, exitflag] = myfsolve(fun, x0, tol, maxIter)
    if nargin < 3, tol = 1e-8; end
    if nargin < 4, maxIter = 100; end

    x = x0(:);
    n = length(x);
    exitflag = 0;

    for iter = 1:maxIter
        F = fun(x);
        F = F(:);

        if norm(F) < tol
            exitflag = 1;
            break;
        end

        J = numericalJacobian(fun, x);

        dx = J \ (-F);
        x = x + dx;

        if norm(dx) < tol
            exitflag = 1;
            break;
        end
    end

    fval = fun(x);
end

function J = numericalJacobian(fun, x)
    n = length(x);
    F0 = fun(x);
    F0 = F0(:);
    m = length(F0);
    J = zeros(m, n);
    h = 1e-8;

    for i = 1:n
        xh = x;
        xh(i) = xh(i) + h;
        Fh = fun(xh);
        J(:,i) = (Fh(:) - F0) / h;
    end
end