function fig3_chm()
    N =10; %number of trajectories
    D =100;%extracellular drug amount, in uM 
    Nr=[100, 100, 1000]; % ribosome pool size 
    Kn = 0.035; %nutritional capacity
    spec = ["full", "", ""]; %choice of type of simulaiton "": reduced model; "full": full model
    titles = ["Full model, 100 ribosomes" "Reduced model, 100 ribosomes" "Reduced model, 1000 ribosomes", ""]; %titles
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
       
    for id=1:3
        if spec(id) =="full"
            filenames ="./data/complete_full_D_"+num2str(D)+"_Nr_"+num2str(Nr(id))+"_Kn_"+num2str(Kn);
        else 
            filenames ="./data/complete_D_"+num2str(D)+"_Nr_"+num2str(Nr(id))+"_Kn_"+num2str(Kn);
        end
    
 
    figure
    set(gcf,'Color','w');    
    load(filenames, 'complete_tt', 'complete_xx'); 
    Nribof = zeros(1, length(complete_tt{1}));
    hold on
    for i = 1:N
        %In the full model, bound and free ribosomes are accounted for
        %separately. We are interested in free and total amounts. 
        if spec(id) == "full" 
            plot(complete_tt{i}/60,complete_xx{i}(:,8), 'Color',[255/255,114/255,118/255])
            hold on
            plot(complete_tt{i}/60, complete_xx{i}(:,9)+complete_xx{i}(:,8), 'Color','k' )
            hold on
        else
        % In the reduced model, we need to solve the adiabatic equation to
        % get the fb (fraction of free ribosome) to then solve for free
        % ribosome.
            for k =1:length(complete_tt{i})
                func=@(x) complete_xx{i}(k,1)-x*(1+complete_xx{i}(k,2)/(Kd+x)+complete_xx{i}(k,3)/(ka+x)+complete_xx{i}(k,8)/(Kr+x));
                df=round(fzero(func,[0 D*2000]));
                fb=Kr/(Kr+df);
                Nribof(k)=round(complete_xx{i}(k,8)*fb);

            end
            plot(complete_tt{i}/60, Nribof, 'Color',[255/255,114/255,118/255] )
            hold on
            plot(complete_tt{i}/60, complete_xx{i}(:,8), 'Color','k' )
            hold on
        end
    end 
    
    hold on
    xl = xlabel('Time (hours)');
    fontsize(xl,60,'points')
    yl = ylabel('Ribosomes'); 
    fontsize(yl,60,'points')
    hold on 
    xlim([-1000,3000]/60)
    ylim([0, Nr(id)])
    %drug start line
    %set which x/y ticks we want 
    xticks([-15, 0, 15, 30, 45])
    ax = gca;
    ax.FontSize = 60; 
    [lgd, hobj, ~,~] = legend('Free Ribosomes','Total Ribosomes', 'Location', 'north');
    set(lgd, 'box', 'off');
    hl = findobj(hobj,'type','line');
    set(hl,'LineWidth', 10);
    ht = findobj(hobj,'type','text');
    set(ht,'FontSize',60);
    if Nr(id) == 1000
        ax.YAxis.Exponent = 1;
    end
     title(titles(id))

    end 
end