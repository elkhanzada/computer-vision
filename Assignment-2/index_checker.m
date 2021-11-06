function [left_row,right_row,left_col,right_col] = index_checker(left_row,right_row,left_col,right_col,h,w)
    if left_row < 1
        left_row = 1;
    end
    if right_row > h
        right_row = h;
    end
    if left_col < 1
        left_col = 1;
    end
    if right_col > w
        right_col = w;
    end
end