function [next_region] = get_next_region(old_region_list,current_region_list)
%GET_NEXT_REGION Returns the next region not currently in use
%   Detailed explanation goes here

num_regions = length(old_region_list);
next_region = -1;

for value = 1:num_regions
    if old_region_list(value) ==0 && current_region_list(value)==0
        next_region = value;
        return
    end
end

end

