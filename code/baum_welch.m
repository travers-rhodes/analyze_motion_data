% INPUT
% init: initial probability of each state (num_states by 1 matrix)
% transition: transition probability of each state (num_states by
% num_states). column index is TO, row index if FROM (so if probabilities
% sum, you left multiply state * transition), per wikipedia.
% rows sum to 1.
% probs: the emission probability of the observed value, for each state 
% (time x num_states matrix). This is computed from the AR model or similar 
% data-dependent model. Normalized so that rows sum to one.
% OUTPUT:
% init: the input probability
% transition: the transition probabilities
% prob_each_state: the probability of each state label at each time
function [init, transition, prob_each_state] = baum_welch(init, transition, probs)
%% comment out (for testing out code while writing)
% num_states = 3;
% [init, transition] = initialize_HMM(num_states);
% init = [0.2,0.3,0.5]';
% transition = [[1,0,0];[0,1,0];[0,0,1]];
% time = 6;
% rng(0);
% probs = rand(time, num_states);
% probs_sum = sum(probs');
% probs = (probs' ./ probs_sum)';

%%
time = size(probs,1);
num_states = size(init,1);

% we use the baum_welch algorithm, saving off
% 1) the probability of arriving at that state and having seen all the
% previous observations
forward_prob_of_state = zeros(time, num_states);
% 2) Given we actually are at this state, what's the probability of 
% the actions ___after this state___ resulting in the observed sequence
backward_prob_of_state = zeros(time, num_states);

%% initialize the first column
forward_prob_of_state(1,:) = init' .* probs(1,:);

%%
for t = 2:time
    %%
    forward_prob_of_state(t, :) = probs(t,:) .* (forward_prob_of_state(t-1,:) * transition);
    % normalize to avoid NaN
    forward_prob_of_state(t, :) = forward_prob_of_state(t, :) / sum(forward_prob_of_state(t, :));
end

%% initialize the last column
backward_prob_of_state(time,:) = ones(1,num_states);
for t = time-1:-1:1
    %%
    backward_prob_of_state(t, :) = transition * (backward_prob_of_state(t+1,:) .* probs(t+1,:))';
    % normalize to avoid NaN
    backward_prob_of_state(t, :) = backward_prob_of_state(t, :) / sum(backward_prob_of_state(t, :));
end

%% Expected Number of times in state
% WE CAN COMPUTE THIS FROM THE MORE GRANULAR COUNT BELOW (commenting out
% since it's nice to have around as a sanity check on normalizations)
% prob_being_in_state is time by numstates
unscaled_prob_each_state = forward_prob_of_state .* backward_prob_of_state;
normalization_factor_prob_in_state = sum(unscaled_prob_each_state,2);
prob_each_state = unscaled_prob_each_state ./ normalization_factor_prob_in_state;
% since we only have transitions for times 1:(time-1), we also only want to
% count the number of times it hits states in 1:(time-1)
exp_count_in_state = sum(prob_each_state(1:(time-1),:),1);

%% Expected number of times going from each state to each other state
% row_index is FROM column_index is TO
transition_probs = zeros(time-1, num_states, num_states);

for t = 1:(time-1)
    % prob in row at time t times prob in column at time t+1
    transition_probs(t,:,:) = transition .* (forward_prob_of_state(t,:)' * (backward_prob_of_state(t+1,:) .* probs(t+1,:)));
    transition_probs(t,:,:) = transition_probs(t,:,:) / sum(sum(transition_probs(t,:,:),2),3);
end

% at each time it has to make some transition, so we sum over each time
% step and divide by that amount
transition_probs_sum = sum(sum(transition_probs,3),2);
normalized_transition_probs = transition_probs ./ transition_probs_sum;
exp_transition_count = reshape(sum(normalized_transition_probs,1),num_states,num_states);

%prob_each_state = reshape(sum(transition_probs,3),time-1,num_states);

init = prob_each_state(1,:)';
transition = exp_transition_count ./ exp_count_in_state';

end

