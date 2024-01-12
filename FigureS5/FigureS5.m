%% Figure S5
load 'Data/microcolony_velocity_data.mat'

velocity = abs(all_v_averages);
velocity = velocity(450:1050,2:end); 

% Cell from the slow-growing region of the trap
x = linspace(0,170,95);
b = 56; 
trajectory = zeros(1,601);
trajectory_indices = zeros(1,601);
loc = x(b);
for i=45:601 
    vel = velocity(i,b); 
    trajectory(i) = loc;
    trajectory_indices(i) = b;
    dist = vel*120*10^6;
    loc = loc - dist;
    b = find(x>=loc,1);
end

% Cell from the fast-growing region of the trap
b = 50; 
trajectory_above = zeros(1,601);
trajectory_above_indices = zeros(1,601);
loc = x(b);
for i=45:601
    vel = velocity(i,b); 
    trajectory_above(i) = loc;
    trajectory_above_indices(i) = b;
    dist = vel*120*10^6;
    loc = loc - dist;
    b = find(x>=loc,1);
end

load 'Data/microcolony_growth_data.mat'

data = abs(grow_all(450:1050,:)); 
growth = ((data.*0.001)./1.79).*3600;
data = growth./log(2);
growth = data;

g = zeros(1,601);

for i = 45:601
    g(i) = growth(i,trajectory_indices(i));
end

g_above = zeros(1,601);
for i = 45:601
    g_above(i) = growth(i,trajectory_above_indices(i));
end

x = linspace(451,1051,601);
time = ((x-1)*2)/60;
time = time -16.4667;

figure
plot(time(46:81),smooth(g_above(46:81)),'--','LineWidth',3,'Color',[0 0.4470 0.7410]) 
hold on
plot(time(46:94),smooth(g(46:94)),'-','LineWidth',3,'Color',[0 0.4470 0.7410]) 
legend('Fast-growing','Slow-growing','Location','northeast')
legend('FontName','Ariel')
legend box off
ylabel('Growth (doub./h)','FontSize',32,'FontName','Ariel');
xlabel('Time (hours)','FontSize',32,'FontName','Ariel');
ylim([0 3])
yticks([0 1 2 3])
xticks(0:0.2:1.6)
xlim([0 time(94)])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Ariel','fontsize',32)
