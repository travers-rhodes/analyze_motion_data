% note: this test assumes we're using a BIASED mean_squared_error
% estimate
eps = 10e-10;
prob_each_state = ones(4,1);
num_states = 1;
additional_info = zeros(4,0);
model_options.fitIntercept = true;
model_options.degree = 0;
model_options.is_fit_to_frame = false;

x = [[1];[2];[3];[4]];
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
assert(abs(coeffs(1,1,1)-2.5) < eps)
assert(abs(mean_squared_error - (1.5^2 + 0.5^2) * 2 / 4) < eps);

clear;
eps = 10e-10;
prob_each_state = [[1,0];[1,0];[0,1];[0,1]];
num_states = 2;
additional_info = zeros(4,0);
model_options.fitIntercept = true;
model_options.degree = 0;
model_options.is_fit_to_frame = false;
x = [[1];[2];[3];[4]];
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
assert(abs(coeffs(1,1,1)-1.5) < eps)
assert(abs(coeffs(2,1,1)-3.5) < eps)
assert(abs(mean_squared_error(1) - (0.5^2) * 2 / 2) < eps);
assert(abs(mean_squared_error(2) - (0.5^2) * 2 / 2) < eps);

clear;
eps = 10e-10;
x = [[1];[1];[1];[2]];
model_options.fitIntercept = true;
model_options.degree = 2;
model_options.is_fit_to_frame = true;
num_states = 2;

additional_info = [1;2;3;4];

prob_each_state = [[0.9,0.1];[0.9,0.1];[0.9,0.1];[0.9,0.1];];
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
assert(abs(coeffs(1,1,1) - 1.25) < eps);
assert(abs(coeffs(1,1,2) - 0) < eps);
assert(abs(coeffs(1,1,3) - 0) < eps);
assert(abs(coeffs(2,1,1) - 1.25) < eps);
assert(abs(coeffs(2,1,2) - 0) < eps);
assert(abs(coeffs(2,1,3) - 0) < eps);
assert(abs(mean_squared_error(1) - (0.25 ^ 2 * 3 + 0.75^2)/4) < eps);
assert(abs(mean_squared_error(2) - (0.25 ^ 2 * 3 + 0.75^2)/4) < eps);

additional_info = zeros(4,0);
model_options.fitIntercept = true;
model_options.degree = 2;
model_options.is_fit_to_frame = false;
num_states = 4;
prob_each_state = ones(4,4)/4;
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
assert(size(coeffs,1) == 4)
assert(size(coeffs,2) == 1)
assert(size(coeffs,3) == 3)

additional_info = zeros(4,1);
model_options.fitIntercept = true;
model_options.degree = 2;
model_options.is_fit_to_frame = false;
num_states = 4;
prob_each_state = ones(4,4)/4;
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
assert(size(coeffs,1) == 4)
assert(size(coeffs,2) == 1)
assert(size(coeffs,3) == 4)


additional_info = zeros(4,1);
model_options.fitIntercept = false;
model_options.degree = 2;
model_options.is_fit_to_frame = false;
num_states = 4;
prob_each_state = ones(4,4)/4;
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
assert(size(coeffs,1) == 4)
assert(size(coeffs,2) == 1)
assert(size(coeffs,3) == 3)



additional_info = zeros(4,1);
model_options.fitIntercept = false;
model_options.degree = 2;
model_options.is_fit_to_frame = false;
num_states = 4;
prob_each_state = ones(4,4)/4;
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
assert(size(coeffs,1) == 4)
assert(size(coeffs,2) == 1)
assert(size(coeffs,3) == 3)


x = [[1,1];[1,2];[1,3];[2,1]];
additional_info = zeros(4,1);
model_options.fitIntercept = false;
model_options.degree = 2;
model_options.is_fit_to_frame = false;
num_states = 3;
prob_each_state = ones(4,3)/3;
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
assert(size(coeffs,1) == 3)
assert(size(coeffs,2) == 2)
assert(size(coeffs,3) == 3)


%% test error throwing
clear;
model_options.fitIntercept = true;
model_options.degree = 2;
model_options.is_fit_to_frame = true;
num_states = 1;
x = [[1];[1];[1];[2];[3]];
prob_each_state = ones(5,1)/5;

additional_info = [1;2;3;4;5];
model_options.fitIntercept = false;
hitError = false;

try
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
catch e
    hitError = true;
    assert(contains(e.message, "intercept"))
end
assert(hitError == true)

model_options.fitIntercept = true;
additional_info = [[1;2;3;4;5],[1;2;3;4;5]];
hitError = false;
try
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
catch e
    hitError = true;
    assert(contains(e.message, "additional_info"))
end
assert(hitError == true)

model_options.fitIntercept = true;
num_states = 2;
additional_info = [1;2;3;4;5];
hitError = false;
try
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
catch e
    hitError = true;
    assert(contains(e.message, "num_states"))
end
assert(hitError == true)


clear;
eps = 10e-10;
x = [[1];[1];[1];[2]];
prob_each_state = [[1,0];[1,0];[1,0];[1,0]];
model_options.fitIntercept = true;
model_options.degree = 2;
model_options.is_fit_to_frame = true;
num_states = 2;

additional_info = [1;2;3;4];
try
[coeffs,mean_squared_error] = fit_AR_models(x, prob_each_state, num_states, additional_info, model_options);
catch e
    hitError = true;
    assert(contains(e.message, "no data"))
end
assert(hitError == true)
