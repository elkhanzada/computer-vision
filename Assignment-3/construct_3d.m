function points3D = construct_3d(Q,disparityMap)
                Q = Q';
                totalPoints = numel(disparityMap);
                [x, y] = meshgrid(cast(1:size(disparityMap, 2), 'like', disparityMap),...
                                  cast(1:size(disparityMap, 1), 'like', disparityMap));
                points_2d = [x(:), y(:), disparityMap(:),ones(totalPoints, 1, 'like', disparityMap)];
                points_3d = points_2d * Q;
                points_3d = bsxfun(@times, points_3d(:, 1:3), 1./points_3d(:, 4));
                X = reshape(points_3d(:, 1), size(disparityMap));
                Y = reshape(points_3d(:, 2), size(disparityMap));
                Z = reshape(points_3d(:, 3), size(disparityMap));
                
                % invalid disparity results in the 3D location being NaN.
                X(disparityMap == 0) = NaN;
                Y(disparityMap == 0) = NaN;
                Z(disparityMap == 0) = NaN;
                
                points3D = cat(3, X, Y, Z);
end