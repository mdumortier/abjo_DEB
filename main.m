%--------------------------------------------------------------------------
% Compute model prediction for one individual with standard DEB equations
%
% Parameter from DEBSea
% 
% from the egg to adult stage
% 
% Food density and temperature variation
% 
% calls: set_par.m, integration.m, get_obs.m, plot_SFV.m, plot_obs.m
% 
% Maxence Dumortier - 09/12/2023
%--------------------------------------------------------------------------
tic
clear all 
clc
close all

%% 1. Initialisation simulation and model parameters
pars = set_par();

%% 2. Calculate flux and differential equation
[tEVHR,pars,transi]= integration(pars);

%% 3. Calculate observable variables
obs = get_obs(tEVHR,pars);

%% Display

disp('-------------------------');
disp("Date of birth (d): "+string(transi.t_birth)+"; (y):"+string(transi.t_birth/365));
disp("Date of metamorphosis (d): "+string(transi.t_meta)+"; (y):"+string(transi.t_meta/365));
disp("Date of puberty (d): "+string(transi.t_pub)+"; (y):"+string(transi.t_pub/365));
disp("End time of simulation (d): "+string(pars.time(end))+"; (y):"+string(pars.time(end)/365));
disp('-------------------------');

%% 4. Make plot
%% 4.1. Plot State and forcing variables
fig_SFV = plot_SFV(pars, tEVHR);

%% 4.2. Plot observable variables
fig_obs=plot_obs(obs,tEVHR);

toc

