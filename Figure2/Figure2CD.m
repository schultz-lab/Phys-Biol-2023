%% Figure 2C
ka=10; % enzyme michaelis constant (uM)
Ka=50; % enzyme Vmax (1/min)
Kd=0.001; % dissociation repressor drug (uM)
Ki=0.015; % drug import rate (1/min)

phic=0.48; % partition, universal
rho=0.76; % partition, universal
k0t=0.075; % max. translational capacity (1/min), for E. coli
k0n=0.1196; % max. nutritional capacity (1/min), varies with media, fit to L0=0.029
L0=0.029; % max. growth (1/min), in uFlu mmachine with M63 media

A=0.008; % full expression of enzyme (uM/min)
R=0.0003; % full expression of repressor (uM/min)
ra=0.0001; % repressor for half-repression of enzyme (uM) 0.0001
rr=0.000075; % repressor for half-repression of repressor (uM) 0.000075
na=4; % enzyme Hill coefficient
nr=4; % repressor Hill coefficient

HA=@(r) A*ra^na./(ra^na+r.^na);
HR=@(r) R*rr^nr./(rr^nr+r.^nr);

LL=@(kn) (phic/rho)*(k0t*kn)/(k0t+kn);
L0=LL(k0n);

f=@(kn) (LL(kn)/L0).*(k0t./(kn+k0t))/(k0t/(k0n+k0t));
        
fr=@(r,kn) f(kn)*HR(abs(r))-LL(kn)*abs(r);
fa=@(a,r,kn) f(kn)*HA(r)-LL(kn)*abs(a);
a=zeros(1,100);
r=zeros(1,100);
L=zeros(1,100);

for i=1:100   
    kn=0.12*i/100;
    r0=abs(fzero(@(r) fr(r,kn),0));
    a0=abs(fzero(@(a) fa(a,r0,kn),0));
    Kn(i)=kn;
    r(i)=r0;
    a(i)=a0;
    L(i)=LL(kn);
end

figure
hold on
plot((L*60)/log(2),a./max(a),'-r','LineWidth',3)
plot((L*60)/log(2),r./max(r),'-g','LineWidth',3)
ylim([0 1.2])
yticks([0 0.5 1])
yticklabels({'0', '0.5', '1'})
fs=32;
ax = gca;
ax.FontSize = fs;
legend('TetA','TetR','FontSize',fs,'FontName','Ariel','Location','southwest')
legend box off
xlabel('Growth (doub./h)','FontSize',fs,'FontName','Ariel')
ylabel('Expression (norm.)','FontSize',fs,'FontName','Ariel'); 
box off

%% Figure 2D
load 'Data/microcolony_growth_data.mat'
load 'Data/microcolony_tetA_data.mat'
load 'Data/microcolony_tetR_data.mat'

% Growth
data = abs(grow_all(91:494,:)); 
growth = ((data.*0.001)./1.79).*3600;
data = growth./log(2);
myGrowthMatrix = data.';

myGrowthMatrix = myGrowthMatrix(:,1:104);
av_growth = mean(myGrowthMatrix,2); % mean of each row/at each depth

% TetA
data = xy16c3;
myMatrix = zeros(809,404); 
j=1;

for i=91:494 
    timepoint = data{i};
    trap = timepoint(1,:);
    myMatrix(:,j) = trap';
    j = j+1;
end

myMatrix = myMatrix(:,1:104);
av_tetA = mean(myMatrix,2);
sd_tetA = std(myMatrix,[],2);
y_tetA = linspace(0,170,809);

y = linspace(0,170,95);

indices = zeros(1,95);
for i=1:95
    x = y(i);
    l = find(y_tetA<=x,1,'last');
    u = find(y_tetA>=x,1);
    if min(x-y_tetA(l),y_tetA(u)-x)==x-y_tetA(l)
        indices(i) = l;
    elseif min(x-y_tetA(l),y_tetA(u)-x)==y_tetA(u)-x
        indices(i) = u; 
    end
end

tetA = av_tetA(indices);
err_tetA = sd_tetA(indices);
a_norm = max(tetA(29:93));

g = av_growth(29:93);
a = tetA(29:93)./a_norm;
err = err_tetA(29:93)./a_norm;

% TetR
data = xy16c2;
myMatrix = zeros(809,404); 
j=1;
for i=91:494 
    timepoint = data{i};
    trap = timepoint(1,:);
    myMatrix(:,j) = trap';
    j = j+1;
end

myMatrix = myMatrix(:,1:104);
av_tetR = mean(myMatrix,2);
sd_tetR = std(myMatrix,[],2);
y_tetR = linspace(0,170,809);

y = linspace(0,170,95);
indices = zeros(1,95);
for i=1:95
    x = y(i);
    l = find(y_tetR<=x,1,'last');
    u = find(y_tetR>=x,1);
    if min(x-y_tetR(l),y_tetR(u)-x)==x-y_tetR(l)
        indices(i) = l;
    elseif min(x-y_tetR(l),y_tetR(u)-x)==y_tetR(u)-x
        indices(i) = u; 
    end
end

tetR = av_tetR(indices);
err_tetR = sd_tetR(indices);

r_norm = max(tetR(29:93));
r = tetR(29:93)./r_norm;
err_R = err_tetR(29:93)./r_norm;

figure
H= shadedErrorBar(g(1:32),a(1:32),err(1:32),'lineprops', '-r');
H.mainLine.LineWidth = 2;
hold on
H=shadedErrorBar(g(1:32),r(1:32),err_R(1:32),'lineprops', '-g');
H.mainLine.LineWidth = 2;
fs=32;
ax = gca;
ax.FontSize = fs;
ylim([0 1.2])
yticks([0 0.5 1])
yticklabels({'0', '0.5', '1'})
xlabel('Growth (doub./h)','FontSize',fs,'FontName','Ariel'); 
ylabel('Expression (norm.)','FontSize',fs,'FontName','Ariel'); 
legend('TetA','TetR','Location','southwest','FontName','Ariel');
legend box off
box off