function []=show_finres(y,omega,gt,x_u,x_l,x_m)
%%% This function show the final result of PIs
x = (length(y(omega>0.5))+1):length(y);
figure;
area = fill([x, fliplr(x)], [x_l', fliplr(x_u')], [128,128,128]/255, 'EdgeColor', [0.8, 0.8, 0.8], 'facealpha', '.5'); % 灰色阴影
hold on;
plot([y(omega>0.5);gt],'Color',[58/255,191/255,153/255],'LineWidth', 2);
hold on;
plot(x, x_m,'Color',[255,99,71]/255, 'LineStyle', '--','LineWidth', 2);
hold on;
w = length(y(omega>0.5))+1;
xline(w, 'b--', 'LineWidth', 1.5);

legend('PIs', 'GroundTruth','PFs', 'Location', 'northwest');
xlabel('TimeStep');
ylabel('Value');
% ylim([2500 7000]);
close all;
end