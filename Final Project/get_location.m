function [coords] = get_location(omega_area_source,target_image,mask)
[omega_height,omega_width,~] = size(omega_area_source);
[target_height, target_width, ~] = size(target_image);
[x, y] = find(mask);
xmin = min(x);xmax = max(x);ymin = min(y);ymax = max(y);
imshow(target_image);
uiwait(msgbox({'Left click on any location to specify and Right click when you are done'}));
b = 1;

% Loop till right click is observed
while b==1
    [y,x,b] = ginput(1);
    
    % This is to make sure we are not out of boundaruy
    y = max(y,(ymax - ymin)/2 + 1);
    y = min(y, target_width-(ymax - ymin)/2);
    x = max(x,(xmax - xmin)/2 + 1);
    x = min(x, target_height-((xmax - xmin)/2));
    
    % Save location information
    coords(1) = (x - (xmax - xmin)/2);
    coords(2) = (x + (xmax - xmin)/2);
    coords(3) = (y - (ymax - ymin)/2);
    coords(4) = (y + (ymax - ymin)/2);  
    temp_omega = target_image(coords(1):coords(2),coords(3):coords(4),:);
    temp_target = target_image;
    temp_source = temp_omega;
    for i=1:omega_height
        for j=1:omega_width
            if mask(i,j)
                temp_source(i,j,:) = omega_area_source(i,j,:);
            end
        end
    end
    % Show user the pasted image on specified location.
    temp_target( coords(1):coords(2),coords(3):coords(4),:) = temp_source;
    imshow(temp_target);
    if b ~= 1
        break
    end
end
end