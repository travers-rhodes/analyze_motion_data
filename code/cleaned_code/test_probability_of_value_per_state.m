% removed most of the specific checks on probabilities after I switched
% from normpdf to tpdf
clear;
data = [1;2;3;4;];
coeffs = ones(1,1,1);
additional_info = zeros(4,0);
mean_squared_error = 1;
model_options.fitIntercept = true;
model_options.degree=0;
model_options.is_fit_to_frame = false;

%%%% t-dist residuals
residual_options.isGaussian = false;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
assert(abs(probs(1)-1) < eps)
assert(abs(probs(2)-1) < eps)
assert(abs(probs(3)-1) < eps)
assert(abs(probs(4)-1) < eps)

coeffs = ones(2,1,1);
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
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
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
% assert(abs(probs(1,1)-normpdf(0)/(normpdf(0) + normpdf(3))) < eps)
assert(abs(probs(1,1)-tpdf(0,3)/(tpdf(0,3) + tpdf(3*sqrt(3),3))) < eps)
% assert(abs(probs(2,1)-normpdf(1)/(normpdf(1) + normpdf(2))) < eps)
assert(abs(probs(2,1)-tpdf(1*sqrt(3),3)/(tpdf(1*sqrt(3),3) + tpdf(2*sqrt(3),3))) < eps)
% assert(abs(probs(3,1)-(1-normpdf(1)/(normpdf(1) + normpdf(2)))) < eps)
assert(abs(probs(3,1)-tpdf(2*sqrt(3),3)/(tpdf(2*sqrt(3),3) + tpdf(1*sqrt(3),3))) < eps)
% assert(abs(probs(4,1)-(1-normpdf(0)/(normpdf(0) + normpdf(3)))) < eps)
assert(abs(probs(4,1)-tpdf(3*sqrt(3),3)/(tpdf(3*sqrt(3),3) + tpdf(0*sqrt(3),3))) < eps)
% assert(abs(probs(1,2)-(1-normpdf(0)/(normpdf(0) + normpdf(3)))) < eps)
assert(abs(probs(1,2)-tpdf(3*sqrt(3),3)/(tpdf(3*sqrt(3),3) + tpdf(0*sqrt(3),3))) < eps)
% assert(abs(probs(2,2)-(1-normpdf(1)/(normpdf(1) + normpdf(2)))) < eps)
assert(abs(probs(2,2)-tpdf(2*sqrt(3),3)/(tpdf(2*sqrt(3),3) + tpdf(1*sqrt(3),3))) < eps)
% assert(abs(probs(3,2)-normpdf(1)/(normpdf(1) + normpdf(2))) < eps)
assert(abs(probs(3,2)-tpdf(1*sqrt(3),3)/(tpdf(1*sqrt(3),3) + tpdf(2*sqrt(3),3))) < eps)
% assert(abs(probs(4,2)-normpdf(0)/(normpdf(0) + normpdf(3))) < eps)
assert(abs(probs(4,2)-tpdf(0,3)/(tpdf(0,3) + tpdf(3*sqrt(3),3))) < eps)

coeffs = ones(2,1,1);
mean_squared_error = [1;2^2];
coeffs(2) = 4;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
% assert(abs(probs(1,1)-normpdf(0)/(normpdf(0) + normpdf(3/2)/2)) < eps)
assert(abs(probs(1,1)-tpdf(0,3)/(tpdf(0,3) + tpdf(3/2*sqrt(3),3)/2)) < eps)
% assert(abs(probs(2,1)-normpdf(1)/(normpdf(1) + normpdf(2/2)/2)) < eps)
assert(abs(probs(2,1)-tpdf(1*sqrt(3),3)/(tpdf(1*sqrt(3),3) + tpdf(2/2*sqrt(3),3)/2)) < eps)
% assert(abs(probs(3,1)-normpdf(2)/(normpdf(2) + normpdf(1/2)/2)) < eps)
assert(abs(probs(3,1)-tpdf(2*sqrt(3),3)/(tpdf(2*sqrt(3),3) + tpdf(1/2*sqrt(3),3)/2)) < eps)
% assert(abs(probs(4,1)-normpdf(3)/(normpdf(3) + normpdf(0)/2)) < eps)
assert(abs(probs(4,1)-tpdf(3*sqrt(3),3)/(tpdf(3*sqrt(3),3) + tpdf(0*sqrt(3),3)/2)) < eps)
% assert(abs(probs(1,2)-normpdf(3/2)/2/(normpdf(3/2)/2 + normpdf(0))) < eps)
assert(abs(probs(1,2)-tpdf(3/2*sqrt(3),3)/2/(tpdf(3/2*sqrt(3),3)/2 + tpdf(0*sqrt(3),3))) < eps)
% assert(abs(probs(2,2)-normpdf(2/2)/2/(normpdf(2/2)/2 + normpdf(1))) < eps)
assert(abs(probs(2,2)-tpdf(2/2*sqrt(3),3)/2/(tpdf(2/2*sqrt(3),3)/2 + tpdf(1*sqrt(3),3))) < eps)
% assert(abs(probs(3,2)-normpdf(1/2)/2/(normpdf(1/2)/2 + normpdf(2))) < eps)
assert(abs(probs(3,2)-tpdf(1/2*sqrt(3),3)/2/(tpdf(1/2*sqrt(3),3)/2 + tpdf(2*sqrt(3),3))) < eps)
% assert(abs(probs(4,2)-normpdf(0/2)/2/(normpdf(0/2)/2 + normpdf(3))) < eps)
assert(abs(probs(4,2)-tpdf(0,3)/2/(tpdf(0,3)/2 + tpdf(3*sqrt(3),3))) < eps)

