function [Dfix, Afix, Rfix, Lfix]=threshold(D,Kn) 

ka=10; % enzyme michaelis constant (uM)
Ka=50; % enzyme Vmax (1/min)
Kd=0.001; % dissociation repressor drug (uM)
Ki=0.015; % drug import rate (1/min)

phic=0.48; % partition, universal
rho=0.76; % partition, universal
k0t=0.075; % max. translational capacity (1/min), for E. coli
k0n=Kn;%0.1196; % max. nutritional capacity (1/min), varies with media, fit to L0=0.029
L0=0.029; % max. growth (1/min), in uFlu mmachine with M63 media
Kr=1; % drug conc. for half-repression of growth (uM)

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

Kt=@(d,r) k0t*Kr./(Kr+df(d,r));

L=@(d,r) (phic/rho)*Kn*Kt(d,r)./(Kn+Kt(d,r)); 
f=@(d,r) (L(d,r)/L0).*(Kt(d,r)./(Kn+Kt(d,r)))/(k0t/(k0n+k0t));

FR=@(d,r) f(d,r)*HR(d,r)-L(d,r)*r;

function r=rfix(d)
    FFR=@(r) FR(d,r);
    r=fzero(FFR,[0 1000]);
end

function x=afix(d)
    rx=rfix(d);
    x=(f(d,rx)/L(d,rx))*HA(d,rx);
end

function x=FD(d)
    rx=rfix(d);
    dfx=df(d,rx);
    x=Ki*(D-dfx) - Ka*afix(d)*dfx / (ka+dfx) - L(d,rx)*d;
end

dfix1=fzero(@FD,D);
dfix2=fzero(@FD,0);
if dfix1>dfix2+0.2
    dfix3=fzero(@FD,[dfix2+0.1 dfix1-0.1]);
    Dfix=[dfix2 dfix3 dfix1];
    Afix=[afix(dfix2) afix(dfix3) afix(dfix1)];
    Rfix=[rfix(dfix2) rfix(dfix3) rfix(dfix1)];
    Lfix=L(Dfix,Rfix);
else
    Dfix=dfix1;
    Afix=afix(dfix1);
    Rfix=rfix(dfix1);
    Lfix=L(Dfix,Rfix);
end

end