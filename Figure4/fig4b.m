function fig4b()
    total = 1000; 
    mksize = 1500;
    legsize = 40;
    Nr =100; 
    DD = [100, 138.8, 157.5, 175];
    Kn = 0.035;
    colors = [[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]; [0.9290 0.6940 0.1250]; [0.4940 0.1840 0.5560]]; 
    figure
    set(gcf,'Color','w');
    hold on 
    for i=1:length(DD)
        filenames ="./data/rectimes_D_"+num2str(DD(i))+"_Nr_"+num2str(Nr)+"_Kn_"+num2str(Kn);
        load(filenames, 'rec'); 
        frac(i) = length(rec)/total; 
        scatter(DD(i), frac(i), mksize, colors(i, :),'filled')

    end
   
    xlabel('Drug \muM')
    ylabel('Probability of Survival')
    ylim([0,1])
    xlim([80, 200])
    
    ax = gca; 

    for i=1:length(DD)-1
       line([DD(i), DD(i+1)], [frac(i), frac(i+1)], 'Color', 'k')
    end 

    line([138.8, 138.8], [0, 1], 'Color',colors(2,:),'LineStyle','--', 'LineWidth', 5)
    hold off
    ax.FontSize = legsize; 

    [lgd, hobj, ~,~] =legend({'100 \muM', '138.8 \muM', '157.5 \muM' , '175 \muM'});
    title(lgd,"Exposure:")
    lgd.Title.Visible = 'on';
    set(lgd, 'box', 'off');
    ht = findobj(hobj,'type','text');
    set(ht,'FontSize',40);
    hp = findobj(hobj,'type','patch');
    set(hp,'MarkerSize',20);
    lgd.Title.NodeChildren.Position = [0.5 1.2 0];

end