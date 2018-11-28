function [new_weights] = rescale_weights(weights)
    %weights = smoothdata(weights);
    std_weight = std(weights);
   	mean_weight = mean(weights);
    if (std_weight < 0.00000001)
       new_weights = ones(size(weights)) * mean_weight;
       return;
    end
    constant_scaling_parameter = 10;
    dynamic_scaling_parameter = 0.5;
    relative_scaling = 0.5;
    expansion_factor = max(relative_scaling * constant_scaling_parameter +...
        (1-relative_scaling) * 1/std_weight*dynamic_scaling_parameter,constant_scaling_parameter);
    weights = (weights - mean_weight)* expansion_factor + mean_weight;
    
    % cap above at 1 and below at 0
    shift_down = 1 - weights;
    weights = (1 + weights - abs(shift_down))/2;
    weights = (weights + abs(weights))/2;
    
    new_weights = weights;
end