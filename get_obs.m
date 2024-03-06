function obs=get_obs(tEVHR,pars);
%--------------------------------------------------------------------------
% Compute physical length, weight, energy density, fecundity and GSI from 
% state variables
%
% obs: n-vector with
%    Lw: Standard length - cm
%    WV: Dry weight of structure - g
%    WE: Dry weight of reserve - g
%    WER: Dry weight of reproduction buffer - g
%    W: Dry weight - g
%    Ww: Total wet weight - g
%    EV: Energy content of structure - J
%    Ew: Energy density of the organism - J.g-1
%    F: Fecundity - #
%    GSI : Gonado-somatic index - 
%    LO : Otolith radius 
%
% called by: main.m
%
% Maxence Dumortier - 09/12/2023
%--------------------------------------------------------------------------
%% 1. Unpack state variable
Tps = tEVHR.x;
E = tEVHR.y(1,:);
V = tEVHR.y(2,:);
E_H = tEVHR.y(3,:);
E_R = tEVHR.y(4,:);
V_O = tEVHR.y(5,:);

%% 1.Physical length
obs.L_w = (V.^(1/3))./pars.del_M; % cm - physical length

%% 2.Wet weight
obs.W_V = pars.d_V*V; % dry weight of structure
obs.W_E = pars.w_E/pars.mu_E*E; % dry weight of reserve
obs.W_ER = pars.w_E/pars.mu_E*E_R; % dry weight of reproduction buffer
obs.W_ER = pars.kap_R*E_R/(pars.mu_E/pars.w_E);
obs.W = obs.W_V + obs.W_E + obs.W_ER; % total dry weight
obs.W_w = obs.W./(1-pars.c_w); % assume the same water content in structure and reserves

%% 3. Energy density
obs.E_V = V.*((pars.mu_V*pars.d_V)/pars.w_V); % J - Energy content of structure
obs.E_w = (obs.E_V+E+E_R)./obs.W_w; % J.g-1 - Energy density of the organism

%% 4. Fecundity
obs.F = floor((pars.kap_R*E_R)./pars.E_0); % Fecundity = egg number = kap_R

%% 5. Gonado-somatic index
obs.GSI = obs.W_ER./obs.W; % - Gonado-somatic index

%% 6. Otolith radius
obs.L_O = (V_O.^(1/3))./pars.del_O;

%% 7. Otolith opacity











