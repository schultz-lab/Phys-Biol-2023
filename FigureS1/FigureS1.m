%% Figure S1
% Define drug concentrations
D=linspace(0,600,301);
% Define nutrient concentrations 
Kn=linspace(0,0.1196,50);

end_growth = zeros(length(D),length(Kn));

for i=1:length(D)
    for j=1:length(Kn)
        [tt,lambda,xx] = nutrients(D(i),Kn(j),0.029,1800,2);
        end_growth(i,j) = lambda(end);
    end
end

end_growth = end_growth*60;

% Plot end growth for all nutritional capacities and drug concentrations
figure
h=heatmap(end_growth/log(2),'XLabel','Nutritional capacity','YLabel','Tetracycline (\muM)','FontSize',32,'FontName','Ariel','ColorScaling','scaled');
h.NodeChildren(3).YDir='normal';
grid off

annotation('textarrow',[0.965 0.965],[0.55,0.55],'string','Growth (doub./h)', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',90,'FontSize',32,'FontName','Ariel');

% Adjust y axis
YLabels = D;
CustomYLabels = string(YLabels);
CustomYLabels(:) = " ";
CustomYLabels(1) = "0";
CustomYLabels(51) = "100";
CustomYLabels(101) = "200";
CustomYLabels(151) = "300";
CustomYLabels(201) = "400";
CustomYLabels(251) = "500";
CustomYLabels(301) = "600";
h.YDisplayLabels = CustomYLabels;

% Adjust x axis
XLabels = Kn;
CustomXLabels = string(XLabels);
CustomXLabels(:) = " ";
CustomXLabels(10) = "0.0220";
CustomXLabels(20) = "0.0464";
CustomXLabels(30) = "0.0708";
CustomXLabels(40) = "0.0952";
CustomXLabels(50) = "0.1196";
h.XDisplayLabels = CustomXLabels;
hAx=h.NodeChildren(3);
hAx.XAxis.TickLabelRotation=0;