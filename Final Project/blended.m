function [result] = blended(target_image,omega_area_source,omega_area_target,mask, coords)
% Pad to consider boundaries
mask = padarray(mask,[1,1]);
omega_area_source = padarray(omega_area_source,[1,1],'replicate');
omega_area_target= padarray(omega_area_target,[1,1],'replicate');
[mask_height, mask_width] = size(mask);
omega_loc = find(mask(:));
omega_grid = zeros(size(mask));
[x, ~] = find(mask);
omega_grid(omega_loc) = 1:length(x);
A = -delsq(omega_grid);
temp = imerode(mask, [0 1 0; 1 1 1; 0 1 0]);
delta_omega = xor(mask,temp);
delta_omega_loc = delta_omega(:);
delta_omega_grid = omega_grid(delta_omega);

% Construct B matrix and find unknown pixel values for each channel
for i = 1:3
    oneSource = omega_area_source(:,:,i);
    oneTarget = omega_area_target(:,:,i);
    [gxs,gys,gms] = get_gradients(oneSource);
    [gxt,gyt,gmt] = get_gradients(oneTarget);
    indices = gmt >= gms;
    gxs(indices) = gxt(indices);
    gys(indices) = gyt(indices);
    diverg = -imfilter(gxs,[0 1 -1])-imfilter(gys,[0 1 -1]');
    B = diverg(omega_loc);
    temp = oneTarget;
    temp(mask) = 0;
    temp_final = imfilter(temp,[0 -1 0; -1 0 -1; 0 -1 0]);
    B(delta_omega_grid) = B(delta_omega_grid)+temp_final(delta_omega_loc);
    X = A\B;
    oneTarget(omega_loc) = X;
    target_image(coords(1):coords(2),coords(3):coords(4),i) = oneTarget(2:mask_height-1,2:mask_width-1,:);
end
result = target_image;
end