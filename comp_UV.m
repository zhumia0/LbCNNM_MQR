function [U,V] = comp_UV(m)
%COMP_UV 此处显示有关此函数的摘要
%   compute the basis matrices of the real-part and complex-part of Fourier transform matrices 
F = dftmtx(m);
F1 = real(F);
F2 = imag(F);
% skinny svd of F1
[U1,S1,V1] = svd(F1);
S1 = diag(S1);
inds = S1 > 0.1;
U1 = U1(:,inds);
V1 = V1(:,inds);

% skinny svd of F2
[U2,S2,V2] = svd(F2);
S2 = diag(S2);
inds = S2 > 0.1;
U2 = U2(:,inds);
V2 = V2(:,inds);

% combine F1 and F2
U = [U1,U2];
V = [V1,V2];
end

