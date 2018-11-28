timeSeriesName = "../../spoon_positions.txt";
data = dlmread(timeSeriesName);
rng(0)
%data = data(1:100000,3);
time = size(data,1);
spoon_data = data(:, 2:3);
num_states = 2;
degree = 0;
additional_data = zeros(size(hat_data,1),0);
is_ref_frame_additional = false;

[prob_each_state, coeffs, mean_squared_error] = expectation_maximize(spoon_data, num_states, degree, additional_data, is_ref_frame_additional);

start = spoon_data(1:degree,:);
est_path = get_computed_path(start, coeffs, prob_each_state, additional_data);
mod_path = get_modeled_path(start, coeffs, prob_each_state, spoon_data, additional_data);

clf;
hold on
plot(spoon_data,"Color",[0,0,1])
plot(est_path,"Color",[0,1,1])
plot(mod_path,"Color",[1,0,0])
plot(hat_data,"Color",[1,0,1])
hold off
