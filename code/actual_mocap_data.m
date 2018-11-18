timeSeriesName = "../pose_data_full_1.txt";
data = dlmread(timeSeriesName);
rng(0)
%data = data(1:100000,3);
time = 50000;
data = smoothdata(data(1:time,:));
spoon_data = data(:, 1:7);
hat_data = data(:, 8:14);
%data = smoothdata(data(1:100000,:),'gaussian',500);
num_states = 2;
degree = 2;
additional_data = zeros(time,0);

[prob_each_state, coeffs, mean_squared_error] = expectation_maximize(spoon_data, num_states, degree, hat_data);

start = spoon_data(1:degree,:);
est_path = get_computed_path(start, coeffs, prob_each_state, hat_data);

clf;
hold on
plot(spoon_data)
plot(est_path)
hold off