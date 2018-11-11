% Data is a Time by Measurement Dimension matrix
% state labels is the assignment of each data to its corresponding hidden
% state. It is a Time x 1 matrix
% num_states is the number of hidden states (we build one AR for each)
function [states, coeffs, mean_squared_error] = expectation_maximize(data, num_states, degree)
%%
%initialization for testing function (normally commented out)
timeSeriesName = "../pose_data_all_1.txt";
data = dlmread(timeSeriesName);
data = data(1:10000,:);
num_states = 4;
degree = 2;

%% randomly initialize transition probabilities
[init, transition] = initialize_HMM(num_states);

total_time = size(data,1);
% randomly assign states
state_labels = randi([1,num_states],total_time,1);

% fit AR model
[coeffs, mean_squared_error] = fit_AR_models(data, state_labels, num_states, degree);

[probs] = probability_of_value(data, coeffs, mean_squared_error);

state_labels = most_probable_states(init, transition, probs);

end