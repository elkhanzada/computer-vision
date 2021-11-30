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
[r_rect,e] = build_rect(rot_1,rot_2,trans_1,trans_2);
[warp_1,warp_2] = compute_projections(calibration,r_rect,rot_1,rot_2);
or_size = size(I1);
I_before = [I1,I2];
I1 = imwarp(I1,projective2d(warp_1'),"OutputView",imref2d(or_size));
I2 = imwarp(I2,projective2d(warp_2'),"OutputView",imref2d(or_size));
I_after = [I1,I2];
[h,w] = size(I_after);
imshow(I_before); hold on;
title("BEFORE");
for i = 1:20:h
    line([1,w],[i,i],'color','green','Linewidth',1);
end
hold off;
figure;
imshow(I_after); hold on;
title("AFTER");
for i = 1:20:h
    line([1,w],[i,i],'color','green','Linewidth',1);
end
hold off;
%% Task 3
useRefine = false;
disparityMap = disparity(I1,I2,8,40,useRefine);
figure;
imagesc(disparityMap); hold on;
title("Disparity Map");
hold off;
%% Task 4
f = (calibration(1,1)+calibration(2,2))/2;
q = [1 0 0 -loc_1(1);
    0 1 0 -loc_1(2);
    0 0 0 f;
    0 0 -1/e(1) (loc_1(1)-loc_2(1))/e(1)];
points3D = construct_3d(q,disparityMap);
%% Task 5
res_dir = "outputs/";
filename = "discrete";
if useRefine
    filename = "refined";
end
I1 = imread("data/images/undistorted00000100.jpg");
ptCloud = pointCloud(points3D,"Color",I1);
pcwrite(ptCloud,res_dir+filename,'PLYFormat','ascii');
%}