% making sure that for t distribution we still handle things even really
% far from distribution (ie: confirm _not_ equal to 0.5)
coeffs = ones(2,1,1);
mean_squared_error = [10^(-50);10^(-50)];
coeffs(2) = 4;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
assert(abs(probs(1,1)-1) < eps)
% assert(abs(probs(2,1)-.5) < eps)
assert(abs(probs(2,1)-.5) > eps)
% assert(abs(probs(3,1)-.5) < eps)
assert(abs(probs(3,1)-.5) > eps)
assert(abs(probs(4,1)-0) < eps)
assert(abs(probs(1,2)-0) < eps)
% assert(abs(probs(2,2)-.5) < eps)
assert(abs(probs(2,2)-.5) > eps)
% assert(abs(probs(3,2)-.5) < eps)
assert(abs(probs(3,2)-.5) > eps)
assert(abs(probs(4,2)-1) < eps)


% making sure no NaN when really, really far from all predictions
coeffs = ones(2,1,1);
mean_squared_error = [10^(-252);10^(-252)];
coeffs(2) = 4;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
assert(abs(probs(1,1)-1) < eps)
assert(abs(probs(2,1)-.5) < eps)
assert(abs(probs(3,1)-.5) < eps)
assert(abs(probs(4,1)-0) < eps)
assert(abs(probs(1,2)-0) < eps)
assert(abs(probs(2,2)-.5) < eps)
assert(abs(probs(3,2)-.5) < eps)
assert(abs(probs(4,2)-1) < eps)



%% Gaussian Residuals
clear;
data = [1;2;3;4;];
coeffs = ones(1,1,1);
additional_info = zeros(4,0);
mean_squared_error = 1;
model_options.fitIntercept = true;
model_options.degree=0;
model_options.is_fit_to_frame = false;

%%%% gaussian residuals
residual_options.isGaussian = true;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
assert(abs(probs(1)-1) < eps)
assert(abs(probs(2)-1) < eps)
assert(abs(probs(3)-1) < eps)
assert(abs(probs(4)-1) < eps)

coeffs = ones(2,1,1);
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
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
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
assert(abs(probs(1,1)-normpdf(0)/(normpdf(0) + normpdf(3))) < eps)
% assert(abs(probs(1,1)-tpdf(0,3)/(tpdf(0,3) + tpdf(3*sqrt(3),3))) < eps)
assert(abs(probs(2,1)-normpdf(1)/(normpdf(1) + normpdf(2))) < eps)
% assert(abs(probs(2,1)-tpdf(1*sqrt(3),3)/(tpdf(1*sqrt(3),3) + tpdf(2*sqrt(3),3))) < eps)
assert(abs(probs(3,1)-(1-normpdf(1)/(normpdf(1) + normpdf(2)))) < eps)
% assert(abs(probs(3,1)-tpdf(2*sqrt(3),3)/(tpdf(2*sqrt(3),3) + tpdf(1*sqrt(3),3))) < eps)
assert(abs(probs(4,1)-(1-normpdf(0)/(normpdf(0) + normpdf(3)))) < eps)
% assert(abs(probs(4,1)-tpdf(3*sqrt(3),3)/(tpdf(3*sqrt(3),3) + tpdf(0*sqrt(3),3))) < eps)
assert(abs(probs(1,2)-(1-normpdf(0)/(normpdf(0) + normpdf(3)))) < eps)
% assert(abs(probs(1,2)-tpdf(3*sqrt(3),3)/(tpdf(3*sqrt(3),3) + tpdf(0*sqrt(3),3))) < eps)
assert(abs(probs(2,2)-(1-normpdf(1)/(normpdf(1) + normpdf(2)))) < eps)
% assert(abs(probs(2,2)-tpdf(2*sqrt(3),3)/(tpdf(2*sqrt(3),3) + tpdf(1*sqrt(3),3))) < eps)
assert(abs(probs(3,2)-normpdf(1)/(normpdf(1) + normpdf(2))) < eps)
% assert(abs(probs(3,2)-tpdf(1*sqrt(3),3)/(tpdf(1*sqrt(3),3) + tpdf(2*sqrt(3),3))) < eps)
assert(abs(probs(4,2)-normpdf(0)/(normpdf(0) + normpdf(3))) < eps)
% assert(abs(probs(4,2)-tpdf(0,3)/(tpdf(0,3) + tpdf(3*sqrt(3),3))) < eps)

