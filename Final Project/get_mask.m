function [mask,x,y] = get_mask(source_image)
    figure, imshow(source_image);
    uiwait(msgbox({'Draw a mask. To finish drawing, please double click'}));
    imHandler = drawfreehand(gca);
    wait(imHandler);
    mask = imHandler.createMask();
    close;
    [x, y] = find(mask);
    mask = mask(min(x):max(x), min(y):max(y));
end