function pars = set_par()
%--------------------------------------------------------------------------
% Parameters (values, unit and description)
% pars: n-vector of parameters
%
% called by: main.m, get_obs.m, plot_SFV.m, plot_obs.m
%
% Maxence Dumortier - 09/12/2023
%--------------------------------------------------------------------------

%% 1. Simulation parameters
nbyears = 8; % years - simulation duration
pars.time = 365*nbyears; % days - simulation duration

%% 2. Forcing variables parameters
%% 2.1. Temperature
pars.T = 273.15 + 20; %12; % K - mean temperature
pars.T_alpha = 0; % Amplitude of the sinusoidal variation of temperature
pars.T_phi = 365*2/3; % Phase offset or initial variation of temperature
pars.T_P = 1; % Period of the sinusoidal variation of temperature

%% 2.2. Food
pars.X_mean = 200; % g.l-1 - mean food density
pars.X_alpha = 0; % Amplitude of the sinusoidal variation of food
pars.X_phi = 365*2.2/3; % Phase offset or initial variation of food
pars.X_P = 1; % Period of the sinusoidal variation of food

%% 3. State variable - Initial conditions
pars.E_0 = 1.26224; % J - Reserve
pars.V_0 = 1*10^(-7); %0.001; % cm^3 - Structural volume
pars.E_H0 = 0; % J - Cumulated energy invested into development
pars.E_R0 = 0; % J - Reproduction buffer
pars.L_O0 = 0.1*10^(-1); % cm - Otolith length
pars.V_C0 = 6.4*10^(-8); % cm^3 - Volume of calcium carbonate (otolith)
pars.V_P0 = 3.4*10^(-8); % cm^3 - Volume of protein matrix (otolith)

%% 4 Primary parameters
%% 4.1. Arrhenius temperature
pars.T_A = 9800; % K - Arrhenius temperature
pars.T_low = 273.15 + 13;% K - Lower boundary of the tolerance range
pars.T_high = 273.15+ 30; %305; % K - Upper boundary of the tolerance range
pars.T_AL = 8250; % K - Arrhenius temperature for lower boundary
pars.T_AH = 8390; % K - Arrhenius temperature for upper boundary
pars.T_ref = 293.15; % K - Reference temperature

%% 4.2. Core parameters
pars.p_Am = 419.0; %311.682; %311.682; %770; % J.d-1.cm-2 - maximum surface specific assimilation rate
pars.p_M = 415.9; %127.831; % J.d-1.cm-3 - vol-specific somatic maintenance
pars.p_T = 0; % J.d.cm-3 - Surf-spec somatic maintenance 
pars.v =  1.37 * 10^(-2); %0.08581; % cm.d-1 - Energy conductance
pars.kap = 0.89; % 0.97993; % - Allocation fraction to soma (growth + somatic maintenance)
pars.kap_R = 0.95; % - Reproduction efficiency
pars.k_J = 0.002; %0.015; % d-1 - Maturity maintenance rate coefficient
pars.E_G  = 5213.4; %5220.69; % J.cm-3 - Volume spec cost for struct

%% 4.3. Energy maturity threshold
pars.E_Hb = 1.18*10^(-2); %0.01515; % J - Maturity at birth
pars.E_Hj = 0.358; %0.4352; % Maturity at metamorphosis
pars.E_Hp = 3065.1; %24270; % J - Maturity at puberty

%% 4.4. Structural volume maturity threshold (needed for acceleration factor)
pars.V_b = 0; % cm^3 - Structural volume at birth
pars.V_j = 0; % cm^3 - Structural volume at metamorphosis
pars.V_p = 0; % cm^3 - Structural volume at puberty

%% 5. Auxiliary and coumpound parameters
%% 5.1. Compounds parameters
pars.X_K = 0.01; %5; % same as food - Half saturation coefficient of the functional response
pars.E_m = pars.p_Am/pars.v; % J.cm-3 - Maximum reserve density

%% 5.2. Otolith module parameters
pars.v_GC = 1*10^(-8); % 0.0535; % cm^3.J-1 - calcium carbonate coupling coefficient to growth
pars.v_DC = 1*10^(-7); % 0.459; % cm^3.J-1 - calcium carbonate coupling coefficient to dissipation
pars.v_GP = 0.00535; % cm^3.J-1 - protein matrix coupling coefficient to growth
pars.v_DP = 0.000535; % cm^3.J-1 - protein matrix coupling coeffient to dissipation
pars.T_AC = 3000; % K - Arrhenius temperature for CaCO3 precipitation
pars.T_C = 282; % K - Reference temperature for CaCO3 precipitation

%% 5.2. Auxiliary parameters (computing observable variables)
pars.del_M = 0.11; %0.43546; % - Shape coefficient to convert vol-length to physical length
pars.del_O = 0.4; % - Otolith shape coefficient
pars.c_w = 0.5; % - Total water faction of the organism
pars.d_V = 1; %0.00005; % g.cm-3 - Specific density of structure
pars.w_E = 20; % g.mol-1 - Specific weight of reserve
pars.w_V = 20; % g.mol-1 - Specific weight of structure 
pars.mu_E = 23012; %300000; %468440; % J.mol-1 - Chemical potential of reserve
pars.mu_V = 21834; %10000; % J.mol-1 - Chemical potential of structure

end 
