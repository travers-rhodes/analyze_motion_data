% num_states gives the number of states in the HMM
% we return Init (a num_states,1) matrix and
% the Transition matrix (num_states by num_states)
% each defaulted to reasonable, uniform, values
function [Init, Transition] = initialize_HMM(num_states)
    regularization = 0.1;
    Transition = (1-regularization)*eye(num_states) + regularization * ones(num_states)/num_states;
    Init = ones(num_states,1)/num_states;
end