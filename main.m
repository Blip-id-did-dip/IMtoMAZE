image_path = 'images\flower.jpg';
image = imread(image_path);


rs_image = imresize(image,[100,100]);

gray_image = rgb2gray(rs_image);

bw_image = dither(gray_image);

figure(1)
imshow(bw_image)
maze_image = bw_image;

%Intent is to use a version of Ellers alogrithm to locate and then resolve
%areas of the maze that generate issues

num_rows = size(maze_image,1);
num_cols = size(maze_image,2);

region_map = zeros(size(maze_image));

region_num = 1;

% This is currently a primitive version that will prevent loops but will
% not ensure all areas are connected

for y_ind= 1:num_cols
    for x_ind=1:num_rows
        if maze_image(x_ind,y_ind) == 0
            continue
        end
        
        left_region = 0;
        top_region = 0;
        diag_region = 0;
        if x_ind > 1
            left_region = region_map(x_ind-1,y_ind);
        end
        if y_ind >1
            top_region = region_map(x_ind,y_ind-1);
        end
        if x_ind >1 && y_ind>1 
            diag_region = region_map(x_ind-1,y_ind-1);
        end
        
        if left_region ==0 && top_region == 0
            region_num = region_num +1;
            region_map(x_ind,y_ind) = region_num;
        elseif left_region == 0 || top_region == 0
            region_map(x_ind,y_ind) = top_region + left_region;
        elseif top_region == left_region && top_region ~= diag_region
            maze_image(x_ind,y_ind) = 0;
        else
            %we must merge the two regions together
            region_map(x_ind,y_ind) = left_region;
            for corY_ind = 1:y_ind
                for corX_ind = 1:num_rows
                    if region_map(corX_ind,corY_ind) == top_region
                        region_map(corX_ind,corY_ind) = left_region;
                    end
                end
            end
        end
        
        
    end
end

figure(2)
imshow(maze_image)