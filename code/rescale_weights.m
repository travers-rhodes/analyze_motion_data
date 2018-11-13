function [new_weights] = rescale_weights(weights)
    max_weight = max(weights);
    min_weight = min(weights);
    weights = (weights - min_weight)/(max_weight - min_weight);
    weights = weights.^1.0;
    new_weights = weights / sum(weights);
end