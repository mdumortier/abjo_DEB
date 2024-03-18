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
V_C = tEVHR.y(5,:);
V_P = tEVHR.y(6,:);

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
obs.L_O = (V_C.^(1/3))./pars.del_O;

%% 7. Otolith opacity

% 1. Environmental conditions
X = food(Tps, pars); % Food density
T = temp(Tps, pars); % Temperature

% 2. Acceleration factor
s_M = zeros(size(E_H));

for i = 1:length(E_H)

    if E_H(i) <= pars.E_Hb
        s_M(i) = 1;
    elseif E_H(i) <= pars.E_Hj && pars.V_b > 0
        s_M(i) = (V(i) ./ pars.V_b).^(1/3);
    elseif E_H(i) >= pars.E_Hj && pars.V_j > 0
        s_M(i) = (pars.V_j / pars.V_b)^(1/3);
    else
        s_M(i) = 1;
    end
end

% if E_H <= pars.E_Hb
%     s_M = 1;
% elseif E_H <= pars.E_Hj && pars.V_b > 0
%     s_M = (V ./ pars.V_b).^(1/3);
% elseif E_H >= pars.E_Hj && pars.V_j > 0
%     s_M = (pars.V_j / pars.V_b)^(1/3);
% else
%     s_M = 1;
% end

% 3. Temperature correction function
pars = corr_T(pars, T);

% 4. Temperature correction for CaCO3 precipitation
cC_T = exp(pars.T_AC ./ pars.T_C - pars.T_AC ./ T);

% 5. Scaled functional response
% f=X./(X+pars.X_K);
f = 1;

% 6. Flux calculation
pS = pars.p_MT .* V + pars.p_TT .* V.^(2/3); % somatic maintenance
pC = E.*((pars.E_G * s_M * pars.vT./V.^(1/3)+pS./V)./(pars.kap*E./V+pars.E_G)); % mobilization
pJ = pars.k_JT * E_H; % maturity maintenance
pR = (1 - pars.kap) * pC - pJ; % reproduction buffer
pD = pS + pJ + (1-pars.kap_R)* pR; % Dissipation
pG = pars.kap * pC - pS; % Growth

% 6. Otolith opacity
obs.O = 1 ./ cC_T .* ((pars.v_GP.*pG) + (pars.v_DP.*pD)./ (pars.v_GC.*pG + pars.v_DC.*pD));
% obs.O = (pars.v_GC.*pG) ./ (pars.v_GC.*pG + pars.v_DC.*pD);

plot(Tps,pG)



