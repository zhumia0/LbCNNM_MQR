function [MSIS] = comp_sMSIS(x, Ut, Lt, gt, alpha, time_interval)
h = length(gt);
n = length(x);
m = time_interval;
Ut_hat = zeros(h,1);
Lt_hat = zeros(h,1);
% Ut_alm_mean = zeros(h,1);
% Lt_alm_mean = zeros(h,1);
bias = zeros(h,1);
for i = 1:h
    %% 方法1
%     [mu_K1,sigma_hat_K1,~,~] = normfit(pi(i,:),alpha);     %0.05:0.05:1
%     [mu_K2,sigma_hat_K2,~,~] = normfit(pi(i,2:2:end),alpha);     %0.1:0.1:1
%     Ut_K2 = mu_K2+1.96*sigma_hat_K2;
%     Lt_K2 = mu_K2-1.96*sigma_hat_K2;
%     Ut_K1 = mu_K1+1.96*sigma_hat_K1;
%     Lt_K1 = mu_K1-1.96*sigma_hat_K1;
%     Ut_K2sigma = pi(i,10)+1.96*sigma_hat_K2;
%     Lt_K2sigma = pi(i,10)-1.96*sigma_hat_K2;
%     Ut_K1sigma = pi(i,10)+1.96*sigma_hat_K1;
%     Lt_K1sigma = pi(i,10)-1.96*sigma_hat_K1;

    %% 方法2-1
%     Ut_alm_mean = mean(Ut(i,:));
%     Lt_alm_mean = mean(Lt(i,:));
    %% 方法2-4
%     y_h = 0.5*(Ut(i,:)+Lt(i,:));
%     Ut_pfalm = pi(i,10)+1.96*std(y_h);
%     Lt_pfalm = pi(i,10)-1.96*std(y_h);
    %% 方法2-3
%     y_h = 0.5*(Ut(i,:)+Lt(i,:));
%     Ut_alm = mean(y_h)+1.96*std(y_h);
%     Lt_alm = mean(y_h)-1.96*std(y_h);
    %% 方法2-2
%     sigma_ut = std(Ut(i,:));
%     sigma_lt = std(Lt(i,:));
%     sigma_alm = 0.5*(sigma_ut+sigma_lt);
%     %Ut_pfalm_sigma
%     Ut_pfalm_sigma = pi(i,10)+1.96*sigma_alm;
%     Lt_pfalm_sigma = pi(i,10)-1.96*sigma_alm;
    %% ensemble
%     Ut_hat(i) = mean([Ut_K2,Ut_K1sigma,Ut_K2sigma,Ut_alm,Ut_pfalm,Ut_alm_mean,Ut_pfalm_sigma]);
%     Lt_hat(i) = mean([Lt_K2,Lt_K1sigma,Lt_K2sigma,Lt_alm,Lt_pfalm,Lt_alm_mean,Lt_pfalm_sigma]);

    %%
    Ut_hat(i) = Ut(i);
    Lt_hat(i) = Lt(i);
    %%
    if gt(i) < Lt_hat(i)
        bias(i) = Lt_hat(i) - gt(i);
    elseif gt(i) > Ut_hat(i)
        bias(i) = gt(i) - Ut_hat(i);
    else
        bias(i) = 0;
    end
    
end
% show_fig(gt,Ut_hat,Lt_hat);
numerator = sum((Ut_hat-Lt_hat)+2*bias/alpha);
denominator = sum(abs(x(m+1:n,:)-x(1:n-m,:)))/(n-m);
MSIS = numerator/denominator/h;
res = MSIS;

end