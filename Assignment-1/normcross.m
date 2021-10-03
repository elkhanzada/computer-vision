function score = normcross(m1, m2)
norm1 = m1 / norm(m1(:));
norm2 = m2 / norm(m2(:));
result = norm1 .* norm2;
score = sum(result(:));