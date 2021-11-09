function [best_num_of_inliers,best_homography,best_match_indexes] = ransac_model(vec1,vec2,seed)
    % 5 is good
    rng(seed);
    vec1(:,3) = 1;
    vec2(:,3) = 1;
    best_num_of_inliers = 0;
    best_homography = 0;
    best_match_indexes = 0;
    for i = 1:1257
        ran_indices = randperm(length(vec1),4);
        
        %im1 random samples
        x1_1 = vec1(ran_indices(1),1);
        x2_1 = vec1(ran_indices(2),1);
        x3_1 = vec1(ran_indices(3),1);
        x4_1 = vec1(ran_indices(4),1);
        y1_1 = vec1(ran_indices(1),2);
        y2_1 = vec1(ran_indices(2),2);
        y3_1 = vec1(ran_indices(3),2);
        y4_1 = vec1(ran_indices(4),2);
        %im2 random samples
        x1_2 = vec2(ran_indices(1),1);
        x2_2 = vec2(ran_indices(2),1);
        x3_2 = vec2(ran_indices(3),1);
        x4_2 = vec2(ran_indices(4),1);
        y1_2 = vec2(ran_indices(1),2);
        y2_2 = vec2(ran_indices(2),2);
        y3_2 = vec2(ran_indices(3),2);
        y4_2 = vec2(ran_indices(4),2);
        
        % homography computation
        homography = compute_homography(x1_1,y1_1,x2_1,y2_1,x3_1,y3_1,x4_1,y4_1,...
                                  x1_2,y1_2,x2_2,y2_2,x3_2,y3_2,x4_2,y4_2);
        
        %Avoid singular matrices
        if (cond(homography') > 1e15 )
            continue;
        end 
        %Apply homography
        vec1_transform = (homography'*vec1');
        vec2_transform = vec2';
        
        %Computer euclidean distance and find number of inliers
        vec1_transform(1,:) = vec1_transform(1,:)./vec1_transform(3,:);
        vec1_transform(2,:) = vec1_transform(2,:)./vec1_transform(3,:);
        differences = vec1_transform(1:2,:)-vec2_transform(1:2,:);
        pixel_errs = sqrt(differences(1,:).^2 + differences(2,:).^2);
        match_indexes = pixel_errs<2;
        number_of_inliers = sum(match_indexes);
        if number_of_inliers > best_num_of_inliers
            best_num_of_inliers = number_of_inliers;
            best_match_indexes = match_indexes;
            best_homography = homography;
        end
    end
end