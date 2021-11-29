function score = ssd(matrix1,matrix2)
    diff = (matrix1 - matrix2).^2;
    score = sum(diff(:));
end