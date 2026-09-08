%******************************************************************
%
% MiniProject2.m
%
% PROGRAM DESCRIPTION: This program takes info from a hill slope and a jump
% to find a test jump and the optimized jump.
%
% AUTHOR: Nick Park, 5/15/26
%
%******************************************************************
clc
clear variables
close all
%******************************************************************
% CONSTANTS
load("jumpDayHillProfile.mat");
m=70; %kg, ski jumper max
g=9.80665; %m/s^2
A=0.7; % m^2   ski jumper frontal area
p=1.17; % kg/m^3  air density
v0=27; % m/s   jump speed
d=0.59; % m    take-off jump height
y0=2; % y0 vector -5 to 5 degrees   initial jump angle
alpha=20; % alpha vector 13 to 33 degrees  angle of attack
anmax=1.835; % g's
xf= xL+30;    %xl+30;  m end point for simulation
dt=0.001; % s, delta t
lambda=0.4;% weighting constant
vmax=sqrt(g*anmax*R); % max velocity, m/s
%*********************************************************************
% Begin

% TEST JUMP SECTION: This section takes a test jump and gets the outputs.

[x,y,t,v]=trajectory(m,g,A,p,v0,d,y0,alpha,xf,dt); % trajectory 
[xland,yland,vland]=landingPoint(x,y,xHill,yHill,v); %landing point
anlanding=(vland^2)/(R*g); %landing centripetal acceleration in g's
p1=plot(x,y,"b:"); % plotting the trajectory
hold on
p2=plot(xHill,yHill,"k");% plotting the slope
p3=plot(xland,yland,"ro");% plotting the landing point
p4=plot(0,0,"rx","MarkerSize",10); %Take off point
xline(xL,"r--","L-Point")
xline(xP,"r--","P-Point")
xline(xK,"g--","K-Point")
legend([p1 p2 p3 p4],{"Trajectory","Hill Profile","Landing Point","Take-off Point"}) %This was found in the doc legend section


fprintf("Task 1: Test Jump\n");
fprintf("Landing x-location         = %8.4f m\n",xland);
fprintf("Landing y-location         = %8.4f m\n",yland);
fprintf("Landing velocity           = %8.4f m/s\n",vland);
fprintf("Centripetal Acceleration   = %5.1f g's\n\n",anlanding);








%**************************************************************************
% OPTIMIZED SECTION: This section takes all of the possible combinations
% for alpha and gamma and finds the best jump

y0=[-5:0.5:5]; % y0 vector -5 to 5 degrees   initial jump angle
alpha=[13:0.5:33]; % alpha vector 13 to 33 degrees  angle of attack

a=2; %counter for C
C(1)=0; % Initializing C

for i=1:length(alpha) % for angle of attack
    for k=1:length(y0) % for initial jump angle
        [x,y,t,v]=trajectory(m,g,A,p,v0,d,y0(k),alpha(i),xf,dt); % trajectory changes each round
        [xland,yland,vland]=landingPoint(x,y,xHill,yHill,v); %landing point
        if xland > xP && xland < xL && vland<=vmax  %falls between min and max x values
            safexland=xland; % one safe jump,x
            safeyland=yland; % one safe jump,y
            CTest=max(C);% CTest is the current maximum value of C; if the current C is greater, the xland and yland will be recorded
            C(a)=(lambda*((vmax-vland)/vmax))+((1-lambda)*((xland-xP)/xland)); % The highest C value is the best jump
            a=a+1;
            if C(a-1)>CTest % This finds the max C value
                maxxland=xland; % optimized x land
                maxyland=yland;% optimized y land
                maxx=x;% optimized x tracjectory
                maxy=y;% optimized y tracjectory
                maxy0=y0(k);% optimized y0
                maxalpha=alpha(i);% optimized alpha
                maxvland=vland; % optimized vland

            end
        end

    end
end

anlanding=(maxvland^2)/(R*g); %landing centripetal acceleration in g's

figure
p1=plot(maxx,maxy,"b:"); % plotting the trajectory
hold on
p2=plot(xHill,yHill,"k");% plotting the slope
p3=plot(maxxland,maxyland,"ro");% plotting the landing point
p4=plot(0,0,"rx","MarkerSize",10);
xline(xL,"r--","L-Point")
xline(xP,"r--","P-Point")
xline(xK,"g--","K-Point")
legend([p1 p2 p3 p4],{"Trajectory","Hill Profile","Landing Point","Take-off Point"}) %This was found in the doc legend section

fprintf("Task 2: Optimal Jump Search\n");
fprintf("Initial Path Angle      = %5.1f degrees\n",maxy0);
fprintf("Angle of Attack         = %5.1f degrees\n",maxalpha);
fprintf("Max Landing x-location  = %8.4f m\n",maxxland);
fprintf("Landing y-location      = %8.4f m\n\n",maxyland);

fprintf("Min Landing Velocity    = %8.4f m/s\n",maxvland);
fprintf("Centripetal Acceleration= %5.1f g's\n",anlanding);