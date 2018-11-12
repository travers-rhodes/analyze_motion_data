function [init, transition] = compute_new_HMM_params(state_labels, init, transition)

max_state_label = max(state_labels);
transition_counts = zeros(max_state_label);

for t = 2:size(state_labels,1)
    transition_counts(state_labels(t-1),state_labels(t)) = ...
        transition_counts(state_labels(t-1),state_labels(t)) + 1;
end

% this is made up: average the current init and the new estimate
new_est_init = zeros(size(init));
new_est_init(state_labels(1)) = 1;
init = (new_est_init + init)/2;

% this is also made up:
% update the transition probabilities (avg old and new) only if there is data.
% otherwise, use old transition probabilities.

for r = 1:max_state_label
    num_samples = sum(transition_counts(r,:));
    if num_samples > 0
        transition(r,:) = (transition(r,:) + transition_counts(r,:)/num_samples)/2;
    end
end

end