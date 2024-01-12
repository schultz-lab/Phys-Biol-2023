%% Figure 1C
load 'Data/mother_machine_data.mat'

ii=find(mean(data(5,:,60:90),3)>0.5);
t=0:10:900;
t0=180;
t=t-t0;

n=1;
gg=0;
for i=1:40
    g=squeeze(data(5,i,:));
    if sum(i==ii)
        gg=((n-1)*gg+g)/n;
        n=n+1;
    end
end

figure
L0=mean(gg(5:15));
dr=@(x) L0./x-1;
n=1;
dd=0;
rr=0;
aa=0;
for i=ii
    d=smooth(dr(squeeze(data(5,i,:))),3);
    dd=((n-1)*dd+d)/n;
    r=smooth(squeeze(data(2,i,:)./data(1,i,:)),3);
    rr=((n-1)*rr+r)/n;
    a=smooth(squeeze(data(3,i,:)./data(1,i,:)),3);
    aa=((n-1)*aa+a)/n;
    hold on
    plot(t/60,smooth(d)/0.8,'Color',[0.9 0.9 1],'LineWidth',1)
    plot(t/60,r/3,'Color',[0.8 0.9 0.8],'LineWidth',1)
    plot(t/60,a/2,'Color',[1 0.8 0.8],'LineWidth',1)
    n=n+1;
end
plot(t/60,dd,'Color',[0 0 1],'LineWidth',3)
plot(t/60,rr/3,'Color',[0 0.7 0],'LineWidth',3)
plot(t/60,aa/2,'Color',[1 0 0],'LineWidth',3)
plot([0 0],[0 2.2],'--k','LineWidth',3)
axis([-100/60 600/60 0 2.2])
set(gca,'FontName','Ariel','FontSize',32)
xlabel('Time (hours)','FontName','Ariel','FontSize',32)
ylabel('Concentration (norm.)','FontName','Ariel','FontSize',32)

%% Figure 1D
[tt,xx,lambda] = deterministic(1,70,1,600);
figure
plot(tt/60,xx(:,3)/3,'-b','LineWidth',3)
hold on
plot(tt/60,2.5*xx(:,2),'-r','LineWidth',3)
plot(tt/60,38*xx(:,1),'-g','LineWidth',3)
plot([0 0],[0 2.2],'--k','LineWidth',3)
axis([-100/60 600/60 0 2.2])
%yticks([0 0.5 1 1.5])
%xticks([0 5 10])
set(gca,'FontName','Ariel','FontSize',32)
xlabel('Time (hours)','FontName','Ariel','FontSize',32)
ylabel('Concentration (norm.)','FontName','Ariel','FontSize',32)
legend('Tetracycline','TetA','TetR')
legend box off
box off

%% Figure 1F
% Extract tetA at the end of the experiment to use in defining survival categories
tetA_end = data(3,:,91)./data(1,:,91);
growth = squeeze(data(5,:,2:end));
% Ensure all growth is non-negative
growth(growth<0)=0;

% Define survival categories
arrested = find(data(5,:,91)<=0.5 & tetA_end(1,:)<2); % low growth at the end and little tetA
recovered = find(data(5,:,91)>0.5); % high growth at the end
moribund = [];
for i=1:40
    for j=1:90
        if growth(i,j)<0.5
            moribund = [moribund i];
        end
    end
end
moribund = unique(moribund);
moribund=setdiff(moribund,arrested);
recovered=setdiff(recovered,moribund);

growth = growth.*log(2);

figure
n=1;
ggr=0;

for i=recovered
    g=squeeze(data(5,i,:));
        ggr=((n-1)*ggr+g)/n;
        n=n+1;
    hold on
    plot(t/60,g,'Color',[0.95, 0.95, 0.8],'LineWidth',1)
end

n=1;
nm=1;
ggm1=0;
ggm2=0;

for i=moribund
    g=squeeze(data(5,i,:));
    if sum(i==ii)
        ggm1=((n-1)*ggm1+g)/n;
        n=n+1;
    else
       ggm2=((nm-1)*ggm2+g)/nm;
       nm=nm+1;
    end
    hold on
    plot(t/60,g,'Color',[1 0.8 0.8],'LineWidth',1)
end


n=1;
gga=0;

for i=arrested
    g=squeeze(data(5,i,:));
        gga=((n-1)*gga+g)/n;
        n=n+1;
    hold on
    plot(t/60,g,'Color',[0.75 0.75 0.75],'LineWidth',1)
end

plot(t/60,ggr,'Color',[0.75, 0.75, 0],'LineWidth',3)
plot(t/60,ggm1,'Color','r','LineWidth',3)
plot(t/60,ggm2,'Color','r','LineWidth',3)
plot(t/60,gga,'Color','k','LineWidth',3)
plot([0 0],[0 2],'--k','LineWidth',3)
axis([-100/60 600/60 0 1.6])
yticks([0 0.5 1 1.5])
set(gca,'FontName','Ariel','FontSize',32)
xlabel('Time (hours)','FontName','Ariel','FontSize',32)
ylabel('Growth (doub./h)','FontName','Ariel','FontSize',32)

%% Figure 1G
% Define parameters
T=750;
Kr=[1,0.4,0.2,0.1];
L0=0.015;
D=50;

% Simulate responses
[tt_r,xx_r,lambda_r] = deterministic(1,D,Kr(1),T); % recovered
[tt_m1,xx_m1,lambda_m1] = deterministic(1,D,Kr(2),T); % moribund
[tt_m2,xx_m2,lambda_m2] = deterministic(1,D,Kr(3),T); % moribund
[tt_a,xx_a,lambda_a] = deterministic(1,D,Kr(4),T); % arrested

figure
hold on
plot(tt_r/60,(lambda_r*60)/log(2),'Color',[0.75, 0.75, 0],'LineWidth',3,'DisplayName', 'Recovered')
plot(tt_m1/60,(lambda_m1*60)/log(2),'-r','LineWidth',3,'DisplayName', 'Moribund')
plot(tt_m2/60,(lambda_m2*60)/log(2),'-r','LineWidth',3,'DisplayName', 'moribund2')
plot(tt_a/60,(lambda_a*60)/log(2),'-k','LineWidth',3,'DisplayName', 'Arrested')
line([t(1) t(19)],[(L0*60)/log(2)+0.01,(L0*60)/log(2)+0.01],'Color',[0.75, 0.75, 0],'LineWidth',3)
line([t(1) t(19)],[(L0*60)/log(2)-0.01,(L0*60)/log(2)-0.01],'Color','red','LineWidth',3)
line([t(1) t(19)],[(L0*60)/log(2),(L0*60)/log(2)],'Color','black','LineWidth',3)
plot([0 0],[0 2],'--k','LineWidth',3)
axis([-100/60 600/60 0 1.6])
yticks([0 0.5 1 1.5])
set(gca,'FontName','Ariel','FontSize',32)
xlabel('Time (hours)','FontName','Ariel','FontSize',32)
ylabel('Growth (doub./h)','FontName','Ariel','FontSize',32)
legend('show')
set(findobj(gcf, 'DisplayName', 'moribund2'), 'HandleVisibility', 'off');
legend({'Recovered', 'Moribund', 'Arrested'})
legend box off