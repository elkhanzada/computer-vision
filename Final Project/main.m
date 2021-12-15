clc; clear; close all;warning('off','all');
source_image = im2double(imread('images/source1.jpg'));
target_image = im2double(imread('images/target1.jpg'));
[mask,x,y] = get_mask(source_image);
omega_area_source = source_image(min(x):max(x), min(y):max(y), :);
[coordinates] = get_location(omega_area_source,target_image,mask);
omega_area_target = target_image( coordinates(1) : coordinates(2), coordinates(3) : coordinates(4) , : );
blended_image = blended(target_image,omega_area_source,omega_area_target,mask, coordinates);
imshow(blended_image);