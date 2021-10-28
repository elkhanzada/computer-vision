clear;
path = "wall/im1.pgm";
[H,points] = feature_detection(path,10,0.004,50000);
I = imread(path);
imshow(H);
montage({I,H});