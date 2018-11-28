%%
%% Note that the residuals are _NOT_ normal, but are heavier tailed.
%%
%% we estimate the noise as t distribution with nu of 3
clear;
timeSeriesName = "../../spoon_positions.txt";
data = dlmread(timeSeriesName);
rng(0)
%data = data(1:100000,3);
time = size(data,1);
spoon_data = data(:, 2:3);
num_states = 1;
prob_each_state = ones(time,1);
additional_data = zeros(size(spoon_data,1),0);

model_options.fitIntercept = true;
model_options.degree=1;
model_options.is_fit_to_frame = false;

[coeffs, mean_squared_error] = fit_AR_models(spoon_data, prob_each_state, num_states, additional_data, model_options);
[z_score, resid] = apply_linear_model(spoon_data, additional_data, model_options, coeffs, mean_squared_error, 1);

std(resid)

clf;
hold on
plot(spoon_data,"Color",[0,0,1])
plot(resid,"Color",[0,1,1])
hold off

nu = 3;
default_variance = nu/(nu-2);
default_std = sqrt(default_variance);

clf;
hold on
histfit(resid)
plot(-0.015:0.0001:0.015, tpdf((-0.015:0.0001:0.015)/std(resid)*default_std,nu)/std(resid)*default_std)
hold off

fitdist(resid,'tLocationScale')
