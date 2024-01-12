function fig4c_inset()
    colors = [[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]; [0.9290 0.6940 0.1250]; [0.4940 0.1840 0.5560]; [1 0 0]]; 
    D = 125; 
    Kn = 0.035;
    Nr=100;
    legsize = 80;

    filenames ="./data/survival_D_"+num2str(D)+"_Nr_"+num2str(Nr)+"_Kn_"+num2str(Kn);

    load(filenames, 'frac')
    figure
    set(gcf,'Color','w');
    
    handleToThisBarSeries1 = bar(1, frac,'BarWidth', 0.9);
    set(handleToThisBarSeries1, 'FaceColor', 'k');	
    hold on 
    
    handleToThisBarSeries2 =  bar(2, 1-frac,'BarWidth', 0.9);
    set(handleToThisBarSeries2, 'FaceColor', colors(1,:), 'FaceAlpha', 0.5, 'FaceColor', 'r');	
    xticklabels(["Arrest" "Survival"])
    xticks([1,2]);
    xtickangle(20);
    ylabel('Probability');
    ax = gca; 
    ax.FontSize = legsize; 
end