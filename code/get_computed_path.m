function [path] = get_computed_path(start, coeffs, prob_states, additional_info)
%%
time = size(prob_states,1);
num_measurments = size(start,2);
path = zeros(time,num_measurments);
addl_info_count = size(additional_info,2);
% assume we have an intercept
degree = size(coeffs,3) - 1 - addl_info_count;
num_states = size(prob_states,2);

for i = 1:degree
    for dim = 1:num_measurments
        path(i,dim) = start(i,dim);
    end
end

X = zeros(1,degree + addl_info_count);

for i = (degree+1):time
    %[~, state] = max(prob_states(i,:));
    for dim = 1:size(coeffs,2)
        for deg = 1:degree
            X(1,deg) = path(i - deg, dim);
        end
        for extra = 1:addl_info_count
            X(1,degree + extra) = additional_info(i, extra);
        end
        cofs = reshape(prob_states(i,:) * reshape(coeffs(:,dim,:),num_states,degree + addl_info_count+1),addl_info_count + degree+1,1);
        intcept = cofs(1);
        othercoefs = cofs(2:(degree + addl_info_count +1));
        path(i,dim) = intcept + othercoefs' * X';
    end
end