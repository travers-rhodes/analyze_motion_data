% Data is a Time by Measurement Dimension matrix
% state labels is the assignment of each data to its corresponding hidden
% state. It is a Time x 1 matrix
% num_states is the number of hidden states (we build one AR for each)
function [prob_each_state, coeffs, mean_squared_error] = expectation_maximize(data, num_states, degree, additional_info)
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
fitIntercept = true;
% force the computed MSE's of different states to not get too different.
% setting this to 0 makes it not exist
regularization_param = 0.00;
% magic parameter that decides how quickly we update the transition and init matrices
% setting this to 1 makes it not exist
update_size = .9;
% whether the transition dynamics of HMM are believed at all
trust_HMM = 0.2;
% up the MSE slightly to avoid problems when fit is perfect
mse_fudge = 0.0000001;

%% randomly initialize transition probabilities
[init, transition] = initialize_HMM(num_states);

total_time = size(data,1);
% randomly assign states
unscaled_prob_each_state = rand(total_time,num_states);
prob_each_state = unscaled_prob_each_state ./ sum(unscaled_prob_each_state,2);
first_run = true;

%%
for run_counter = 1:100
    %%
    % fit AR model
    [new_coeffs, new_mean_squared_error] = fit_AR_models(data, prob_each_state, num_states, degree, fitIntercept, additional_info);
    "running " + run_counter
    squeeze(new_mean_squared_error)
    squeeze(new_coeffs)
    % slowly update params
    if first_run
        coeffs = new_coeffs;
        mean_squared_error = new_mean_squared_error;
    end
    coeffs = new_coeffs * update_size + (1-update_size) * coeffs;
    mean_squared_error = (new_mean_squared_error + mse_fudge) * update_size + (1-update_size) * mean_squared_error;
    
    % artificially regularize the mean_squared_errors to avoid divergences.
    % (average each mean squared error toward the mean mean squared
    % error...you know?)
    mean_squared_error = (1-regularization_param) * mean_squared_error + regularization_param * sum(mean_squared_error)/num_states;
    
    % compute probability of emitting each value given AR model for each state
    [probs] = probability_of_value_per_state(data, coeffs, mean_squared_error, fitIntercept);
    
    % compute new init and transition and state assignments given baum-welch
    [new_init, new_transition, new_prob_each_state] = baum_welch(init, transition, probs);
    % slowly update params
    if first_run
        init = new_init;
        transition = new_transition;
        prob_each_state = new_prob_each_state;
    end
    init = new_init * update_size + (1-update_size) * init;
    transition = new_transition * update_size + (1-update_size) * transition;
    prob_each_state = new_prob_each_state * update_size + (1-update_size) * prob_each_state;
    
    
    prob_each_state = prob_each_state * trust_HMM + (1-trust_HMM) * probs;

    % plotting code
    clf;
    hold on
    for i = 1:num_states
        plot(new_prob_each_state(:,i))
    end
    plot(data)
    hold off
    pause(0.1);
    first_run = false;
end
hold on
for i = 1:num_states
    plot(new_prob_each_state(:,i))
end
plot(data)
hold off
end
