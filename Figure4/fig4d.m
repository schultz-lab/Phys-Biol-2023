function fig4d()

    Kn = [0.0152, 0.02, 0.035];
    T =10000; 
    D=125;
    legsize = 40;
    filenames ="./data/rectimes_D_125_Nr_100_Kn_range";
    load(filenames, 'mean_rectime', 'lower_rectime','upper_rectime', 'probs')
    N=500;
    Kn2 = linspace(0.01, 0.035, N);
    for i=1:N
        [tt_det,~, L_det] = deterministic(D, T, Kn2(i));
        thres = mean([min(L_det), L_det(end)]);
        idx = find(L_det<=thres, 1, "last");
        t_rec_det2(i) = tt_det(idx)/60;
    end
         
    mksize = 1500; 
    figure
    set(gcf, 'Color', 'w')
    colormap copper 
    cmap = colormap;
    scatter(Kn, mean_rectime, mksize, cmap(round((1-probs)*length(cmap)), :), 'filled')
    hcb = colorbar;
    colorTitleHandle = get(hcb,'Title');
    titleString = 'Probability of Survival';
    set(colorTitleHandle ,'String',titleString);
    hold on 
    plot(Kn2, smooth(t_rec_det2, 10), 'b', 'LineWidth', 4)
    hold on 
    
    hold on
    scatter(Kn, lower_rectime, 2*mksize, '_k')
    hold on     
    scatter(Kn, upper_rectime, 2*mksize, '_k')
    hold on 
    
    
    hold on
    line([Kn(1), Kn(1)], [lower_rectime(1), upper_rectime(1)], 'linewidth', 2, 'Color', 'k')
    
    hold on
    line([Kn(2), Kn(2)], [lower_rectime(2), upper_rectime(2)], 'linewidth', 2, 'Color', 'k')
    
    hold on
    line([Kn(3), Kn(3)], [lower_rectime(3), upper_rectime(3)], 'linewidth', 2, 'Color', 'k')
    [lgd, hobj, ~,~] =legend('Stochastic', 'Deterministic');
    set(lgd, 'box', 'off');
    hl = findobj(hobj,'type','line');
    set(hl,'LineWidth',4);
    ht = findobj(hobj,'type','text');
    set(ht,'FontSize',40);
    hp = findobj(hobj,'type','patch');
    set(hp,'MarkerSize',40);
    
    xlim([0, 0.035])
    xlabel('Nutritional capacity')
    ylabel('Recovery time (hours)')
    ax = gca; 
    ax.FontSize = legsize; 
    
          
    
end
