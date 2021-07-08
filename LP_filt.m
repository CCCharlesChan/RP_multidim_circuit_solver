function [ V_filt ] = LP_filt( t, V )
%Implement a low-pass filter corresponding to the frequency response of the
%measurement pipette.
%   t - N-dim vector: time axis of the signal;
%   V - N-dim Vector, the signal to be filtered.

%% define the filter
period = t(end) + t(2) - 2*t(1); %ms

%corresponding frequency range
N_side = 40;    %include 40 sidelobes on each side to minimize aliasing
N = length(t);
w = 2*pi*(-N_side*N:N_side*N)/period*1E3;

%physical model of the measurement pipette: R1+(C//R2)
R1 = 9.8E6; %Ohm, resistance of the pipette tip
R2 = 500E6; %Ohm, input resistance of the amplifier
C = 2E-11;  %Farad, capacitance across the glass wall of the capillary

%% Frequency response of the pipette
Imp = 1./(1/R2+1i*w*C);
div_ratio = (Imp)./(Imp+R1);
div_ratio(1) = div_ratio(1) + div_ratio(end);
div_ratio = div_ratio(1:end-1);
div_ratio = reshape(div_ratio, [N, 2*N_side]);
div_ratio = sum(div_ratio, 2);

%% Calculate impulse reponse and discard the tail of insignificant amplitude
Imp_res = abs(ifft(div_ratio));
Imp_res(round(N*.7):end)=0;

%% Filter by convolution
V_filt = real(ifft(fft(V(:)).*fft(Imp_res)));

end

