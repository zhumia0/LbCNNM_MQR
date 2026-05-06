function [f_hat] = est_freq(x)
%EST_PREQ 此处显示有关此函数的摘要
x = detrend(x, 1);
[pxx, freq] = periodogram(x, [], [], length(x));
[~, idx] = max(pxx);
f_hat = freq(idx);
end
