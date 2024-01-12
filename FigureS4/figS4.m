function figS4()

load('./data/complete_full_D_100_Nr_100_Kn_0.035', 'complete_aa')
    
%plot the time-average aa for each reaction across all trajectories

aa = zeros(size(complete_aa{1}, 1), size(complete_aa{1}, 2)); 

%summing over all trajectories
for i =1:length(complete_aa)
    aa = aa+complete_aa{i}(:,:);
end
aa = aa/length(complete_aa); 

mean_for_each_reaction = mean(aa(3000:size(aa,1), :), 1);

[sorted, idx] = sort(mean_for_each_reaction); 

labels = ["Tc import" "Tc degradation" "TetR binding O1" ...
    "TetR unbinding O1"  "TetR binding O2" "TetR unbinding O2"...
    "Tc binding TetR" "Tc unbinding TetR"  "Tc binding Ribo" "Tc unbinding Ribo" ...
     "Tc binding TetA" "Tc unbinding TetA"  "TetA pumps Tc" ...
     "TetR production" "TetA production" "Ribo production"...
     "TetRf dilution" "TetRb dilution" "TetAf dilution" "TetAb dilution" ...
      "Ribof dilution" "Ribob dilution"];


figure
h = bar(sorted);
xticklabels(labels(idx))
set(gca, 'YScale', 'log')
set(gca, 'Color', 'W')
xticks([1:22]);
title('Average reaction-rate in full simulation steady-state')
ax = gca;
ax.FontSize = 40; 
set(gcf, 'Position', get(0, 'Screensize'));
end
