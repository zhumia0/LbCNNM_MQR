function [cover, num, h] = comp_coverage(gt,Ut,Lt)
h = length(gt);
num = 0;
Ut_hat = zeros(h,1);
Lt_hat = zeros(h,1);
for i = 1 : h    
    Ut_hat(i) = Ut(i);
    Lt_hat(i) = Lt(i);
    if gt(i) > Lt_hat(i) && gt(i) < Ut_hat(i)
        num = num + 1;
    end
end
cover = num / h;
end