function [array] = find_and_replace(array,find_this, replacement)
%FIND_AND_REPLACE finds and replace all instances of a value in a vector
%   Detailed explanation goes here

for k = 1:length(array)
    if array(k) == find_this
        array(k) = replacement;
    end
end
end

