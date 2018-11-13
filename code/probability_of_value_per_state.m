% INPUT
% data is a Time by Measurement Dimension matrix.
% coeffs is a states by measurement dimension by degree matrix
% mean_squared_error is a states by measurement dimension matrix
% fitIntercept (whether the first coeff is an intercept term (true) or a data
% coefficient (false))
% OUTPUT
% probs is the probability that, for each state, the values observed might be pulled from
% the model predicted by that state, for each time.
% it is of dimension time by number_of_states
function [probs] = probability_of_value_per_state(data, coeffs, mean_squared_error, fitIntercept)
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
if fitIntercept
degree = size(coeffs,3) - 1;
else
degree = size(coeffs,3);
end
num_states = size(coeffs,1);
% pad the data with the first value (not with zeros)
padded_data = [repmat(data(1,:),degree,1); data];
real_time_indices = (1:time) + degree;
probs = ones(time, num_states);
%%
for meas_var = 1:measurement_dimension
    %%
    y = padded_data(real_time_indices, meas_var);
    X = zeros(time,degree);
    for deg = 1:degree
        X(:,deg) = padded_data(real_time_indices - deg, meas_var);
    end
    if fitIntercept
        coeff_vals = coeffs(:, meas_var, 2:(degree+1));
    else
        coeff_vals = coeffs(:, meas_var, :);
    end
    coeff_vals = reshape(coeff_vals,[num_states, degree]);
    if fitIntercept
        pred_y = (coeff_vals * X')' + coeffs(:, meas_var, 1)';
    else
        pred_y = (coeff_vals * X')';
    end
    resid_y = y - pred_y;
    z_score = resid_y ./ sqrt(mean_squared_error(:,meas_var))';
    probs = probs .* normpdf(z_score);
end
% normalize since you must be in some state
sum_probs = sum(probs, 2);
probs = ((probs') ./ sum_probs')';
% get rid of NaNs induced by overly large z_scores
probs(sum_probs==0,:) = 1/num_states;

end