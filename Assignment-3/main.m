clc;
clear;
close all;
%% Task 1
[rot_1,trans_1] = decompose_extrinsic("data/cam-poses/camera00000100.txt");
[rot_2,trans_2] = decompose_extrinsic("data/cam-poses/camera00000103.txt");
loc_1 = -trans_1'*rot_1;
loc_2 = -trans_2'*rot_2;
%% Task 2
calibration = readmatrix("data/Calibration.txt");
I1 = im2double(imread("data/images/undistorted00000100.jpg"));
I2 = im2double(imread("data/images/undistorted00000103.jpg"));
r_rect = build_rect(rot_1,rot_2,trans_1,trans_2);
[warp_1,warp_2] = compute_projections(calibration,r_rect,rot_1,rot_2);
or_size = size(I1);
I_before = [I1,I2];
I1 = imwarp(I1,projective2d(warp_1'),"OutputView",imref2d(or_size));
I2 = imwarp(I2,projective2d(warp_2'),"OutputView",imref2d(or_size));
I_after = [I1,I2];
% [h,w] = size(I_after);
% imshow(I_before); hold on;
% for i = 1:20:h
%     line([1,w],[i,i],'color','green','Linewidth',1);
% end
% hold off;
% figure;
% imshow(I_after); hold on;
% for i = 1:20:h
%     line([1,w],[i,i],'color','green','Linewidth',1);
% end
% hold off;
%% Task 3
disparityMap = disparity(I1,I2,8,35);
figure;
imagesc(disparityMap);
%% Task 4
[x, y] = meshgrid(...
                    cast(1:size(disparityMap, 2), 'like', disparityMap),...
                    cast(1:size(disparityMap, 1), 'like', disparityMap));