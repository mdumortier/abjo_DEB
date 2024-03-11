function fig_obs=plot_obs(obs,tEVHR)
% -------------------------------------------------------------------------
% Make plot for observable variables
%
%
% Maxence Dumortier - 09/12/2023
% -------------------------------------------------------------------------
fig_obs = figure('Name','Observables'); 

%% 1. Physical length
subplot(3,4,1)
hold on
Tps = tEVHR.x./365;
plot(Tps,obs.L_w,'k','LineWidth',1)        
xlabel('time (y)')
ylabel('Lw - Standard length (cm)')
title('Physical length')

%% 2. Weight

%% 2.1. Dry weight
subplot(3,4,2)
hold on
Tps = tEVHR.x./365;
plot(Tps,obs.W,'k','LineWidth',1)
plot(Tps,obs.W_E,'b','LineWidth',1)
plot(Tps,obs.W_V,'r','LineWidth',1)
plot(Tps,obs.W_ER,'m','LineWidth',1)
xlabel('time (y)')
ylabel('W- Dry weight (g)')
title('Dry weight')
legend('W', 'W_E', 'W_V', 'W_E_R',Location='northwest')

%% 2.2. Wet weight
%% Ww/t
subplot(3,4,3)
hold on
Tps = tEVHR.x./365;
plot(Tps,obs.W_w,'k','LineWidth',1)
xlabel('time (y)')
ylabel('Ww - Wet weigth (g)')
title('Wet weight')

%% Ww/Lw
subplot(3,4,4)
hold on
plot(obs.L_w,obs.W_w,'k','LineWidth',1)
ylabel('Ww - Wet weight (g)')
xlabel('Lw - Standard length (cm)')    
title('Wet weight - Length')

%% 3. Energy density
subplot(3,4,5)
hold on
Tps = tEVHR.x./365;
plot(Tps,obs.E_w,'k','LineWidth',1)
xlabel('time (y)')
ylabel('Ew - Energy density of the organism (J.g^-^1)')
title('Energy density')

%% 4. Fecundity

%% 4.1 F/t
subplot(3,4,9)
hold on
Tps = tEVHR.x./365;
plot(Tps,obs.F,'k','LineWidth',1)
xlabel('time (y)')
ylabel('F - Number of eggs (#)')
title('Fecundity')

%% 4.2 F/Lw
subplot(3,4,10)
hold on
plot(obs.L_w,obs.F,'k','LineWidth',1)
xlabel('Lw - Standard length (cm)')
ylabel('F - Number of eggs (#)')
title('Fecundity - Length')

%% 5. Gonado-somatic index
subplot(3,4,11)
hold on
Tps = tEVHR.x./365;
plot(Tps,obs.GSI,'k','LineWidth',1)
xlabel('time (y)')
ylabel('GSI - Gonado-somatic index (-)')
title('Gonado-somatic index')

%% 6. Otolith

%% 6.1. Otolith radius
subplot(3,4,7)
hold on
Tps = tEVHR.x./365;
plot(Tps,obs.L_O,'k','LineWidth',1)
xlabel('time (y)')
ylabel('L_O (cm)')
title('Otolith radius')

subplot(3,4,8)
hold on
Tps = tEVHR.x./365;
plot(Tps,obs.O,'k','LineWidth',1)
xlabel('time (y)')
ylabel('O (-)')
title('Otolith opacity')
end