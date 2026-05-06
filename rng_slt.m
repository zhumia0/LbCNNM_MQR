% 参数设置
n = 23000; % 数字范围 1 到 n
num_samples = n/10; % 需要选择的数字个数

% 固定随机数种子
rng(42); % 随机数种子（42是示例，可自行修改）

% 随机选择 n/10 个数
obj = randperm(n, num_samples);
obj = sort(obj);
% 将选择结果保存到文件中
save('./data/Yearly_selected.mat', 'obj');

% 加载已保存的数字（重复实验时使用）

% 显示选择的结果
disp(obj);
