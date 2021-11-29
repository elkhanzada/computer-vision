function [rot,trans] = decompose_extrinsic(file)
    A = readmatrix(file);
    rot = A(:,1:3);
    trans = A(:,4);
end