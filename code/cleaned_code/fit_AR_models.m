% INPUT
% Data is a Time by Measurement Dimension matrix
% prob_each_state is the probabilistic assignment of each data to its corresponding hidden
% state. It is a Time x num_states matrix
% num_states is the number of hidden states (we build one AR for each)
% degree is the degree of the AR model
% additional_info is a matrix of size time x number_of_additional_info that
% lists extra world-state information the model can use, like head position at each
% time.
% model_options contains many properties, including
% % fitIntercept says whether we allow the AR model to have an intercept term
% % (is that legal?)
% % is_ref_frame_additional: boolean indicating if the "additional_info" is a
% % reference frame point (that is either added to or not added to
% % predictions, depending on which fits best).
% OUTPUT
% coeffs_mat is a num_states by meas_dimension by degree matrix of coefficients
% used to predict next value, in formula x_n = c[1] x_n-1 + c[2] x_n-2
% mean_squared_error is of dimension num_states by meas_dimension, and gives an estimate
% of the variance of residuals (used as a probability measure for state
% distribution around the predicted value)
function [coeffs, mean_squared_error] = fit_AR_models(data, prob_each_state, num_states, additional_info, model_options)
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
if(size(additional_info,1) ~= size(data,1))
    error("additional_info must have the same number of data points as data");
end

time = size(data,1);
measurement_dimension = size(data,2);
addl_info_count = size(additional_info,2);
final_num_coeffs = model_options.degree + addl_info_count;
if model_options.fitIntercept
    final_num_coeffs = final_num_coeffs + 1;
end


%I don't know what to do here, but pre-padding with first value makes some sense
%to me, so let's do that
padded_data = construct_padded_data(data, model_options.degree);

% pre-allocate coeffs and mean_squared_error for speed
coeffs = zeros(num_states, measurement_dimension, final_num_coeffs);
mean_squared_error = zeros(num_states, measurement_dimension);
for state = 1:num_states
    non_zero_prob_indices = find(prob_each_state(:,state) > 0);
    raw_data_indices = non_zero_prob_indices;
    
    if size(raw_data_indices,1) == 0
        %TODO: Throw error here? Reset to larger pool of points?
        continue
    end
    
    
    for meas_var = 1:measurement_dimension
        % pull y from data
        y = data(raw_data_indices, meas_var);
        
        X = get_x_values(padded_data, additional_info, raw_data_indices, meas_var, model_options);
        
        % scale weights
        weights = prob_each_state(raw_data_indices,state);
        weights = rescale_weights(weights);
        
        if (model_options.is_fit_to_frame && addl_info_count > 0)
            if (addl_info_count ~= measurement_dimension)
                error("fitting to frame means that additional_info is a point of the same dimension as your measured point")
            end
            if (~model_options.fitIntercept)
                 error("fitting to frame currently always fits intercept")
            end

          [coeffs(state, meas_var, :), mean_squared_error(state, meas_var)] = ...
              fit_frame_based_model(X, y, weights, additional_info(raw_data_indices,meas_var), final_num_coeffs, meas_var);
        else
            [coeffs(state, meas_var, :), mean_squared_error(state, meas_var)] = ...
              fit_linear_model(X, y, weights, model_options.fitIntercept);
%         [B,FitInfo] = lasso(X,y,'Alpha',0.1,'Weights', weights);
%         lassoChoice = 10;
%         if size(B,2) < lassoChoice
%            coeffs(state, meas_var, :) = [FitInfo.Intercept(size(B,2)),B(:,size(B,2))'];
%            mean_squared_error(state,  meas_var) = FitInfo.MSE(size(B,2));
%         else
%             coeffs(state, meas_var, :) = [FitInfo.Intercept(:,lassoChoice),B(:,lassoChoice)'];
%             mean_squared_error(state,  meas_var) = FitInfo.MSE(:,lassoChoice);
%         end
        end
    end
end
