% Data is a Time by Measurement Dimension matrix
% state labels is the assignment of each data to its corresponding hidden
% state. It is a Time x 1 matrix
% num_states is the number of hidden states (we build one AR for each)
% degree is the degree of the AR model
% coeffs_struct is a num_states by 
function [coeffs_mat] = fit_AR_models(data, state_labels, num_states, degree)
   

