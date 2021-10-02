function [reconstructed_image,best_ncc_1,best_ncc_2,best_x_1,best_y_1,best_x_2,best_y_2] = alignment_task(image_path)
    image = imread(image_path);
    image = double(image);
    [h,w] = size(image);
    h = h-1;
    blue_channel = image(1:round(h/3),1:w);
    green_channel = image(round(h/3)+1:round(2*h/3),1:w);
    red_channel = image(round(2*h/3)+1:h,1:w);
    first = green_channel;
    second = red_channel;
    third = blue_channel;
    best_x_1 = 0;
    best_y_1 = 0;
    best_x_2 = 0;
    best_y_2 = 0;
    best_ncc_1 = -1;
    best_ncc_2 = -1;
    range = 15;
    for i = -range:range
        for j = -range:range
            shift_1=circshift(first,[i j]);
            shift_2=circshift(second,[i j]);
            norm_1 = normxcorr2(third,shift_1);
            norm_2 = normxcorr2(third,shift_2);
            [ypeak_1,xpeak_1] = find(norm_1==max(norm_1(:)));
            [ypeak_2,xpeak_2] = find(norm_2==max(norm_2(:)));
            max_score_1 = max(norm_1(:));
            max_score_2 = max(norm_2(:));
            if best_ncc_1 < max_score_1
                best_ncc_1 = max_score_1;
                best_x_1 = xpeak_1-size(first,2);
                best_y_1 = ypeak_1-size(first,1);
            end
            if best_ncc_2 < max_score_2
                best_ncc_2 = max_score_2;
                best_x_2 = xpeak_2-size(second,2);
                best_y_2 = ypeak_2-size(second,1);
            end
                
        end
    end
    green_channel = circshift(green_channel,[best_x_1,best_y_1]);
    red_channel = circshift(red_channel,[best_x_2,best_y_2]);
    reconstructed_image = uint8(cat(3,red_channel,green_channel,blue_channel));   
end