function [reconstructed_image,square_error,mean_error,max_error] = mosaic_task(good_image)
    mosaic_image = imread("mosaic\crayons_mosaic.bmp");
    original_image = imread("mosaic\crayons.jpg");
    original_image = double(original_image);
    original_red = original_image(:,:,1);
    original_green = original_image(:,:,2);
    original_blue = original_image(:,:,3);
    mosaic_image = double(mosaic_image);
    [h,w] = size(mosaic_image);
    red_mask = repmat([1 0; 0 0],h/2,w/2);
    green_mask = repmat([0 1; 1 0],h/2,w/2);
    blue_mask = repmat([0 0; 0 1],h/2,w/2);
    red_channel = mosaic_image.*red_mask;
    green_channel = mosaic_image.*green_mask;
    blue_channel = mosaic_image.*blue_mask;
    if good_image == true    
        red_filter = (1/4)*[1 2 1; 2 4 2; 1 2 1];
        green_filter = (1/4)*[0 1 0; 1 4 1; 0 1 0];
        blue_filter = (1/4)*[1 2 1; 2 4 2; 1 2 1];
    else
        red_filter = (1/4)*[1 0 1; 0 0 0; 1 0 1];
        green_filter = (1/4)*[0 1 0; 1 0 1; 0 1 0];
        blue_filter = (1/4)*[1 0 1; 0 0 0; 1 0 1];
    end
    reconstructed_red_channel = filter2(red_filter,red_channel);
    reconstructed_green_channel = filter2(green_filter,green_channel);
    reconstructed_blue_channel = filter2(blue_filter,blue_channel);
    reconstructed_image = cat(3,reconstructed_red_channel,reconstructed_green_channel,reconstructed_blue_channel);
    D_red = (original_red - reconstructed_red_channel).^2;
    D_green = (original_green - reconstructed_green_channel).^2;
    D_blue = (original_blue - reconstructed_blue_channel).^2;
    square_error = D_red+D_green+D_blue;
    mean_error = mean(square_error(:));
    max_error = max(square_error(:));
    reconstructed_image = uint8(reconstructed_image);
end