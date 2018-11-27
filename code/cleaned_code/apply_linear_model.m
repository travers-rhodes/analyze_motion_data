function [z_score, resid_y] = apply_linear_model(padded_data, additional_info, model_options, coeffs, mean_squared_error, meas_var)
    num_states = size(coeffs,1);
    addl_info_count = size(additional_info,2);
    degree = model_options.degree;
    time = size(padded_data,1) - degree;
    padded_time_indices = (1:time) + degree;
    y = padded_data(padded_time_indices, meas_var);
    X = get_x_values(padded_data, additional_info, (1:time), meas_var, model_options);
    
    if model_options.fitIntercept
        non_int_coeff_vals = coeffs(:, meas_var, 2:end);
    else
        non_int_coeff_vals = coeffs(:, meas_var, :);
    end
    non_int_coeff_vals = reshape(non_int_coeff_vals,[num_states, degree + addl_info_count]);
    if model_options.fitIntercept
        intercept = coeffs(:, meas_var, 1)';
        pred_y = (non_int_coeff_vals * X')' + intercept;
    else
        pred_y = (non_int_coeff_vals * X')';
    end
    resid_y = y - pred_y;
    z_score = resid_y ./ sqrt(mean_squared_error(:,meas_var))';
end