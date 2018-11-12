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
% state_labels: the most probable state (length is time)
function [state_labels] = most_probable_states(init, transition, probs)
%% comment out (for testing out code while writing)
% num_states = 3;
% [init, transition] = initialize_HMM(num_states);
% % transition = [[1,0,0];[1,0,0];[1,0,0]];
% time = 10;
% probs = rand(time, num_states);
% probs_sum = sum(probs');
% probs = (probs' ./ probs_sum)';

%%
time = size(probs,1);
num_states = size(init,1);

% we use the viterbi algorithm, saving off
% 1) the maximum probability of arriving at that state
% 2) the previous state so that that max_prob is achieved.
max_prob_of_state = zeros(time, num_states);
% for the first row, the previous state is "0" (no prev state)
previous_state = zeros(time - 1, num_states);

%% initialize the first column
max_prob_of_state(1,:) = init' .* probs(1,:);

%%
for t = 2:time
    %%
    [maxval,ind] = max(transition .* max_prob_of_state(t-1,:)');
    max_prob_of_state(t, :) = probs(t,:) .* maxval;
    % normalize to avoid NaN
    max_prob_of_state(t, :) = max_prob_of_state(t, :) / sum(max_prob_of_state(t, :));
    previous_state(t,:) = ind;
end

state_labels = zeros(time, 1);
[~, ind] = max(max_prob_of_state(t,:));
state_labels(time) = ind;
% working backward, save off the most probable state path
for t = time:-1:2
    state_labels(t-1) = previous_state(t, state_labels(t));
end
end

