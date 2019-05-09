% This function locates the PSF of a distorted image.  %
% Input: distorted image, Output: PSF center location, %
% PSF size, in pixel.                                  %

function result = PSFloc(im_d)
    imd_size = size(im_d);
    if mod(imd_size(1),2) == 0
    	center_pos = imd_size(1)/2;
    else
        center_pos = (1+imd_size(1))/2;
    end

    loc = [center_pos, center_pos];
    
    x = 1;
    y = 1;
    current_posx = [center_pos,center_pos];
    centerp = im_d(center_pos,center_pos);
    while (im_d(current_posx(1),current_posx(2))>centerp/5)
        current_posx = [current_posx(1),current_posx(2)+1];
%         disp(current_posx);
        x = x+1;
    end
    current_posy = [center_pos,center_pos];
    while (im_d(current_posy(1),current_posy(2))>centerp/5)
        current_posy = [current_posy(1)+1,current_posy(2)];
        y = y+1;
    end
    psf_size = [x,y];
    result = [loc;psf_size];
end
