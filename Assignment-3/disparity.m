function dispmap  = disparity(I1,I2, n, dmax)
    I1 = im2gray(I1);
    I2 = im2gray(I2);
%     I1 = imresize(I1,0.5);
%     I2 = imresize(I2,0.5);
    dispmap = zeros(size(I1,1),size(I1,2));
    [h,w] = size(I1);
    for i = 1+n:h-n
        for j = 1+n+dmax:w-n
            loop = 0;
            max_score = -Inf;
            maxD = -1;
            patch_1 = I2(i-n:i+n,j-n:j+n);
            for z = j:-1:j-dmax
                loop=loop+1;
                patch_2 = I1(i-n:i+n,z-n:z+n);
                score = normcross(patch_1,patch_2);
                if max_score < score
                    max_score = score;
                    maxD = loop;
                end
            end
            if maxD~=-1
                dispmap(i,j) = maxD;
            end
        end
   end
end