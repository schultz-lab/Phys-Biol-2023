function fig3_ejo()
   D =100;%extracellular drug amount, in uM 
   Nr=[100, 100, 1000]; % ribosome pool size 
   Kn = 0.035; %nutritional capacity
   spec = ["full", "", ""]; %choice of type of simulation "": reduced model; "full": full model
   titles = ["Full model, 100 ribosomes" "Reduced model, 100 ribosomes" "Reduced model, 1000 ribosomes"]; %titles
   legsize = 40; 
   for id=1:3
       if spec(id) =="full"
           filenames ="./data/rectimes_full_D_"+num2str(D)+"_Nr_"+num2str(Nr(id))+"_Kn_"+num2str(Kn);
       else 
           filenames ="./data/rectimes_D_"+num2str(D)+"_Nr_"+num2str(Nr(id))+"_Kn_"+num2str(Kn);
       end                     
       load(filenames, 'rec'); 
       figure
       edges = linspace(100/60, 700/60, 50);
       histogram(rec/60, edges)
        
       %set which x/y ticks we want 
       xlabel('Recovery time (hours)');
       ylabel('Count');
       title(titles(id))
       ax =gca;
       ax.FontSize = legsize; 
       set(gcf,'Color','w');
       box off 
   end
end
