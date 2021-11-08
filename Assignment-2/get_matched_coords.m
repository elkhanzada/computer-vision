function [v1,v2] = get_matched_coords(old1,old2,f1,f2)
    v1 = zeros(length(f1),2);
    v2 = zeros(length(f2),2);
    for i=1:length(f1)
        v1(i,2) = old1(f1(i),2);
        v1(i,1) = old1(f1(i),1);
        v2(i,2) = old2(f2(i),2);
        v2(i,1) = old2(f2(i),1);
    end
end