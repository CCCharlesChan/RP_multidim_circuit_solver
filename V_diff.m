function [f, g] = V_diff(Va, Vr, R, D, D_d, I_pc, V)
%Compute the left side of Equation (7), which is solved if equal to 0.
%   Va - N-dim vector, voltage across the active electrodes; N is the
%   number of pixels;
%   Vr - scalar, voltage across the return electrode;
%   R  - NxN matrix, access resistance matrix;
%   D  - Function handle, dark I-V characteristics of diodes;
%   D_d - Function handle, derivative of D;
%   I_pc - N-dim vector, short-circuit photocurrent of the photodiodes;
%   V  - Assumed forward-bias voltage of the photodiodes.

dV = Va + Vr + R * (I_pc - D(V)) - V;   % Equation (7)
f = dV(:)'*dV(:)/2; % sum squared error

if nargout > 1 % if gradient required, then compute g:=df/dV
    g = -R'*dV.*D_d(V) - dV;
end
end