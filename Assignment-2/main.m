clear;
clc;
close all;
%% Task 1,2
%
path = "wall/im1.pgm";
[before_nonmax,after_nonmax,~,~,~] = feature_detection(path,5,0.05,0,true);
I = imread(path);
for i = 1: length(before_nonmax)
    I = insertMarker(I,[before_nonmax(i,1) before_nonmax(i,2)],'X', 'color', 'red');
end
I1 = I;
imwrite(I1,"outputs/task1.png");
I = imread(path);
for i = 1: length(after_nonmax)
    I = insertMarker(I,[after_nonmax(i,1) after_nonmax(i,2)],'X', 'color', 'red');
end
I2 = I;
imwrite(I2,"outputs/task2.png");
%montage({I1,I2});
%}
%% Task 3
%
path_1 = "wall/im1.pgm";
path_2 = "wall/im2.pgm";
[~,vec1,image_xx_1,image_xy_1,image_yy_1] = feature_detection(path_1,5,0.05,0,true);
[~,vec2,image_xx_2,image_xy_2,image_yy_2] = feature_detection(path_2,5,0.05,0,true);

I1 = imread(path_1);
I2 = imread(path_2);
[ncc,ssd] = rotate_descriptor(path_1,path_2,vec1,vec2,10,...
                                image_xx_1,image_xy_1,image_yy_1,...
                                image_xx_2,image_xy_2,image_yy_2);
[f1,f2] = find(ncc==max(ncc,[],2));
%[f1,f2] = find(ssd==min(ssd,[],2));
m = [f1,f2];
showMatching(I1,I2,vec1,vec2,m)
figure
imagesc(-ncc);
colorbar;
figure;
imagesc(ssd);
colorbar;
%}
%% Task 4
%
path_1 = "wall/im1.pgm";
path_2 = "wall/im2.pgm";
[~,vec1,image_xx_1,image_xy_1,image_yy_1] = feature_detection(path_1,5,0.05,900,false);
[~,vec2,image_xx_2,image_xy_2,image_yy_2] = feature_detection(path_2,5,0.05,900,false);

I1 = imread(path_1);
I2 = imread(path_2);
[ncc,ssd] = rotate_descriptor(path_1,path_2,vec1,vec2,10,...
                                image_xx_1,image_xy_1,image_yy_1,...
                                image_xx_2,image_xy_2,image_yy_2);
[im1_matches,im2_matches] = find(ncc==max(ncc,[],2));
%showMatching(I1,I2,vec1,vec2,[im1_matches,im2_matches]);
[new_vec1,new_vec2] = get_matched_coords(vec1,vec2,im1_matches,im2_matches);
[o1,o2,o3] = ransac_model(new_vec1,new_vec2,663);
tform = projective2d(o2);
warped = imwarp(I1,tform,"OutputView",imref2d(size(I1)));
new_image = zeros(size(I1,1),size(I2,2),3);
new_image(:,:,1) = warped;
new_image(:,:,2) = I2;
imwrite(uint8(new_image),"outputs/task4.png");
%}
%% Task 5
%{
path_1 = "panorama/uttower_left.jpg";
path_2 = "panorama/uttower_right.jpg";
[~,vec1,image_xx_1,image_xy_1,image_yy_1] = feature_detection(path_1,5,0.05,900,false);
[~,vec2,image_xx_2,image_xy_2,image_yy_2] = feature_detection(path_2,5,0.05,900,false);

I1 = imread(path_1);
I2 = imread(path_2);
[ncc,ssd] = rotate_descriptor(path_1,path_2,vec1,vec2,10,...
                                image_xx_1,image_xy_1,image_yy_1,...
                                image_xx_2,image_xy_2,image_yy_2);
[im1_matches,im2_matches] = find(ncc==max(ncc,[],2));
showMatching(I1,I2,vec1,vec2,[im1_matches,im2_matches]);
[new_vec1,new_vec2] = get_matched_coords(vec1,vec2,im1_matches,im2_matches);
[o1,o2,o3] = ransac_model(new_vec1,new_vec2,5);
tform = projective2d(o2);
warped = imwarp(I1,tform);
new_image = zeros(1000,2000,3);
new_image(1:size(I2,1),1:size(I2,2),:) = I2;
new_image(1:size(warped,1),1:size(warped,2),:) = warped;
figure;
imshow(uint8(new_image));
%}