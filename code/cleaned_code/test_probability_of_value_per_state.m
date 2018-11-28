clear;
data = [1;2;3;4;];
coeffs = ones(1,1,1);
additional_info = zeros(4,0);
mean_squared_error = 1;
model_options.fitIntercept = true;
model_options.degree=0;
model_options.is_fit_to_frame = false;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options);
assert(abs(probs(1)-1) < eps)
assert(abs(probs(2)-1) < eps)
assert(abs(probs(3)-1) < eps)
assert(abs(probs(4)-1) < eps)



coeffs = ones(2,1,1);
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options);
assert(abs(probs(1,1)-0.5) < eps)
assert(abs(probs(2,1)-0.5) < eps)
assert(abs(probs(3,1)-0.5) < eps)
assert(abs(probs(4,1)-0.5) < eps)
assert(abs(probs(1,2)-0.5) < eps)
assert(abs(probs(2,2)-0.5) < eps)
assert(abs(probs(3,2)-0.5) < eps)
assert(abs(probs(4,2)-0.5) < eps)

coeffs = ones(2,1,1);
mean_squared_error = [1;1];
coeffs(2) = 4;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options);
assert(abs(probs(1,1)-normpdf(0)/(normpdf(0) + normpdf(3))) < eps)
assert(abs(probs(2,1)-normpdf(1)/(normpdf(1) + normpdf(2))) < eps)
assert(abs(probs(3,1)-(1-normpdf(1)/(normpdf(1) + normpdf(2)))) < eps)
assert(abs(probs(4,1)-(1-normpdf(0)/(normpdf(0) + normpdf(3)))) < eps)
assert(abs(probs(1,2)-(1-normpdf(0)/(normpdf(0) + normpdf(3)))) < eps)
assert(abs(probs(2,2)-(1-normpdf(1)/(normpdf(1) + normpdf(2)))) < eps)
assert(abs(probs(3,2)-normpdf(1)/(normpdf(1) + normpdf(2))) < eps)
assert(abs(probs(4,2)-normpdf(0)/(normpdf(0) + normpdf(3))) < eps)

coeffs = ones(2,1,1);
mean_squared_error = [1;2^2];
coeffs(2) = 4;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options);
assert(abs(probs(1,1)-normpdf(0)/(normpdf(0) + normpdf(3/2)/2)) < eps)
assert(abs(probs(2,1)-normpdf(1)/(normpdf(1) + normpdf(2/2)/2)) < eps)
assert(abs(probs(3,1)-normpdf(2)/(normpdf(2) + normpdf(1/2)/2)) < eps)
assert(abs(probs(4,1)-normpdf(3)/(normpdf(3) + normpdf(0)/2)) < eps)
assert(abs(probs(1,2)-normpdf(3/2)/2/(normpdf(3/2)/2 + normpdf(0))) < eps)
assert(abs(probs(2,2)-normpdf(2/2)/2/(normpdf(2/2)/2 + normpdf(1))) < eps)
assert(abs(probs(3,2)-normpdf(1/2)/2/(normpdf(1/2)/2 + normpdf(2))) < eps)
assert(abs(probs(4,2)-normpdf(0/2)/2/(normpdf(0/2)/2 + normpdf(3))) < eps)

% making sure no NaN when really far from all predictions
coeffs = ones(2,1,1);
mean_squared_error = [10^(-52);10^(-52)];
coeffs(2) = 4;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options);
assert(abs(probs(1,1)-1) < eps)
assert(abs(probs(2,1)-.5) < eps)
assert(abs(probs(3,1)-.5) < eps)
assert(abs(probs(4,1)-0) < eps)
assert(abs(probs(1,2)-0) < eps)
assert(abs(probs(2,2)-.5) < eps)
assert(abs(probs(3,2)-.5) < eps)
assert(abs(probs(4,2)-1) < eps)