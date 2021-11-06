function [vec_before,vec_after,image_xx,image_xy,image_yy] = feature_detection(path,n,k,threshold)
    image = imread(path);
    if numel(size(image))==3
      image = im2double(rgb2gray(image));
    else
       image = im2double(image);
    end
    [h,w] = size(image);
    % define sobel kernel
    sobel = [-1 0 1; -2 0 2; -1 0 1];
    gaussian = fspecial("gaussian",5,0.5);
    dgaus = filter2(sobel,gaussian);
    % construct image gradients
    image_x = filter2(dgaus,image);
    image_y = filter2(dgaus',image);
    image_xx = image_x.^2;
    image_yy = image_y.^2;
    image_xy = image_x.*image_y;
    image_xx = filter2(gaussian,image_xx);
    image_yy = filter2(gaussian,image_yy);
    image_xy = filter2(gaussian,image_xy);
    corners = zeros(h,w);
    points = 0;
    for i = 1+n:h-2*n
        for j = 1+n:w-2*n
            patch_xx = image_xx(i-n:i+n,j-n:j+n);
            patch_xy = image_xy(i-n:i+n,j-n:j+n);
            patch_yy = image_yy(i-n:i+n,j-n:j+n);
            H = [sum(patch_xx(:)) sum(patch_xy(:)); 
                sum(patch_xy(:)) sum(patch_yy(:))];
            R = det(H) - k*trace(H)^2;
            if R > threshold
               corners(i,j) = R;
               points=points+1;
            end
        end
    end
    disp(points);
    temp = corners;
    strongest = zeros(h,w);
    for s = 1:1000
        [maxim,id] = max(temp(:));
        [i,j] = ind2sub(size(temp),id);
        temp(i,j)=-Inf;
        strongest(i,j) = maxim;
    end
    before_nonmax = strongest;
    [row_before, col_before] = find(before_nonmax > 0);
    vec_before = [col_before(:),row_before(:)];
    binary_window = fspecial('disk',10);
    %strongest = filter2(binary_window,strongest);
    strongest_final = zeros(h,w);
    for s = 1:size(row_before,1)
        lr = row_before(s)-10;
        rr = row_before(s)+10;
        lc = col_before(s)-10;
        rc = col_before(s)+10;
        [left_row,right_row,left_col,right_col] = index_checker(lr,rr,lc,rc,h,w);
        slice = strongest(left_row:right_row, left_col:right_col);
        %slice = filter2(binary_window,slice);
        cur = strongest(row_before(s),col_before(s));
        [maxim,~] = max(slice(:));
        if cur >= maxim
            strongest_final(row_before(s),col_before(s)) = strongest(row_before(s),col_before(s));
        end
    end
    [row_after,col_after] = find(strongest_final > 0);
    vec_after = [col_after,row_after];
end