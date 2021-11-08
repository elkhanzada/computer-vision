function [best_num_of_inliers,best_homography,best_match_indexes] = ransac_model(vec1,vec2)
    rng('default');
    vec1(:,3) = 1;
    vec2(:,3) = 1;
    best_num_of_inliers = 0;
    best_homography = 0;
    best_match_indexes = 0;
    k = 5; %no. of correspondences
    e = 0.5; %outlier ratio = no. of outliers/total no. points
             %              = 1- no. of inliers/total no. of points
    p = 0.99; %probability that a point is an inlier
    N_iter = round(log10(1-p)/log10(1-(1-e)^k)); % no. of iterations
    for i = 1:100000
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
        homography = compute_homography(x1_1,y1_1,x2_1,y2_1,x3_1,y3_1,x4_1,y4_1,...
                                  x1_2,y1_2,x2_2,y2_2,x3_2,y3_2,x4_2,y4_2);
        vec1_transform = (homography'*vec1');
        vec2_transform = vec2';
        vec1_transform(1,:) = vec1_transform(1,:)./vec1_transform(3,:);
        vec1_transform(2,:) = vec1_transform(2,:)./vec1_transform(3,:);
        differences = vec1_transform(1:2,:)-vec2_transform(1:2,:);
        pixel_errs = sqrt(differences(1,:).^2 + differences(2,:).^2);
        match_indexes = pixel_errs<2;
        number_of_inliers = sum(match_indexes);
        if number_of_inliers > best_num_of_inliers
            e = (1-number_of_inliers/length(vec1));
            N_iter = round(log10(1-p)/log10(1-(1-e)^k));
            best_num_of_inliers = number_of_inliers;
            best_match_indexes = match_indexes;
            best_homography = homography;
        end
        % Apply transformation to im1 samples
      %  tform = projective2d(homo');
       % [new_vec1_x,new_vec2_y] = transformPointsForward(tform,vec1(:,2),vec1(:,1));
    end
end