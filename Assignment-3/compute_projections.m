function [w1,w2] = compute_projections(calibration,r_rect,rot_1,rot_2)
rot1 = r_rect;
rot2 = r_rect*rot_1*inv(rot_2);
w1 = calibration*rot1*inv(calibration);
w2 = calibration*rot2*inv(calibration);
end