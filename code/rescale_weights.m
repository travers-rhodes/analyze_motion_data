function [new_weights] = rescale_weights(weights)
    %weights = smoothdata(weights);
    std_weight = std(weights);
   	mean_weight = mean(weights);
    weights = (weights - mean_weight)/(2*std_weight) + 0.5;
    shift_down = 1 - weights;
    weights = weights - abs(shift_down);
    weights = weights + abs(weights);
    weights = weights.^8.0;
    new_weights = weights / sum(weights);
end