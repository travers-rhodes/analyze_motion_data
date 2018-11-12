% Data is a Time by Measurement Dimension matrix
% state labels is the assignment of each data to its corresponding hidden
% state. It is a Time x 1 matrix
% num_states is the number of hidden states (we build one AR for each)
function [states, coeffs, mean_squared_error] = expectation_maximize(data, num_states, degree)
%%
%initialization for testing function (normally commented out)
timeSeriesName = "../pose_data_all_1.txt";
data = dlmread(timeSeriesName);
data = data(1:100000,:);
num_states = 2;
degree = 1;

%% randomly initialize transition probabilities
[init, transition] = initialize_HMM(num_states);

total_time = size(data,1);
% randomly assign states
unscaled_prob_each_state = rand(total_time,num_states);
prob_each_state = unscaled_prob_each_state ./ sum(unscaled_prob_each_state,2);

%%
for run_counter = 1:100
    %%
    "running " + run_counter
    % fit AR model
    [coeffs, mean_squared_error] = fit_AR_models(data, prob_each_state, num_states, degree);
    % compute probability of emitting each value given AR model for each state
    [probs] = probability_of_value_per_state(data, coeffs, mean_squared_error);
    % compute new init and transition and state assignments given baum-welch
    [init, transition, prob_each_state] = baum_welch(init, transition, probs);
    plot(prob_each_state(:,1))
    w = waitforbuttonpress;
end
end