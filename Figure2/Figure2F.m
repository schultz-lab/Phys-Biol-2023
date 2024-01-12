%% Figure 2F
D = linspace(0.000001,500,201);
% Define nutritional capacities
Kn = linspace(0.000001,0.1196,50);

Lfixs = zeros(length(D),length(Kn));
drug = zeros(length(D),length(Kn));

for i=1:length(D)
    for j=1:length(Kn)
        [Dfix, Afix, Rfix, Lfix]=threshold(D(i),Kn(j));
        if length(Lfix)==1
            Lfixs(i,j) = Lfix;
        else
            Lfixs(i,j) = Lfix(end);
            drug(i,j) = D(i);
        end
    end
end

indices = zeros(1,length(Kn));
Ds = zeros(1,length(Kn));
for i=4:length(Kn)
    indices(i) = find(drug(:,i),1,"first");
    Ds(i) = drug(indices(i),i);
end

Ds(3) = 220;
Ds(2) = 300;

figure
plot(Kn(2:end),Ds(2:end),'LineWidth',3)
ylim([0 200])
xlabel("Nutritional capacity",'FontSize',32,'FontName','Ariel')
ylabel({'Threshold tetracycline';'D_{thr} (\muM)'},'FontSize',32,'FontName','Ariel')

xticks([0 0.0464 0.1196])
xticklabels({'0','0.0464', '0.1196'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Ariel','fontsize',32)
a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'FontName','Ariel','fontsize',32)
yticks([0 100 200])
box off
