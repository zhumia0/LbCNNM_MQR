function [x_quantile,x_hat] = inexact_alm_LbCNNM_1D_quantile(y, g,  Q, n, q, lambda)
p = size(Q, 1);
maxIter = 2000;
fnorm = sqrt(n)*norm(y);
tol = 1e-4;
rho = 1.05; % this one can be tuned
% initialize
W = zeros(p, n); %Lagrange multiplier 
x = y ;
%parameters
obsrate = sum(g > 0.5)/n;
mu = obsrate/fnorm; % this one can be tuned
Ax = cconv1mtx(Q*x,n);
iter = 0;
while iter < maxIter       
   iter = iter + 1;   
    %update Z
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
    Z =U*bsxfun(@times,V',diagS);  
    %update x
    temp = Q' * adj_1D(W - mu*Z);
    x_g1 = (lambda*q.*g-temp)./(mu*n);
    x_g2 = (lambda*(q-1).*g-temp)./(mu*n);

    %% median or mean
%     x_hat = median([x_g1,x_g2,y],2);   
    x_hat = [mean([x_g1(g>0.5),x_g2(g>0.5),y(g>0.5)],2);median([x_g1(g<0.5),x_g2(g<0.5),y(g<0.5)],2)];
    
    Ax = cconv1mtx(Q*x_hat,n);
    H = Ax - Z;
    %% stop Criterion    
    stopCriterion = norm(H, 'fro') / fnorm; 
    if stopCriterion < tol
        break;
    else
        W = W + mu*H;
        mu = min(mu*rho,10^10);
    end
    
end
x_quantile = x_hat(g<0.5);
end
