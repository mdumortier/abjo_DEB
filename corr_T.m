function pars = corr_T(pars, T)
% -------------------------------------------------------------------------
% Correct parameters based on Temperature
%
% pars: n-vector of parameters
% T : scalar or n-vector with temperature
%
% pars : n-vector with corrected parameters
%
% called by : flux.m
%
% Maxence Dumortier - 09/12/2023
% -------------------------------------------------------------------------
 %% 1. Calculate temperature correction factor
 temp_c_T = exp(pars.T_A ./ pars.T_ref - pars.T_A ./ T); % Arrhenius expression (simplest version)
 s_T = 1 ./ (1 + exp(pars.T_AL ./ T - pars.T_AL ./ pars.T_low) + exp(pars.T_AH ./ pars.T_high - pars.T_AH ./ T));
 s_Tref = 1 ./ (1 + exp(pars.T_AL ./ pars.T_ref - pars.T_AL ./ pars.T_low) + exp(pars.T_AH ./ pars.T_high - pars.T_AH ./ pars.T_ref));
 % c_T = temp_c_T .* s_T ./ s_Tref; % Arrhenius expression (optimal range version)
 c_T = 0.832385;

 %% 2. Apply correction to parameters
 pars.vT = pars.v .* c_T; % cm.d-1
 pars.p_AmT = pars.p_Am .* c_T; % J.d-1.cm-2
 pars.p_MT = pars.p_M .* c_T; % J.d-1.cm-3
 pars.k_JT = pars.k_J .* c_T; % d-1
 pars.p_TT = pars.p_T .* c_T; % J.d-1.cm-2
