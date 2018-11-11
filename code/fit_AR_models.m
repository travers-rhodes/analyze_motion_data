% Data is a Time by Measurement Dimension matrix
% state labels is the assignment of each data to its corresponding hidden
% state. It is a Time x 1 matrix
% num_states is the number of hidden states (we build one AR for each)
% degree is the degree of the AR model
% coeffs_mat is a num_states by meas_dimension by degree matrix of coefficients
% used to predict next value, in formula x_n = c[1] x_n-1 + c[2] x_n-2
% mean_squared_error is of dimension num_states by meas_dimension, and gives an estimate
% of the variance of residuals (used as a probability measure for state
% distribution around the predicted value)
function [coeffs, mean_squared_error] = fit_AR_models(data, state_labels, num_states, degree)
%%
% % initialization for testing function (normally commented out)
% timeSeriesName = "../pose_data_all_1.txt";
% data = dlmread(timeSeriesName);
% data = data(1:1000,:);
% num_states = 3;
% degree = 2;
% state_labels = (1 + floor(((1:size(data,1)) - 1)/(size(data,1)/num_states)))';

%%
%I don't know what to do here, but pre-padding with zeros makes some sense
%to me, so let's do that
measurement_dimension = size(data,2);
padded_data = [zeros(degree, measurement_dimension); data];
coeffs = zeros(num_states, measurement_dimension, degree);
mean_squared_error = zeros(num_states, measurement_dimension);
for state = 1:num_states
    data_indices = find(state_labels == state) + degree;
    for meas_var = 1:measurement_dimension
        y = padded_data(data_indices, meas_var);
        X = zeros(size(data_indices,1),degree);
        for deg = 1:degree
            X(:,deg) = padded_data(data_indices - deg, meas_var);
        end
        lm = fitlm(X,y,'Intercept',false);
        coeffs(state, meas_var, :) = lm.Coefficients.Estimate;
        mean_squared_error(state,  meas_var) = lm.MSE;
    end
end