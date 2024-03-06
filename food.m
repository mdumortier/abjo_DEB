function X = food(t,pars)
%--------------------------------------------------------------------------
% Determine food density at time t
% Here we compute it as a periodic function (sinus) to roughly simulate the
% variation in the north hemisphere through the year
%
% t: scalar or n-vector of time points
% pars: n-vector of parameters
%
% X: scalar or n-vector with food density
%
% called by: flux.m
%
% Maxence Dumortier - 09/12/2023
%--------------------------------------------------------------------------
%% 1. Food forcing variable
% pars.X_alpha = 0 : Constant food density on the vector t
% pars.X_alpha ≠ 0 : food density oscillation (seasonal variation)
X = pars.X_mean + pars.X_alpha*sin(t*2*pi/(365*pars.X_P)+pars.X_phi*2*pi/(365*pars.X_P));
end
