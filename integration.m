function [tEVHR,pars,transi] = integration(pars)
%--------------------------------------------------------------------------
% Compute model predictions (numerical integration)
%
% pars: n-vector of parameters
%
% tEVHR: 5-vector with d/dt E, V, E_H, E_R, V_O
% pars: n-vector of parameters
% transi: n-vector with time of stage transition
%
% called by: main.m
% calls: flux.m, vol_birth.m, vol_pub.m
%
% Maxence Dumortier - 09/12/2023
%--------------------------------------------------------------------------
%% 1. Initialize outputs

disp("-- Start of the dynamic of the individual --")

Tps = [];
E = [];
V = [];
E_H = [];
E_R = [];
V_C = [];
V_P = [];

%% 2.1. Integration from begining to birth (embryo phase)
% CI = [pars.E_0,pars.V_0,pars.E_H0,pars.E_R0, pars.V_O0];
CI = [pars.E_0,pars.V_0,pars.E_H0,pars.E_R0, pars.V_C0, pars.V_P0];
opts = odeset('RelTol',1e-12,'Events',@(t,EVHR)vol_birth(t,EVHR,pars.E_Hb));
t_EVHR_0b = ode45(@(t,CI) flux(t, CI, pars), [0:pars.time], CI, opts);

Tps = [Tps, t_EVHR_0b.x]; 
E = [E, t_EVHR_0b.y(1,:)];
V = [V, t_EVHR_0b.y(2,:)];
E_H = [E_H, t_EVHR_0b.y(3,:)];
E_R = [E_R, t_EVHR_0b.y(4,:)];
V_C = [V_C, t_EVHR_0b.y(5,:)];
V_P = [V_P, t_EVHR_0b.y(6,:)];

%% 2.2. Register volume at birth (V_b)

if isempty(t_EVHR_0b.ye) % if it dies before birth
    pars.V_b = [];
    transi.t_birth= 0;
else
    pars.V_b = t_EVHR_0b.ye(2); % register V_b
    transi.t_birth = t_EVHR_0b.xe;
    disp("Embryo phase ended")
end

%% 3.1. Integration from birth to metamorphosis (larval phase)
if isnan(E(end)) == false
    % CI = [E(end),V(end),E_H(end),E_R(end), V_C(end)];
    CI = [E(end),V(end),E_H(end),E_R(end), V_C(end), V_P(end)];
    opts = odeset('Reltol', 1e-12, 'Events', @(t,EVHR)vol_meta(t,EVHR,pars.E_Hj));
    t_EVHR_bj = ode45(@(t,CI) flux(t,CI,pars), [Tps(end):pars.time],CI,opts);

     Tps = [Tps, t_EVHR_bj.x]; 
     E = [E, t_EVHR_bj.y(1,:)];
     V = [V, t_EVHR_bj.y(2,:)];
     E_H = [E_H, t_EVHR_bj.y(3,:)];
     E_R = [E_R, t_EVHR_bj.y(4,:)];
     V_C = [V_C, t_EVHR_bj.y(5,:)];
     V_P = [V_P, t_EVHR_bj.y(6,:)];

     %% 3.2. Register volume at matamorphosis (V_j)
     if isempty(t_EVHR_bj.ye) % if it dies before metamorphosis
         pars.V_j = [];
         transi.t_meta = 0;
     else
         pars.V_j = t_EVHR_bj.ye(2); % Register V_j
         transi.t_meta = t_EVHR_bj.xe;
         disp("larval phase ended")
     end
end

%% 4.1. Integration from metamoprhosis to puberty (juvenil phase)
if isnan(E(end)) == false
    % CI = [E(end),V(end),E_H(end),E_R(end), V_C(end)];
    CI = [E(end),V(end),E_H(end),E_R(end), V_C(end), V_P(end)];
    opts = odeset('Reltol', 1e-12, 'Events', @(t,EVHR)vol_pub(t,EVHR,pars.E_Hp));
    t_EVHR_jp = ode45(@(t,CI) flux(t,CI,pars), [Tps(end):pars.time],CI,opts);
    
    Tps = [Tps, t_EVHR_jp.x]; 
    E = [E, t_EVHR_jp.y(1,:)];
    V = [V, t_EVHR_jp.y(2,:)];
    E_H = [E_H, t_EVHR_jp.y(3,:)];
    E_R = [E_R, t_EVHR_jp.y(4,:)];
    V_C = [V_C, t_EVHR_jp.y(5,:)];
    V_P = [V_P, t_EVHR_jp.y(6,:)];
    
    %% 4.2. Register volume at puberty (V_p)
    if isempty(t_EVHR_jp.ye) % if it dies before puberty
        pars.V_p = [];
        transi.t_pub= 0;
    else
        pars.V_p = t_EVHR_jp.ye(2); % register V_b
        transi.t_pub = t_EVHR_jp.xe;
        disp("Juvenile phase ended")
    end
end

%% 5. Integration from puberty to the end (adult phase)
if isnan(E(end)) == false
    % CI = [E(end),V(end),E_H(end),E_R(end), V_C(end)];
    CI = [E(end),V(end),E_H(end),E_R(end), V_C(end), V_P(end)];
    opts  =  odeset('Reltol',1e-12);
    t_EVHR_pend = ode45(@(t,CI) flux(t,CI,pars), [Tps(end):pars.time],CI,opts);
    
    Tps = [Tps, t_EVHR_pend.x]; 
    E = [E, t_EVHR_pend.y(1,:)];
    V = [V, t_EVHR_pend.y(2,:)];
    E_H = [E_H, t_EVHR_pend.y(3,:)];
    E_R = [E_R, t_EVHR_pend.y(4,:)]; 
    V_C = [V_C, t_EVHR_pend.y(5,:)];
    V_P = [V_P, t_EVHR_pend.y(6,:)];
    
    disp("Adult phase ended")
end

%% 6. Save the outputs
tEVHR.x = Tps;
tEVHR.y(1,:) = E;
tEVHR.y(2,:) = V;
tEVHR.y(3,:) = E_H;
tEVHR.y(4,:) = E_R;
tEVHR.y(5,:) = V_C;
tEVHR.y(6,:) = V_P;

disp("-- End of dynamic of the individual --")
end





