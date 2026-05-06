function [x_u,x_l] = LbCNNMQR(x,h,alpha,i,lambda,A,A_cal)
    global res;
    len = length(x);
    t1 = tic;
    if nargin < 7 || isempty(A) || isempty(A_cal)
        %% train A
        [A,~,~] = LbCNNM_train(x, h);

        %% train A_cal
        x_cal = x(1:len-h);
        [A_cal,~,~] = LbCNNM_train(x_cal, h);
        % res(i,2) = toc(t1); %training time
    end
    m_size = size(A,2);
    k_size = round(0.5*size(A,1));
    m_size_cal = size(A_cal,2);
    k_size_cal = round(0.5*size(A_cal,1));
    %% calibration
    gt_cal = x(len-h+1:len);
    y_cal = [x(len - m_size_cal + 1 : len - h);zeros(h, 1)];
    omega_cal = ones(m_size_cal, 1);
    omega_cal(m_size_cal - h + 1 : m_size_cal) = 0;

    %% A_tr or A
    [x_m_cal,~] = LbCNNM_pred(y_cal, omega_cal, A_cal, k_size_cal);
    [x_u_cal,~] = inexact_alm_LbCNNM_1D_quantile(y_cal, omega_cal, A_cal, k_size_cal, 1 - alpha/2, lambda);
    x_l_cal = 2*x_m_cal-x_u_cal;
    % x_lp_cal = 2*x_mp_cal-x_up_cal;
    % show_res(y_cal,omega_cal,x(len-h+1:end),x_up_cal,x_lp_cal,x_mp_cal);
    % show_finres(y_cal,omega_cal,x(len-h+1:end),x_u_cal,x_l_cal,x_m_cal);
    %% diff  s_cal
    % resd_m = quantile(abs(gt_cal - x_m_cal),1-alpha);    
    resd_m = quantile([abs(gt_cal - x_m_cal);abs(gt_cal - x_u_cal);abs(gt_cal - x_l_cal)],1-alpha);
    
    
    %% predict interval
    y = [x(len - m_size + h + 1 : len);zeros(h, 1)];
    omega = ones(m_size, 1);
    omega(m_size - h + 1 : m_size) = 0;
    [x_u,~] = inexact_alm_LbCNNM_1D_quantile(y, omega, A, k_size, 1- alpha/2, lambda);
    [x_m,~] = LbCNNM_pred(y, omega, A, k_size);
    x_l = 2*x_m-x_u;
    % x_lp = 2*x_mp-x_up;
    x_ut = max(x_u,x_l);
    x_lt = min(x_u,x_l);
    % x_upt = max(x_up,x_lp);
    % x_lpt = min(x_up,x_lp);
    % show_res(y,omega,gt,x_up);
    % show_finres(y,omega,gt,x_ut,x_lt,x_m);
    % [x_l] = inexact_alm_LbCNNM_1D_quantile(y, omega, A, k_size, 0.05, 200);
    x_u = x_ut + resd_m;
    x_l = x_lt - resd_m;
    % x_up = x_upt + resd_m;
    % x_lp = x_lpt - resd_m;
%     show_finres(y,omega,gt,x_u,x_l,x_m);
    res(i,3) = toc(t1); % running time
end