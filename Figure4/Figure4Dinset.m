%% Figure 4D inset
D = linspace(0,200,201);
Kn = [0.0152, 0.02, 0.035];
t1 =1;
times = zeros(length(Kn),length(D));

for j=1:length(D)
    for i=1:length(Kn)
        [tt,lambda,xx] = nutrients(D(j),Kn(i),0.015,1800,1);
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

indices = [158,150,134];
for i=1:3
    times(i,indices(i):end) = Inf;
end

figure
for i=1:length(Kn)
    plot(D,smooth(times(i,:))/60,'LineWidth',3) 
    hold on
end
xline(125,'--k','LineWidth',3)
xlabel('Tc (\muM)','FontSize',32,'FontName','Ariel')
xlim([0 200])
ylim([0 22])
ylabel('Recovery (h)','FontSize',32,'FontName','Ariel')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Ariel','fontsize',32)
xticks([0 100 200])
xticklabels({'0', '100', '200'})
legend('0.0152','0.020','0.035')
legend('Location','northwest','FontName','Ariel')
legend box off
box off