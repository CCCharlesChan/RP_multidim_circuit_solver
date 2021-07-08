function [ X, cost_val, step_size, iter_cnt, time_cost ] = my_grad_desc( cost_fun, X0, epsilon, alpha )
%Gradient descent with adaptive step size
%   cost_fun - function handle, the cost function to minimize; 0 is the
%   minimization target;
%   X0 - initial guess;
%   epsilon - error tolerance to stop the minimization
%   alpha - step size tolerance to stop the minimization

%% Initialize the optimization
step_size = 1;
X = X0;
[cost_val, g_val] = cost_fun(X);    %compute the current cost function and gradient

%% Optimization
iter_cnt=0; %step count
time_cost = toc;    %time the optimization

while (cost_val>epsilon) && (step_size>alpha)   %ending condition: cost function satisfies tolerance, or step size smaller than specified
    
    X1 = X - step_size*g_val;   %test if the tentative step size reduces the cost function
    [f, g] = cost_fun(X1);
    if f>cost_val
        while f>cost_val    %if not, reduce the step size by a factor of 10 until the cost function decreases
            step_size = step_size/10;
            X1 = X - step_size*g_val;
            [f, g] = cost_fun(X1);
        end
    else    %if so, increase the step size by a factor of 2
        step_size = step_size*2;
    end
    X = X1; %accept the tentative step
    
    %update the cost function and the gradient
    cost_val = f;
    g_val = g;
    
    %counter ++
    iter_cnt=iter_cnt+1;
end

% end timing
time_cost = toc - time_cost;

end

