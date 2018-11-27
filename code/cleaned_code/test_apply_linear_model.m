padded_data = [1;2;3;4];
coeffs = ones(1,1,1);
model_options.degree = 0;
model_options.fitIntercept = true;
model_options.is_fit_to_frame = false;
additional_info = zeros(4,0);
mean_squared_error = 10;
meas_var = 1;
[z_score, resid] = apply_linear_model(padded_data, additional_info, model_options, coeffs, mean_squared_error, meas_var);
assert(abs(resid(1)-0) < eps)
assert(abs(resid(2)-1) < eps)
assert(abs(resid(3)-2) < eps)
assert(abs(resid(4)-3) < eps)
assert(abs(z_score(1)-0) < eps)
assert(abs(z_score(2)-sqrt(0.1)) < eps)
assert(abs(z_score(3)-2 * sqrt(0.1)) < eps)

coeffs = ones(2,1,1);
coeffs(2,1,1) = 2;
model_options.num_states = 2;
[z_score, resid] = apply_linear_model(padded_data, additional_info, model_options, coeffs, mean_squared_error, meas_var);
assert(abs(resid(1,1)-0) < eps)
assert(abs(resid(2,1)-1) < eps)
assert(abs(resid(3,1)-2) < eps)
assert(abs(resid(4,1)-3) < eps)
assert(abs(resid(1,2)+1) < eps)
assert(abs(resid(2,2)-0) < eps)
assert(abs(resid(3,2)-1) < eps)
assert(abs(resid(4,2)-2) < eps)
assert(abs(z_score(1)-0) < eps)
assert(abs(z_score(2)-sqrt(0.1)) < eps)
assert(abs(z_score(3)-2 * sqrt(0.1)) < eps)
assert(abs(z_score(1,2)+sqrt(0.1)) < eps)
assert(abs(z_score(2,2)-0) < eps)
assert(abs(z_score(3,2)-sqrt(0.1)) < eps)

padded_data = [1;2;3;4];
model_options.degree = 1;
coeffs = ones(1,1,2);
model_options.num_states = 1;
[z_score, resid] = apply_linear_model(padded_data, additional_info, model_options, coeffs, mean_squared_error, meas_var);
assert(abs(resid(1,1)-0) < eps)
assert(abs(resid(2,1)-0) < eps)
assert(abs(resid(3,1)-0) < eps)
assert(abs(z_score(1)-0) < eps)
assert(abs(z_score(2)-0) < eps)
assert(abs(z_score(3)-0) < eps)

padded_data = [1;1;2;4];
model_options.degree = 1;
coeffs = ones(1,1,2);
model_options.num_states = 1;
[z_score, resid] = apply_linear_model(padded_data, additional_info, model_options, coeffs, mean_squared_error, meas_var);
assert(abs(resid(1,1)- -1) < eps)
assert(abs(resid(2,1)-0) < eps)
assert(abs(resid(3,1)-1) < eps)
assert(abs(z_score(1)+sqrt(0.1)) < eps)
assert(abs(z_score(2)-0) < eps)
assert(abs(z_score(3)-sqrt(0.1)) < eps)