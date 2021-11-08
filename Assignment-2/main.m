clear;
close all;
%% Task 1,2
%{
path = "wall/im1.pgm";
[vec1,vec2,~,~,~] = feature_detection(path,5,0.05,4000,true);
I = imread(path);
for i = 1: length(vec1)
    I = insertMarker(I,[vec1(i,1) vec1(i,2)],'X', 'color', 'red');
end
I1 = I;
I = imread(path);
for i = 1: length(vec2)
    I = insertMarker(I,[vec2(i,1) vec2(i,2)],'X', 'color', 'red');
end
I2 = I;
montage({I1,I2});
%}
%% Task 3
%{
path_1 = "wall/im1.pgm";
path_2 = "wall/im2.pgm";
[~,vec1,image_xx_1,image_xy_1,image_yy_1] = feature_detection(path_1,5,0.05,4500,true);
[~,vec2,image_xx_2,image_xy_2,image_yy_2] = feature_detection(path_2,5,0.05,4500,true);

I1 = imread(path_1);
I2 = imread(path_2);
[ncc,ssd] = rotate_descriptor(path_1,path_2,vec1,vec2,10,...
                                image_xx_1,image_xy_1,image_yy_1,...
                                image_xx_2,image_xy_2,image_yy_2);
[f1,f2] = find(ncc==max(ncc,[],2));
%[f1,f2] = find(ssd==min(ssd,[],2));
m = [f1,f2];
figure;
showMatching(I1,I2,vec1,vec2,m)
figure
imagesc(ncc);
colorbar;
figure;
imagesc(ssd);
colorbar;
%}
%% Task 4
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
[new_vec1,new_vec2] = get_matched_coords(vec1,vec2,im1_matches,im2_matches);
[o1,o2,o3] = ransac_model(new_vec1,new_vec2);


