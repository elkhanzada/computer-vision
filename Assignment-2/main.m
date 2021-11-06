clear;
close all;
%% Task 1,2

path = "wall/im1.pgm";
[vec1,vec2,~,~,~] = feature_detection(path,5,0.05,4000);
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

%% Task 3
path_1 = "wall/im1.pgm";
path_2 = "wall/im2.pgm";
[~,vec1,image_xx_1,image_xy_1,image_yy_1] = feature_detection(path_1,5,0.05,4500);
[~,vec2,image_xx_2,image_xy_2,image_yy_2] = feature_detection(path_2,5,0.05,4500);

I1 = imread(path_1);
I2 = imread(path_2);
[ncc,ssd] = rotate_descriptor(path_1,path_2,vec1,vec2,5,...
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
