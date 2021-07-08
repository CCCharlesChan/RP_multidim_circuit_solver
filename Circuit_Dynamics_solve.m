%% This script calculates the multi-dimensional circuit dynamics as described in Section 1.3
clear all; close all; clc

%% load parameters of the device
Device = load('Model/Device.mat');

D = @(V) interp1(Device.V_diode, Device.I_diode, V, 'linear', 'extrap'); %interpolate dark I-V characteristics of the diode

Device.I_diode_d = diff(Device.I_diode)./diff(Device.V_diode); %take derivative of the I-V curve
Device.V_diode_d = mean([Device.V_diode(1:end-1), Device.V_diode(2:end)], 2);
D_d = @(V) interp1(Device.V_diode_d, Device.I_diode_d, V, 'linear', 'extrap');

R = Device.R; % the impedance matrix in Ohm
N_px = size(R, 1);

%define the electrode-electrolyte interface
C0 = .3;    %mF/cm^2
Rf0 = .75;   %Ohm*cm^2
Cf0 = .8;  %mF/cm^2

%on the active electrodes
Ca = C0*pi*9^2*1E-8;%mF
Rfa = C0*Rf0/Ca;    %Ohm
Cfa = Ca*Cf0/C0;    %mF

%on the return electrode
Cr = Ca*N_px*Device.ARratio;%mF
Rfr = C0*Rf0/Cr;            %Ohm
Cfr = Cr*Cf0/C0;            %mF

%% set up the circuit solver
% gradient descent meta-parameters
alpha = 1E-6;           %minimum step size
epsilon = N_px*1E-8/2;  %relative error tolerance
V_ini = 0.3*ones(N_px, 1);  %initial guess for voltage across the diode at time step 1

Stimulus = load('Model/Stimulus.mat');    %load the light projection pattern
N_cycle = 30;   % simulate 30 periods, 15 with the field stop open, 15 with it close

Va_t = ones([size(Stimulus.ptCurrent_open), N_cycle])*0.4;  %potential across the interfaces of active electrodes
Vfa_t = Va_t;   %potential across the pseudocapacitors of active electrodes
Vr_t = zeros([size(Stimulus.ptCurrent_open, 2), N_cycle]);  %potential of the return
Vfr_t = Vr_t;   %pseudocapacitive potential of the return
I_t = zeros(size(Va_t));    %current across the interface as a funtion of time

%initial values of the interfaces
Va = Va_t(:, 1, 1);
Vfa = Vfa_t(:, 1, 1);
Vr = Vr_t(1, 1);
Vfr = Vfr_t(1, 1);

%% solve for the multi-dimensional dynamics of the circuit

ptCurrent_t = Stimulus.ptCurrent_open;  %light projection pattern with the FS open

tic
for cycle_idx = 1:N_cycle
    if cycle_idx == floor(N_cycle/2)+1
        ptCurrent_t = Stimulus.ptCurrent_close; %FS closes at the end of the 15th period
    end
    for kk = 1:length(Stimulus.t)
        
        cost_fun = @(V) V_diff(Va, Vr, R, D, D_d, ptCurrent_t(:, kk), V);   %cost function defined as Equation (7)
        [ V_step, cost_val, step_size, iter_cnt, time_cost] = my_grad_desc( cost_fun, V_ini, epsilon, alpha );  %gradient descent with adaptive step size
        V_ini = V_step; %solution at one time step is the initial guess for the next time step
        I_step = ptCurrent_t(:, kk) - D(V_step); %interface current in A
        
        %Update the state of the interfaces by Equation (8)-(10)        
        Va = Va + (I_step - (Va-Vfa)/Rfa ) *Stimulus.si/Ca;
        Vr = Vr + (sum(I_step) - (Vr-Vfr)/Rfr ) *Stimulus.si/Cr;
        Vfa = Vfa + (Va-Vfa)/Rfa *Stimulus.si/Cfa;
        Vfr = Vfr + (Vr-Vfr)/Rfr *Stimulus.si/Cfr;
        
        Va_t(:, kk, cycle_idx) = Va;
        Vr_t(kk, cycle_idx) = Vr;
        Vfa_t(:, kk, cycle_idx) = Vfa;
        Vfr_t(kk, cycle_idx) = Vfr;
        I_t(:, kk, cycle_idx) = I_step;
        
    end
    
    %the first time step of the next period continues from the last step of the current period.
    Va = Va_t(:, end, cycle_idx);
    Vfa = Vfa_t(:, end, cycle_idx);
    Vr = Vr_t(end, cycle_idx);
    Vfr = Vfr_t(end, cycle_idx);
    disp(cycle_idx)
    toc
end

%% save the computed circuit dynamics
t = Stimulus.t;
save('Output_dynamics.mat', 't', 'Va_t', 'Vr_t', 'I_t', 'Vfa_t', 'Vfr_t');