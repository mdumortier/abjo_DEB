function [vol_pub, isterminal, dir] = vol_pub(t, y, EHp)
%--------------------------------------------------------------------------
% Event function in ode : finding volume at puberty (Vp)
%
% called by : integration.m
%
% Maxence Dumortier - 09/12/2023
%--------------------------------------------------------------------------
% Calculate the difference between the current volume and the volume at which the event occurs
vol_pub = y(3) - EHp;

% Set isterminal to 1 to stop the integration when the event occurs
isterminal = 1;

% Set dir to 0 (not used in this function)
dir = 0;

end