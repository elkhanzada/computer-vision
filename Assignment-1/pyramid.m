function [best_ncc,best_i,best_j] = pyramid(ch_1,ch_2,n)
    if n == 0
        % The smallest one uses [-15,15] range.
        range = 15;
        best_i = 0;
        best_j = 0;
        best_ncc = -1;
        for i = -range:range
            for j = -range:range
                shift=circshift(ch_2,[i j]);
                max_score = normcross(ch_1,shift);
                if best_ncc < max_score
                    best_ncc = max_score;
                    best_i = i;
                    best_j = j; 
                end
            end
        end
    else
        scaled_ch_1 = imresize(ch_1, 1/2);
        scaled_ch_2 = imresize(ch_2, 1/2);
        [ncc,i_rec,j_rec] = pyramid(scaled_ch_1, scaled_ch_2, n-1);
        % Needs to be multiplied by 2 as it is scaled down by 2.
        ch_2 = circshift(ch_2, [i_rec*2,j_rec*2]);
        % Larger images use [-2,2] range.
        range = 2;
        best_i = 0;
        best_j = 0;
        best_ncc = -1;
        for i = -range:range
            for j = -range:range
                shift=circshift(ch_2,[i j]);
                max_score = normcross(ch_1,shift);
                if best_ncc < max_score
                    best_ncc = max_score;
                    best_i = i;
                    best_j = j; 
                end
            end
        end
        % Update the estimations.
        best_i = best_i + i_rec*2;
        best_j = best_j + j_rec*2;
    end
end