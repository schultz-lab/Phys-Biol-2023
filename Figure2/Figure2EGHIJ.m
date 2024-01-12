%% Figure 2E
% Define drug concentrations
D=linspace(0,200,201);
% Define nutritional capacities
Kn=linspace(0,0.1196,50);

end_growth=zeros(length(D),length(Kn));

for i=1:length(D)
    for j=1:length(Kn)
        [tt,lambda,xx] = nutrients(D(i),Kn(j),0.029,1800,1);
        end_growth(i,j) = lambda(end);
    end
end

% Plot end growth for all nutritional capacities and drug concentrations
figure('Position', [0 0 1280 749])
ax1 = axes('Position',[0.11,0.153204272363151,0.775,0.811795727636849]);
h=heatmap((end_growth*60)/log(2),'XLabel','Nutritional capacity','YLabel','Tetracycline (\muM)','FontSize',40,'FontName','Ariel');
h.NodeChildren(3).YDir='normal';
grid off

annotation('textarrow',[0.97 0.97],[0.55,0.55],'string','Growth (doub./h)', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',90,'FontSize',40,'FontName','Ariel');
% Adjust y axis
YLabels = D;
CustomYLabels = string(YLabels);
CustomYLabels(:) = " ";
CustomYLabels(1) = "0";
CustomYLabels(101) = "100";
CustomYLabels(201) = "200";
h.YDisplayLabels = CustomYLabels;

% Adjust x axis
XLabels = Kn;
CustomXLabels = string(XLabels);
CustomXLabels(:) = " ";
CustomXLabels(1) = "0";
CustomXLabels(10) = "0.0220";
CustomXLabels(20) = "0.0464";
CustomXLabels(30) = "0.0708";
CustomXLabels(40) = "0.0952";
CustomXLabels(50) = "0.1196";
h.XDisplayLabels = CustomXLabels;
hAx=h.NodeChildren(3);
hAx.XAxis.TickLabelRotation=0;

%% Figure 2G
figure
for i=[10 15 20 25 50]
    plot((end_growth(:,i)*60)/log(2),'LineWidth',3)
    hold on
end

xlabel('Tetracycline (\muM)','FontSize',32,'FontName','Ariel')
ylabel('Growth (doub./h)','FontSize',32,'FontName','Ariel')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Ariel','fontsize',32)
legend('Kn=0.0220','Kn=0.0342','Kn=0.0464','Kn=0.0586','Kn=0.1196')
legend('FontName','Ariel')
legend boxoff
box off
xlim([0 200])
xticks([0 100 200 300])
xticklabels({'0', '100', '200', '300'})

%% Figure 2H-I
% Define select drug concentrations
D = [50 80]; 
drug = {'D = 50\muM',  'D = 100 \muM'};
% Define select nutrient concentrations
Kn = [Kn(10),Kn(15),Kn(20),Kn(25),Kn(50)];

for j=1:length(D)
    figure
    for i=1:length(Kn)
        [tt,lambda,xx] = nutrients(D(j),Kn(i),0.029,3000,1); 
        plot(tt/60,(lambda*60)/log(2),'LineWidth',3)
        hold on 
        xlabel('Time (hours)','FontSize',32,'FontName','Ariel')
        ylabel('Growth (doub./h)','FontSize',32,'FontName','Ariel')
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Ariel','fontsize',32)
        xticks([0 10 20 30 40 50])
        xticklabels({'0','10', '20', '30','40','50'})
        xlim([0 50])
        ylim([0 3])
    end
    legend('Kn=0.0220','Kn=0.0342','Kn=0.0464','Kn=0.0586','Kn=0.1196')
    legend('Location','northwest','FontName','Ariel')
    legend box off
    box off
end


%% Figure 2J
D = linspace(0,300,301);
t1 =1;
times = zeros(length(Kn),length(D));

for j=1:length(D)
    for i=1:length(Kn)
        [tt,lambda,xx] = nutrients(D(j),Kn(i),0.029,1800,1);
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
        times(i,j) = t;
     end
end

indices = [102,92,87,1,1];
for i=1:3
    times(i,indices(i):end) = Inf;
end

% Plot recovery times against drug concentration 
figure
for i=1:length(Kn)
    plot(D,smooth(times(i,:))/60,'LineWidth',3) 
    hold on
end

xlabel('Tetracycline (\muM)','FontSize',32,'FontName','Ariel')
xlim([0 200])
ylim([0 20.136])
ylabel('Recovery time (hours)','FontSize',32,'FontName','Ariel')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Ariel','fontsize',32)
xticks([0 100 200])
xticklabels({'0', '100', '200'})
legend('Kn=0.0220','Kn=0.0342','Kn=0.0464','Kn=0.0586','Kn=0.1196')
legend('Location','northeast','FontName','Ariel')
legend box off
box off