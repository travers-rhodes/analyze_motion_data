% INPUT
% Data is a Time by Measurement Dimension matrix
% prob_each_state is the probabilistic assignment of each data to its corresponding hidden
% state. It is a Time x num_states matrix
% num_states is the number of hidden states (we build one AR for each)
% degree is the degree of the AR model
% fitIntercept says whether we allow the AR model to have an intercept term
% (is that legal?)
% additional_info is a matrix of size time x number_of_additional_info that
% lists extra world-state information the model can use, like head position at each
% time.
% OUTPUT
% coeffs_mat is a num_states by meas_dimension by degree matrix of coefficients
% used to predict next value, in formula x_n = c[1] x_n-1 + c[2] x_n-2
% mean_squared_error is of dimension num_states by meas_dimension, and gives an estimate
% of the variance of residuals (used as a probability measure for state
% distribution around the predicted value)
function [coeffs, mean_squared_error] = fit_AR_models(data, prob_each_state, num_states, degree, fitIntercept, additional_info)
%%
% %initialization for testing function (normally commented out)
% timeSeriesName = "../pose_data_all_1.txt";
% data = dlmread(timeSeriesName);
% data = data(1:1000,:);
% num_states = 3;
% degree = 2;
% time = size(data,1);
% unscaled_prob_each_state = rand(time,num_states);
% prob_each_state = unscaled_prob_each_state ./ sum(unscaled_prob_each_state,2);
% fitIntercept = true;

%%
%I don't know what to do here, but pre-padding with zeros makes some sense
%to me, so let's do that
time = size(data,1);
measurement_dimension = size(data,2);
addl_info_count = size(additional_info,2);
padded_data = [zeros(degree, measurement_dimension); data];
for i = 1:degree
    padded_data(i,:) = data(degree+1,:);
end
if fitIntercept
    coeffs = zeros(num_states, measurement_dimension, degree + addl_info_count + 1);
else
    coeffs = zeros(num_states, measurement_dimension, degree + addl_info_count);
end
mean_squared_error = zeros(num_states, measurement_dimension);
for state = 1:num_states
    
    [~, most_probable_indices] = sort(prob_each_state(:,state),'descend');
    non_zero_prob_indices = find(prob_each_state(:,state) > 0);
    raw_data_indices = non_zero_prob_indices;%intersect(most_probable_indices(1:ceil(num_states * time/(num_states+ 1))),non_zero_prob_indices);
    data_indices =  raw_data_indices + degree;
    if size(data_indices,1) == 0
        continue
    end
    for meas_var = 1:measurement_dimension
        y = padded_data(data_indices, meas_var);
        X = zeros(size(data_indices,1),degree + addl_info_count);
        for deg = 1:degree
            X(:,deg) = padded_data(data_indices - deg, meas_var);
        end
        for extra = 1:addl_info_count
            X(:,degree + extra) = additional_info(raw_data_indices,extra);
        end
        % scale weights?
        weights = prob_each_state(raw_data_indices,state);
        weights = time * rescale_weights(weights);
%         weights = weights * size(raw_data_indices,1) / sum(weights);
%         lm = fitlm(X,y,'Intercept',fitIntercept, 'Weights', weights);
%         coeffs(state, meas_var, :) = lm.Coefficients.Estimate;
%         mean_squared_error(state,  meas_var) = lm.MSE;
        [B,FitInfo] = lasso(X,y,'Alpha',0.5,'Weights', weights);
        lassoChoice = 5;
        if size(B,2) < lassoChoice
           coeffs(state, meas_var, :) = [FitInfo.Intercept(size(B,2)),B(:,size(B,2))'];
           mean_squared_error(state,  meas_var) = FitInfo.MSE(size(B,2));
        else
            coeffs(state, meas_var, :) = [FitInfo.Intercept(:,lassoChoice),B(:,lassoChoice)'];
            mean_squared_error(state,  meas_var) = FitInfo.MSE(:,lassoChoice);
        end
    end
end
