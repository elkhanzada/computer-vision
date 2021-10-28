function [corners,points] = feature_detection(path,n,k,threshold)
    image = imread(path);
    [h,w] = size(image);
    gaussian = fspecial("gaussian",5,0.5);
    [gx,gy] = gradient(gaussian);
%     [~,gxy] = gradient(gx);
    image_x = filter2(gx,image);
    image_y = filter2(gy,image);
    image_xx = image_x.^2;
    image_yy = image_y.^2;
    image_xy = image_x.*image_y;
    Sum_xx = filter2(gaussian,image_xx);
    Sum_yy = filter2(gaussian,image_yy);
    Sum_xy = filter2(gaussian,image_xy);
    corners = zeros(h,w);
    points = 0;
    for i = 1+n:h-n
        for j = 1+n:w-n
            H = [Sum_xx(i,j) Sum_xy(i,j); Sum_xy(i,j) Sum_yy(i,j)];
            R = det(H) - k*(trace(H)^2);
            if R > threshold
                corners(i,j) = R;
                points=points+1;
            end
        end
    end
end
    