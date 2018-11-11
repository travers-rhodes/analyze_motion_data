timeSeriesName = "../pose_data_all_1.txt";
saveDir = "./";
trial_vec = [1,2,3];
raw_data = dlmread(timeSeriesName);
raw_data = raw_data(1:10000,:);
data_size = size(raw_data);
d = data_size(2);
T = data_size(1);


close all;
figure; plot(raw_data);
title('True State and Mode Sequences')
data_struct.obs = raw_data';

%%
