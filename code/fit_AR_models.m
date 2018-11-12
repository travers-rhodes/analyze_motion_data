% Data is a Time by Measurement Dimension matrix
% prob_each_state is the probabilistic assignment of each data to its corresponding hidden
% state. It is a Time x num_states matrix
% num_states is the number of hidden states (we build one AR for each)
% degree is the degree of the AR model
% coeffs_mat is a num_states by meas_dimension by degree matrix of coefficients
% used to predict next value, in formula x_n = c[1] x_n-1 + c[2] x_n-2
% mean_squared_error is of dimension num_states by meas_dimension, and gives an estimate
% of the variance of residuals (used as a probability measure for state
% distribution around the predicted value)
function [coeffs, mean_squared_error] = fit_AR_models(data, prob_each_state, num_states, degree)
%%
% initialization for testing function (normally commented out)
% timeSeriesName = "../pose_data_all_1.txt";
% data = dlmread(timeSeriesName);
% data = data(1:1000,:);
% num_states = 3;
% degree = 2;
% time = size(data,1);
% unscaled_prob_each_state = rand(time,num_states);
% prob_each_state = unscaled_prob_each_state ./ sum(unscaled_prob_each_state,2);

%%
%I don't know what to do here, but pre-padding with zeros makes some sense
%to me, so let's do that
time = size(data,1);
measurement_dimension = size(data,2);
padded_data = [zeros(degree, measurement_dimension); data];
coeffs = zeros(num_states, measurement_dimension, degree);
mean_squared_error = zeros(num_states, measurement_dimension);
for state = 1:num_states
    
    [~, most_probable_indices] = sort(prob_each_state(:,state),'descend');
    non_zero_prob_indices = find(prob_each_state(:,state) > 0);
    raw_data_indices = intersect(most_probable_indices(1:ceil(time/(num_states*3))),non_zero_prob_indices);
    data_indices =  raw_data_indices + degree;
    if size(data_indices,1) == 0
        continue
    end
    for meas_var = 1:measurement_dimension
        y = padded_data(data_indices, meas_var);
        X = zeros(size(data_indices,1),degree);
        for deg = 1:degree
            X(:,deg) = padded_data(data_indices - deg, meas_var);
        end
        lm = fitlm(X,y,'Intercept',false, 'Weights', prob_each_state(raw_data_indices,state));
        coeffs(state, meas_var, :) = lm.Coefficients.Estimate;
        mean_squared_error(state,  meas_var) = lm.MSE;
    end
end