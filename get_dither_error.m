function [errors] = get_dither_error(target,actual_value)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

err_diff = target - actual_value;
% This err_diff should be distrubuted additively to the neighbouring pixels
errors = zeros(1,4);
end

