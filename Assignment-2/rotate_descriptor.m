function [ncc_scores,ssd_scores] = rotate_descriptor(path_1,path_2,vec1,vec2,n,image_xx_1,image_xy_1,image_yy_1,image_xx_2,image_xy_2,image_yy_2)
    image_1 = imread(path_1);
    image_2 = imread(path_2);
    if numel(size(image_1))==3
      image_1 = im2double(rgb2gray(image_1));
      image_2 = im2double(rgb2gray(image_2));
    else
       image_1 = im2double(image_1);
       image_2 = im2double(image_2);
    end
    ncc_scores = zeros(size(vec1,1),size(vec2,1));
    ssd_scores = zeros(size(vec1,1),size(vec2,1));
    x1 = vec1(:,2);
    y1 = vec1(:,1);
    x2 = vec2(:,2);
    y2 = vec2(:,1);
    for i=1:size(x1,1)
        x = x1(i);
        y = y1(i);
        [h,w] = size(image_1);
        [left_row,right_row,left_col,right_col] = index_checker(x-3*n,x+3*n,y-3*n,y+3*n,h,w);
        patch_xx_1 = image_xx_1(left_row:right_row,left_col:right_col);
        patch_xy_1 = image_xy_1(left_row:right_row,left_col:right_col);
        patch_yy_1 = image_yy_1(left_row:right_row,left_col:right_col);
        patch_1 = image_1(left_row:right_row,left_col:right_col);

        H = [sum(patch_xx_1(:)) sum(patch_xy_1(:)); 
                sum(patch_xy_1(:)) sum(patch_yy_1(:))];
        [V,~] = eigs(H,1);
        theta = atand(V(2)/V(1));
        rot = [cos(theta) sin(theta) 0;
                -sin(theta) cos(theta) 0;
                0 0 1 ];
        tform = affine2d(rot);
        patch_1 = imwarp(patch_1,tform);
        len = ceil(length(patch_1)/2);
        patch_1 = patch_1(len-n:len+n,len-n:len+n);
        for j=1:size(x2,1)
            x = x2(j);
            y = y2(j);
            [h,w] = size(image_2);
            [left_row,right_row,left_col,right_col] = index_checker(x-3*n,x+3*n,y-3*n,y+3*n,h,w);
            patch_xx_2 = image_xx_2(left_row:right_row,left_col:right_col);
            patch_xy_2 = image_xy_2(left_row:right_row,left_col:right_col);
            patch_yy_2 = image_yy_2(left_row:right_row,left_col:right_col);
            patch_2 = image_2(left_row:right_row,left_col:right_col);
            H = [sum(patch_xx_2(:)) sum(patch_xy_2(:)); 
                sum(patch_xy_2(:)) sum(patch_yy_2(:))];
            [V,~] = eigs(H,1);
            theta = atand(V(2)/V(1));
            rot = [cos(theta) sin(theta) 0;
                -sin(theta) cos(theta) 0;
                0 0 1 ];
            tform = affine2d(rot);
            patch_2 = imwarp(patch_2,tform);
            len = ceil(length(patch_2)/2);
            patch_2 = patch_2(len-n:len+n,len-n:len+n);
            ncc_scores(i,j) = normcross(patch_1,patch_2);
            ssd_scores(i,j) = ssd(patch_1,patch_2);
        end
    end
end