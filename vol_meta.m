function [vol_meta, isterminal, dir] = vol_meta(t, y, EHj)
%--------------------------------------------------------------------------
% Event function in ode : finding volume at metamorphosis (Vj)
%
% called by : integration.m
%
% Maxence Dumortier - 09/12/2023
%--------------------------------------------------------------------------
% Calculate the difference between the current volume and the volume at which the event occurs
vol_meta = y(3) - EHj;

% Set isterminal to 1 to stop the integration when the event occurs
isterminal = 1;

% Set dir to 0 (not used in this function)
dir = 0;

end