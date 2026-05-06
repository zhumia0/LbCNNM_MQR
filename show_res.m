function []=show_res(y,omega,gt,x_u)
% This function show the result of preliminary PIs
figure;
plot(x_u,'Color',[44/255,145/255,224/255],'LineWidth', 2);
hold on;
plot([y(omega>0.5);gt],'Color',[58/255,191/255,153/255],'LineWidth', 2);
hold on;
w = length(y(omega>0.5));
xline(w, 'b--', 'LineWidth', 1.5); 
legend('UpperBound', 'GroundTruth',  'Location', 'northwest'); 
xlabel('TimeStep');
ylabel('Value');
close all;
end