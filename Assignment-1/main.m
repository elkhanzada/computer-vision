clear;
%% Task 1,2,3
% If true then weighted average filter will be used, otherwise average
% filter.

[reconstructed_image,square_error,mean_error,max_error] = mosaic_task(false);
imshow(reconstructed_image,[]);
figure;imagesc(uint8(square_error));
colorbar
%% Task 4,5
path = "data/";
file_list = dir(path);
for i=3:length(file_list)
    [image,best_ncc_1,best_ncc_2,x1,y1,x2,y2] = alignment_task(path+file_list(i).name);
    disp(file_list(i).name);
    disp("blue channel - " + best_ncc_1 + ",["+x1+" "+y1+"]")
    disp("green channel - " + best_ncc_2 + ",["+x2+" "+y2+"]")
    figure;imshow(image,[]);
end
%% Bonus task (Multiscale)
path = "data_hires/";
file_list = dir(path);
for i=3:length(file_list)
    [image,best_ncc_1,best_ncc_2,x1,y1,x2,y2] = bonus_task(path+file_list(i).name);
    disp(file_list(i).name);
    disp("blue channel - " + best_ncc_1 + ",["+x1+" "+y1+"]")
    disp("green channel - " + best_ncc_2 + ",["+x2+" "+y2+"]")
    figure;imshow(image,[]);
end