coeffs = ones(2,1,1);
mean_squared_error = [1;2^2];
coeffs(2) = 4;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
assert(abs(probs(1,1)-normpdf(0)/(normpdf(0) + normpdf(3/2)/2)) < eps)
% assert(abs(probs(1,1)-tpdf(0,3)/(tpdf(0,3) + tpdf(3/2*sqrt(3),3)/2)) < eps)
assert(abs(probs(2,1)-normpdf(1)/(normpdf(1) + normpdf(2/2)/2)) < eps)
% assert(abs(probs(2,1)-tpdf(1*sqrt(3),3)/(tpdf(1*sqrt(3),3) + tpdf(2/2*sqrt(3),3)/2)) < eps)
assert(abs(probs(3,1)-normpdf(2)/(normpdf(2) + normpdf(1/2)/2)) < eps)
% assert(abs(probs(3,1)-tpdf(2*sqrt(3),3)/(tpdf(2*sqrt(3),3) + tpdf(1/2*sqrt(3),3)/2)) < eps)
assert(abs(probs(4,1)-normpdf(3)/(normpdf(3) + normpdf(0)/2)) < eps)
% assert(abs(probs(4,1)-tpdf(3*sqrt(3),3)/(tpdf(3*sqrt(3),3) + tpdf(0*sqrt(3),3)/2)) < eps)
assert(abs(probs(1,2)-normpdf(3/2)/2/(normpdf(3/2)/2 + normpdf(0))) < eps)
% assert(abs(probs(1,2)-tpdf(3/2*sqrt(3),3)/2/(tpdf(3/2*sqrt(3),3)/2 + tpdf(0*sqrt(3),3))) < eps)
assert(abs(probs(2,2)-normpdf(2/2)/2/(normpdf(2/2)/2 + normpdf(1))) < eps)
% assert(abs(probs(2,2)-tpdf(2/2*sqrt(3),3)/2/(tpdf(2/2*sqrt(3),3)/2 + tpdf(1*sqrt(3),3))) < eps)
assert(abs(probs(3,2)-normpdf(1/2)/2/(normpdf(1/2)/2 + normpdf(2))) < eps)
% assert(abs(probs(3,2)-tpdf(1/2*sqrt(3),3)/2/(tpdf(1/2*sqrt(3),3)/2 + tpdf(2*sqrt(3),3))) < eps)
assert(abs(probs(4,2)-normpdf(0/2)/2/(normpdf(0/2)/2 + normpdf(3))) < eps)
% assert(abs(probs(4,2)-tpdf(0,3)/2/(tpdf(0,3)/2 + tpdf(3*sqrt(3),3))) < eps)

% making sure that for t distribution we still handle things even really
% far from distribution (ie: confirm _not_ equal to 0.5)
coeffs = ones(2,1,1);
mean_squared_error = [10^(-50);10^(-50)];
coeffs(2) = 4;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
assert(abs(probs(1,1)-1) < eps)
assert(abs(probs(2,1)-.5) < eps)
% assert(abs(probs(2,1)-.5) > eps)
assert(abs(probs(3,1)-.5) < eps)
% assert(abs(probs(3,1)-.5) > eps)
assert(abs(probs(4,1)-0) < eps)
assert(abs(probs(1,2)-0) < eps)
assert(abs(probs(2,2)-.5) < eps)
% assert(abs(probs(2,2)-.5) > eps)
assert(abs(probs(3,2)-.5) < eps)
% assert(abs(probs(3,2)-.5) > eps)
assert(abs(probs(4,2)-1) < eps)


% making sure no NaN when really, really far from all predictions
coeffs = ones(2,1,1);
mean_squared_error = [10^(-252);10^(-252)];
coeffs(2) = 4;
probs = probability_of_value_per_state(data, additional_info, coeffs, mean_squared_error, model_options,residual_options);
assert(abs(probs(1,1)-1) < eps)
assert(abs(probs(2,1)-.5) < eps)
assert(abs(probs(3,1)-.5) < eps)
assert(abs(probs(4,1)-0) < eps)
assert(abs(probs(1,2)-0) < eps)
assert(abs(probs(2,2)-.5) < eps)
assert(abs(probs(3,2)-.5) < eps)
assert(abs(probs(4,2)-1) < eps)