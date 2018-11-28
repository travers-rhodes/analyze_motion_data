%% properties we want rescale weights to have
% binary in should give binary out
weights = [1,0,1,0,1];
new_weights = rescale_weights(weights);
assert(all(abs(weights - new_weights) < eps));

weights = [1.0,1.0,0.0,0.0];
new_weights = rescale_weights(weights);
assert(all(abs(weights - new_weights) < eps));

weights = [[1;1;1;1]];
new_weights = rescale_weights(weights);
assert(all(abs(weights - new_weights) < eps));

weights = [[0;0;0;0;]];
new_weights = rescale_weights(weights);
assert(all(abs(weights - new_weights) < eps));

weights = zeros(10000,1);
weights(1) = 1;
new_weights = rescale_weights(weights);
assert(all(abs(weights - new_weights) < eps));

% constant value should return same value
weights = ones(10,1)/10;
new_weights = rescale_weights(weights);
assert(all(abs(weights - new_weights) < eps));

weights = [0.11,0.16,0.26,0.27,0.3];
new_weights = rescale_weights(weights);
