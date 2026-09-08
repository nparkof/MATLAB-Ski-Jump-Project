function [x,y,t,v]=trajectory(m,g,A,p,v0,d,y0,alpha,xf,dt)
i=1;
vx=zeros(1,1e6); %preallocation
vy=zeros(1,1e6); %preallocation
vx(i)=v0*cosd(y0); % initial x velocity
vy(i)=v0*sind(y0); % initial y velocity
v(i)=sqrt(vx(i)^2+vy(i)^2); % magnitude of velocity
CD=0.0103*alpha; % drag coefficient
CL=-0.00025*alpha^2+0.0228*alpha-0.092; %lift coefficient
D(i)= (1/2)*p*A*CD*v(i)^2; % drag force  N
L(i)= (1/2)*p*A*CL*v(i)^2; % lift force  N

x=zeros(1,1e6);
y=zeros(1,1e6);% pre allocation makes code run quicker
t=zeros(1,1e6);

x(1)=0; % initial x distance
y(1)=d; % initial y distance
t(1)=0; % s, time vector

while x(i)<=xf % while current x is less than or equal to xf
    vx(i+1)=vx(i)+((-D(i)*(vx(i)/v(i))-L(i)*(vy(i)/v(i)))*dt)/m; % x velocity
    vy(i+1)=vy(i)+((-m*g-D(i)*(vy(i)/v(i))+L(i)*(vx(i)/v(i)))*dt)/m; % y velocity
    x(i+1)=x(i)+(vx(i))*dt; % x position
    y(i+1)=y(i)+(vy(i))*dt; % y position
    t(i+1)=t(i)+dt; % time vector
    v(i+1)=sqrt(vx(i+1)^2+vy(i+1)^2); % velocity magnitude
    D(i+1)= (1/2)*p*A*CD*v(i+1)^2; % drag
    L(i+1)= (1/2)*p*A*CL*v(i+1)^2; % lift
    i=i+1; % index
end

x=x(1:i);
y=y(1:i); % fixing vectors
t=t(1:i);

