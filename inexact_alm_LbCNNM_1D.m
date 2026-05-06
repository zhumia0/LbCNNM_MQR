function [x,Ut,Lt] = inexact_alm_LbCNNM_1D(y, g,  Q, n, lambda)
%%% This matlab code implements the (inexact) augmented Lagrange multiplier method for
%%% min_{x}  |A(Q*x)|_* + 0.5*n*lambda |P_
% Omega(x - y)|_2^2
%%% A() -- linear operator that returns the convolutional matrix of a vector
%%% | |_* -- the nuclear norm of a matrix
%% parameters:
% y -- m x 1 vector of observations (required input),with the missing entries being filled with zero
% g -- m x 1 vector with 1 and 0 denoting the observed and missing entries respecitvely (required input) 
% Q --- p x m column-wisely orthogonal matrix (required input) 
% n -- kernel size (required input) 
% lambda -- weight parameter
%      - DEFAULT 1000

p = size(Q, 1);
maxIter = 2000;
tol = 1e-7;

if nargin < 5 || isempty(lambda)
    lambda = 1000;
end

fnorm = sqrt(n)*norm(y);

% initialize
W = zeros(p, n); %Lagrange multiplier 
x = y;
x_hat = repmat(y,1,n);

%parameters
obsrate = sum(g > 0.5)/n;
mu = obsrate/fnorm; % this one can be tuned
rho = 1.05; % this one can be tuned
iter = 0;
Ut = zeros(size(g(g < 0.5,:),1),maxIter);
Lt = zeros(size(Ut));
%% loop
Ax = cconv1mtx(Q*x,n);
while iter < maxIter       
   iter = iter + 1;   
    %update L
    temp = Ax + W./mu;
    [U,S,V] = svd(temp, 'econ');
    diagS = diag(S);
    svp = length(find(diagS > 1/mu));
    diagS = max(0,diagS - 1/mu);
    if svp < 0.5 %svp = 0
        svp = 1;
    end
    diagS = diagS(1:svp);
    U = U(:,1:svp);
    V = V(:,1:svp);
    L =U*bsxfun(@times,V',diagS);  
        
    %update x
    temp = Q'*adj_1D(mu*L - W)/n;
    temp = lambda*y+temp;
    diagA = lambda*g + mu;
    x_h = temp./diagA;


    temp_x = Q'*adj_2D(mu*L - W);
    temp_x = repmat(lambda*y,1,n)+temp_x;
    diagA = repmat(lambda*g,1,n) + mu;
    x_hat = temp_x./diagA;
    x_1 = x_hat((g<0.5),:);
    for j = 1:size(Ut,1)
        Ut(j,iter) = max(x_1(j,:));
        Lt(j,iter) = min(x_1(j,:));
    end
    x = mean(x_hat,2);
    Ax = cconv1mtx(Q*x,n);

    
    

    H = Ax - L;
    %% stop Criterion    
    stopCriterion = norm(H, 'fro') / fnorm; 
    if stopCriterion < tol
        break;
    else
        W = W + mu*H;
        mu = min(mu*rho,10^10);
    end    
end
%% Low-Rank Approximation
% [U1,S1,V1] = svd(Ax,"econ");
% k = 0;
% while k < size(S1,1)
%     k = k + 1;
% 
%     diagS_lwa = diag(S1);
%     lwa_error = sqrt(sumsqr(diagS_lwa(k+1:end)));
%     Ax_F = sqrt(sumsqr(diagS_lwa));
%     stop_lwa = lwa_error/Ax_F;
%     if stop_lwa < 0.1
%         lwa = U1(:,1:k)*S1(1:k,1:k)*V1(:,1:k)';
%         x_a = Q'*adj_2D(lwa);
%         x_a = x_a((g<0.5),:);
%         x_pi = x((g<0.5),:);
% 
%         x_mean = zeros(size(x_a,1),1);
%         x_std = zeros(size(x_a,1),1);
%         for i = 1:size(x_a,1)
%             x_mean(i) = x_pi(i);
%             x_std(i) = std(x_a(i,:));
%         end
%         Ut = x_mean + 1.96 * x_std;
%         Lt = x_mean - 1.96 * x_std;
%         break;
%     end  
% end

% 
% [~,S_Ax,~] = svd(Ax,"econ");
% n_norm = sum(diag(S_Ax));
% resd = x(g>0.5)-y(g>0.5);
% f_norm = lambda*n*sum(resd(:).^2)/2;

Ut = Ut(:,3:iter);
Lt = Lt(:,3:iter);
end

