function [colour] = pixel_dither(target)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
WHITE = 1;
BLACK = 0;

colour = BLACK;
if target > 127
    colour = WHITE;
end

end

