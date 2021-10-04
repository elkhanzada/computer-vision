function [reconstructed_image,best_ncc_1,best_ncc_2,x1,y1,x2,y2] = bonus_task(image_path)
    image = imread(image_path);
    image = double(image);
    [h,w] = size(image);
    h = int64(h/3);
    blue_channel = image(1:h-1,1:w);
    green_channel = image(h:2*h-2,1:w);
    red_channel = image(2*h-1:h*3-3,1:w);
    % Scaling down 3 times would be sufficient.
    [best_ncc_1,x1,y1] = pyramid(red_channel,green_channel,3);
    [best_ncc_2,x2,y2] = pyramid(red_channel,blue_channel,3);
    blue_channel = circshift(blue_channel,[x2,y2]);
    green_channel = circshift(green_channel,[x1,y1]);
    reconstructed_image = uint16(cat(3,red_channel,green_channel,blue_channel));