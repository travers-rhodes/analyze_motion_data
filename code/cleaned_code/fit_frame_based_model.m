function [coeffs, mean_squared_error] = fit_frame_based_model(X, y, weights, frame_value, final_num_coeffs, meas_var)
    coeffs = zeros(1,1,final_num_coeffs);
    degree = size(X,2);
    
    lm_frame1 = fitlm(X,y,'Intercept',true, 'Weights', weights);
    shifted_y = y - frame_value;
    lm_frame2 = fitlm(X,shifted_y,'Intercept',true, 'Weights', weights);
    
    if (lm_frame1.MSE < lm_frame2.MSE)
      coeffs(1,1, 1:(degree + 1)) = lm_frame1.Coefficients.Estimate;
      mean_squared_error = lm_frame1.SSE/sum(weights);
    else
      coeffs(1, 1, 1:(degree + 1)) = lm_frame2.Coefficients.Estimate;
      coeffs(1, 1, degree + meas_var + 1) = 1;
      mean_squared_error = lm_frame2.SSE/sum(weights);
    end
end