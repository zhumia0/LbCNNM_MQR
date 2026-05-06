function [] = testM4_PIs(class)
close all;
disp('loading data ...')
alpha = 0.05; %significance level
lambda = 20;
time_interval = get_ti(class); %time interval of m in MSIS
data = loadmatfile(['./data/M4' class 'Train.mat']);
GT = loadmatfile(['./data/M4' class 'Test.mat']);
% A_train = loadmatfile(['./results/M4' class '_A.mat']);
% A_cal_train = loadmatfile(['./results/M4' class '_A_cal.mat']);
% slt_n = loadmatfile(['./data/' class '_selected.mat']);  %M4-small
% len_slt = length(slt_n);
n = length(data);
disp([num2str(n) ' sequences.']);
global res; % length, training time, testing time, sMSIS (testing), coverage, num_in_PIs, h
res = zeros(n,7);
 for i = 1:n
    disp(['processing sequence ' num2str(i)]);
    x = data{i}; %training data
    len = length(x);
    gt = GT{i}; %ground truth
    h = length(gt);  %forecast horizon
    res(i, 1) = len/h;
    %% trained A
%     A = A_train{i};

    %% trained A_cal
%     A_cal = A_cal_train{i};   
    [x_u,x_l] = LbCNNMQR(x,h,alpha,i,lambda);
%     [x_u,x_l] = LbCNNM_CP(x,h,alpha,i,A,A_cal);

    res(i,4) = comp_sMSIS(x, x_u, x_l, gt, alpha, time_interval);
    [res(i,5),res(i,6),res(i,7)] = comp_coverage(gt,x_u,x_l);
    disp(['MSIS is ',num2str(res(i,4)),' , coverage is ',num2str(res(i,5))]);
    
%% test for selected data
% for i = 1:len_slt
%     j = slt_n(i);
%     disp(['processing sequence ' num2str(i)]);
%     x = data{j}; %training data
%     len = length(x);
%     gt = GT{j}; %ground truth
%     h = length(gt);  %forecast horizon
%     res(i, 1) = len/h;
%     %% trained A
%     A = A_train{j};
% 
%     %% trained A_cal
%     A_cal = A_cal_train{j};   
%     [x_u,x_l] = LbCNNMQR(x,h,alpha,i,lambda,A,A_cal);
% %     [x_u,x_l] = LbCNNM_CP(x,h,alpha,i,A,A_cal);
% 
%     res(i,4) = comp_sMSIS(x, x_u, x_l, gt, alpha, time_interval);
%     [res(i,5),res(i,6),res(i,7)] = comp_coverage(gt,x_u,x_l);
%     disp(['MSIS is ',num2str(res(i,4)),' , coverage is ',num2str(res(i,5))]);
 end
n = size(res,1);
disp(['results on ' num2str(n) ' sequences: ']);
disp(['sMSIS, min:' num2str(min(res(:,4))) '.  median: ' ...
    num2str(median(res(:,4))) ' , avg: ' num2str(mean(res(:,4))) ' , std: ' num2str(std(res(:,4)))]);
disp([])
num_of_cov = sum(res(:,6));
num_of_all = sum(res(:,7));
coverage = 100.0 * num_of_cov / num_of_all;
disp(['Coverage of ', class, ' is ', num2str(coverage), '%']);
disp(['Included predict : ', num2str(num_of_cov), ' All need to be predicted : ', num2str(num_of_all)]);
end

