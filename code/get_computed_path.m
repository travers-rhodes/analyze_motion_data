function [path] = get_computed_path(start, coeffs, prob_states, time)
%%
path = zeros(time,size(start,2));

% assume we have an intercept
degree = size(coeffs,3) - 1;
num_states = size(prob_states,2);

for i = 1:degree
    for dim = 1:size(coeffs,2)
        path(i,dim) = start(i,dim);
    end
end

X = zeros(1,degree);

for i = (degree+1):time
    %[~, state] = max(prob_states(i,:));
    for dim = 1:size(coeffs,2)
        for deg = 1:degree
            X(1,deg) = path(i - deg, dim);
        end
        cofs = reshape(prob_states(i,:) * reshape(coeffs(:,dim,:),num_states,degree+1),degree+1,1);
        intcept = cofs(1);
        othercoefs = cofs(2:(degree+1));
        path(i,dim) = intcept + othercoefs * X';
    end
end