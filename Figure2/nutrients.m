function [tt,lambda,xx] = nutrients(D,Kn,L0,T,s) 

% T=1800;
% L0=0.029; % max. growth (1/min), in uFlu mmachine with M63 media
% L0=0.015; % max. growth (1/min), in uFlu mmachine with M63 media

% this function simulates and plots the not-normalized system for standard parameters
% the only inputs are drug concentration (sudden exposure at t=0),
% nutritional capacity,
% desired simulation time, and
% proteome sector

% 225 uM tet = 100 ug/ml

ka=10; % enzyme michaelis constant (uM)
Ka=50; % enzyme Vmax (1/min)
Kd=0.001; % dissociation repressor drug (uM)
Ki=0.015; % drug import rate (1/min)

phic=0.48; % partition, universal
rho=0.76; % partition, universal
k0t=0.075; % max. translational capacity (1/min), for E. coli
k0n=Kn; % max. nutritional capacity (1/min), varies with media, fit to L0=0.029
Kr=1; % drug conc. for half-repression of growth (uM)
% c0=0.4; % nutrient conc. for half-repression of growth (au/um^2) - not use
% used

% g=0.4; % nutrient consumption, depends on cell area (au/um^2/min) - not used
% Dn=1200; % nutrient diffusion (um^2/min) - not used
% cell consumes nutrient at rate g*Ar*L/L0

A=0.008; % full expression of enzyme (uM/min)
R=0.0003; % full expression of repressor (uM/min)
ra=0.0001; % repressor for half-repression of enzyme (uM)
rr=0.000075; % repressor for half-repression of repressor (uM)
na=4; % enzyme Hill coefficient
nr=4; % repressor Hill coefficient

df=@(d,r) (d-r-Kd+sqrt((d-r-Kd).^2+4*Kd*d))/2;
rf=@(d,r) (r-d-Kd+sqrt((r-d-Kd).^2+4*Kd*r))/2;
HA=@(d,r) A*ra^na./(ra^na+rf(d,r).^na);
HR=@(d,r) R*rr^nr./(rr^nr+rf(d,r).^nr);

DD=@(t) D*heaviside(t);

Kt=@(d,r) k0t*Kr./(Kr+df(d,r));
% Kn=@(c) k0n*c./(c0+c); - not used

L=@(d,r) (phic/rho)*Kn*Kt(d,r)./(Kn+Kt(d,r)); 
if s==1
    f=@(d,r) (L(d,r)/L0).*(Kt(d,r)./(Kn+Kt(d,r)))/(k0t/(k0n+k0t)); % <-- for nutrient limitation
else
    f=@(d,r) (L(d,r)/L0); % <-- for modeling TetA and TetR as being in sector Q
end

function dx=equations(t,x)
    dx=zeros(3,1);
    dx(1)= f(x(3),x(1))*HR(x(3),x(1)) - L(x(3),x(1))*x(1);
    dx(2)= f(x(3),x(1))*HA(x(3),x(1)) - L(x(3),x(1))*x(2);
    dx(3)= Ki*(DD(t)-df(x(3),x(1))) - Ka*x(2)*df(x(3),x(1)) / (ka+df(x(3),x(1))) - L(x(3),x(1))*x(3);
end

fr=@(r) f(0,r)*HR(0,abs(r))-L0*abs(r);
r0=abs(fzero(fr,0));
fa=@(a) f(0,r0)*HA(0,r0)-L0*abs(a);
a0=abs(fzero(fa,0));

% opts = odeset('Events',@(t,x) events(t,x));
[tt,xx]=ode113(@(t,x) equations(t,x),[0 T],[r0,a0,0]); % add , opts to stop early

lambda = L(xx(:,3),xx(:,1));
end