function fig3_afk()
    D =100;%extracellular drug amount, in uM 
    Nr=[100, 100, 1000]; % ribosome pool size 
    Kn = 0.035; %nutritional capacity
    spec = ["full", "", ""]; %choice of type of simulation "": reduced model; "full": full model
    titles = ["Full model, 100 ribosomes" "Reduced model, 100 ribosomes" "Reduced model, 1000 ribosomes", ""]; %titles
    T=10000; %simulated time

    for id=1:3
        if spec(id) =="full"
            filenames ="./data/complete_full_D_"+num2str(D)+"_Nr_"+num2str(Nr(id))+"_Kn_"+num2str(Kn);
        else 
            filenames ="./data/complete_D_"+num2str(D)+"_Nr_"+num2str(Nr(id))+"_Kn_"+num2str(Kn);
        end
        [tt_det, ~, L_det] = deterministic(D, T, Kn);
                     
        figure
        Nreps = 0;
        set(gcf,'Color','w');
        load(filenames, 'complete_tt', 'complete_LL'); 
        for i = 1:length(complete_tt)
            plot(complete_tt{i}/60, complete_LL{i}*60, 'Color',[0.75,0.75,0.75] )
            hold on 
            Nreps = Nreps+1;
        end 
        hold on
        plot(tt_det/60, L_det*60,'--k', 'LineWidth',2)
        
        %drug start line
        line([0,0], [0, 2], 'Color', 'k', 'LineWidth',4, 'LineStyle', '--')
        %set which x/y ticks we want 
        xticks([-15, 0, 15, 30, 45])
        yticks([0, 0.6, 1.2, 1.8])
        ax =gca;
        xlim([-1000,3000]/60)
        xlabel('Time (hours)');
        ylabel('Growth (hours^{-1})');
        title(titles(id))
        ax.FontSize = 40; 
        ax.Title.FontSize = 40;
    end
end