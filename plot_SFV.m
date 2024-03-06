function fig_SFV = plot_SFV(pars, tEVHR)
% -------------------------------------------------------------------------
% Make plot for forcing and state variables
%
%
% Maxence Dumortier - 09/12/2023
% -------------------------------------------------------------------------
fig_SFV = figure('Name','State & Forcing Variables');

%% 1. Forcing variables

%%  1.1. Temperature
subplot(3,4,1)
hold on
Tps = tEVHR.x./365;
plot(Tps,(temp(Tps*365,pars)-273.15),'k','LineWidth',1)        
xlabel('time (y)')
ylabel('T')
title('Temperature (°C)')

%% 1.2. Food density
subplot(3,4,2)
hold on
Tps = tEVHR.x./365;
plot(Tps,(food(Tps*365,pars)),'k','LineWidth',1)        
xlabel('time (y)')
ylabel('X')
title('food density (units up to you)')

%% 1.3. Functional response
subplot(3,4,3)
hold on
Tps = tEVHR.x./365;
X = food(Tps*365,pars); 
f = X./(X+pars.X_K);
plot(Tps,f,'k','LineWidth',1)        
xlabel('time (d)')
ylabel('f(X)')
title('Functional response')

%% 1.4. Temperature correction factor
subplot(3,4,4)
hold on
Tps = tEVHR.x./365;
T = temp(Tps,pars);
temp_c_T = exp(pars.T_A ./ pars.T_ref - pars.T_A ./ T); % Arrhenius expression (simplest version)
s_T = 1 ./ (1 + exp(pars.T_AL ./ T - pars.T_AL ./ pars.T_low) + exp(pars.T_AH ./ pars.T_high - pars.T_AH ./ T));
s_Tref = 1 ./ (1 + exp(pars.T_AL ./ pars.T_ref - pars.T_AL ./ pars.T_low) + exp(pars.T_AH ./ pars.T_high - pars.T_AH ./ pars.T_ref));
c_T = temp_c_T .* s_T ./ s_Tref; % Arrhenius expression (optimal range version)
plot(Tps,c_T,'k','LineWidth',1)
xlabel('time (d)')
ylabel('c_T')
title ('Temperature correction factor (-)')

%% 2. State variables

%% 2.1. Reserve
subplot(3,4,5)
hold on
Tps = tEVHR.x./365;
E = tEVHR.y(1,:);
plot(Tps,E,'k','LineWidth',1)
xlabel('time (y)')
ylabel('E (J)')
title('Reserve')

%% 2.2. Structure
subplot(3,4,6)
hold on
Tps = tEVHR.x./365;
V = tEVHR.y(2,:);
plot(Tps,V,'k','LineWidth',1)
xlabel('time (y)')
ylabel('V (cm^3)')
title('Structure')

%% 2.3. Maturation
subplot(3,4,7)
hold on
Tps = tEVHR.x./365;
E_H = tEVHR.y(3,:);
plot(Tps,E_H,'k','LineWidth',1)
xlabel('time (y)')
ylabel('E_H (J)')
title('Maturation')

%% 2.4. Reproduction buffer
subplot(3,4,8)
hold on
Tps = tEVHR.x./365;
E_R = tEVHR.y(4,:);
plot(Tps,E_R,'k','LineWidth',1)
xlabel('time (y)')
ylabel('E_R (J)')
title('Reproduction buffer')

%% 2.5. Reserve density
subplot(3,4,9)
hold on
Tps = tEVHR.x./365;
resDens = tEVHR.y(1,:)./tEVHR.y(2,:);
plot(Tps,resDens,'k','LineWidth',1)
xlabel('time (y)')
ylabel('[E]=E/V (J.cm^-^3)')
title('Reserve density')

%% 2.6. Scaled reserve density
subplot(3,4,10)
hold on
Tps = tEVHR.x./365;
scaled_e =  (tEVHR.y(1,:)./tEVHR.y(2,:))./(pars.E_m);
plot(Tps,scaled_e,'k','LineWidth',1)
xlabel('time (y)')
ylabel('e (-)')
title('Scaled reserve density')   

%% 2.7. Otolith volume
subplot(3,4,12)
hold on
Tps = tEVHR.x./365;
V_O = tEVHR.y(5,:);
plot(Tps,V_O,'k','LineWidth',1)
xlabel('time (y)')
ylabel('V_O (cm^3)')
title('Otolith volume')
end 