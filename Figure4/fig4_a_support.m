function fig4_a_support(id)
   DD = [100, 138.8, 157.5, 175]; %drug concentrations 
   colors = [[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]; [0.9290 0.6940 0.1250]; [0.4940 0.1840 0.5560]]; 
   Nr=100; % ribosome pool size 
   Kn = 0.035; %nutritional capacity
   spec =  ""; %choice of type of simulation "": reduced model; "full": full model
   legsize = 40; 
   filenames ="./data/rectimes_D_"+num2str(DD(id))+"_Nr_"+num2str(Nr)+"_Kn_"+num2str(Kn);
   load(filenames, 'rec'); 
   edges = linspace(100/60, 700/60, 50);
   xlim([0,12])
   set(gcf,'Color','w');
   histogram(rec/60, edges, 'EdgeAlpha',1, 'FaceAlpha',0.5, 'FaceColor', colors(id, :));
   legend(strcat(num2str(DD', '%.1f'), '\muM'))
   ax = gca; 
   ax.Legend.String = {'100 \muM', '138.8 \muM', '157.5 \muM' , '175 \muM'};
   ax.Legend.Title.String = "Exposure:";
   legend box off
   lgd = legend("show");
   hold on 
 

   xl = xlabel('Recovery time (hours)');
   yl = ylabel('Count');
   ax.FontSize = legsize; 
   box off 
    
end
