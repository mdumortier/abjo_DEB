function dEVHR = flux(t, EVHR, pars) 
%--------------------------------------------------------------------------
% Define differential equations of the state variables
%
% t: n-vector with time points
% EVHR: 4-vector with state variables
%   E - J - reserve energy
%   V - cm^3 - structural volume
%   E_H - J - cumulated energy invested into maturity
%   E_R - J - reproduction buffer
% pars : n-vector of parameters
%
% dEVHR: 4-vector with d/dt E, V, E_H, E_R
%
% called by: integration.m
% calls: food.m, temp.m, corr_T.m
%
% Maxence Dumortier - 09/12/2023
%--------------------------------------------------------------------------
%% 1. Unpack state variables
E = EVHR(1); % Energy in reserve
V = EVHR(2); % Structure
E_H = EVHR(3); % Maturity
E_R = EVHR(4); % Energy in reproduction buffer
V_C = EVHR(5); % Volume of CaCO3 (otolith)
V_P = EVHR(6); % Volume of protein matrix (otolith)

%% 2. Environmental conditions
X = food(t, pars); % Food density
T = temp(t, pars); % Temperature

%% 3. Case when reserve energy is empty
if E <= 0 % death
    disp('Reserve empty: death at ' + string(t));
    E = 0;
    pS = nan; pG = nan; pA = nan; pC = nan; pJ = nan; pR = nan; pD = nan;
end

%% 4. Acceleration factor
if isnan(E_H) % if death beforte the end
    s_M = nan;
else
    s_M = acc(E_H,V,pars);
end

%% 5. Temperature correction function
pars = corr_T(pars, T); 

%% 6. Temperature correction for CaCO3 precipitation
cC_T = exp(pars.T_AC ./ pars.T_C - pars.T_AC ./ T);

%% 7. Scaled functional response
% f=X./(X+pars.X_K);
f = 1;

%% 8. Flux calculation
if E_H < pars.E_Hb  % before birth no assimilation
    pA = 0;
else
    pA = s_M * pars.p_AmT * f * V^(2/3); % assimilation
end

pS = pars.p_MT * V + pars.p_TT * V^(2/3); % somatic maintenance
pC = E*((pars.E_G * s_M * pars.vT/V^(1/3)+pS/V)/(pars.kap*E/V+pars.E_G)); % mobilization
pJ = pars.k_JT * E_H; % maturity maintenance
pR = (1 - pars.kap) * pC - pJ; % reproduction buffer
pD = pS + pJ + (1-pars.kap_R)* pR; % Dissipation

%% 9. Case when maturity maintenance can't be paid
if pJ < 0
    disp("! maturity maintenance can't be paid ! - EH = " + string(E_H) + " t = " + string(t));
    pR = 0;
end

%% 10. Starvation scenarios
pERes = 0;
if pars.kap* pC < pS % if there is not enough mobilisation to pay p_S
    disp("Warning: somatic maintenance can't be paid");
    delta = abs(pars.kap * pC - pS); % Calculate missing energy needed

    %% 10.1 The individual is an adult
    if E_H >= pars.E_Hp
        if E_R >= delta % Enough energy in reprod. buffer
            pERes = delta; % Energy in reprod. buffer is used for rescue
            pG = 0; % stop growth
            disp('Energy from E_R used for rescue without growth');
        else % Not enough energy in reprod. buffer
            pS = nan; pG = nan; pA = nan; pC = nan; pJ = nan; pR = nan; pD = nan; % the individual dies
            disp('Energy in E_R is not enough : the individual died at ' + string(t));
        end
        
    %% 10.2 The individual isn't an adult
    else
        if pR >= delta % Enough energy meant for maturity
            pG = 0; % stop growth
            pR = 0; % stop maturity
            disp('Maturity paid for pS');
        else % Not enough energy meant for maturity
             pS = nan; pG = nan; pA = nan; pC = nan; pJ = nan; pR = nan; pD = nan; % the individual dies
             disp('Energy meant for maturity is not enough : the individual died at ' + string(t));
        end
    end
else % if enough mobilisation to pay p_S
    pG = pars.kap * pC - pS; % Growth
end

%% 11. State variables differential equation
% dEVHR = zeros(5, 1); % initialize the state variables updates
dEVHR = zeros(6, 1); % initialize the state variables updates

dEVHR(1) = pA - pC; % dE
dEVHR(2) = pG / pars.E_G; % dV   
if E_H < pars.E_Hp
    dEVHR(3) = pR; % dE_H
    dEVHR(4) = 0; % dE_R
else
    dEVHR(3) = 0; % dE_H
    dEVHR(4) = pars.kap_R * pR - pERes; % dE_R
end
% dEVHR(5) = (pars.v_GC*pG) + (pars.v_DC*pD); % dV_C
dEVHR(5) = cC_T * ((pars.v_GC*pG) + (pars.v_DC*pD)); % dV_C
dEVHR(6) = (pars.v_GP*pG) + (pars.v_DP*pD); % dV_P
end


