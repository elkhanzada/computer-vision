function dispmap  = disparity(I1,I2, n, dmax, useRefine)
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
            distances = zeros(dmax+1,1);
            for z = j:-1:j-dmax
                loop=loop+1;
                patch_2 = I1(i-n:i+n,z-n:z+n);
                score = normcross(patch_1,patch_2);
                if max_score < score
                    max_score = score;
                    maxD = loop;
                end
                if ~isnan(score)
                    distances(loop)=score;
                end
            end
            if useRefine 
                if maxD>1 && maxD<=dmax
                    refined =  maxD + (distances(maxD+1)-distances(maxD-1))/....
                    (2*(distances(maxD)-min([distances(maxD-1) distances(maxD+1)])));
                    dispmap(i,j) = refined;
                elseif maxD==1
                    refined =  maxD + (distances(maxD+1)-distances(maxD+2))/....
                    (2*(distances(maxD)-min([distances(maxD+1) distances(maxD+2)])));
                    dispmap(i,j) = refined; 
                elseif maxD>dmax
                    refined =  maxD + (distances(maxD-1)-distances(maxD-2))/....
                    (2*(distances(maxD)-min([distances(maxD-1) distances(maxD-2)])));
                    dispmap(i,j) = refined; 
                end
             else
                if maxD~=-1
                    dispmap(i,j) = maxD;
                end
             end
         end
     end
    if useRefine
        dispmap = medfilt2(dispmap, [n*2+1 n*2+1]);
    end
end