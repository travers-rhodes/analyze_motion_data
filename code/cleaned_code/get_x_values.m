function X = get_x_values(padded_data, additional_info, raw_data_indices, meas_var, model_options)
    addl_info_count = size(additional_info,2);
    padded_data_indices =  raw_data_indices + model_options.degree;
    x_width = model_options.degree;
    if ~model_options.is_fit_to_frame
        x_width = x_width + addl_info_count;
    end
    % pre-allocate X for speed
    X = zeros(size(padded_data_indices,1),x_width);
    % fill in X based on previous values
    for deg = 1:model_options.degree
        X(:,deg) = padded_data(padded_data_indices - deg, meas_var);
    end
    if ~model_options.is_fit_to_frame
        % continue filling in X based on additional_info param
        for extra = 1:addl_info_count
            X(:,model_options.degree + extra) = additional_info(raw_data_indices,extra);
        end
    end
end