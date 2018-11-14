%% Generate 1D Data
% For this data set, imagine a head position that varies in a step function
% over time
% The bowl position is fixed
% The spoon travels like the sqrt of the remaining distance to its destination
% at each timestep or something like that, switching target every period
% length seconds
period = 20;
num_period = 50;
time = period*num_period;
additional_data = zeros(time,0);
pos = zeros(time,1);

indx = 1;
for perd = 1:num_period
    for pos_in_period = 1:period
        if indx == 1
            pos(indx) = 0;
        else
            if (pos_in_period < period/3)
                % heading down to 0.2
                pos(indx) = 0.5 * pos(indx-1) + 0.1;% + rand(1)* 0.001;
            else
                % heading up to 2
                pos(indx) = 0.9 * pos(indx-1) + 0.2;% + rand(1)* 0.001;
            end
        end
        indx = indx + 1;
    end
end

data = pos;

num_states = 2;
degree = 1;
    
[prob_each_state, coeffs, mean_squared_error] = expectation_maximize(data, num_states, degree,additional_data);

start = 0;
est_path = get_computed_path(start, coeffs, prob_each_state,additional_data);

clf;
hold on
plot(data)
plot(est_path)
hold off
