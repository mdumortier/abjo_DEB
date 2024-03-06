function T = temp(t,pars)
%--------------------------------------------------------------------------
% Determine temperature at time t
% Here we compute it as a periodic function (sinus) to roughly simulate the
% variation in the north hemisphere through the year
%
% t: scalar or n-vector of time points
% pars: n-vector of parameters
%
% T: scalar or n-vector with temperature
%
% called by : flux.m
%
% Maxence Dumortier - 09/12/2023
%--------------------------------------------------------------------------
%% 1. Temperature forcing variable
% pars.T_alpha = 0 : Constant temperature on the vector t
% pars.T_alpha ≠ 0 : Temperature oscillation (seasonal variation)
T = pars.T + pars.T_alpha*sin(t*2*pi/(365*pars.T_P)+pars.T_phi*2*pi/(365*pars.T_P));

