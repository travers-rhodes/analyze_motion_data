% INPUT
% data is a Time by Measurement Dimension matrix.
% coeffs is a states by measurement dimension by degree matrix
% mean_squared_error is a states by measurement dimension matrix
% OUTPUT
% probs is the probability that, for each state, the values observed might be pulled from
% the model predicted by that state, for each time.
% it is of dimension time by number_of_states
function [probs] = probability_of_value_per_state(data, coeffs, mean_squared_error)
%%
% %initialization for testing function (normally commented out)
% timeSeriesName = "../pose_data_all_1.txt";
% data = dlmread(timeSeriesName);
% data = data(1:10000,:);
% num_states = 4;
% degree = 2;
% state_labels = 1 + floor(((1:size(data,1)) - 1)/(size(data,1)/num_states));
% [coeffs, mean_squared_error] = fit_AR_models(data, state_labels, num_states, degree);

%%
measurement_dimension = size(data,2);
time = size(data,1);
degree = size(coeffs,3);
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
    coeff_vals = coeffs(:, meas_var, :);
    coeff_vals = reshape(coeff_vals,[num_states, degree]);
    pred_y = (coeff_vals * X')';
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