%% Kinematics of guidewire
% Author: wayne wu
% version: v1.0
clc,clear,close all
%% Parameters
NL = 7; % Number of edges 
MASS = 0.06e-03; % Mass of guidewire (g)
LENGTH = 28.6e-03; % length of guidewire (m)
r = (1.086e-03)/2; % Radius (m)
Mag = 1e5; %magnetization (A/m)
g = 9.81; %9.81; % gravity (m/s^2)
kb = 3e-7;%bending stiffness coefficience (3e-7)
kd = 0.1; %0.1;% 1e-5; % viscous damping (0.1)
ks = 0.01;%0.001;% E*pi*r^2; % stretching stiffness (0.01)
sN = [1,2]; % fixed vertices
% x0 = [zeros(1,NL+1);zeros(1,NL+1);linspace(0,LENGTH,NL+1)]; % 竖直
x0 = [linspace(0,LENGTH,NL+1);zeros(1,NL+1);zeros(1,NL+1)]; % |----------
v0 = zeros(3,NL+1);

Bm = [0;0;10]*1e-3; %external magnetic field
%% Main
                                                             
x = x0;
v = v0;
% explict Euler solve
h = 0.001; % time step
simTime = 0;
tolSimTime = 10;
lastsimTime = 0;
while simTime < tolSimTime
    % time-variant 
    % set Bm here
    forces = lump_force(x,v,NL,MASS,LENGTH,r,g,Mag,kb,kd,ks,sN,Bm);
    % 注意这里的力已经除过质量了，是加速度形式！
    newx = x+h*v+h^2*forces;
    
    v = (newx - x)/h;
    x = newx;
    % Plot
    if simTime - lastsimTime > 0.0417 % 伪实时帧率
        lastsimTime = simTime;
        plot(x(1,:),x(3,:),'.-k','MarkerSize',20,'Linewidth',1);
        xlabel('x');ylabel('z');
        xlim([0,2*LENGTH]);ylim([-LENGTH,LENGTH]);
%         xlim([-LENGTH,LENGTH]);ylim([0,LENGTH]);
        title(simTime)
        pause(1e-8);
    end
    simTime = simTime + h;
end

% ODE23s
% Initialization
% x = reshape([linspace(0,LENGTH,NL+1);zeros(2,NL+1)],3*(NL+1),1);
% load Naturalsagging.mat
% x = reshape(x,3*(NL+1),1);
% v = zeros(3*(NL+1),1);
% X0 = [x;v];
% X = [x;v];
% sample time
% tspan = [0 5];
% derivative
% opt = odeset('MaxStep',0.1);
% [t,X] = ode23s(@(t,X) state_space(t,X,NL,MASS,LENGTH,r,g,Mag,kb,kd,ks,Bm),tspan,X0,opt);
% plot

% figure
% for i = 1:length(t)
%         x = reshape(X(i,1:3*(NL+1)),3,NL+1);
%         plot(x(1,:),x(3,:),'.-k')
%         xlim([0,LENGTH]);ylim([-LENGTH,0.2*LENGTH])
% %         xlim([-LENGTH,LENGTH]);ylim([0,2*LENGTH]);
%         title(t(i))
%         pause(1e-8)
% end
