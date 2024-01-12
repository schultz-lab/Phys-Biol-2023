function fig3_bgl()
    D =100;%extracellular drug amount, in uM 
    Nr=[100, 100, 1000]; % ribosome pool size 
    Kn = 0.035; %nutritional capacity
    spec = ["full", "", ""]; %choice of type of simulaiton "": reduced model; "full": full model
    titles = ["Full model, 100 ribosomes" "Reduced model, 100 ribosomes" "Reduced model, 1000 ribosomes", ]; %titles
    Nrmin = 0.13*Nr; 
    T=10000; %simulated time
    k0n=0.035; % max. nutritional capacity (1/min), varies with media, fit to L0=0.015
    ka=10000; % enzyme michaelis constant (nM)
    Ka=50; % enzyme Vmax (1/min)
    Kd=1; % dissociation repressor drug (nM)
    Ki=0.015; % drug import rate (1/min)
    
    phic=0.48; % partition, universal
    phirmax=0.55; % partition, universal
    phizero=0.07; % partition, universal
    rho=0.76; % partition, universal
    k0t=0.075; % max. translational capacity (1/min), for E. coli
    L0=0.015; % max. growth (1/min), in uFlu mmachine with M63 media
    Kr=1000; % drug conc. for half-repression of growth (nM)
    
    A=8; % full expression of enzyme (nM/min), Philip: 0.008, Mina: 0.05
    R=0.3; % full expression of repressor (nM/min), Philip: 0.0003, Mina: 0.005
    ra=0.1; % repressor for half-repression of enzyme (nM)
    rr=0.075; % repressor for half-repression of repressor (nM)
    na=5; % enzyme Hill coefficient
    nr=3; % repressor Hill coefficient
    rt=0.15; % ra/sqrt((sqrt(2)-1))
    nn=2;
    N = 10; %Number of trajectories
       
    for id=1:3
        if spec(id) =="full"
            filenames ="./data/complete_full_D_"+num2str(D)+"_Nr_"+num2str(Nr(id))+"_Kn_"+num2str(Kn);
        else 
            filenames ="./data/complete_D_"+num2str(D)+"_Nr_"+num2str(Nr(id))+"_Kn_"+num2str(Kn);
        end
        [tt_det, xx_det, ~] = deterministic(D, T, Kn);
        
        %go through all trajectories, save them and get maxima
        
        load(filenames, 'complete_tt', 'complete_xx'); 
        tt_stoch = zeros(N, length(complete_tt{1}));
        dd_stoch = zeros(N, length(complete_xx{1}(:,1)));
        rr_stoch = zeros(N, length(complete_xx{1}(:,2)));
        aa_stoch = zeros(N, length(complete_xx{1}(:,3)));

        for i = 1:N
            tt_stoch(i, :) = complete_tt{i};
            dd_stoch(i, :) = complete_xx{i}(:,1);

            %the full model records bound and free quantities separately.
            %we want the total amount. 
            if spec(id) == "full" 
                rr_stoch(i, :) = complete_xx{i}(:, 2)+complete_xx{i}(:, 10);
                aa_stoch(i, :) = complete_xx{i}(:, 3)+complete_xx{i}(:, 11); 
            else
                rr_stoch(i, :) = complete_xx{i}(:,2);    
                aa_stoch(i, :) = complete_xx{i}(:,3);
        
            end
         
        end 
        
        %normalize
        % the deterministic model gives results in uM. We want them in nM. 
        maximum_d = max([max(1000*xx_det(:,3)), max(dd_stoch)]); 
        maximum_r = max([max(1000*xx_det(:,1)), max(rr_stoch)]); 
        maximum_a = max([max(1000*xx_det(:,2)), max(aa_stoch)]);
        
        
        figure
        set(gcf,'Color','w');
        
        for i = 1:N
            hold on 
            plot(tt_stoch(i,:)/60, dd_stoch(i, :)/maximum_d, 'b',  'Color',[0, 0, 1, 0.2])
            hold on 
            plot(tt_stoch(i,:)/60, rr_stoch(i, :)/maximum_r, 'g',  'Color',[0, 1, 0, 0.2])
            hold on 
            plot(tt_stoch(i,:)/60, aa_stoch(i, :)/maximum_a, 'r', 'Color',[1, 0, 0, 0.2])
            hold on
         
        end 
        %drug
        plot(tt_det/60, 1000*xx_det(:,3)/maximum_d, '--b', 'LineWidth',4)%
        hold on 
        
        %repressor
        plot(tt_det/60, 1000*xx_det(:,1)/maximum_r,'--g', 'LineWidth',4) % 
        hold on
        
        %pump
        plot(tt_det/60, 1000*xx_det(:,2)/maximum_a, '--r', 'LineWidth',4)%
        hold on
        
        %drug start line
        line([0,0], [0, 1], 'Color', 'k', 'LineWidth',4, 'LineStyle', '--')
        %set which x/y ticks we want 
        xticks([-15, 0, 15, 30, 45])
        
        xlabel('Time (hours)');
        ylabel('Concentrations');
        [lgd, hobj, ~,~] = legend('Tc', 'TetR', 'TetA', 'Location', 'northwest');
        set(lgd, 'box', 'off');
        hl = findobj(hobj,'type','line');
        set(hl,'LineWidth',5);
        ht = findobj(hobj,'type','text');
        set(ht,'FontSize',60);
        lgd.ItemTokenSize(1) = 5;
        xlim([-1000, 3000]/60)
        title(titles(id))
        ax =gca;
        ax.FontSize = 50; 
    end 
end
