function [new_weights] = rescale_weights(weights)
    %weights = smoothdata(weights);
    std_weight = std(weights) + 0.0000001;
   	mean_weight = mean(weights);
    weights = (weights - mean_weight)/(std_weight) + 0.5;
    shift_down = 1 - weights;
    weights = (1 + weights - abs(shift_down))/2;
    weights = (weights + abs(weights) + 0.03)/2;
    weights = weights.^4.0;
    new_weights = weights / (sum(weights) + 0.0000001);
end