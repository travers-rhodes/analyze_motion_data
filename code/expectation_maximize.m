% Data is a Time by Measurement Dimension matrix
% state labels is the assignment of each data to its corresponding hidden
% state. It is a Time x 1 matrix
% num_states is the number of hidden states (we build one AR for each)
function [states, coeffs, mean_squared_error] = expectation_maximize(data, num_states, degree)
%%
%initialization for testing function (normally commented out)
timeSeriesName = "../pose_data_all_1.txt";
data = dlmread(timeSeriesName);
data = data(1:100000,3);
num_states = 2;
degree = 0;
fitIntercept = true;
regularization_param = 0.2;

%% randomly initialize transition probabilities
[init, transition] = initialize_HMM(num_states);

total_time = size(data,1);
% randomly assign states
unscaled_prob_each_state = rand(total_time,num_states);
prob_each_state = unscaled_prob_each_state ./ sum(unscaled_prob_each_state,2);

%%
for run_counter = 1:50
    %%
    "running " + run_counter
    % fit AR model
    [coeffs, mean_squared_error] = fit_AR_models(data, prob_each_state, num_states, degree, fitIntercept)
    % artificially regularize the mean_squared_errors to avoid divergences.
    % (average each mean squared error toward the mean mean squared
    % error...you know?)
    mean_squared_error = (1-regularization_param) * mean_squared_error + regularization_param * sum(mean_squared_error)/num_states;
    % compute probability of emitting each value given AR model for each state
    [probs] = probability_of_value_per_state(data, coeffs, mean_squared_error, fitIntercept);
    % compute new init and transition and state assignments given baum-welch
    [init, transition, prob_each_state] = baum_welch(init, transition, probs);
end
hold on
plot(prob_each_state(:,1))
plot(data)
hold off
end