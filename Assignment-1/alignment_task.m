function [reconstructed_image,best_ncc_1,best_ncc_2,best_i_1,best_j_1,best_i_2,best_j_2] = alignment_task(image_path)
    image = imread(image_path);
    image = double(image);
    [h,w] = size(image);
    h = h-1;
    blue_channel = image(1:round(h/3),1:w);
    green_channel = image(round(h/3)+1:round(2*h/3),1:w);
    red_channel = image(round(2*h/3)+1:h,1:w);
    first = blue_channel;
    second = green_channel;
    third = red_channel;
    best_i_1 = 0;
    best_j_1 = 0;
    best_i_2 = 0;
    best_j_2 = 0;
    best_ncc_1 = -1;
    best_ncc_2 = -1;
    range = 15;
    for i = -range:range
        for j = -range:range
            shift_1=circshift(first,[i j]);
            shift_2=circshift(second,[i j]);
            max_score_1 = normcross(third,shift_1);
            max_score_2 = normcross(third,shift_2);
            if best_ncc_1 < max_score_1
                best_ncc_1 = max_score_1;
                best_i_1 = i;
                best_j_1 = j; 
            end
            if best_ncc_2 < max_score_2
                best_ncc_2 = max_score_2;
                best_i_2 = i;
                best_j_2 = j;
            end    
        end
    end
    blue_channel = circshift(blue_channel,[best_i_1,best_j_1,]);
    green_channel = circshift(green_channel,[best_i_2,best_j_2]);
    reconstructed_image = uint8(cat(3,red_channel,green_channel,blue_channel));   
end