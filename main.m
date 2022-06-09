image_path = 'images\flower.jpg';
image = imread(image_path);


rs_image = imresize(image,[100,200]);

gray_image = rgb2gray(rs_image);

bw_image = dither(gray_image);

figure(1)
imshow(bw_image)

maze_image = zeros(size(gray_image),'logical');
error_image = zeros(size(gray_image));

%Intent is to use a version of Ellers alogrithm to locate and then resolve
%areas of the maze that generate issues

num_rows = size(maze_image,1);
num_cols = size(maze_image,2);

% The region lists tell which regions are currently being considered by the
% algorithm. So if the maze currently has 3 distinct partitions, the
% current region list will contain 3 non-zero entries

old_region_list = zeros(size(maze_image,1),1);
current_region_list = zeros(size(old_region_list));

% Region info tells what regions the pixels in the current two rows belong
% to
old_row_info = zeros(size(maze_image,1)+ 1,1);
current_row_info = zeros(size(maze_image,1)+1,1);


region_num = 1;

% This is currently a primitive version that will prevent loops but will
% not ensure all areas are connected

WHITE = 1;
BLACK = 0;
for y_ind= 1:num_cols
    for x_ind=1:num_rows
        
        % C A
        % B D <-- We are determining the pixel in region D
        
        region_A = old_row_info(x_ind+1);
        region_C = old_row_info(x_ind);
        region_B = current_row_info(x_ind);
        region_D = 0;
        pixel = BLACK;
        
        if region_A == BLACK
            % Black or White possible
            pixel = pixel_dither(gray_image(x_ind,y_ind));
            
            if pixel == BLACK
                region_D = 0;
            elseif region_B ~= BLACK
                % If region_B is white and this pixel is set white, set the
                % region value of D to match region_B
                region_D = region_B;
            else
                % If region B is black and this pixel is set white, a new
                % region is made
                region_D = get_next_region(old_region_list, current_region_list);
            end
            
        elseif region_B == BLACK
            if old_region_list(region_A) == x_ind
                % This is the last opportunity to continue region A
                % This pixel must be white
                % Since region_A is white, set region_D to region_A
                
                pixel = WHITE;
                region_D = region_A;
                
                
            else
                % pixel can be either colour
                pixel = pixel_dither(gray_image(x_ind,y_ind));
                % If setting to white, set region_D to region_A
                if pixel == WHITE
                    region_D = region_A;
                else
                    region_D = 0 ;
                end
            end
        else
            if region_A == region_B && region_A ~= region_C
                % Pixel must be black to prevent creating a loop
                pixel = BLACK;
                region_D = 0;
            else
                if old_region_list(region_A) == x_ind
                    % This is the last opportunity to continue region A
                    % This pixel must be white
                    % Since region_A is white, set region_D to region_A
                    
                    pixel = WHITE;
                    region_D = region_A;
                    % MERGE_REGION B into A
                    old_row_info = find_and_replace(old_row_info,region_B,region_A);
                    current_row_info = find_and_replace(current_row_info,region_B,region_A);
                    old_region_list(region_B) = 0;
                    current_region_list(region_B) = 0;
                    
                else
                    % Black or White possible
                    pixel = pixel_dither(gray_image(x_ind,y_ind));
                    % If set to white, then we set region_D to region_A and
                    % merge regions A and B
                    if pixel == WHITE
                        region_D = region_A;
                        % MERGE_REGION B into A
                        old_row_info = find_and_replace(old_row_info,region_B,region_A);
                        current_row_info = find_and_replace(current_row_info,region_B,region_A);
                        old_region_list(region_B) = 0;
                        current_region_list(region_B) = 0;
                    else
                        region_D = 0;
                    end
                end
                
                
                
            end
        end
        
        % update the current region list
        current_row_info(x_ind+1) = region_D;
        if region_D ~= BLACK
            old_region_list(region_D) = 0;
            current_region_list(region_D) = x_ind;
        end
        
        maze_image(x_ind,y_ind) = pixel;
        error = get_dither_error(gray_image(x_ind,y_ind), pixel*255);
        %Spread errors
        
    end
    old_region_list = current_region_list;
    old_row_info = current_row_info;
    current_row_info(1:end) = 0;
    current_region_list(1:end) = 0;
    
end

figure(2)
imshow(maze_image)