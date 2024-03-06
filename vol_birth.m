function [vol_birth, isterminal, dir] = vol_birth(t, y, EHb)
%--------------------------------------------------------------------------
% Event function in ode : finding volume at birth (Vb)
%
% called by : integration.m
%
% Maxence Dumortier - 09/12/2023
%--------------------------------------------------------------------------
% Calculate the volume at birth (Vb) as the difference between the third
% element of the state vector y and the maturity at birth (EHb)
vol_birth = y(3) - EHb;

% Set isterminal to 1 to stop the integration when the event is triggered
isterminal = 1;

% Set dir to 0 to detect both increasing and decreasing events
dir = 0;
end