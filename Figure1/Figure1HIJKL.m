%% Figure 1H-J
% Define drug concentrations
D = [100 125 150];%[75 100 125];
titles = {'Drug = 100\muM','Drug = 125\muM','Drug = 150\muM'};

%Plot response over time for each drug concentration
for i = 1:length(D)
    figure
    [tt,xx,lambda] = deterministic(1,D(i),1,1800);
    plot(tt/60,lambda*60,'-k','LineWidth',3)
    hold on
    plot(tt/60,xx(:,2),'-r','LineWidth',3)
    plot(tt/60,xx(:,1),'-g','LineWidth',3)
    xlabel('Time (hours)','FontSize',32,'FontName','Ariel')
    legend('Growth','TetA','TetR','FontName','Ariel')
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Ariel','fontsize',32)
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    legend boxoff
    box off
    xticks([0 10 20 30])
    xticklabels({'0','10', '20', '30'})
end

%% Figure 1K
% Define drug concentrations
D = linspace(0,200,201);

t1 =1;
times = zeros(1,length(D));

for i=1:length(D)
    [tt,xx,lambda] = deterministic(1,D(i),1,1800);
    av = (lambda(end)+min(lambda))/2;
    if lambda(end)~= min(lambda) 
        t2 = find(lambda<av,1,'last');
        if ~isempty(t2)
            t = tt(t2) - tt(t1);
        else
            t = Inf;
        end            
    else
        t = Inf;         
    end    
    times(i) = t;   
end

slope = diff(times);
% Find max slope and the index where it occurs
ind = find(slope==max(slope(~isinf(slope(1:133)))));
% Set all values afterwards to Inf
times(ind:end) = Inf;

% Plot recovery time as a function of drug
figure
plot(D,times/60,'-k','LineWidth',3)
xlabel('Tetracycline (\muM)','FontSize',32,'FontName','Ariel')
xlim([10 200])
ylim([0 max(times/60)])
box off
ylabel('Recovery time (hours)','FontSize',32,'FontName','Ariel')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Ariel','fontsize',32)
xticks([0 50 100 150 200])
xticklabels({'0', '50', '100', '150', '200'})

%% Figure 1L
growth_end = [];

% Simulate response for each drug concentration
for i=1:length(D)
    [tt,xx,lambda] = deterministic(1,D(i),1,1800);
    growth_end = [growth_end lambda(end)];
end

% Plot end growth against drug concentration
figure
plot(D,(growth_end*60)/log(2),'-k','LineWidth',3)
xlabel('Tetracycline (\muM)','FontSize',32,'FontName','Ariel')
ylabel('Growth (doub./h)','FontSize',32,'FontName','Ariel')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Ariel','fontsize',32)
xticks([0 100 200])
xticklabels({'0','100', '200'})
box off