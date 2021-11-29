function r_rect = build_rect(rot_1,rot_2,trans_1,trans_2)
    e = trans_1-rot_1*inv(rot_2)*trans_2;
    r1 = e/norm(e);
    r2 = [-e(2) e(1) 0]./sqrt(e(1)^2+e(2)^2);
    r3 = cross(r2,r1);
    r_rect = [r1';r2;r3];
end