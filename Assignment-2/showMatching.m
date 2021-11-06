% Visualization of image matching
% Ilwoo Lyu
%
% I1=imread('im1'); % left image
% I2=imread('im2'); % right image
% X = [x, y] % feature locations (left)
% Y = [x, y] % feature locations (right)
% m = [f1, f2] % feature ID (left) and feature ID (right) - this should be
% constructed by some metrics (SSD, NCC, etc.)

function showMatching(I1,I2, X, Y, m)
    rect = [0 0 min(size(I1, 2), size(I2,2)) min(size(I1, 1), size(I2,1))];
    I1=imcrop(I1, rect);
    I2=imcrop(I2, rect);

    h1=size(I1,1);
    h2=size(I2,1);
    h = max(h1, h2);
    scale1 = h / h1;
    scale2 = h / h2;
    X = X * scale1;
    Y = Y * scale2;
    if size(I1, 3) == 1
        I1(:,:,2)=I1(:,:,1);
        I1(:,:,3)=I1(:,:,1);
    end
    if size(I2, 3) == 1
        I2(:,:,2)=I2(:,:,1);
        I2(:,:,3)=I2(:,:,1);
    end
    I1 = imresize(I1, scale1);
    I2 = imresize(I2, scale2);
    w1=size(I1,2);
    Y(:, 1) = Y(:, 1) + w1;
    I=[I1, I2];
    imshow(I);
    hold on;
    showCorner(X(:,1), X(:,2));
    showCorner(Y(:,1), Y(:,2));
    
    if nargin == 5
        c = jet(length(m));
        for i = 1: length(m)
            plot([X(m(i,1),1), Y(m(i,2), 1)],[X(m(i,1),2),Y(m(i,2),2)],'color',c(i,:),'LineWidth',1);
            text(X(m(i,1), 1), X(m(i,1), 2), num2str(i),'color',c(i,:),'fontsize', 10);
            text(Y(m(i,2), 1), Y(m(i,2), 2), num2str(i),'color',c(i,:),'fontsize', 10);
        end
    end
    hold off;
end

function showCorner(key_x, key_y)
    plot(key_x,key_y,'X','markersize',8,'color','red');
end