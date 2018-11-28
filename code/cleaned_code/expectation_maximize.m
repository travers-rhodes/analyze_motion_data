% Data is a Time by Measurement Dimension matrix
% state labels is the assignment of each data to its corresponding hidden
% state. It is a Time x 1 matrix
% num_states is the number of hidden states (we build one AR for each)
% is_ref_frame_additional: boolean indicating if the "additional_info" is a
% reference frame point (that is either added to or not added to
% predictions, depending on which fits best).
function [prob_each_state, coeffs, mean_squared_error] = expectation_maximize(data, num_states, additional_info, model_options, residual_options)
%%
% %initialization for testing function (normally commented out)
% timeSeriesName = "../pose_data_full_1.txt";
% data = dlmread(timeSeriesName);
% rng(0)
% %data = data(1:100000,3);
% data = smoothdata(data(1:100000,:));
% %data = smoothdata(data(1:100000,:),'gaussian',500);
% num_states = 5;
% degree = 2;


%%
% force the computed MSE's of different states to not get too different.
% setting this to 0 makes it not exist
regularization_param = 0.01;
% magic parameter that decides how quickly we update the transition and init matrices
% setting this to 1 makes it not exist
update_size = 1.0;

total_time = size(data,1);
% randomly assign states
unscaled_prob_each_state = rand(total_time,num_states);
prob_each_state = unscaled_prob_each_state ./ sum(unscaled_prob_each_state,2);
first_run = true;

%%
for run_counter = 1:model_options.number_iterations
    %%
    % fit AR model
    [new_coeffs, new_mean_squared_error] = fit_AR_models(data, prob_each_state, num_states, additional_info, model_options);
    "running " + run_counter
    squeeze(new_mean_squared_error)
    squeeze(new_coeffs)
    % slowly update params
    if first_run
        coeffs = new_coeffs;
        mean_squared_error = new_mean_squared_error;
    end
    coeffs = new_coeffs * update_size + (1-update_size) * coeffs;
    mean_squared_error = (new_mean_squared_error) * update_size + (1-update_size) * mean_squared_error;
    
    % artificially regularize the mean_squared_errors to avoid divergences.
    % (average each mean squared error toward the mean mean squared
    % error...you know?)
    mean_squared_error = (1-regularization_param) * mean_squared_error + regularization_param * sum(mean_squared_error)/num_states;
    
    % compute probability of emitting each value given AR model for each state
    [probs] = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options, residual_options);
    if (isnan(probs(1,1)))
        error("HOW")
    end
    prob_each_state = probs;

    % plotting code
    clf;
    hold on
    for i = 1:num_states
        plot(prob_each_state(:,i))
    end
    plot(data)
    hold off
    pause(0.1);
    first_run = false;
end
hold on
for i = 1:num_states
    plot(prob_each_state(:,i))
end
plot(data)
hold off
end
