function [x_u,x_l] = LbCNNM_CP(x,h,alpha,i,A,A_cal)
    global res;
    len = length(x);
    if nargin < 6 || isempty(A) || isempty(A_cal)
        %% train A
        t1 = tic;
        [A,~,~] = LbCNNM_train(x, h);

        %% train A_cal
        x_cal = x(1:len-h);
        [A_cal,~,~] = LbCNNM_train(x_cal, h);
        res(i,2) = toc(t1); %training time
    end
    
    m_size = size(A,2);
    k_size = round(0.5*size(A,1));
    m_size_cal = size(A_cal,2);
    k_size_cal = round(0.5*size(A_cal,1));
    %% validation
    gt_cal = x(len-h+1:len);
    y_cal = [x(len - m_size_cal + 1 : len - h);zeros(h, 1)];
    omega_cal = ones(m_size_cal, 1);
    omega_cal(m_size_cal - h + 1 : m_size_cal) = 0;
%     gt_cal = x(len-p+1:len);
%     y_cal = [x(len - m_size_cal + 1 : len - p);zeros(p, 1)];
%     omega_cal = ones(m_size_cal, 1);
%     omega_cal(m_size_cal - p + 1 : m_size_cal) = 0;
    
    lambda = 20;
    t1 = tic;
    % x_m_cal = inexact_alm_LbCNNM_1D_quantile(y_cal, omega_cal, A_cal, k_size_cal, 0.5, lambda);
    x_m_cal = LbCNNM_pred(y_cal, omega_cal, A_cal, k_size_cal);
    % x_u_cal = inexact_alm_LbCNNM_1D_quantile(y_cal, omega_cal, A_cal, k_size_cal, 1 - alpha/2, lambda);
    % x_l_cal = 2*x_m_cal-x_u_cal;
%     resd_u = quantile(abs(gt_cal - x_u_cal),1-alpha);
%     resd_l = quantile(abs(gt_cal - x_l_cal),1-alpha);
    resd_m = quantile(abs(gt_cal - x_m_cal),1-alpha);    %区间扩张
    
    
    %% predict interval
    
    y = [x(len - m_size + h + 1 : len);zeros(h, 1)];
    omega = ones(m_size, 1);
    omega(m_size - h + 1 : m_size) = 0;
    x_m = LbCNNM_pred(y, omega, A, k_size);
    % x_u = inexact_alm_LbCNNM_1D_quantile(y, omega, A, k_size, 1- alpha/2, lambda);
    % x_l = 2*x_m-x_u;
    % x_ut = max(x_u,x_l);
    % x_lt = min(x_u,x_l);
    % [x_l] = inexact_alm_LbCNNM_1D_quantile(y, omega, A, k_size, 0.05, 200);
    x_u = x_m + resd_m;
    x_l = x_m - resd_m;
    % x_u = x_ut + resd_u + bias;
    % x_l = x_lt - resd_u + bias;
    res(i,3) = toc(t1); % testing time
end