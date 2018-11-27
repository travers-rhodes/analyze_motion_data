eps = 0.00000000001;
x = [[1,1];[1,2];[1,3];[2,4]];
y = [[1;2;3;5]];
weights = [[1;1;1;1]];
coeffs = zeros(5,4,3);
[coeffs(2,2,:),mean_squared_error] = fit_linear_model(x,y,weights,true);
assert(coeffs(1,1,1) == 0);
assert(abs(coeffs(2,2,1) - -1) < eps);
assert(abs(coeffs(2,2,2) - 1) < eps);
assert(abs(coeffs(2,2,3) - 1) < eps);
assert(abs(mean_squared_error) < eps);

coeffs = zeros(5,4,2);
[coeffs(2,2,:),mean_squared_error] = fit_linear_model(x,y,weights,false);
assert(coeffs(1,1,1) == 0);
assert(abs(coeffs(2,2,1) - 2/7.0) < eps);
% note divide by two because dofs
assert(abs(mean_squared_error - ((2/7)^2 * 3 + (3/7)^2)/2) < eps);


coeffs = zeros(5,4,10);
final_num_coeffs = 10;
meas_var = 3;
frame_value = [[1;3;3;5]];
[coeffs(2,2,:),mean_squared_error] = fit_frame_based_model(x, y, weights, frame_value, final_num_coeffs, meas_var);
assert(abs(coeffs(2,2,1) - -1) < eps);
assert(abs(coeffs(2,2,2) - 1) < eps);
assert(abs(coeffs(2,2,3) - 1) < eps);
assert(abs(mean_squared_error) < eps);


x = [[1,1];[1,2];[1,3];[2,4];[2,2]];
y = [[1;2;3;5;5]];
weights = [[1;1;1;1;1]];
coeffs = zeros(5,4,3);
[coeffs(2,2,:),mean_squared_error] = fit_linear_model(x,y,weights,true);
assert(coeffs(1,1,1) == 0);
assert(abs(coeffs(2,2,1) - -1.5) < eps);
assert(abs(coeffs(2,2,2) - 2.5) < eps);
assert(abs(coeffs(2,2,3) - 0.5) < eps);
assert(abs(mean_squared_error - 0.5) < eps);


coeffs = zeros(5,4,10);
frame_value = [[1;2;3;4;5]];
[coeffs(2,2,:),mean_squared_error] = fit_frame_based_model(x, y, weights, frame_value, final_num_coeffs, meas_var);
assert(abs(coeffs(2,2,1) - -0.75) < eps);
assert(abs(coeffs(2,2,2) - 0.25) < eps);
assert(abs(coeffs(2,2,3) - 0.25) < eps);
assert(abs(mean_squared_error - 0.1250) < eps);

y = [[0;0;0;1;0;]];
coeffs = zeros(5,4,3);
[coeffs(2,2,:),mean_squared_error] = fit_linear_model(x,y,weights,true);
assert(abs(coeffs(2,2,1) - -0.75) < eps);
assert(abs(coeffs(2,2,2) - 0.25) < eps);
assert(abs(coeffs(2,2,3) - 0.25) < eps);
assert(abs(mean_squared_error - 0.1250) < eps);
