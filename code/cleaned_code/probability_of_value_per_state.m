% INPUT
% data is a Time by Measurement Dimension matrix.
% additional_info is the additional_info about this model.
% coeffs is a states by measurement dimension by degree matrix
% mean_squared_error is a states by measurement dimension matrix
% model_options is an object including parameters:
% fitIntercept (whether the first coeff is an intercept term (true) or a data
% coefficient (false))
% OUTPUT
% probs is the probability that, for each state, the values observed might be pulled from
% the model predicted by that state, for each time.
% it is of dimension time by number_of_states
function [probs] = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options, residual_options)
%%
% %initialization for testing function (normally commented out)
% timeSeriesName = "../pose_data_all_1.txt";
% data = dlmread(timeSeriesName);
% data = data(1:10000,:);
% num_states = 4;
% degree = 2;
% total_time = size(data,1);
% % randomly assign states
% unscaled_prob_each_state = rand(total_time,num_states);
% prob_each_state = unscaled_prob_each_state ./ sum(unscaled_prob_each_state,2);
% fitIntercept = true;
% [coeffs, mean_squared_error] = fit_AR_models(data, prob_each_state, num_states, degree, fitIntercept);

%%
measurement_dimension = size(data,2);
time = size(data,1);
num_states = size(coeffs,1);

% pad the data with the first value (not with zeros)
padded_data = construct_padded_data(data, model_options.degree);

probs = ones(time, num_states);
%%
for meas_var = 1:measurement_dimension
    %%
    [z_score, ~] = apply_linear_model(padded_data, additional_info, model_options, coeffs, mean_squared_error, meas_var);
   
    if (residual_options.isGaussian)
        probs = probs .* normpdf(z_score) ./ sqrt(mean_squared_error(:,meas_var))';
    else
        % we use a t distribution with nu of 3 for funzies. See
        % experiment_distribution_errors.m for some context
        nu = 3;
        default_variance = nu/(nu-2);
        default_std = sqrt(default_variance);
        probs = tpdf(z_score*default_std,nu)./ sqrt(mean_squared_error(:,meas_var))' * default_variance;
    end
end
% normalize since you must be in some state
sum_probs = sum(probs, 2);
probs = ((probs') ./ sum_probs')';
% get rid of NaNs induced by overly large z_scores
probs(sum_probs==0,:) = 1/num_states;

end