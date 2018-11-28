function [new_weights] = rescale_all_weights(weights)
new_weights = weights;
num_states = size(weights,2);

for state = 1:num_states
    nonzero_inds = (weights(:,state)~= 0);
    new_weights(nonzero_inds,state) = rescale_weights(weights(nonzero_inds,state));
end

end