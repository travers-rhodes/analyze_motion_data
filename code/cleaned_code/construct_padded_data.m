function padded_data = construct_padded_data(data, degree)
    measurement_dimension = size(data,2);
    padded_data = [zeros(degree, measurement_dimension); data];
    for i = 1:degree
        padded_data(i,:) = data(degree+1,:);
    end
end