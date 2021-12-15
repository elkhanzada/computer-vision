function [gx,gy, gm] = get_gradients(image)
    gx = imfilter(image,[-1 1 0]);
    gy = imfilter(image, [-1 1 0]');
    gm = gx.^2 + gy.^2;
end