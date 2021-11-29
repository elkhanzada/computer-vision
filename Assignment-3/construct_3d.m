function points3D = construct_3d(Q,disparityMap)
                totalPoints = numel(disparityMap);
                [y,x] = find(disparityMap==disparityMap);
                points_2d = [x(:), y(:), disparityMap(:),ones(totalPoints, 1, 'like', disparityMap)];
                points_3d = points_2d * Q;
                points_3d = bsxfun(@times, points_3d(:, 1:3), 1./points_3d(:, 4));
                % create outputs
                X = reshape(points_3d(:, 1), size(disparityMap));
                Y = reshape(points_3d(:, 2), size(disparityMap));
                Z = reshape(points_3d(:, 3), size(disparityMap));
                
                % invalid disparity results in the 3D location being NaN.
%                 X(disparityMap == -realmax('single')) = NaN;
%                 Y(disparityMap == -realmax('single')) = NaN;
%                 Z(disparityMap == -realmax('single')) = NaN;
                
                points3D = cat(3, X, Y, Z);
end