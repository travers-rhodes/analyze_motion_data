function [coeffs, mean_squared_error] = fit_linear_model(X, y, weights, fitIntercept)
    final_num_coeffs = size(X,2);
    if (fitIntercept)
        final_num_coeffs = final_num_coeffs + 1;
    end
    coeffs = zeros(1,1,final_num_coeffs);
    
    lm = fitlm(X,y,'Intercept', fitIntercept, 'Weights', weights);
    coeffs(1, 1, :) = lm.Coefficients.Estimate;
    mean_squared_error = lm.MSE;
end