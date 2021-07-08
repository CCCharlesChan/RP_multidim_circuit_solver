%% This script computes the potential waveform at the pipette tip by linear combination of the elementary fields
clear all; close all; clc

%% load the elementary fields
load('Model/ElementaryFields.mat'); %only the potential at the pipette tip is loaded for each elementary field

%% synthesize the waveform at the pipette tip by combining the elementary potentials

%load the dynamics
dynamics = load('Output_dynamics.mat');
N_cycle = size(dynamics.I_t, 3);

%recover the complete time axis
period = dynamics.t(2)+dynamics.t(end);
t = dynamics.t(:)+(0:N_cycle-1)*period;
t = t(:) - floor(N_cycle/2)*period;

%combine the elementary fields with coefficients equal to the currents of the pixels
I_t = reshape(dynamics.I_t, [length(V_dict), length(t)]);
V = V_dict'*I_t;

%% save the computed potential waveform
V = LP_filt(t, V);  %low-pass frequency response of the pipette
save('Output_waveform.mat', 't', 'V');

