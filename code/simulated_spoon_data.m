%% Generate 1D Data
% For this data set, imagine a head position that varies in a step function
% over time
% The bowl position is fixed
% The spoon travels like the sqrt of the remaining distance to its destination
% at each timestep or something like that, switching target every period
% length seconds
rng(0)
period = 100;
num_period = 10;
time = period*num_period;
head_pos = 6 + repelem(rand(num_period,1),period);
bowl_pos = repelem(3,time);

spoon_pos = zeros(time,1);

epsilon = 0.000000000001;

indx = 1;
for perd = 1:num_period
    for pos_in_period = 1:period
        if indx == 1
            spoon_pos(indx) = bowl_pos(indx);
        else
            if (pos_in_period < period/3)
                % heading to mouth
                target_dist = head_pos(indx) - spoon_pos(indx-1);
            else
                % heading to bowl
                target_dist = bowl_pos(indx) - spoon_pos(indx-1);
            end
            speed = min(sqrt(abs(target_dist))/3,abs(target_dist));
            if target_dist > epsilon
                direction = 1;
            elseif target_dist < -epsilon
                direction = -1;
            else
                direction = 0;
            end
            spoon_pos(indx) = spoon_pos(indx-1) + direction*speed;
        end
        indx = indx + 1;
    end
end
%spoon_pos = smoothdata(spoon_pos);

clf;
hold on
plot(spoon_pos);
hold off

data = spoon_pos;
env_data = head_pos;

num_states = 5;
degree = 1;

first_diff =  data(2:time,:) - data(1:(time-1),:);
additional_info = head_pos;
[prob_each_state, coeffs, mean_squared_error] = expectation_maximize(data, num_states, degree, additional_info);

start = data(1);
est_path = get_computed_path(start, coeffs, prob_each_state, additional_info);

clf;
hold on
plot(data)
plot(est_path)
hold off

% clf;
% hold on
% plot(cumsum(first_diff))
% plot(cumsum(est_path))
% hold off