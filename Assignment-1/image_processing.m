clear;
[reconstructed_image,square_error,mean_error,max_error] = mosaic_task(true);
imshow(reconstructed_image);
figure;
imagesc(uint8(square_error));
colorbar
%[image,best_ncc_1,best_ncc_2,x1,y1,x2,y2] = alignment_task("data/00125v.jpg");
%imshow(image);
