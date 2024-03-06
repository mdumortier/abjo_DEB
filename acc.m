function s_M = acc(E_H,V,pars)
% -------------------------------------------------------------------------
% Function to calculate acceleration factor
%
% E_H: 
% V:
%
% s_M:
%
% called by: 
% 
% Maxence Dumortier - 09/12/2023
% -------------------------------------------------------------------------
if E_H <= pars.E_Hb
    s_M = 1;
elseif E_H <= pars.E_Hj && pars.V_b > 0
    s_M = (V / pars.V_b)^(1/3);
elseif E_H >= pars.E_Hj && pars.V_j > 0
    s_M = (pars.V_j / pars.V_b)^(1/3);
else
    s_M = 1;
end
end

