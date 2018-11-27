data = [[1,3];[1,2];[1,3];[2,4];[2,2]];
padded_dat = construct_padded_data(data, 2);
assert(size(padded_dat,1) == 7);
assert(size(padded_dat,2) == 2);
assert(padded_dat(1,1) == 1);
assert(padded_dat(1,2) == 3);
assert(padded_dat(2,1) == 1);
assert(padded_dat(2,2) == 3);
assert(padded_dat(3,1) == 1);
assert(padded_dat(3,2) == 3);
assert(padded_dat(4,1) == 1);
assert(padded_dat(4,2) == 2);


additional_info = zeros(7,0);
raw_data_indices = [1;3;5];
meas_var = 2;
model_options.degree = 2;
model_options.is_fit_to_frame = false;
x = get_x_values(padded_dat, additional_info, raw_data_indices, meas_var, model_options);
assert(size(x,1) == 3);
assert(size(x,2) == 2);
assert(x(1,1) == data(1,2))
assert(x(2,1) == data(2,2))
assert(x(3,1) == data(4,2))
assert(x(1,2) == data(1,2))
assert(x(2,2) == data(1,2))
assert(x(3,2) == data(3,2))

model_options.degree = 2;
model_options.is_fit_to_frame = true;
x = get_x_values(padded_dat, additional_info, raw_data_indices, meas_var, model_options);
assert(size(x,1) == 3);
assert(size(x,2) == 2);
assert(x(1,1) == data(1,2))
assert(x(2,1) == data(2,2))
assert(x(3,1) == data(4,2))
assert(x(1,2) == data(1,2))
assert(x(2,2) == data(1,2))
assert(x(3,2) == data(3,2))


model_options.is_fit_to_frame = true;
additional_info = [1;2;3;4;5];
x = get_x_values(padded_dat, additional_info, raw_data_indices, meas_var, model_options);
assert(size(x,1) == 3);
assert(size(x,2) == 2);
assert(x(1,1) == data(1,2))
assert(x(2,1) == data(2,2))
assert(x(3,1) == data(4,2))
assert(x(1,2) == data(1,2))
assert(x(2,2) == data(1,2))
assert(x(3,2) == data(3,2))

model_options.is_fit_to_frame = false;
additional_info = [1;2;3;4;5];
x = get_x_values(padded_dat, additional_info, raw_data_indices, meas_var, model_options);
assert(size(x,1) == 3);
assert(size(x,2) == 3);
assert(x(1,1) == data(1,2))
assert(x(2,1) == data(2,2))
assert(x(3,1) == data(4,2))
assert(x(1,2) == data(1,2))
assert(x(2,2) == data(1,2))
assert(x(3,2) == data(3,2))
assert(x(1,3) == additional_info(1,1))
assert(x(2,3) == additional_info(3,1))
assert(x(3,3) == additional_info(5,1))
