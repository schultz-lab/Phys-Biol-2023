function [tt, xx, LL] = deterministic(D, T, Kn) % add C for nutrient limitation

h = 1;
% this function simulates and plots the not-normalized system for standard parameters
% the only inputs are drug concentration (sudden exposure at t=0)
% and concentration of limiting nutrient (the cell does not consume)

% 225 uM tet = 100 ug/ml

ka=10; % enzyme michaelis constant (uM)
Ka=50; % enzyme Vmax (1/min)
Kd=0.001; % dissociation repressor drug (uM)
Ki=0.015; % drug import rate (1/min)

phic=0.48; % partition, universal
rho=0.76; % partition, universal
k0t=0.075; % max. translational capacity (1/min), for E. coli
k0n=0.035; % max. nutritional capacity (1/min), varies with media, fit to L0=0.015
L0=0.015; % max. growth (1/min), in uFlu mmachine with M63 media
Kr=1; % drug conc. for half-repression of growth (uM)


A=0.008; % full expression of enzyme (uM/min), Philip: 0.008, Mina: 0.05
R=0.0003; % full expression of repressor (uM/min), Philip: 0.0003, Mina: 0.005
ra=0.0001; % repressor for half-repression of enzyme (uM)
rr=0.000075; % repressor for half-repression of repressor (uM)
na=4; %5;% enzyme Hill coefficient
nr=4;%3; % repressor Hill coefficient
rt=1.5e-4; % ra/sqrt((sqrt(2)-1))
n=2;

df=@(d,r) (d-r-Kd+sqrt((d-r-Kd).^2+4*Kd*d))/2;
rf=@(d,r) (r-d-Kd+sqrt((r-d-Kd).^2+4*Kd*r))/2;
if h==1
    HA=@(d,r) A*ra^na./(ra^na+rf(d,r).^na);
    HR=@(d,r) R*rr^nr./(rr^nr+rf(d,r).^nr);
else
    H=@(d,r) rt^n./(rt^n+rf(d,r).^n);
    HA=@(d,r) A*H(d,r).^2;
    HR=@(d,r) R*(0.5*H(d,r).^2+0.5*H(d,r));
end
DD=@(t) D*heaviside(t);
Kt=@(d,r) k0t*Kr./(Kr+df(d,r));

L=@(d,r) (phic/rho)*Kn*Kt(d,r)./(Kn+Kt(d,r)); 

f=@(d,r) (L(d,r)/L0).*(Kt(d,r)./(Kn+Kt(d,r)))/(k0t/(Kn+k0t)); 

g=@(d,r) (L(d,r)/L0).*(Kn/Kn).*(Kn+k0t)./(Kn+Kt(d,r)); 

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

[tt,xx]=ode113(@(t,x) equations(t,x),[-1000 T],[r0,a0,0]); % add , opts to stop early

LL = L(xx(:,3), xx(:,1));


end