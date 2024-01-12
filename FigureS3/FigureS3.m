%% Figure S3
% Simulate response for D=50

[tt,xx,lambda] = deterministic(1,50,1,600);
[tt1,xx1,lambda1] = deterministic(2,50,1,600);

% Define normalization parameters
L0=0.015; % max. growth (1/min), in uFlu mmachine with M63 media
R=0.0003; % full expression of repressor (uM/min)
A=0.008; % full expression of enzyme (uM/min)
Kr=1; % drug conc. for half-repression of growth (uM)

tt=tt/60;
tt1=tt1/60;

%Plot response
figure
plot(tt1,xx1(:,1)*L0/R,'-g','LineWidth',3)
hold on
plot(tt1,xx1(:,2)*L0/A,'-r','LineWidth',3)
plot(tt1,xx1(:,3)/Kr,'-b','LineWidth',3)

plot(tt,xx(:,1)*L0/R,'--g','LineWidth',3)
plot(tt,xx(:,2)*L0/A,'--r','LineWidth',3)
plot(tt,xx(:,3)/Kr,'--b','LineWidth',3)

legend('TetR','TetA','Tetracycline')
legend('FontName','Ariel')
legend boxoff
xlabel('Time (h)','FontSize',32,'FontName','Ariel')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Ariel','fontsize',32)
xticks([0 2 4 6 8 10])
set(gca,'xticklabel',[0 2 4 6 8 10])
set(gca,'ytick',[])
set(gca,'yticklabel',[])