clear;
timeSeriesName = "../../spoon_positions.txt";
data = dlmread(timeSeriesName);
rng(0)
%data = data(1:100000,3);
time = size(data,1);
data = smoothdata(data(1:time,:),'gaussian',20);
spoon_data = data(:, 1:3);
num_states = 5;
additional_data = zeros(size(spoon_data,1),0);

model_options.fitIntercept = true;
model_options.degree=2;
model_options.is_fit_to_frame = false;
model_options.number_iterations = 100;
residual_options.isGaussian=false;

[prob_each_state, coeffs, mean_squared_error] = expectation_maximize(spoon_data, num_states, additional_data, model_options, residual_options);

start = spoon_data(1:model_options.degree,:);
%est_path = get_computed_path(start, coeffs, prob_each_state, additional_data);
%mod_path = get_modeled_path(start, coeffs, prob_each_state, spoon_data, additional_data);

clf;
hold on
plot(spoon_data,"Color",[0,0,1])
%plot(est_path,"Color",[0,1,1])
%plot(mod_path,"Color",[1,0,0])
hold off
