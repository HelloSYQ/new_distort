% This function finds the most probable polynomial parameter for point %
% reconstruction model.                                                %
% input: range: 4-element vector, int, range(1), range(2) range of     %
% first prameter, range(3), range(4), range of second parameter.       %
% step: double, step of the searching.                                 %
% imn1: string, name of the source image.                              %
% imn2: string, name of the distorted image.                           %
% output: double, 2 polynomial parameters.                             %
% Date: 2019-05-09 ======== Author: Hellosyq                           %

function result = De_pointResD(range_m,step,imn1,imn2)
    
    im_o = im2double(imread(imn1));
    im_d = im2double(imread(imn2));
    
    min = 10^4;
    % main calculation 
    for i = range_m(1):range_m(2);
        for j = range_m(3):range_m(4)
            k = [i j]*step;
            im_new = ext_pointDis(im_o,k);
            value = sum(sum((im_d-im_new).^2));
	    disp(value);
            if value<min
                min = value;
                kout = k;
            end
        end
    end

    result = kout;
end
